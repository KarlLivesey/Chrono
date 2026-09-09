// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
// Exact package query budgets are asserted by the corresponding in-package tests.
// Subscriber Limits counters do not include the skel namespace.
@IsTest
private class ChronoBulkCalcConsumerTest {
  @IsTest
  static void convertsAllEightTypesInIndependentOrderedBatch() {
    List<String> types = new List<String>{
      'Instant',
      'ZonedDateTime',
      'PlainDateTime',
      'PlainDate',
      'PlainTime',
      'PlainYearMonth',
      'PlainMonthDay',
      'Duration'
    };
    List<String> values = new List<String>{
      '2026-09-07T08:00Z',
      '2026-09-07T09:00+01:00[Europe/London]',
      '2026-09-07T09:00',
      '2026-09-07',
      '09:00',
      '2026-09',
      '--09-07',
      'PT1H'
    };
    List<skel.ChronoConvertInput> inputs = new List<skel.ChronoConvertInput>();
    for (Integer i = 0; i < 200; i++) {
      Integer index = Math.mod(i, 8);
      skel.ChronoConvertInput input = new skel.ChronoConvertInput();
      input.valueType = types[index];
      input.targetType = types[index];
      input.value = values[index];
      inputs.add(input);
    }
    inputs.add(null);
    Test.startTest();
    List<skel.ChronoValueResult> results = skel.ChronoValueService.convert(
      inputs
    );
    Test.stopTest();
    Assert.areEqual(201, results.size());
    for (Integer i = 0; i < 200; i++) {
      Assert.isTrue(
        results[i].success,
        'Item ' + i + ': ' + results[i].errorMessage
      );
      skel.ChronoValue value = results[i].value;
      Assert.areEqual(types[Math.mod(i, 8)], value.valueType);
      Integer populated = 0;
      for (
        Object part : new List<Object>{
          value.instant,
          value.zonedDateTime,
          value.plainDateTime,
          value.plainDate,
          value.plainTime,
          value.yearMonth,
          value.monthDay,
          value.duration
        }
      ) {
        if (part != null) {
          populated++;
        }
      }
      Assert.areEqual(1, populated, 'Exactly one typed value');
    }
    Assert.isFalse(results[200].success);
    results[0].value.instant.value = null;
    results[1].value.zonedDateTime.timeZoneId = 'GMT';
    results[3].value.plainDate.value = null;
    results[7].value.duration.milliseconds = 1;
    Assert.isNotNull(results[8].value.instant.value);
    Assert.areEqual('Europe/London', results[9].value.zonedDateTime.timeZoneId);
    Assert.areEqual(
      Date.newInstance(2026, 9, 7),
      results[11].value.plainDate.value
    );
    Assert.areEqual(3600000L, results[15].value.duration.milliseconds);
    Assert.areEqual(values[0], inputs[0].value, 'Requests remain unchanged');
  }
  @IsTest
  static void arithmeticAndComparisonExposeNativeValues() {
    skel.ChronoAdjustInput adjust = new skel.ChronoAdjustInput();
    adjust.valueType = 'PlainDate';
    adjust.dateValue = Date.newInstance(2026, 1, 31);
    adjust.amount = 1;
    adjust.unit = 'months';
    List<skel.ChronoValueResult> adjusted = skel.ChronoCalculationService.adjust(
      new List<skel.ChronoAdjustInput>{ adjust, null }
    );
    Assert.isTrue(
      adjusted[0].success,
      'Expected success: ' + adjusted[0].errorMessage
    );
    Assert.areEqual(
      Date.newInstance(2026, 2, 28),
      adjusted[0].value.plainDate.value
    );
    Assert.isFalse(adjusted[1].success);
    skel.ChronoDifferenceInput elapsed = new skel.ChronoDifferenceInput();
    elapsed.startInstant = Datetime.newInstanceGmt(2026, 9, 7, 9, 0, 0);
    elapsed.endInstant = elapsed.startInstant.addMinutes(90);
    List<skel.ChronoDurationCalculationResult> durations = skel.ChronoCalculationService.difference(
      new List<skel.ChronoDifferenceInput>{ elapsed, elapsed, null }
    );
    Assert.areEqual(5400000L, durations[0].value.milliseconds);
    durations[0].value.milliseconds = 0;
    Assert.areEqual(5400000L, durations[1].value.milliseconds);
    Assert.isFalse(durations[2].success);
    skel.ChronoCalendarDifferenceInput calendar = new skel.ChronoCalendarDifferenceInput();
    calendar.valueType = 'PlainDateTime';
    calendar.value = '2026-01-31T10:00';
    calendar.endValueType = 'PlainDateTime';
    calendar.endValue = '2026-03-02T11:30';
    calendar.largestUnit = 'month';
    skel.ChronoDurationCalculationResult difference = skel.ChronoCalculationService.calendarDifference(
      new List<skel.ChronoCalendarDifferenceInput>{ calendar }
    )[0];
    Assert.isTrue(
      difference.success,
      'Expected success: ' + difference.errorMessage
    );
    Assert.areEqual(1, difference.value.months);
    Assert.areEqual(2, difference.value.days);
    Assert.areEqual(5400000L, difference.value.milliseconds);
    skel.ChronoCompareInput compare = new skel.ChronoCompareInput();
    compare.valueType = 'PlainDate';
    compare.value = '2026-01-01';
    compare.endValueType = 'PlainDate';
    compare.endValue = '2026-01-02';
    Assert.areEqual(
      -1,
      skel.ChronoCalculationService.compare(
          new List<skel.ChronoCompareInput>{ compare }
        )[0]
        .comparison
    );
  }
  @IsTest
  static void boundariesAndRoundingKeepValueType() {
    skel.ChronoPeriodBoundaryInput boundary = new skel.ChronoPeriodBoundaryInput();
    boundary.valueType = 'PlainDate';
    boundary.value = '2026-09-07';
    boundary.unit = 'month';
    boundary.boundary = 'start';
    skel.ChronoValueResult start = skel.ChronoCalculationService.boundary(
      new List<skel.ChronoPeriodBoundaryInput>{ boundary }
    )[0];
    Assert.isTrue(start.success, 'Expected success: ' + start.errorMessage);
    Assert.areEqual(Date.newInstance(2026, 9, 1), start.value.plainDate.value);
    skel.ChronoRoundInput input = new skel.ChronoRoundInput();
    input.valueType = 'PlainTime';
    input.value = '10:07:30';
    input.unit = 'minute';
    input.increment = 15;
    input.roundingMode = 'ceil';
    skel.ChronoValueResult rounded = skel.ChronoCalculationService.round(
      new List<skel.ChronoRoundInput>{ input }
    )[0];
    Assert.isTrue(rounded.success, 'Expected success: ' + rounded.errorMessage);
    Assert.areEqual(
      Time.newInstance(10, 15, 0, 0),
      rounded.value.plainTime.value
    );
  }
  @IsTest
  static void localResolutionReturnsTypedOccurrencesAndNearestBoundaries() {
    skel.ChronoResolveLocalInput repeated = new skel.ChronoResolveLocalInput();
    repeated.valueType = 'PlainDateTime';
    repeated.value = '2026-10-25T01:30';
    repeated.timeZoneId = 'Europe/London';
    skel.ChronoResolveLocalInput missing = new skel.ChronoResolveLocalInput();
    missing.valueType = 'PlainDateTime';
    missing.value = '2026-03-29T01:30';
    missing.timeZoneId = 'Europe/London';
    List<skel.ChronoLocalResolutionResult> results = skel.ChronoTimeZoneService.resolveLocal(
      new List<skel.ChronoResolveLocalInput>{
        repeated,
        missing,
        repeated,
        null
      }
    );
    Assert.isTrue(
      results[0].success,
      'Expected success: ' + results[0].errorMessage
    );
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 10, 25, 0, 30, 0),
      results[0].earlierValue.instant
    );
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 10, 25, 1, 30, 0),
      results[0].laterValue.instant
    );
    Assert.isTrue(
      results[1].success,
      'Expected success: ' + results[1].errorMessage
    );
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 3, 29, 1, 0, 0).getTime() - 1,
      results[1].previousValue.instant.getTime()
    );
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 3, 29, 1, 0, 0),
      results[1].nextValue.instant
    );
    results[0].earlierValue.instant = null;
    Assert.isNotNull(results[2].earlierValue.instant);
    Assert.isFalse(results[3].success);
  }
}
