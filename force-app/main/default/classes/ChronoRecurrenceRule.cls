// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Deliberately bounded RFC 5545 subset. Unsupported rule parts fail explicitly rather than changing recurrence meaning. */
public with sharing class ChronoRecurrenceRule { // NOPMD -- Aggregate spans parsing and independent recurrence filters; method limits still apply.
  public String frequency;
  public Integer interval = 1;
  public Integer count;
  public Date untilDate;
  public Datetime untilInstant;
  public Integer weekStart = 1;
  public Set<Integer> weekdays = new Set<Integer>();
  public Set<Integer> monthDays = new Set<Integer>();
  public Set<Integer> months = new Set<Integer>();
  public static final Map<String, Integer> WEEKDAY_CODES = new Map<String, Integer>{
    'MO' => 1,
    'TU' => 2,
    'WE' => 3,
    'TH' => 4,
    'FR' => 5,
    'SA' => 6,
    'SU' => 7
  };
  public ChronoRecurrenceRule(ChronoRecurrenceInput input) {
    if (input.operation == 'rrule') {
      parse(input.rule, input.valueType);
    } else {
      frequency = input.frequency;
      interval = input.interval == null ? 1 : input.interval;
      count = input.count;
      if (!String.isBlank(input.weekdays)) {
        weekdays = weekdaySet(input.weekdays.toUpperCase());
      }
    }
    validateRules();
  }
  private void validateRules() {
    ChronoSupport.choice(
      frequency,
      new Set<String>{ 'daily', 'weekly', 'monthly', 'yearly' },
      'recurrence frequency'
    );
    if (interval < 1 || interval > 3660 || invalidCount(count)) {
      throw new ChronoException('Use interval 1–3660 and count 1–1000.');
    }
    if (frequency == 'weekly' && !monthDays.isEmpty()) {
      throw new ChronoException('BYMONTHDAY is not valid with WEEKLY.');
    }
  }
  private static Boolean invalidCount(Integer value) {
    return value != null && (value < 1 || value > 1000);
  }
  private void parse(String text, String valueType) {
    ChronoSupport.requireValue(text, 'RRULE');
    String body = text.trim().toUpperCase();
    if (body.startsWith('RRULE:')) {
      body = body.substring(6);
    }
    Map<String, String> parts = new Map<String, String>();
    for (String part : body.split(';')) {
      List<String> pair = part.split('=');
      if (pair.size() != 2 || parts.containsKey(pair[0])) {
        throw new ChronoException(
          'RRULE parts must be unique NAME=VALUE pairs.'
        );
      }
      parts.put(pair[0], pair[1]);
      assign(pair[0], pair[1]);
    }
    validateUntil(parts, valueType);
  }
  private void validateUntil(Map<String, String> parts, String valueType) {
    if (parts.containsKey('COUNT') && parts.containsKey('UNTIL')) {
      throw new ChronoException('RRULE cannot combine COUNT and UNTIL.');
    }
    if (parts.containsKey('UNTIL')) {
      parseUntil(parts.get('UNTIL'), valueType);
    }
  }
  private void assign(String key, String value) {
    switch on key {
      when 'FREQ' {
        frequency = value.toLowerCase();
      }
      when 'INTERVAL' {
        interval = Integer.valueOf(value);
      }
      when 'COUNT' {
        count = Integer.valueOf(value);
      }
      when 'BYDAY' {
        weekdays = weekdaySet(value);
      }
      when 'BYMONTHDAY' {
        monthDays = numbers(value, 31, true);
      }
      when 'BYMONTH' {
        months = numbers(value, 12, false);
      }
      when 'WKST' {
        weekStart = WEEKDAY_CODES.get(value);
        if (weekStart == null) {
          throw new ChronoException('Invalid WKST.');
        }
      }
      when 'UNTIL' {
        return; // Parsed after the complete rule so type constraints are checked together.
      }
      when else {
        throw new ChronoException('Unsupported RRULE part: ' + key + '.');
      }
    }
  }
  private void parseUntil(String value, String valueType) {
    Boolean dateOnly = valueType == 'PlainDate';
    Boolean exact = valueType == 'Instant' || valueType == 'ZonedDateTime';
    String expression = dateOnly
      ? '[0-9]{8}'
      : (exact ? '[0-9]{8}T[0-9]{6}Z' : '[0-9]{8}T[0-9]{6}');
    ChronoSupport.requireMatch(
      value,
      expression,
      'RRULE UNTIL for this value type'
    );
    Date day = ChronoIso.parseDate(
      value.substring(0, 4) +
        '-' +
        value.substring(4, 6) +
        '-' +
        value.substring(6, 8)
    );
    if (dateOnly) {
      untilDate = day;
      return;
    }
    Time clock = ChronoIso.parseTime(
      value.substring(9, 11) +
        ':' +
        value.substring(11, 13) +
        ':' +
        value.substring(13, 15)
    );
    untilInstant = Datetime.newInstanceGmt(day, clock);
  }
  public static Set<Integer> weekdaySet(String value) {
    Set<Integer> result = new Set<Integer>();
    for (String token : value.split(',')) {
      Integer day = WEEKDAY_CODES.get(token.trim());
      if (day == null) {
        throw new ChronoException(
          'Use plain weekday codes MO,TU,WE,TH,FR,SA,SU. Ordinal BYDAY is not supported; use Find nth weekday instead.'
        );
      }
      result.add(day);
    }
    return result;
  }
  private static Set<Integer> numbers(
    String value,
    Integer maximum,
    Boolean signed
  ) {
    Set<Integer> result = new Set<Integer>();
    for (String token : value.split(',')) {
      Integer component = Integer.valueOf(token);
      if (
        component == 0 ||
        (component < -maximum ||
        component > maximum) ||
        (!signed && component < 0)
      ) {
        throw new ChronoException('Invalid RRULE numeric list.');
      }
      result.add(component);
    }
    return result;
  }
  public Boolean matches(Date day, Date anchor) {
    Integer distance = periodDistance(anchor, day);
    if (Math.mod(distance, interval) != 0) {
      return false;
    }
    if (!months.isEmpty() && !months.contains(day.month())) {
      return false;
    }
    if (!weekdays.isEmpty() && !weekdays.contains(weekday(day))) {
      return false;
    }
    if (!monthDays.isEmpty()) {
      return monthDays.contains(day.day()) ||
        monthDays.contains(
          day.day() - Date.daysInMonth(day.year(), day.month()) - 1
        );
    }
    return defaultDay(day, anchor);
  }
  private Boolean defaultDay(Date day, Date anchor) {
    if (frequency == 'weekly') {
      return !weekdays.isEmpty() || weekday(day) == weekday(anchor);
    }
    if (frequency == 'monthly') {
      return !weekdays.isEmpty() || day.day() == anchor.day();
    }
    if (frequency == 'yearly') {
      if (months.isEmpty() && !weekdays.isEmpty()) {
        return true;
      }
      if (months.isEmpty() && day.month() != anchor.month()) {
        return false;
      }
      return !weekdays.isEmpty() || day.day() == anchor.day();
    }
    return true;
  }
  private Integer periodDistance(Date anchor, Date day) {
    if (frequency == 'yearly') {
      return day.year() - anchor.year();
    }
    if (frequency == 'monthly') {
      return (day.year() - anchor.year()) * 12 + day.month() - anchor.month();
    }
    if (frequency == 'weekly') {
      return ChronoFlowPeriod.periodStart(anchor, 'week', weekStart)
          .daysBetween(ChronoFlowPeriod.periodStart(day, 'week', weekStart)) /
        7;
    }
    return anchor.daysBetween(day);
  }
  public static Integer weekday(Date day) {
    return Math.mod(ChronoHolidays.weekday(day) + 6, 7) + 1;
  }
}
