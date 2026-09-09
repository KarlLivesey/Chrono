// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
@SuppressWarnings('PMD.NcssCount, PMD.ExcessiveParameterList')
private class ChronoOperationInputsTest {
  private static final Datetime INSTANT = Datetime.newInstanceGmt(
    2026,
    9,
    7,
    9,
    15,
    0
  );
  private static final Date TEST_DATE = Date.newInstance(2026, 9, 7);

  private static void assertSource(
    ChronoOperationInput input,
    String valueType,
    String value,
    String expectedFinishType,
    Datetime expectedInstant,
    Date expectedDate,
    String expectedTime,
    String expectedZone,
    String expectedDisambiguation
  ) {
    Assert.areEqual(valueType, input.source.valueType);
    Assert.areEqual(value, input.source.value);
    Assert.areEqual(expectedInstant, input.source.instantValue);
    Assert.areEqual(expectedDate, input.source.dateValue);
    Assert.areEqual(expectedTime, input.source.timeValue);
    Assert.areEqual(expectedZone, input.source.timeZoneId);
    Assert.areEqual(expectedDisambiguation, input.source.disambiguation);
    Assert.areEqual(expectedFinishType, input.finish.valueType);
    Assert.areEqual(expectedZone, input.finish.timeZoneId);
    Assert.areEqual(expectedDisambiguation, input.finish.disambiguation);
  }

  @IsTest
  static void adaptsPeriodAndComparisonInputs() {
    ChronoPeriodBoundaryInput boundary = new ChronoPeriodBoundaryInput();
    boundary.valueType = 'PlainDate';
    boundary.value = '2026-09-07';
    boundary.instantValue = INSTANT;
    boundary.dateValue = TEST_DATE;
    boundary.timeValue = '09:15:00.000';
    boundary.timeZoneId = 'Europe/London';
    boundary.disambiguation = 'later';
    boundary.unit = 'week';
    boundary.boundary = 'start';
    boundary.weekStartsOn = 7;
    ChronoOperationInput period = ChronoOperationInputs.adapt(boundary);
    assertSource(
      period,
      'PlainDate',
      '2026-09-07',
      'PlainDate',
      INSTANT,
      TEST_DATE,
      '09:15:00.000',
      'Europe/London',
      'later'
    );
    Assert.areEqual('week', period.unit);
    Assert.areEqual('start', period.boundary);
    Assert.areEqual(7, period.weekStartsOn);

    ChronoCompareInput compare = new ChronoCompareInput();
    compare.valueType = 'PlainDateTime';
    compare.value = '2026-09-07T09:15';
    compare.instantValue = INSTANT;
    compare.dateValue = TEST_DATE;
    compare.timeValue = '09:15:00.000';
    compare.timeZoneId = 'Europe/London';
    compare.disambiguation = 'later';
    compare.endValueType = 'Instant';
    compare.endValue = '2026-09-07T09:15:00Z';
    compare.endInstant = INSTANT.addMinutes(1);
    compare.endDate = TEST_DATE.addDays(1);
    compare.endTime = '09:16:00.000';
    compare.referenceDate = TEST_DATE;
    compare.toleranceMilliseconds = 250L;
    compare.comparisonPeriod = 'day';
    compare.weekStartsOn = 1;
    ChronoOperationInput compared = ChronoOperationInputs.adapt(compare);
    assertSource(
      compared,
      'PlainDateTime',
      '2026-09-07T09:15',
      'Instant',
      INSTANT,
      TEST_DATE,
      '09:15:00.000',
      'Europe/London',
      'later'
    );
    Assert.areEqual(compare.endInstant, compared.finish.instantValue);
    Assert.areEqual(compare.endDate, compared.finish.dateValue);
    Assert.areEqual(compare.endTime, compared.finish.timeValue);
    Assert.areEqual(compare.referenceDate, compared.referenceDate);
    Assert.areEqual(250L, compared.toleranceMilliseconds);
    Assert.areEqual('day', compared.comparisonPeriod);
    Assert.areEqual(1, compared.weekStartsOn);
    compare.endValueType = null;
    Assert.areEqual(
      compare.valueType,
      ChronoOperationInputs.adapt(compare).finish.valueType
    );

    ChronoCompareAction.Request action = new ChronoCompareAction.Request();
    action.valueType = 'Instant';
    action.value = '2026-09-07T09:15:00Z';
    action.timeZoneId = 'Europe/London';
    action.disambiguation = 'earlier';
    action.endValueType = 'Instant';
    action.endValue = '2026-09-07T10:15:00Z';
    action.referenceDate = TEST_DATE;
    action.toleranceMilliseconds = 500L;
    action.comparisonPeriod = 'month';
    action.weekStartsOn = 2;
    ChronoOperationInput actionInput = ChronoOperationInputs.adapt(action);
    Assert.areEqual('Instant', actionInput.source.valueType);
    Assert.areEqual('Instant', actionInput.finish.valueType);
    Assert.areEqual('month', actionInput.comparisonPeriod);
    Assert.areEqual(2, actionInput.weekStartsOn);
    action.endValueType = null;
    Assert.areEqual(
      action.valueType,
      ChronoOperationInputs.adapt(action).finish.valueType
    );
  }

