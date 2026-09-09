// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Calendar-sensitive duration totals, scaling and collection contracts. */
@IsTest
private class ChronoDurationMathTest {
  @IsTest
  static void createsAndExtractsSignedComponents() {
    ChronoDurationToolsAction.Request request = new ChronoDurationToolsAction.Request();
    request.operation = 'create';
    request.years = -1;
    request.months = -2;
    request.weeks = -1;
    request.days = -3;
    request.hours = -26;
    request.seconds = -1.2349;
    ChronoDurationResult result = ChronoDurationToolsAction.run(
      new List<ChronoDurationToolsAction.Request>{ request }
    )[0];
    Assert.isTrue(
      result.success,
      result.errorMessage == null
        ? 'Expected a valid duration'
        : result.errorMessage
    );
    Assert.areEqual(-14, result.months);
    Assert.areEqual(-10, result.days);
    Assert.areEqual(-26L, result.hours);
    Assert.areEqual(-234, result.millisecondPart);
  }
  @IsTest
  static void pureElapsedTotalsNeedNoCalendarAnchor() {
    ChronoDurationToolsAction.Request request = new ChronoDurationToolsAction.Request();
    request.operation = 'total';
    request.value = 'PT90M';
    request.unit = 'hour';
    Assert.areEqual(
      1.5,
      ChronoDurationToolsAction.run(
          new List<ChronoDurationToolsAction.Request>{ request }
        )[0]
        .total
    );
  }
  @IsTest
  static void calendarDayRespectsSpringTransition() {
    ChronoDurationToolsAction.Request request = new ChronoDurationToolsAction.Request();
    request.operation = 'total';
    request.value = 'P1D';
    request.unit = 'hour';
    request.referenceDate = Date.newInstance(2026, 3, 29);
    request.timeZoneId = 'Europe/London';
    Assert.areEqual(
      23,
      ChronoDurationToolsAction.run(
          new List<ChronoDurationToolsAction.Request>{ request }
        )[0]
        .total
    );
    request.unit = 'day';
    Assert.areEqual(
      1,
      ChronoDurationToolsAction.run(
          new List<ChronoDurationToolsAction.Request>{ request }
        )[0]
        .total
    );
  }
  @IsTest
  static void fractionalCalendarTotalsAndBalanceAreAnchored() {
    ChronoDurationToolsAction.Request request = new ChronoDurationToolsAction.Request();
    request.operation = 'total';
    request.value = 'P1M14D';
    request.unit = 'month';
    request.referenceDate = Date.newInstance(2026, 1, 31);
    Decimal result = ChronoDurationToolsAction.run(
        new List<ChronoDurationToolsAction.Request>{ request }
      )[0]
      .total;
    Assert.isTrue(result > 1.45 && result < 1.46);
    request.operation = 'balance';
    request.value = 'P31D';
    request.referenceDate = Date.newInstance(2026, 1, 1);
    ChronoDurationResult balanced = ChronoDurationToolsAction.run(
      new List<ChronoDurationToolsAction.Request>{ request }
    )[0];
    Assert.areEqual(1, balanced.months);
    Assert.areEqual(0, balanced.days);
  }
  @IsTest
  static void scaleRequiresExplicitCalendarMeaning() {
    ChronoDurationToolsAction.Request request = new ChronoDurationToolsAction.Request();
    request.operation = 'divide';
    request.value = 'P1D';
    request.factor = 2;
    Assert.isFalse(
      ChronoDurationToolsAction.run(
          new List<ChronoDurationToolsAction.Request>{ request }
        )[0]
        .success
    );
    request.scalingMode = 'elapsed';
    request.referenceDate = Date.newInstance(2026, 3, 29);
    request.timeZoneId = 'Europe/London';
    Assert.areEqual(
      41400000L,
      ChronoDurationToolsAction.run(
          new List<ChronoDurationToolsAction.Request>{ request }
        )[0]
        .milliseconds
    );
    request.factor = 0;
    Assert.isFalse(
      ChronoDurationToolsAction.run(
          new List<ChronoDurationToolsAction.Request>{ request }
        )[0]
        .success
    );
  }
  @IsTest
  static void collectionResultsAreIndependent() {
    ChronoDurationToolsInput value = new ChronoDurationToolsInput();
    value.operation = 'absolute';
    value.value = '-P1DT2H';
    ChronoDurationToolsCollectionAction.Request request = new ChronoDurationToolsCollectionAction.Request();
    request.items = new List<ChronoDurationToolsInput>{ value, null, value };
    List<ChronoDurationCollectionResult> results = ChronoDurationToolsCollectionAction.run(
      new List<ChronoDurationToolsCollectionAction.Request>{ request, request }
    );
    Assert.isFalse(results[0].results[1].success);
    Assert.areEqual(1, results[1].results[2].days);
    results[0].results[0].days = 10;
    Assert.areEqual(1, results[1].results[0].days);
  }
}
