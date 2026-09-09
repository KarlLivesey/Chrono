// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Bounded local-clock recurrences with explicit DST and operating-hour corrections. */
public with sharing class ChronoRecurrence implements ChronoActionOperation { // NOPMD -- Aggregate spans separate calendar generation, resolution and schedule operations.
  private final ChronoScheduleCatalogue schedules;
  public ChronoRecurrence(List<Object> requests) {
    List<Object> nativeInputs = new List<Object>();
    for (Object request : requests) {
      nativeInputs.add(
        request == null ? null : nativeSchedule((ChronoRecurrenceInput) request)
      );
    }
    schedules = new ChronoScheduleCatalogue(nativeInputs);
  }
  public ChronoRecurrenceResult execute(ChronoRecurrenceInput input) {
    ChronoSupport.requireValue(input, 'Input');
    return new Occurrences(input, schedules).run();
  }
  private static ChronoAvailabilityInput nativeSchedule(
    ChronoRecurrenceInput input
  ) {
    ChronoAvailabilityInput result = new ChronoAvailabilityInput();
    result.operatingHoursId = input.operatingHoursId;
    result.operatingHours = input.operatingHours;
    result.timeSlots = input.timeSlots;
    result.holidays = input.holidays;
    return result;
  }
  private class Occurrences { // NOPMD -- Per-request state connects independent operations; method limits remain enforced.
    private final ChronoRecurrenceInput input;
    private final ChronoOperationValue source;
    private final Date anchor;
    private final Time clock;
    private final Integer maximum;
    private final String closedPolicy;
    private ChronoScheduleCatalogue.Schedule schedule;
    private ChronoRecurrenceResult result;
    private Occurrences(
      ChronoRecurrenceInput input,
      ChronoScheduleCatalogue schedules
    ) {
      this.input = input;
      source = new ChronoOperationValue(ChronoValueInputs.source(input));
      Datetime wall = source.wallClock();
      anchor = wall.dateGmt();
      clock = wall.timeGmt();
      maximum = ChronoIntervals.resultLimit(input.maximumResults);
      closedPolicy = String.isBlank(input.closedPolicy)
        ? 'keep'
        : input.closedPolicy;
      ChronoSupport.choice(
        closedPolicy,
        new Set<String>{ 'keep', 'skip', 'next', 'previous' },
        'closed schedule policy'
      );
      if (closedPolicy != 'keep' || input.operation == 'nthWorkingDay') {
        schedule = schedules.primary(nativeSchedule(input));
      }
      result = new ChronoRecurrenceResult();
      result.success = true;
      result.values = new List<String>();
      result.dates = new List<Date>();
    }
    private ChronoRecurrenceResult run() {
      if (input.operation == 'generate' || input.operation == 'rrule') {
        generate();
      } else {
        List<Date> days = input.operation == 'nthWorkingDay'
          ? workingDay()
          : ChronoRecurrenceDates.choose(input, anchor);
        for (Date day : days) {
          append(resolve(day));
        }
      }
      result.count = result.values.size();
      result.found = result.count > 0;
      result.value = result.found ? result.values[0] : null;
      return result;
    }
    private void generate() {
      ChronoRecurrenceRule rule = new ChronoRecurrenceRule(input);
      Date finish = lastDate(rule);
      Integer emitted = 0;
      for (Date day = anchor; day <= finish; day = day.addDays(1)) {
        if (!rule.matches(day, anchor)) {
          continue;
        }
        ChronoOperationResult value = resolve(day);
        if (value == null) {
          continue;
        }
        if (pastUntil(value, rule)) {
          break;
        }
        emitted++;
        append(value);
        if (rule.count != null && emitted == rule.count) {
          break;
        }
      }
    }
    private Date lastDate(ChronoRecurrenceRule rule) {
      ChronoSupport.requireValue(input.untilDate, 'Search through date');
      if (
        input.untilDate < anchor ||
        anchor.daysBetween(input.untilDate) > 3660
      ) {
        throw new ChronoException(
          'Recurrence search must end within 3660 days after its start.'
        );
      }
      if (input.operation == 'rrule' && !rule.matches(anchor, anchor)) {
        throw new ChronoException(
          'The RRULE seed must match its filters; RFC 5545 leaves a mismatched DTSTART undefined.'
        );
      }
      return rule.untilDate == null ||
        rule.untilDate > input.untilDate
        ? input.untilDate
        : rule.untilDate;
    }
    private Boolean pastUntil(
      ChronoOperationResult value,
      ChronoRecurrenceRule rule
    ) {
      if (rule.untilInstant == null) {
        return false;
      }
      Datetime point = source.isExact()
        ? value.instantValue
        : Datetime.newInstanceGmt(
            value.dateValue,
            ChronoIso.parseTime(value.timeValue)
          );
      return point > rule.untilInstant;
    }
    private ChronoOperationResult resolve(Date day) {
      Datetime wall = Datetime.newInstanceGmt(day, clock);
      if (!source.isExact()) {
        return source.fromWall(wall);
      }
      List<ChronoPickerOption> options = ChronoLocalCandidates.resolveLocal(
        ChronoIso.dateText(day),
        ChronoIso.timeText(clock),
        source.zoneId
      );
      Boolean gap = options[0].choice == 'backward';
      if (input.operation == 'rrule') {
        return gap ? null : source.fromInstant(options[0].instantValue);
      }
      if (!gap) {
        return source.fromWall(wall);
      }
      return resolveGap(options, day);
    }
    private ChronoOperationResult resolveGap(
      List<ChronoPickerOption> options,
      Date day
    ) {
      String policy = String.isBlank(input.gapPolicy)
        ? 'reject'
        : input.gapPolicy;
      ChronoSupport.choice(
        policy,
        new Set<String>{ 'reject', 'skip', 'forward', 'backward' },
        'skipped-time policy'
      );
      if (policy == 'skip') {
        return null;
      }
      if (policy == 'reject') {
        throw new ChronoException(
          'Recurring local time does not exist on ' + day + '.'
        );
      }
      return source.fromInstant(
        options[policy == 'forward' ? 1 : 0].instantValue
      );
    }
    private void append(ChronoOperationResult value) {
      if (value == null) {
        return;
      }
      value = adjustClosed(value);
      if (value == null) {
        return;
      }
      if (result.values.size() == maximum) {
        throw new ChronoException(
          'Recurrence result limit exceeded. Narrow the range or specify an occurrence count.'
        );
      }
      result.values.add(value.value);
      result.dates.add(value.dateValue);
    }
    private ChronoOperationResult adjustClosed(ChronoOperationResult value) {
      if (closedPolicy == 'keep') {
        return value;
      }
      Boolean dateOnly = value.valueType == 'PlainDate';
      Datetime instant = scheduleInstant(value, dateOnly);
      if (
        schedule.picker.contains(dateOnly ? value.dateValue : null, instant)
      ) {
        return value;
      }
      if (closedPolicy == 'skip') {
        return null;
      }
      Datetime adjusted = schedule.picker.nearest(
        dateOnly ? value.dateValue : null,
        instant,
        closedPolicy == 'next' ? 1 : -1
      );
      if (dateOnly) {
        return new ChronoFlowValue(
            'PlainDate',
            ChronoPlainDateService.create(schedule.picker.localDate(adjusted))
          )
          .result();
      }
      return source.isExact()
        ? source.fromInstant(adjusted)
        : source.fromWall(ChronoSupport.localValue(adjusted, source.zoneId));
    }
    private Datetime scheduleInstant(
      ChronoOperationResult value,
      Boolean dateOnly
    ) {
      if (dateOnly) {
        return null;
      }
      return source.isExact()
        ? value.instantValue
        : source.resolve(
            Datetime.newInstanceGmt(
              value.dateValue,
              ChronoIso.parseTime(value.timeValue)
            )
          );
    }
    private List<Date> workingDay() {
      ChronoRecurrenceDates.requireOrdinal(input.ordinal, 31);
      List<Date> days = new List<Date>();
      Date first = Date.newInstance(anchor.year(), anchor.month(), 1);
      for (
        Integer offset = 0;
        offset < Date.daysInMonth(anchor.year(), anchor.month());
        offset++
      ) {
        Date day = first.addDays(offset);
        if (schedule.picker.contains(day, null)) {
          days.add(day);
        }
      }
      return ChronoRecurrenceDates.nth(days, input.ordinal);
    }
  }
  /** @description Executes a concrete request through the internal operation contract. */
  public Object evaluate(Object input) {
    return this.execute((ChronoRecurrenceInput) input);
  }
  /** @description Supplies the concrete result used to isolate batched results. */
  public Type resultType() {
    return ChronoRecurrenceResult.class;
  }
}