  @IsTest
  static void adaptsWorkingAndResolutionInputs() {
    OperatingHours hours = new OperatingHours();
    List<TimeSlot> slots = new List<TimeSlot>{ new TimeSlot() };
    List<Holiday> holidays = new List<Holiday>{ new Holiday() };

    ChronoCheckWorkingTimeInput check = new ChronoCheckWorkingTimeInput();
    check.valueType = 'ZonedDateTime';
    check.value = '2026-09-07T10:15+01:00[Europe/London]';
    check.instantValue = INSTANT;
    check.dateValue = TEST_DATE;
    check.timeValue = '10:15:00.000';
    check.timeZoneId = 'Europe/London';
    check.disambiguation = 'earlier';
    check.operatingHoursId = '0H0000000000001AAA';
    check.operatingHours = hours;
    check.timeSlots = slots;
    check.holidays = holidays;
    ChronoOperationInput checked = ChronoOperationInputs.adapt(check);
    assertSource(
      checked,
      'ZonedDateTime',
      check.value,
      'ZonedDateTime',
      INSTANT,
      TEST_DATE,
      '10:15:00.000',
      'Europe/London',
      'earlier'
    );
    Assert.areEqual(check.operatingHoursId, checked.operatingHoursId);
    Assert.areEqual(hours, checked.operatingHours);
    Assert.areEqual(slots, checked.timeSlots);
    Assert.areEqual(holidays, checked.holidays);

    ChronoFindWorkingTimeInput find = new ChronoFindWorkingTimeInput();
    find.valueType = 'Instant';
    find.value = '2026-09-07T09:15:00Z';
    find.timeZoneId = 'Europe/London';
    find.disambiguation = 'later';
    find.operatingHoursId = '0H0000000000002AAA';
    find.direction = 'previous';
    find.operatingHours = hours;
    find.timeSlots = slots;
    find.holidays = holidays;
    ChronoOperationInput found = ChronoOperationInputs.adapt(find);
    Assert.areEqual('Instant', found.source.valueType);
    Assert.areEqual('previous', found.direction);
    Assert.areEqual(find.operatingHoursId, found.operatingHoursId);
    Assert.areEqual(hours, found.operatingHours);
    Assert.areEqual(slots, found.timeSlots);
    Assert.areEqual(holidays, found.holidays);

    ChronoResolveLocalInput resolve = new ChronoResolveLocalInput();
    resolve.valueType = 'PlainDateTime';
    resolve.value = '2026-10-25T01:30';
    resolve.timeZoneId = 'Europe/London';
    resolve.disambiguation = 'reject';
    resolve.resolution = 'later';
    ChronoOperationInput resolved = ChronoOperationInputs.adapt(resolve);
    Assert.areEqual(resolve.value, resolved.source.value);
    Assert.areEqual('later', resolved.resolution);

    ChronoResolveLocalAction.Request resolveAction = new ChronoResolveLocalAction.Request();
    resolveAction.valueType = 'PlainDateTime';
    resolveAction.value = '2026-03-29T01:30';
    resolveAction.timeZoneId = 'Europe/London';
    resolveAction.resolution = 'forward';
    ChronoOperationInput resolvedAction = ChronoOperationInputs.adapt(
      resolveAction
    );
    Assert.areEqual('forward', resolvedAction.resolution);

    ChronoCheckWorkingTimeAction.Request checkAction = new ChronoCheckWorkingTimeAction.Request();
    checkAction.valueType = 'PlainDate';
    checkAction.value = '2026-09-07';
    checkAction.operatingHoursId = '0H0000000000003AAA';
    checkAction.operatingHours = hours;
    checkAction.timeSlots = slots;
    checkAction.holidays = holidays;
    ChronoOperationInput checkedAction = ChronoOperationInputs.adapt(
      checkAction
    );
    Assert.areEqual('PlainDate', checkedAction.source.valueType);
    Assert.areEqual(
      checkAction.operatingHoursId,
      checkedAction.operatingHoursId
    );
    Assert.areEqual(slots, checkedAction.timeSlots);

    ChronoFindWorkingTimeAction.Request findAction = new ChronoFindWorkingTimeAction.Request();
    findAction.valueType = 'PlainDateTime';
    findAction.value = '2026-09-07T10:00';
    findAction.direction = 'next';
    findAction.operatingHours = hours;
    findAction.timeSlots = slots;
    findAction.holidays = holidays;
    ChronoOperationInput foundAction = ChronoOperationInputs.adapt(findAction);
    Assert.areEqual('next', foundAction.direction);
    Assert.areEqual(hours, foundAction.operatingHours);
  }

