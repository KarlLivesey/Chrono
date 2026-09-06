// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoFlowArithmeticTest {
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Compact test cases state type, value, amount and unit.
  private static ChronoAdjustInput input(
    String kind,
    String value,
    Integer amount,
    String unit
  ) {
    ChronoAdjustInput item = new ChronoAdjustInput();
    item.valueType = kind;
    item.value = value;
    item.amount = amount;
    item.unit = unit;
    return item;
  }
  private static ChronoFlowResult adjust(ChronoAdjustInput item) {
    return runAdjust(new List<ChronoAdjustInput>{ item })[0];
  }
  @IsTest
  static void arithmeticUsesCoreSemantics() {
    Assert.areEqual(
      '2026-02-28',
      adjust(input('PlainDate', '2026-01-31', 1, 'months')).value,
      'Month end constrained'
    );
    Assert.areEqual(
      '2027-01',
      adjust(input('PlainYearMonth', '2026-12', 1, 'months')).value,
      'Year boundary'
    );
    Assert.areEqual(
      '00:30:00.000',
      adjust(input('PlainTime', '23:30', 1, 'hours')).value,
      'Clock wraps midnight'
    );
    Assert.areEqual(
      '2026-09-02T00:30:00.000',
      adjust(input('PlainDateTime', '2026-09-01T23:30', 1, 'hours')).value,
      'Local date carries'
    );
    Assert.areEqual(
      '2026-09-01T08:29:59.000Z',
      adjust(input('Instant', '2026-09-01T08:30Z', -1, 'seconds')).value,
      'Negative elapsed arithmetic'
    );
    Assert.areEqual(
      'PT10800.000S',
      adjust(input('Duration', 'PT2H', 60, 'minutes')).value,
      'Duration addition'
    );
    ChronoAdjustInput calendar = input(
      'ZonedDateTime',
      '2026-03-28T12:00+00:00[Europe/London]',
      1,
      'days'
    );
    Assert.areEqual(
      '2026-03-29T12:00:00.000+01:00[Europe/London]',
      adjust(calendar).value,
      'Calendar day keeps wall clock'
    );
    calendar.amount = 24;
    calendar.unit = 'hours';
    Assert.areEqual(
      '2026-03-29T13:00:00.000+01:00[Europe/London]',
      adjust(calendar).value,
      'Elapsed hours cross DST'
    );
  }
  @IsTest
  static void unitsDurationsAndInvalidCombinations() {
    for (String unit : new List<String>{ 'years', 'weeks', 'days' }) {
      Assert.isTrue(
        adjust(input('PlainDate', '2026-09-01', 1, unit)).success,
        'Calendar unit ' + unit
      );
    }
    Assert.areEqual(
      '2026-09-01T08:30:00.001Z',
      adjust(input('Instant', '2026-09-01T08:30Z', 1, 'milliseconds')).value,
      'Millisecond precision'
    );
    ChronoAdjustInput duration = input(
      'PlainDateTime',
      '2026-01-01T00:00',
      null,
      null
    );
    duration.duration = 'P1M2DT3H';
    Assert.areEqual(
      '2026-02-03T03:00:00.000',
      adjust(duration).value,
      'Composite duration'
    );
    duration.amount = 1;
    Assert.isFalse(
      adjust(duration).success,
      'Mutually exclusive arithmetic forms'
    );
    Assert.isFalse(
      adjust(input('PlainDate', '2026-09-01', 1, 'hours')).success,
      'Date has no clock'
    );
    Assert.isFalse(
      adjust(input('PlainYearMonth', '2026-09', 1, 'days')).success,
      'Partial month has no day'
    );
    Assert.isFalse(
      adjust(input('PlainMonthDay', '--09-01', 1, 'days')).success,
      'Month day needs reference year'
    );
    Assert.isFalse(
      adjust(input('Instant', '2026-09-01T08:30Z', 1, 'days')).success,
      'Exact instant has no calendar'
    );
    Assert.isFalse(
      adjust(input('PlainDate', '2026-09-01', 2147483647, 'years')).success,
      'Calendar overflow rejected'
    );
    Assert.isFalse(
      adjust(input('PlainTime', '09:00', 1, 'bogus')).success,
      'Unknown unit rejected'
    );
  }
  @IsTest
  static void elapsedDifferenceAndCollections() {
    ChronoDifferenceInput item = new ChronoDifferenceInput();
    item.startValue = '2026-03-28T12:00Z';
    item.endValue = '2026-03-29T12:00+01:00[Europe/London]';
    Assert.areEqual(
      82800000L,
      runDifference(new List<ChronoDifferenceInput>{ item })[0].milliseconds,
      'Difference is 23 elapsed hours'
    );
    ChronoDifferenceCollectionAction.Request request = new ChronoDifferenceCollectionAction.Request();
    request.items = new List<ChronoDifferenceInput>{ item, null };
    List<ChronoFlowCollectionResult> differences = ChronoDifferenceCollectionAction.run(
      new List<ChronoDifferenceCollectionAction.Request>{
        request,
        request,
        null
      }
    );
    Assert.areEqual(3, differences.size(), 'Interview count');
    Assert.isTrue(differences[0].results[0].success, 'Valid item');
    Assert.isFalse(differences[0].results[1].success, 'Invalid item');
    Assert.isFalse(differences[2].success, 'Invalid wrapper');
    differences[0].results[0].milliseconds = 0;
    Assert.areEqual(
      82800000L,
      differences[1].results[0].milliseconds,
      'Independent difference copies'
    );
    item.startInstant = Datetime.now();
    Assert.isFalse(
      runDifference(new List<ChronoDifferenceInput>{ item })[0].success,
      'Conflicting source forms rejected'
    );
    item.startValue = null;
    item.endValue = null;
    item.endInstant = item.startInstant.addHours(-1);
    Assert.areEqual(
      -3600000L,
      runDifference(new List<ChronoDifferenceInput>{ item })[0].milliseconds,
      'Native negative difference'
    );
  }
  @IsTest
  static void adjustmentCollectionsAcrossInterviews() {
    ChronoAdjustCollectionAction.Request request = new ChronoAdjustCollectionAction.Request();
    request.items = new List<ChronoAdjustInput>{
      input('PlainDate', '2026-09-01', 1, 'days'),
      input('PlainDate', '2026-09-01', 2, 'days')
    };
    List<ChronoAdjustCollectionAction.Request> requests = new List<ChronoAdjustCollectionAction.Request>();
    for (Integer i = 0; i < 200; i++) {
      requests.add(request);
    }
    Test.startTest();
    List<ChronoFlowCollectionResult> results = ChronoAdjustCollectionAction.run(
      requests
    );
    Test.stopTest();
    Assert.areEqual(200, results.size(), 'Bulk interview count');
    Assert.areEqual(
      '2026-09-03',
      results[199].results[1].value,
      'Correct inner order'
    );
    Assert.areEqual(0, runAdjust(null).size(), 'Empty scalar batch');
    Assert.areEqual(0, runDifference(null).size(), 'Empty difference batch');
    Assert.areEqual(
      0,
      ChronoAdjustCollectionAction.run(null).size(),
      'Empty collections'
    );
    Assert.areEqual(
      0,
      ChronoDifferenceCollectionAction.run(null).size(),
      'Empty difference collections'
    );
  }
  private static List<ChronoFlowResult> runAdjust(
    List<ChronoAdjustInput> items
  ) {
    if (items == null) {
      return ChronoAdjustAction.run(null);
    }
    List<ChronoAdjustAction.Request> wrappers = new List<ChronoAdjustAction.Request>();
    for (ChronoAdjustInput item : items) {
      wrappers.add(
        item == null
          ? null
          : (ChronoAdjustAction.Request) JSON.deserialize(
              JSON.serialize(item),
              ChronoAdjustAction.Request.class
            )
      );
    }
    return ChronoAdjustAction.run(wrappers);
  }
  private static List<ChronoFlowResult> runDifference(
    List<ChronoDifferenceInput> items
  ) {
    if (items == null) {
      return ChronoDifferenceAction.run(null);
    }
    List<ChronoDifferenceAction.Request> wrappers = new List<ChronoDifferenceAction.Request>();
    for (ChronoDifferenceInput item : items) {
      wrappers.add(
        item == null
          ? null
          : (ChronoDifferenceAction.Request) JSON.deserialize(
              JSON.serialize(item),
              ChronoDifferenceAction.Request.class
            )
      );
    }
    return ChronoDifferenceAction.run(wrappers);
  }
  @IsTest
  static void durationOverflowIsAnItemFailure() {
    ChronoAdjustInput item = input(
      'Duration',
      'PT9223372036854775.807S',
      1,
      'milliseconds'
    );
    ChronoFlowResult result = adjust(item);
    Assert.isFalse(result.success, 'Duration addition cannot wrap');
    Assert.isTrue(
      result.errorMessage.contains('millisecond range'),
      'Overflow diagnostic'
    );
  }
}
