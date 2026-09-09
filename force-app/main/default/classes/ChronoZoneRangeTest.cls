// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoZoneRangeTest {
  @IsTest
  static void conversionAndExplicitOverrideAreDistinct() {
    ChronoZoneToolsInput input = new ChronoZoneToolsInput();
    input.operation = 'convert';
    input.valueType = 'ZonedDateTime';
    input.value = '2026-03-15T10:00+00:00[Europe/London]';
    input.targetTimeZoneId = 'America/New_York';
    Assert.areEqual(
      '2026-03-15T06:00:00.000-04:00[America/New_York]',
      ChronoZoneTools.execute(input).value
    );
    input.conversionMode = 'localClock';
    Assert.areEqual(
      '2026-03-15T10:00:00.000-04:00[America/New_York]',
      ChronoZoneTools.execute(input).value
    );
    input.operation = 'overrideOffset';
    input.suppliedOffset = '+01:00';
    ChronoZoneResult result = ChronoZoneTools.execute(input);
    Assert.isTrue(result.isOverride);
    Assert.areEqual(
      '2026-03-15T09:00:00.000+00:00[Europe/London]',
      result.value
    );
    Assert.areEqual('2026-03-15T10:00:00.000+01:00', result.suppliedValue);
    input.valueType = 'PlainDateTime';
    input.value = '2026-03-29T01:30';
    input.timeZoneId = 'Europe/London';
    Assert.isTrue(
      ChronoZoneTools.execute(input).success,
      'An explicit offset can resolve a skipped source clock'
    );
    input.operation = 'compareZones';
    input.valueType = 'Instant';
    input.value = '2026-03-15T10:00Z';
    Assert.areEqual(
      -14400,
      ChronoZoneTools.execute(input).offsetDifferenceSeconds
    );
  }
  @IsTest
  static void transitionsBoundariesAndNonHourChanges() {
    ChronoZoneToolsInput input = new ChronoZoneToolsInput();
    input.operation = 'transitions';
    input.valueType = 'Instant';
    input.value = '2026-03-29T01:00Z';
    input.timeZoneId = 'Europe/London';
    input.endInstant = Datetime.newInstanceGmt(2026, 10, 25, 1, 0, 0);
    ChronoZoneResult result = ChronoZoneTools.execute(input);
    Assert.areEqual(
      1,
      result.transitionValues.size(),
      'Include start, exclude end'
    );
    Assert.areEqual(0, result.offsetsBefore[0]);
    Assert.areEqual(3600, result.offsetsAfter[0]);
    input.operation = 'nextTransition';
    input.value = '2026-10-01T00:00Z';
    input.timeZoneId = 'Australia/Lord_Howe';
    input.searchDays = 10;
    result = ChronoZoneTools.execute(input);
    Assert.areEqual(
      '2026-10-04T02:30:00.000+11:00[Australia/Lord_Howe]',
      result.transitionValues[0]
    );
    Assert.areEqual(1800, result.offsetsAfter[0] - result.offsetsBefore[0]);
    input.operation = 'previousTransition';
    input.value = '2026-10-05T00:00Z';
    Assert.areEqual(
      result.transitionValues,
      ChronoZoneTools.execute(input).transitionValues
    );
    input.operation = 'nextTransition';
    input.timeZoneId = 'UTC';
    Assert.isFalse(ChronoZoneTools.execute(input).found);
  }
  private static ChronoRangeToolsInput range() {
    ChronoRangeToolsInput input = new ChronoRangeToolsInput();
    input.valueType = 'PlainDate';
    input.value = '2026-09-01';
    input.endValue = '2026-09-11';
    return input;
  }
  @IsTest
  static void unionSubtractionCoverageAndHalfOpenPoints() {
    ChronoRangeToolsInput input = range();
    input.operation = 'coverage';
    input.ranges = new List<String>{
      '2026-09-01/2026-09-04',
      '2026-09-03/2026-09-06',
      '2026-09-09/2026-09-20'
    };
    ChronoRangeResult result = ChronoRangeTools.execute(input);
    Assert.areEqual(70, result.coveragePercent);
    Assert.areEqual(7 * 86400000L, result.milliseconds);
    input.operation = 'gaps';
    Assert.areEqual(
      new List<String>{ '2026-09-06/2026-09-09' },
      ChronoRangeTools.execute(input).ranges
    );
    input.operation = 'contains';
    input.pointValue = '2026-09-11';
    Assert.isFalse(ChronoRangeTools.execute(input).containsValue);
    input.operation = 'clamp';
    Assert.areEqual('2026-09-10', ChronoRangeTools.execute(input).value);
    input.operation = 'relationship';
    input.otherStart = '2026-09-11';
    input.otherEnd = '2026-09-12';
    Assert.areEqual('meets', ChronoRangeTools.execute(input).relationship);
    input.operation = 'intersection';
    Assert.isTrue(ChronoRangeTools.execute(input).ranges.isEmpty());
  }
  @IsTest
  static void splitUsesCalendarDaysAcrossDstAndIntervalZones() {
    ChronoRangeToolsInput input = new ChronoRangeToolsInput();
    input.operation = 'split';
    input.valueType = 'ZonedDateTime';
    input.value = '2026-03-28T12:00+00:00[Europe/London]';
    input.endValue = '2026-03-30T12:00+01:00[Europe/London]';
    input.duration = 'P1D';
    ChronoRangeResult result = ChronoRangeTools.execute(input);
    Assert.areEqual(2, result.ranges.size());
    Assert.areEqual(47 * 3600000L, result.milliseconds);
    Assert.areEqual(
      '2026-03-28T12:00:00.000+00:00[Europe/London]/2026-03-29T12:00:00.000+01:00[Europe/London]',
      result.ranges[0]
    );
    input.operation = 'coverage';
    input.ranges = result.ranges;
    Assert.areEqual(100, ChronoRangeTools.execute(input).coveragePercent);
    input.operation = 'validate';
    input.endValue = '2026-01-01T00:00Z';
    Assert.isFalse(ChronoRangeTools.execute(input).isValid);
  }
  @IsTest
  static void nativeEndpointsAndIndependentListOutputs() {
    ChronoRangeToolsAction.Request request = new ChronoRangeToolsAction.Request();
    request.operation = 'split';
    request.valueType = 'PlainDate';
    request.dateValue = Date.newInstance(2026, 1, 1);
    request.endDate = Date.newInstance(2026, 1, 3);
    request.duration = 'P1D';
    List<ChronoRangeResult> values = ChronoRangeToolsAction.run(
      new List<ChronoRangeToolsAction.Request>{ request, null, request }
    );
    Assert.isTrue(
      values[0].success,
      values[0].errorMessage == null
        ? 'Expected success'
        : values[0].errorMessage
    );
    Assert.isFalse(values[1].success);
    values[0].ranges.clear();
    Assert.areEqual(2, values[2].ranges.size());
    ChronoZoneToolsCollectionAction.Request collection = new ChronoZoneToolsCollectionAction.Request();
    ChronoZoneToolsInput zone = new ChronoZoneToolsInput();
    zone.operation = 'listZones';
    zone.search = 'London';
    collection.items = new List<ChronoZoneToolsInput>{ zone, null, zone };
    ChronoZoneCollectionResult result = ChronoZoneToolsCollectionAction.run(
      new List<ChronoZoneToolsCollectionAction.Request>{ collection }
    )[0];
    Assert.isFalse(result.success);
    result.results[0].timeZoneIds.clear();
    Assert.areEqual(
      new List<String>{ 'Europe/London' },
      result.results[2].timeZoneIds
    );
  }
}
