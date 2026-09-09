// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Validated component construction and replacement using the native-backed core values. */
public with sharing class ChronoValueConstruction { // NOPMD -- PMD counts calls to other services named create as recursion.
  @SuppressWarnings(
    'PMD.CognitiveComplexity'
  ) // Qualified service factories are not recursive calls to this method.
  public static ChronoOperationResult create(ChronoValueFields input) {
    ChronoSupport.choice(
      input.valueType,
      new Set<String>{
        'PlainDate',
        'PlainDateTime',
        'PlainTime',
        'PlainYearMonth',
        'PlainMonthDay',
        'Instant',
        'ZonedDateTime'
      },
      'constructed value type'
    );
    validateShape(input);
    Boolean isTimeOnly = input.valueType == 'PlainTime';
    Date day = isTimeOnly ? null : datePart(input);
    Time clock = hasTime(input.valueType) ? timePart(input) : null;
    Object value;
    switch on input.valueType {
      when 'PlainDate' {
        value = ChronoPlainDateService.create(day);
      }
      when 'PlainTime' {
        value = ChronoPlainTimeService.create(clock);
      }
      when 'PlainDateTime' {
        value = ChronoPlainDateTimeService.create(day, clock);
      }
      when 'PlainYearMonth' {
        value = ChronoPlainYearMonthService.create(day.year(), day.month());
      }
      when 'PlainMonthDay' {
        value = ChronoPlainMonthDayService.create(day.month(), day.day());
      }
      when else {
        ChronoZonedDateTime zoned = ChronoPlainDateTimeService.toZonedDateTime(
          ChronoPlainDateTimeService.create(day, clock),
          input.timeZoneId,
          ChronoFlowConvert.policy(input.disambiguation)
        );
        value = input.valueType == 'Instant'
          ? (Object) ChronoInstantService.create(
              ChronoZonedDateTimeService.toDatetime(zoned)
            )
          : (Object) zoned;
      }
    }
    return new ChronoFlowValue(input.valueType, value).result();
  }
  public static ChronoOperationResult replace(ChronoValueFields input) {
    ChronoDetailsResult original = ChronoValueInspection.details(input);
    if (input.valueType == 'Duration') {
      throw new ChronoException(
        'Use the duration action for duration components.'
      );
    }
    input.year = pick(input.year, original.year);
    input.month = pick(input.month, original.month);
    input.day = pick(input.day, original.day);
    input.hour = pick(input.hour, original.hour);
    input.minute = pick(input.minute, original.minute);
    input.second = pick(input.second, original.second);
    input.millisecond = pick(input.millisecond, original.millisecond);
    if (String.isBlank(input.timeZoneId)) {
      input.timeZoneId = original.timeZoneId;
    }
    return create(input);
  }
  private static Boolean hasTime(String kind) {
    return new Set<String>{
        'PlainDateTime',
        'PlainTime',
        'Instant',
        'ZonedDateTime'
      }
      .contains(kind);
  }
  private static void validateShape(ChronoValueFields input) {
    Boolean hasClock =
      input.hour != null ||
      input.minute != null ||
      input.second != null ||
      input.millisecond != null;
    if (!hasTime(input.valueType) && hasClock) {
      throw new ChronoException(
        'Clock fields are not valid for this value type.'
      );
    }
    validateCalendarFields(input);
    if (!String.isBlank(input.overflow)) {
      ChronoSupport.choice(
        input.overflow,
        new Set<String>{ 'reject', 'constrain' },
        'overflow handling'
      );
    }
  }
  private static void validateCalendarFields(ChronoValueFields input) {
    Map<String, List<Integer>> forbidden = new Map<String, List<Integer>>{
      'PlainTime' => new List<Integer>{ input.year, input.month, input.day },
      'PlainMonthDay' => new List<Integer>{ input.year },
      'PlainYearMonth' => new List<Integer>{ input.day }
    };
    if (!forbidden.containsKey(input.valueType)) {
      return;
    }
    for (Integer component : forbidden.get(input.valueType)) {
      if (component != null) {
        throw new ChronoException(
          'Calendar fields do not belong to ' + input.valueType + '.'
        );
      }
    }
  }

  private static Date datePart(ChronoValueFields input) {
    Integer year = input.valueType == 'PlainMonthDay' ? 2000 : input.year;
    Integer day = input.valueType == 'PlainYearMonth' ? 1 : input.day;
    ChronoSupport.requireValue(year, 'Year');
    ChronoSupport.requireValue(input.month, 'Month');
    ChronoSupport.requireValue(day, 'Day');
    Integer month = input.month;
    if (input.overflow == 'constrain') {
      month = Math.max(1, Math.min(12, month));
      day = Math.max(1, Math.min(Date.daysInMonth(year, month), day));
    }
    return ChronoIso.parseDate(
      ChronoIso.pad(year, 4) +
        '-' +
        ChronoIso.pad(month, 2) +
        '-' +
        ChronoIso.pad(day, 2)
    );
  }
  private static Time timePart(ChronoValueFields input) {
    if (
      input.millisecond != null &&
      (input.millisecond < 0 ||
      input.millisecond > 999)
    ) {
      throw new ChronoException('Millisecond must be between 0 and 999.');
    }
    return ChronoIso.parseTime(
      ChronoIso.pad(pick(input.hour, 0), 2) +
        ':' +
        ChronoIso.pad(pick(input.minute, 0), 2) +
        ':' +
        ChronoIso.pad(pick(input.second, 0), 2) +
        '.' +
        ChronoIso.pad(pick(input.millisecond, 0), 3)
    );
  }
  private static Integer pick(Integer supplied, Integer original) {
    return supplied == null ? original : supplied;
  }
}
