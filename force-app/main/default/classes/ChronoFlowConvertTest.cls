// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoFlowConvertTest {
  private static ChronoConvertInput input(
    String kind,
    String value,
    String target
  ) {
    ChronoConvertInput item = new ChronoConvertInput();
    item.valueType = kind;
    item.value = value;
    item.targetType = target;
    return item;
  }
  private static ChronoFlowResult convert(ChronoConvertInput item) {
    return runConvert(new List<ChronoConvertInput>{ item })[0];
  }
  @IsTest
  static void fractionalSecondsTruncateWithoutRounding() {
    List<String> kinds = new List<String>{
      'ZonedDateTime',
      'Instant',
      'Duration',
      'PlainTime',
      'PlainDateTime',
      'Duration',
      'Instant'
    };
    List<String> supplied = new List<String>{
      '1995-12-07T03:24:30.0000035-08:00[America/Los_Angeles]',
      '2021-01-13T20:57:01.500944804Z',
      'P1Y2M3W4DT5H6M7.987654321S',
      '23:59:59.999999999',
      '2026-12-31T23:59:59.999999999',
      '-PT0.0009S',
      '1969-12-31T23:59:59.999999999Z'
    };
    List<String> expected = new List<String>{
      '1995-12-07T03:24:30.000-08:00[America/Los_Angeles]',
      '2021-01-13T20:57:01.500Z',
      'P14M25DT18367.987S',
      '23:59:59.999',
      '2026-12-31T23:59:59.999',
      'PT0S',
      '1969-12-31T23:59:59.999Z'
    };
    List<ChronoConvertInput> items = new List<ChronoConvertInput>();
    for (Integer i = 0; i < kinds.size(); i++) {
      items.add(input(kinds[i], supplied[i], null));
    }
    List<ChronoFlowResult> results = runConvert(items);
    for (Integer i = 0; i < results.size(); i++) {
      Assert.isTrue(
        results[i].success,
        'Conversion failed: ' + results[i].errorMessage
      );
      Assert.areEqual(
        expected[i],
        results[i].value,
        'Fractional seconds truncate: ' + supplied[i]
      );
    }
    Assert.areEqual(
      -1987L,
      ChronoDurationService.getMilliseconds(
        ChronoDurationService.parseIso('-PT1.987654321S')
      ),
      'Negative durations truncate towards zero'
    );
  }
  @IsTest
  static void allEightTypesNormalise() {
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
      '2026-09-01T08:30Z',
      '2026-09-01T09:30+01:00[Europe/London]',
      '2026-09-01T09:30',
      '2026-09-01',
      '09:30',
      '2026-09',
      '--09-01',
      'P1M2DT3H'
    };
    List<ChronoConvertInput> items = new List<ChronoConvertInput>();
    for (Integer i = 0; i < types.size(); i++) {
      items.add(input(types[i], values[i], null));
    }
    Test.startTest();
    List<ChronoFlowResult> results = runConvert(items);
    Test.stopTest();
    Assert.areEqual(8, results.size(), 'One result per type');
    for (Integer i = 0; i < results.size(); i++) {
      Assert.isTrue(
        results[i].success,
        'Unexpected failure: ' + results[i].errorMessage
      );
      Assert.areEqual(types[i], results[i].valueType, 'Type retained');
    }
    Assert.areEqual(
      10800000L,
      results[7].milliseconds,
      'Duration clock component'
    );
    Assert.areEqual(
      Date.newInstance(2026, 9, 1),
      results[1].dateValue,
      'Zoned local date'
    );
  }
  @IsTest
  static void nativeConversionsAndReferences() {
    ChronoConvertInput local = input('PlainDateTime', null, 'ZonedDateTime');
    local.dateValue = Date.newInstance(2026, 9, 1);
    local.timeValue = '09:30';
    local.timeZoneId = 'Europe/London';
    ChronoFlowResult zoned = convert(local);
    Assert.isTrue(zoned.success, 'Unexpected failure: ' + zoned.errorMessage);
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 9, 1, 8, 30, 0),
      zoned.instantValue,
      'Native date plus clock resolved'
    );
    ChronoConvertInput instant = input('Instant', null, 'PlainDateTime');
    instant.instantValue = zoned.instantValue;
    instant.timeZoneId = 'Asia/Tokyo';
    Assert.areEqual(
      '17:30:00.000',
      convert(instant).timeValue,
      'Explicit target zone'
    );
    ChronoConvertInput monthDay = input(
      'PlainMonthDay',
      '--02-29',
      'PlainDate'
    );
    monthDay.referenceDate = Date.newInstance(2024, 1, 1);
    Assert.areEqual(
      Date.newInstance(2024, 2, 29),
      convert(monthDay).dateValue,
      'Reference year completes leap day'
    );
    monthDay.referenceDate = Date.newInstance(2025, 1, 1);
    Assert.isFalse(convert(monthDay).success, 'Invalid completion rejected');
    ChronoConvertInput yearMonth = input(
      'PlainYearMonth',
      '2026-09',
      'PlainDateTime'
    );
    yearMonth.referenceDate = Date.newInstance(2000, 1, 15);
    yearMonth.referenceTime = '12:00';
    Assert.areEqual(
      '2026-09-15T12:00:00.000',
      convert(yearMonth).value,
      'Reference day and time'
    );
    ChronoConvertInput timeOnly = input('PlainTime', '10:00', 'PlainDateTime');
    timeOnly.referenceDate = Date.newInstance(2026, 9, 1);
    Assert.areEqual(
      '2026-09-01T10:00:00.000',
      convert(timeOnly).value,
      'Time requires explicit date'
    );
  }
  @IsTest
  static void targetTypesAndNativeSources() {
    ChronoConvertInput item = input(
      'ZonedDateTime',
      '2026-09-01T09:30+01:00[Europe/London]',
      'Instant'
    );
    Assert.areEqual(
      '2026-09-01T08:30:00.000Z',
      convert(item).value,
      'Zone stripped after instant resolution'
    );
    item.targetType = 'PlainYearMonth';
    Assert.areEqual('2026-09', convert(item).value, 'Year month projection');
    item.targetType = 'PlainMonthDay';
    Assert.areEqual('--09-01', convert(item).value, 'Month day projection');
    item.targetType = 'PlainTime';
    Assert.areEqual('09:30:00.000', convert(item).value, 'Clock projection');
    item.targetType = 'ZonedDateTime';
    item.timeZoneId = 'Asia/Tokyo';
    Assert.areEqual(
      '17:30:00.000',
      convert(item).timeValue,
      'Change display zone'
    );
    for (
      String kind : new List<String>{
        'PlainDate',
        'PlainYearMonth',
        'PlainMonthDay'
      }
    ) {
      ChronoConvertInput nativeDate = input(kind, null, null);
      nativeDate.dateValue = Date.newInstance(2026, 9, 1);
      Assert.isTrue(
        convert(nativeDate).success,
        'Native date supports ' + kind
      );
    }
    ChronoConvertInput nativeTime = input('PlainTime', null, null);
    nativeTime.timeValue = '09:30';
    Assert.isTrue(convert(nativeTime).success, 'Native clock transport');
    ChronoConvertInput nativeZoned = input('ZonedDateTime', null, null);
    nativeZoned.instantValue = Datetime.newInstanceGmt(2026, 9, 1, 8, 30, 0);
    nativeZoned.timeZoneId = 'Europe/London';
    Assert.isTrue(convert(nativeZoned).success, 'Native zoned source');
  }
  @IsTest
  static void dstPoliciesAndFailuresAreIsolated() {
    ChronoConvertInput overlap = input(
      'PlainDateTime',
      '2026-10-25T01:30',
      'ZonedDateTime'
    );
    overlap.timeZoneId = 'Europe/London';
    Assert.isFalse(
      convert(overlap).success,
      'Ambiguous time rejected by default'
    );
    overlap.disambiguation = 'earlier';
    Datetime earlier = convert(overlap).instantValue;
    overlap.disambiguation = 'later';
    Datetime later = convert(overlap).instantValue;
    Assert.areEqual(
      3600000L,
      later.getTime() - earlier.getTime(),
      'Explicit overlap policies select different instants'
    );
    overlap.value = '2026-03-29T01:30';
    Assert.isFalse(convert(overlap).success, 'Gap never silently shifted');
    ChronoConvertInput duration = input('Duration', 'PT1H', 'PlainTime');
    duration.referenceTime = '09:00';
    Assert.isFalse(
      convert(duration).success,
      'Duration cannot become clock time'
    );
    ChronoConvertInput conflicting = input('PlainDate', '2026-09-01', null);
    conflicting.dateValue = Date.today();
    Assert.isFalse(convert(conflicting).success, 'Ambiguous source rejected');
    List<ChronoFlowResult> results = runConvert(
      new List<ChronoConvertInput>{
        null,
        input('Nope', 'x', null),
        input('PlainDate', '2026-09-01', null)
      }
    );
    Assert.isFalse(results[0].success, 'Null reported');
    Assert.isFalse(results[1].success, 'Unknown type reported');
    Assert.isTrue(results[2].success, 'Other interviews continue');
  }
  @IsTest
  static void duplicatesComputeOnceAndCopiesAreIndependent() {
    List<Object> items = new List<Object>();
    for (Integer i = 0; i < 200; i++) {
      items.add(
        input(
          'PlainDate',
          Math.mod(i, 2) == 0 ? '2026-09-01' : '2026-09-02',
          null
        )
      );
    }
    ChronoFlowBatch batch = new ChronoFlowBatch('Convert');
    Test.startTest();
    List<ChronoFlowResult> results = batch.run(items);
    Test.stopTest();
    Assert.areEqual(
      2,
      batch.computationCount,
      'Equivalent distinct inputs reuse calculations'
    );
    Assert.areEqual(200, results.size(), 'Interview cardinality');
    results[0].value = 'changed';
    Assert.areEqual(
      '2026-09-01',
      results[2].value,
      'Cached objects never escape'
    );
    Assert.areEqual('2026-09-02', results[1].value, 'Original order retained');
    Assert.areEqual(
      '2026-09-01',
      batch.run(new List<Object>{ items[0] })[0].value,
      'Cache cannot leak across invocations'
    );
  }
  @IsTest
  static void collectionsRetainBothLevelsOfOrder() {
    List<ChronoConvertCollectionAction.Request> requests = new List<ChronoConvertCollectionAction.Request>();
    for (Integer i = 0; i < 200; i++) {
      ChronoConvertCollectionAction.Request row = new ChronoConvertCollectionAction.Request();
      row.items = new List<ChronoConvertInput>{
        input('PlainDate', '2026-09-01', null),
        input('PlainDate', '2026-09-02', null)
      };
      requests.add(row);
    }
    requests[1].items = new List<ChronoConvertInput>();
    requests[2] = null;
    requests[3].items[0] = null;
    Test.startTest();
    List<ChronoFlowCollectionResult> results = ChronoConvertCollectionAction.run(
      requests
    );
    Test.stopTest();
    Assert.areEqual(200, results.size(), 'One result per collection interview');
    Assert.areEqual(0, results[1].results.size(), 'Empty collection retained');
    Assert.isTrue(results[1].success, 'Empty is valid');
    Assert.isFalse(results[2].success, 'Null wrapper fails explicitly');
    Assert.isFalse(results[3].results[0].success, 'Item failure retained');
    Assert.isTrue(results[3].results[1].success, 'Sibling succeeds');
    results[0].results[0].value = 'changed';
    Assert.areEqual(
      '2026-09-01',
      results[4].results[0].value,
      'Independent objects across collections'
    );
    Assert.areEqual('2026-09-02', results[4].results[1].value, 'Inner order');
    Assert.areEqual(
      0,
      ChronoConvertCollectionAction.run(null).size(),
      'No interviews'
    );
    Assert.areEqual(0, runConvert(null).size(), 'No scalar interviews');
  }
  private static List<ChronoFlowResult> runConvert(
    List<ChronoConvertInput> items
  ) {
    if (items == null) {
      return ChronoConvertAction.run(null);
    }
    List<ChronoConvertAction.Request> wrappers = new List<ChronoConvertAction.Request>();
    for (ChronoConvertInput item : items) {
      wrappers.add(
        item == null
          ? null
          : (ChronoConvertAction.Request) JSON.deserialize(
              JSON.serialize(item),
              ChronoConvertAction.Request.class
            )
      );
    }
    return ChronoConvertAction.run(wrappers);
  }
  @IsTest
  static void mismatchedNativeInputsAreRejected() {
    ChronoConvertInput item = input('PlainDate', null, null);
    item.dateValue = Date.newInstance(2026, 9, 1);
    item.instantValue = Datetime.now();
    Assert.isFalse(
      convert(item).success,
      'Unrelated native instant cannot silently override or be ignored'
    );
  }
}