  @IsTest
  static void adaptsCalendarRoundAndValueRequests() {
    ChronoCalendarDifferenceInput calendar = new ChronoCalendarDifferenceInput();
    calendar.valueType = 'PlainDate';
    calendar.value = '2026-01-01';
    calendar.instantValue = INSTANT;
    calendar.dateValue = TEST_DATE;
    calendar.timeValue = '09:15:00.000';
    calendar.timeZoneId = 'Europe/London';
    calendar.disambiguation = 'later';
    calendar.endValueType = 'PlainDate';
    calendar.endValue = '2026-03-01';
    calendar.endDate = Date.newInstance(2026, 3, 1);
    calendar.endTime = '00:00:00.000';
    calendar.largestUnit = 'month';
    ChronoOperationInput calendarInput = ChronoOperationInputs.adapt(calendar);
    assertSource(
      calendarInput,
      'PlainDate',
      calendar.value,
      'PlainDate',
      INSTANT,
      TEST_DATE,
      '09:15:00.000',
      'Europe/London',
      'later'
    );
    Assert.areEqual(calendar.endValue, calendarInput.finish.value);
    Assert.areEqual(calendar.endDate, calendarInput.finish.dateValue);
    Assert.areEqual('month', calendarInput.largestUnit);
    calendar.endValueType = null;
    Assert.areEqual(
      calendar.valueType,
      ChronoOperationInputs.adapt(calendar).finish.valueType
    );

    ChronoCalendarDifferenceAction.Request calendarAction = new ChronoCalendarDifferenceAction.Request();
    calendarAction.valueType = 'PlainDateTime';
    calendarAction.value = '2026-01-01T10:00';
    calendarAction.endValueType = 'PlainDateTime';
    calendarAction.endValue = '2026-01-02T10:00';
    calendarAction.largestUnit = 'day';
    ChronoOperationInput calendarActionInput = ChronoOperationInputs.adapt(
      calendarAction
    );
    Assert.areEqual('PlainDateTime', calendarActionInput.finish.valueType);
    Assert.areEqual('day', calendarActionInput.largestUnit);
    calendarAction.endValueType = null;
    Assert.areEqual(
      calendarAction.valueType,
      ChronoOperationInputs.adapt(calendarAction).finish.valueType
    );

    ChronoRoundInput round = new ChronoRoundInput();
    round.valueType = 'PlainTime';
    round.value = '10:17';
    round.instantValue = INSTANT;
    round.dateValue = TEST_DATE;
    round.timeValue = '09:15:00.000';
    round.timeZoneId = 'Europe/London';
    round.disambiguation = 'earlier';
    round.unit = 'minute';
    round.increment = 15;
    round.roundingMode = 'floor';
    ChronoOperationInput rounded = ChronoOperationInputs.adapt(round);
    assertSource(
      rounded,
      'PlainTime',
      round.value,
      'PlainTime',
      INSTANT,
      TEST_DATE,
      '09:15:00.000',
      'Europe/London',
      'earlier'
    );
    Assert.areEqual('minute', rounded.unit);
    Assert.areEqual(15, rounded.increment);
    Assert.areEqual('floor', rounded.roundingMode);

    ChronoRoundAction.Request roundAction = new ChronoRoundAction.Request();
    roundAction.valueType = 'Instant';
    roundAction.value = '2026-09-07T09:15:30Z';
    roundAction.unit = 'second';
    roundAction.increment = 5;
    roundAction.roundingMode = 'ceil';
    ChronoOperationInput roundedAction = ChronoOperationInputs.adapt(
      roundAction
    );
    Assert.areEqual('second', roundedAction.unit);
    Assert.areEqual(5, roundedAction.increment);
    Assert.areEqual('ceil', roundedAction.roundingMode);

    ChronoPeriodBoundaryAction.Request periodAction = new ChronoPeriodBoundaryAction.Request();
    periodAction.valueType = 'PlainDate';
    periodAction.value = '2026-09-07';
    periodAction.unit = 'month';
    periodAction.boundary = 'end';
    periodAction.weekStartsOn = 1;
    ChronoOperationInput periodActionInput = ChronoOperationInputs.adapt(
      periodAction
    );
    Assert.areEqual('month', periodActionInput.unit);
    Assert.areEqual('end', periodActionInput.boundary);
    Assert.areEqual(1, periodActionInput.weekStartsOn);
  }

