// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoFlowOperationsTest {
  private static ChronoOperationInput item(String type, String iso) {
    ChronoOperationInput input = new ChronoOperationInput();
    input.source.valueType = type;
    input.source.value = iso;
    return input;
  }
  private static ChronoFlowResult run(
    String family,
    ChronoOperationInput input
  ) {
    ChronoFlowResult result = new ChronoFlowBatch(family)
      .run(new List<Object>{ input })[0];
    Assert.isTrue(
      result.success,
      result.errorMessage == null
        ? 'Action should succeed'
        : result.errorMessage
    );
    return result;
  }
  private static void fails(
    String family,
    ChronoOperationInput input,
    String text
  ) {
    ChronoFlowResult result = new ChronoFlowBatch(family)
      .run(new List<Object>{ input })[0];
    Assert.isFalse(result.success, 'Expected invalid input');
    Assert.isTrue(result.errorMessage.contains(text), result.errorMessage);
  }
  private static ChronoOperationInput pair(
    String type,
    String first,
    String last
  ) {
    ChronoOperationInput input = item(type, first);
    input.finish.valueType = type;
    input.finish.value = last;
    return input;
  }
  @SuppressWarnings('PMD.NcssCount')
  @IsTest
  static void resultTransportPreservesEveryField() {
    ChronoOperationResult operation = new ChronoOperationResult();
    operation.success = true;
    operation.errorMessage = 'diagnostic';
    operation.valueType = 'ZonedDateTime';
    operation.value = '2026-09-07T10:15:00.000+01:00[Europe/London]';
    operation.instantValue = Datetime.newInstanceGmt(2026, 9, 7, 9, 15, 0);
    operation.dateValue = Date.newInstance(2026, 9, 7);
    operation.timeValue = '10:15:00.000';
    operation.timeZoneId = 'Europe/London';
    operation.months = 2;
    operation.days = 3;
    operation.milliseconds = 4000;
    operation.isOpen = true;
    operation.comparison = -1;
    operation.resolutionStatus = 'repeated';
    operation.earlierValue = 'earlier';
    operation.laterValue = 'later';
    operation.previousValue = 'previous';
    operation.nextValue = 'next';
    operation.withinTolerance = true;
    operation.samePeriod = false;
    ChronoFlowResult result = ChronoFlowResults.fromOperation(operation);
    Assert.areEqual(operation.success, result.success);
    Assert.areEqual(operation.errorMessage, result.errorMessage);
    Assert.areEqual(operation.valueType, result.valueType);
    Assert.areEqual(operation.value, result.value);
    Assert.areEqual(operation.instantValue, result.instantValue);
    Assert.areEqual(operation.dateValue, result.dateValue);
    Assert.areEqual(operation.timeValue, result.timeValue);
    Assert.areEqual(operation.timeZoneId, result.timeZoneId);
    Assert.areEqual(operation.months, result.months);
    Assert.areEqual(operation.days, result.days);
    Assert.areEqual(operation.milliseconds, result.milliseconds);
    Assert.areEqual(operation.isOpen, result.isOpen);
    Assert.areEqual(operation.comparison, result.comparison);
    Assert.areEqual(operation.resolutionStatus, result.resolutionStatus);
    Assert.areEqual(operation.earlierValue, result.earlierValue);
    Assert.areEqual(operation.laterValue, result.laterValue);
    Assert.areEqual(operation.previousValue, result.previousValue);
    Assert.areEqual(operation.nextValue, result.nextValue);
    Assert.areEqual(operation.withinTolerance, result.withinTolerance);
    Assert.areEqual(operation.samePeriod, result.samePeriod);

    ChronoFlowResult copied = ChronoFlowResults.copy(result);
    copied.value = 'changed';
    Assert.areEqual(operation.value, result.value);
    Assert.areEqual('changed', copied.value);
    Assert.isFalse(ChronoFlowResults.failure('bad input').success);
    Assert.areEqual(
      'bad input',
      ChronoFlowResults.failure('bad input').errorMessage
    );
    Assert.isTrue(ChronoFlowResults.success().success);
  }
  @IsTest
  static void compareExactAndPlainFamilies() {
    ChronoOperationInput input = pair(
      'ZonedDateTime',
      '2026-10-25T01:30+00:00[Europe/London]',
      '2026-10-24T21:30-04:00[America/New_York]'
    );
    Assert.areEqual(
      0,
      run('Compare', input).comparison,
      'Same instant in different zones'
    );
    input.finish.value = '2026-10-25T01:30+01:00[Europe/London]';
    Assert.areEqual(
      1,
      run('Compare', input).comparison,
      'Repeated wall time still compares exact instants'
    );
    for (
      String type : new List<String>{
        'PlainDate',
        'PlainDateTime',
        'PlainTime',
        'PlainYearMonth',
        'PlainMonthDay'
      }
    ) {
      Map<String, String> a = new Map<String, String>{
        'PlainDate' => '2026-01-01',
        'PlainDateTime' => '2026-01-01T23:00',
        'PlainTime' => '09:00',
        'PlainYearMonth' => '2025-12',
        'PlainMonthDay' => '--02-29'
      };
      Map<String, String> b = new Map<String, String>{
        'PlainDate' => '2026-01-02',
        'PlainDateTime' => '2026-01-02T01:00',
        'PlainTime' => '10:00',
        'PlainYearMonth' => '2026-01',
        'PlainMonthDay' => '--03-01'
      };
      Assert.areEqual(
        -1,
        run('Compare', pair(type, a.get(type), b.get(type))).comparison,
        type
      );
    }
    input = pair('Instant', '2026-01-01T00:00Z', '2026-01-01T01:00Z');
    Assert.areEqual(-1, run('Compare', input).comparison);
    input.finish.valueType = 'PlainDate';
    input.finish.value = '2026-01-01';
    fails('Compare', input, 'matching plain');
  }
  @IsTest
  static void compareCalendarDurationsNeedsAnchor() {
    ChronoOperationInput input = pair('Duration', 'PT60S', 'PT1M');
    Assert.areEqual(0, run('Compare', input).comparison);
    input.source.value = 'P1D';
    input.finish.value = 'PT24H';
    fails('Compare', input, 'reference date');
    input.referenceDate = Date.newInstance(2026, 3, 29);
    input.source.timeZoneId = 'Europe/London';
    Assert.areEqual(
      -1,
      run('Compare', input).comparison,
      'A spring calendar day is shorter than 24 elapsed hours'
    );
  }
  @IsTest
  static void periodBoundariesRespectDstAndWeekChoice() {
    ChronoOperationInput input = item(
      'ZonedDateTime',
      '2026-03-29T12:00+01:00[Europe/London]'
    );
    input.unit = 'day';
    input.boundary = 'start';
    ChronoFlowResult start = run('PeriodBoundary', input);
    Assert.areEqual(
      '2026-03-29T00:00:00.000+00:00[Europe/London]',
      start.value
    );
    input.boundary = 'end';
    ChronoFlowResult finish = run('PeriodBoundary', input);
    Assert.areEqual(
      23 * 3600000L,
      finish.instantValue.getTime() - start.instantValue.getTime() + 1
    );
    input = item('PlainDate', '2026-09-09');
    input.unit = 'week';
    input.boundary = 'start';
    input.weekStartsOn = 7;
    Assert.areEqual('2026-09-06', run('PeriodBoundary', input).value);
    input.weekStartsOn = 0;
    fails('PeriodBoundary', input, '1 (Monday)');
    input = item('Instant', '2015-10-18T12:00Z');
    input.source.timeZoneId = 'America/Sao_Paulo';
    input.unit = 'day';
    input.boundary = 'start';
    Assert.areEqual(
      '2015-10-18T03:00:00.000Z',
      run('PeriodBoundary', input).value,
      'Skipped midnight starts at 01:00 local'
    );
  }
  @IsTest
  static void periodsPlainDateTimeAndInvalidPartial() {
    ChronoOperationInput input = item('PlainDateTime', '2024-02-12T10:00');
    input.unit = 'month';
    input.boundary = 'end';
    Assert.areEqual(
      '2024-02-29T23:59:59.999',
      run('PeriodBoundary', input).value
    );
    input.unit = 'year';
    input.boundary = 'start';
    Assert.areEqual(
      '2024-01-01T00:00:00.000',
      run('PeriodBoundary', input).value
    );
    input.source.valueType = 'PlainMonthDay';
    input.source.value = '--02-29';
    fails('PeriodBoundary', input, 'complete date');
  }
  @IsTest
  static void roundingClockAndNegativeElapsed() {
    ChronoOperationInput input = item('PlainDateTime', '2026-09-07T23:58');
    input.unit = 'minute';
    input.increment = 15;
    Assert.areEqual('2026-09-08T00:00:00.000', run('Round', input).value);
    input.roundingMode = 'floor';
    Assert.areEqual('2026-09-07T23:45:00.000', run('Round', input).value);
    input.source.valueType = 'PlainTime';
    input.source.value = '23:58';
    input.roundingMode = 'ceil';
    Assert.areEqual('00:00:00.000', run('Round', input).value);
    input.increment = 7;
    fails('Round', input, 'dividing');
    input = item('Duration', '-PT1.5S');
    input.unit = 'second';
    Assert.areEqual('-PT2.000S', run('Round', input).value);
    input.roundingMode = 'ceil';
    Assert.areEqual('-PT1.000S', run('Round', input).value);
    input = item('Instant', '1969-12-31T23:59:59.500Z');
    input.unit = 'second';
    Assert.areEqual('1969-12-31T23:59:59.000Z', run('Round', input).value);
  }
  @IsTest
  static void roundingPreservesOverlapAndActualDayLength() {
    ChronoOperationInput input = item(
      'ZonedDateTime',
      '2026-10-25T01:37+00:00[Europe/London]'
    );
    input.unit = 'minute';
    input.increment = 15;
    Assert.areEqual(
      '2026-10-25T01:30:00.000+00:00[Europe/London]',
      run('Round', input).value
    );
    input.source.value = '2026-10-25T01:37+01:00[Europe/London]';
    Assert.areEqual(
      '2026-10-25T01:30:00.000+01:00[Europe/London]',
      run('Round', input).value
    );
    input = item('ZonedDateTime', '2026-03-29T12:15+01:00[Europe/London]');
    input.unit = 'day';
    Assert.areEqual(
      '2026-03-29T00:00:00.000+00:00[Europe/London]',
      run('Round', input).value,
      'Before the actual 23-hour midpoint'
    );
    input.source.value = '2026-03-29T12:30+01:00[Europe/London]';
    Assert.areEqual(
      '2026-03-30T00:00:00.000+01:00[Europe/London]',
      run('Round', input).value
    );
  }
  @IsTest
  static void inspectAndResolveOverlapAndGap() {
    ChronoOperationInput input = item('PlainDateTime', '2026-10-25T01:30');
    input.source.timeZoneId = 'Europe/London';
    ChronoFlowResult result = run('ResolveLocal', input);
    Assert.areEqual('repeated', result.resolutionStatus);
    Assert.isNull(result.value);
    Assert.isNotNull(result.earlierValue);
    Assert.isNotNull(result.laterValue);
    input.resolution = 'later';
    Assert.areEqual(result.laterValue, run('ResolveLocal', input).value);
    input.source.value = '2026-03-29T01:30';
    input.resolution = 'inspect';
    result = run('ResolveLocal', input);
    Assert.areEqual('nonexistent', result.resolutionStatus);
    Assert.areEqual(
      '2026-03-29T00:59:59.999+00:00[Europe/London]',
      result.previousValue
    );
    Assert.areEqual(
      '2026-03-29T02:00:00.000+01:00[Europe/London]',
      result.nextValue
    );
    input.resolution = 'forward';
    Assert.areEqual(result.nextValue, run('ResolveLocal', input).value);
    input.resolution = 'earlier';
    fails('ResolveLocal', input, 'does not apply');
    input.source.valueType = 'PlainDate';
    input.source.value = '2026-09-07';
    input.resolution = null;
    result = run('ResolveLocal', input);
    Assert.areEqual('unique', result.resolutionStatus);
    Assert.areEqual(
      '2026-09-07T00:00:00.000+01:00[Europe/London]',
      result.value
    );
  }
  @IsTest
  static void nearestGapBoundariesForNonHourChanges() {
    ChronoOperationInput input = item('PlainDateTime', '2026-10-04T02:15');
    input.source.timeZoneId = 'Australia/Lord_Howe';
    ChronoFlowResult result = run('ResolveLocal', input);
    Assert.areEqual(
      '2026-10-04T02:30:00.000+11:00[Australia/Lord_Howe]',
      result.nextValue
    );
    input.source.value = '2011-12-30T12:00';
    input.source.timeZoneId = 'Pacific/Apia';
    result = run('ResolveLocal', input);
    Assert.areEqual(
      '2011-12-31T00:00:00.000+14:00[Pacific/Apia]',
      result.nextValue
    );
  }
  @IsTest
  static void calendarDifferenceKeepsRemainderSeparate() {
    ChronoOperationInput input = pair(
      'PlainDateTime',
      '2026-01-31T10:00',
      '2026-03-02T12:30'
    );
    input.largestUnit = 'month';
    ChronoFlowResult result = run('CalendarDifference', input);
    Assert.areEqual(1, result.months);
    Assert.areEqual(2, result.days);
    Assert.areEqual(9000000L, result.milliseconds);
    input = pair('PlainDate', '2026-02-28', '2026-01-31');
    input.largestUnit = 'month';
    result = run('CalendarDifference', input);
    Assert.areEqual(0, result.months);
    Assert.areEqual(
      -28,
      result.days,
      'Reverse difference is anchored to its own start'
    );
    input = pair('PlainDate', '2024-02-29', '2025-02-28');
    input.largestUnit = 'year';
    result = run('CalendarDifference', input);
    Assert.areEqual(12, result.months);
    Assert.areEqual(0, result.days);
  }
  @IsTest
  static void zonedCalendarDifferenceRequiresCommonZone() {
    ChronoOperationInput input = pair(
      'ZonedDateTime',
      '2026-03-28T12:00+00:00[Europe/London]',
      '2026-03-29T13:00+01:00[Europe/London]'
    );
    ChronoFlowResult result = run('CalendarDifference', input);
    Assert.areEqual(1, result.days);
    Assert.areEqual(3600000L, result.milliseconds);
    input.finish.value = '2026-03-29T08:00-04:00[America/New_York]';
    fails('CalendarDifference', input, 'explicit calculation timezone');
    input.source.timeZoneId = 'Europe/London';
    input.finish.timeZoneId = 'Europe/London';
    Assert.areEqual(1, run('CalendarDifference', input).days);
    input = pair('PlainDateTime', '2026-09-07T11:00', '2026-09-06T12:00');
    result = run('CalendarDifference', input);
    Assert.areEqual(0, result.days);
    Assert.areEqual(-23 * 3600000L, result.milliseconds);
  }
  @IsTest
  static void duplicateInputsKeepIndependentExpandedResults() {
    ChronoOperationInput input = item('PlainDateTime', '2026-10-25T01:30');
    input.source.timeZoneId = 'Europe/London';
    List<Object> inputs = new List<Object>();
    for (Integer i = 0; i < 200; i++) {
      inputs.add(input);
    }
    ChronoFlowBatch batch = new ChronoFlowBatch('ResolveLocal');
    Test.startTest();
    List<ChronoFlowResult> results = batch.run(inputs);
    Test.stopTest();
    Assert.areEqual(200, results.size());
    Assert.areEqual(1, batch.computationCount);
    results[0].earlierValue = 'changed';
    Assert.areNotEqual(
      'changed',
      results[1].earlierValue,
      'Cached result must not escape'
    );
    Assert.areEqual('repeated', results[199].resolutionStatus);
  }
  @IsTest
  static void quarterToleranceAndRoundingPolicies() {
    ChronoOperationInput input = item('PlainDate', '2026-09-07');
    input.unit = 'quarter';
    input.boundary = 'start';
    Assert.areEqual('2026-07-01', run('PeriodBoundary', input).value);
    input.boundary = 'end';
    Assert.areEqual('2026-09-30', run('PeriodBoundary', input).value);
    input = pair(
      'PlainDateTime',
      '2026-09-07T10:00',
      '2026-09-07T10:00:00.050'
    );
    input.toleranceMilliseconds = 50;
    input.comparisonPeriod = 'day';
    ChronoFlowResult compared = run('Compare', input);
    Assert.isTrue(compared.withinTolerance);
    Assert.isTrue(compared.samePeriod);
    input.toleranceMilliseconds = 49;
    Assert.isFalse(run('Compare', input).withinTolerance);
    input = pair('Duration', 'P1D', 'PT23H');
    input.referenceDate = Date.newInstance(2026, 3, 29);
    input.source.timeZoneId = 'Europe/London';
    input.toleranceMilliseconds = 0;
    Assert.isTrue(
      run('Compare', input).withinTolerance,
      'Calendar and elapsed tolerance share an anchor'
    );
    Map<String, String> expected = new Map<String, String>{
      'halfEven' => '-PT2.000S',
      'halfTrunc' => '-PT1.000S',
      'halfCeil' => '-PT1.000S',
      'halfFloor' => '-PT2.000S',
      'trunc' => '-PT1.000S',
      'expand' => '-PT2.000S'
    };
    input = item('Duration', '-PT1.5S');
    input.unit = 'second';
    for (String mode : expected.keySet()) {
      input.roundingMode = mode;
      Assert.areEqual(expected.get(mode), run('Round', input).value, mode);
    }
    ChronoCompareAction.Request request = new ChronoCompareAction.Request();
    request.valueType = 'PlainDate';
    request.value = '2026-01-01';
    request.endValue = '2026-01-02';
    request.toleranceMilliseconds = 86400000L;
    request.comparisonPeriod = 'month';
    compared = ChronoCompareAction.run(
      new List<ChronoCompareAction.Request>{ request }
    )[0];
    Assert.isTrue(compared.withinTolerance);
    Assert.isTrue(compared.samePeriod);
  }
}