  @IsTest
  static void adaptsAdjustConvertDifferenceAndWorkingRequests() {
    ChronoAdjustAction.Request adjust = new ChronoAdjustAction.Request();
    adjust.valueType = 'ZonedDateTime';
    adjust.value = '2026-09-07T10:15+01:00[Europe/London]';
    adjust.instantValue = INSTANT;
    adjust.dateValue = TEST_DATE;
    adjust.timeValue = '10:15:00.000';
    adjust.timeZoneId = 'Europe/London';
    adjust.disambiguation = 'later';
    adjust.duration = 'P1D';
    adjust.amount = 2;
    adjust.unit = 'hours';
    ChronoAdjustInput adjusted = ChronoOperationInputs.adapt(adjust);
    Assert.areEqual(adjust.valueType, adjusted.valueType);
    Assert.areEqual(adjust.value, adjusted.value);
    Assert.areEqual(adjust.instantValue, adjusted.instantValue);
    Assert.areEqual(adjust.dateValue, adjusted.dateValue);
    Assert.areEqual(adjust.timeValue, adjusted.timeValue);
    Assert.areEqual(adjust.timeZoneId, adjusted.timeZoneId);
    Assert.areEqual(adjust.disambiguation, adjusted.disambiguation);
    Assert.areEqual(adjust.duration, adjusted.duration);
    Assert.areEqual(adjust.amount, adjusted.amount);
    Assert.areEqual(adjust.unit, adjusted.unit);

    ChronoConvertAction.Request convert = new ChronoConvertAction.Request();
    convert.valueType = 'PlainTime';
    convert.value = '10:15';
    convert.instantValue = INSTANT;
    convert.dateValue = TEST_DATE;
    convert.timeValue = '10:15:00.000';
    convert.targetType = 'PlainDateTime';
    convert.timeZoneId = 'Europe/London';
    convert.disambiguation = 'earlier';
    convert.referenceDate = TEST_DATE;
    convert.referenceTime = '10:15:00.000';
    ChronoConvertInput converted = ChronoOperationInputs.adapt(convert);
    Assert.areEqual(convert.valueType, converted.valueType);
    Assert.areEqual(convert.value, converted.value);
    Assert.areEqual(convert.targetType, converted.targetType);
    Assert.areEqual(convert.referenceDate, converted.referenceDate);
    Assert.areEqual(convert.referenceTime, converted.referenceTime);

    ChronoDifferenceAction.Request difference = new ChronoDifferenceAction.Request();
    difference.startInstant = INSTANT;
    difference.startValue = '2026-09-07T10:15:00Z';
    difference.endInstant = INSTANT.addHours(2);
    difference.endValue = '2026-09-07T12:15:00Z';
    difference.operatingHoursId = '0H0000000000004AAA';
    difference.startDate = TEST_DATE;
    difference.startTime = '10:15:00.000';
    difference.endDate = TEST_DATE.addDays(1);
    difference.endTime = '12:15:00.000';
    difference.timeZoneId = 'Europe/London';
    difference.disambiguation = 'later';
    difference.endTimeZoneId = 'America/New_York';
    difference.endDisambiguation = 'earlier';
    OperatingHours hours = new OperatingHours();
    List<TimeSlot> slots = new List<TimeSlot>{ new TimeSlot() };
    List<Holiday> holidays = new List<Holiday>{ new Holiday() };
    difference.operatingHours = hours;
    difference.timeSlots = slots;
    difference.holidays = holidays;
    ChronoDifferenceInput differenced = ChronoOperationInputs.adapt(difference);
    Assert.areEqual(difference.startInstant, differenced.startInstant);
    Assert.areEqual(difference.startValue, differenced.startValue);
    Assert.areEqual(difference.endInstant, differenced.endInstant);
    Assert.areEqual(difference.endValue, differenced.endValue);
    Assert.areEqual(difference.operatingHoursId, differenced.operatingHoursId);
    Assert.areEqual(difference.startDate, differenced.startDate);
    Assert.areEqual(difference.startTime, differenced.startTime);
    Assert.areEqual(difference.endDate, differenced.endDate);
    Assert.areEqual(difference.endTime, differenced.endTime);
    Assert.areEqual(difference.timeZoneId, differenced.timeZoneId);
    Assert.areEqual(difference.disambiguation, differenced.disambiguation);
    Assert.areEqual(difference.endTimeZoneId, differenced.endTimeZoneId);
    Assert.areEqual(
      difference.endDisambiguation,
      differenced.endDisambiguation
    );
    Assert.areEqual(hours, differenced.operatingHours);
    Assert.areEqual(slots, differenced.timeSlots);
    Assert.areEqual(holidays, differenced.holidays);

    ChronoWorkingTimeAction.Request working = new ChronoWorkingTimeAction.Request();
    working.startInstant = INSTANT;
    working.startValue = '2026-09-07T10:15:00Z';
    working.timeZoneId = 'Europe/London';
    working.amount = -3;
    working.unit = 'minutes';
    working.scheduleType = 'OperatingHours';
    working.scheduleId = '0H0000000000005AAA';
    working.startDate = TEST_DATE;
    working.startTime = '10:15:00.000';
    working.disambiguation = 'earlier';
    working.operatingHours = hours;
    working.timeSlots = slots;
    working.holidays = holidays;
    ChronoWorkingTimeInput worked = ChronoOperationInputs.adapt(working);
    Assert.areEqual(working.startInstant, worked.startInstant);
    Assert.areEqual(working.startValue, worked.startValue);
    Assert.areEqual(working.timeZoneId, worked.timeZoneId);
    Assert.areEqual(working.amount, worked.amount);
    Assert.areEqual(working.unit, worked.unit);
    Assert.areEqual(working.scheduleType, worked.scheduleType);
    Assert.areEqual(working.scheduleId, worked.scheduleId);
    Assert.areEqual(working.startDate, worked.startDate);
    Assert.areEqual(working.startTime, worked.startTime);
    Assert.areEqual(working.disambiguation, worked.disambiguation);
    Assert.areEqual(hours, worked.operatingHours);
    Assert.areEqual(slots, worked.timeSlots);
    Assert.areEqual(holidays, worked.holidays);
  }
}
