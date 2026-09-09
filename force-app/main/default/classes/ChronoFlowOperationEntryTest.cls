// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoFlowOperationEntryTest {
  private static OperatingHours schedule() {
    OperatingHours hours = new OperatingHours(
      Name = 'Entry test',
      TimeZone = 'Europe/London'
    );
    insert hours;
    insert new TimeSlot(
      OperatingHoursId = hours.Id,
      DayOfWeek = 'Monday',
      Type = 'Normal',
      StartTime = Time.newInstance(9, 0, 0, 0),
      EndTime = Time.newInstance(17, 0, 0, 0)
    );
    return hours;
  }
  @IsTest
  static void checkWorkingTimeContracts() {
    OperatingHours hours = schedule();
    ChronoCheckWorkingTimeAction.Request scalar = new ChronoCheckWorkingTimeAction.Request();
    ChronoCheckWorkingTimeInput item = new ChronoCheckWorkingTimeInput();
    scalar.valueType = 'PlainDate';
    item.valueType = 'PlainDate';
    scalar.dateValue = Date.newInstance(2026, 9, 7);
    item.dateValue = Date.newInstance(2026, 9, 7);
    scalar.operatingHoursId = hours.Id;
    item.operatingHoursId = hours.Id;
    List<ChronoFlowResult> single = ChronoCheckWorkingTimeAction.run(
      new List<ChronoCheckWorkingTimeAction.Request>{ scalar, null }
    );
    Assert.isTrue(
      single[0].success,
      single[0].errorMessage == null
        ? 'Scalar succeeds'
        : single[0].errorMessage
    );
    Assert.isFalse(single[1].success);
    Assert.areEqual(0, ChronoCheckWorkingTimeAction.run(null).size());
    ChronoCheckWorkingTimeCollectionAction.Request collectionRequest = new ChronoCheckWorkingTimeCollectionAction.Request();
    collectionRequest.items = new List<ChronoCheckWorkingTimeInput>{
      item,
      null
    };
    ChronoCheckWorkingTimeCollectionAction.Request empty = new ChronoCheckWorkingTimeCollectionAction.Request();
    empty.items = new List<ChronoCheckWorkingTimeInput>();
    List<ChronoFlowCollectionResult> results = ChronoCheckWorkingTimeCollectionAction.run(
      new List<ChronoCheckWorkingTimeCollectionAction.Request>{
        collectionRequest,
        empty,
        null,
        new ChronoCheckWorkingTimeCollectionAction.Request()
      }
    );
    Assert.isTrue(results[0].results[0].success);
    Assert.isFalse(results[0].results[1].success);
    Assert.isFalse(results[0].success);
    Assert.isTrue(results[1].success);
    Assert.areEqual(0, results[1].results.size());
    Assert.isFalse(results[2].success);
    Assert.isFalse(results[3].success);
    Assert.areEqual(0, ChronoCheckWorkingTimeCollectionAction.run(null).size());
  }
  @IsTest
  static void findWorkingTimeContracts() {
    OperatingHours hours = schedule();
    ChronoFindWorkingTimeAction.Request scalar = new ChronoFindWorkingTimeAction.Request();
    ChronoFindWorkingTimeInput item = new ChronoFindWorkingTimeInput();
    scalar.valueType = 'PlainDate';
    item.valueType = 'PlainDate';
    scalar.value = '2026-09-06';
    item.value = '2026-09-06';
    scalar.operatingHoursId = hours.Id;
    item.operatingHoursId = hours.Id;
    scalar.direction = 'next';
    item.direction = 'next';
    List<ChronoFlowResult> single = ChronoFindWorkingTimeAction.run(
      new List<ChronoFindWorkingTimeAction.Request>{ scalar, null }
    );
    Assert.isTrue(
      single[0].success,
      single[0].errorMessage == null
        ? 'Scalar succeeds'
        : single[0].errorMessage
    );
    Assert.isFalse(single[1].success);
    Assert.areEqual(0, ChronoFindWorkingTimeAction.run(null).size());
    ChronoFindWorkingTimeCollectionAction.Request collectionRequest = new ChronoFindWorkingTimeCollectionAction.Request();
    collectionRequest.items = new List<ChronoFindWorkingTimeInput>{
      item,
      null
    };
    ChronoFindWorkingTimeCollectionAction.Request empty = new ChronoFindWorkingTimeCollectionAction.Request();
    empty.items = new List<ChronoFindWorkingTimeInput>();
    List<ChronoFlowCollectionResult> results = ChronoFindWorkingTimeCollectionAction.run(
      new List<ChronoFindWorkingTimeCollectionAction.Request>{
        collectionRequest,
        empty,
        null,
        new ChronoFindWorkingTimeCollectionAction.Request()
      }
    );
    Assert.isTrue(results[0].results[0].success);
    Assert.isFalse(results[0].results[1].success);
    Assert.isFalse(results[0].success);
    Assert.isTrue(results[1].success);
    Assert.areEqual(0, results[1].results.size());
    Assert.isFalse(results[2].success);
    Assert.isFalse(results[3].success);
    Assert.areEqual(0, ChronoFindWorkingTimeCollectionAction.run(null).size());
  }
  @IsTest
  static void compareContracts() {
    ChronoCompareAction.Request scalar = new ChronoCompareAction.Request();
    ChronoCompareInput item = new ChronoCompareInput();
    scalar.valueType = 'Instant';
    item.valueType = 'Instant';
    scalar.instantValue = Datetime.newInstanceGmt(2026, 9, 7, 10, 0, 0);
    item.instantValue = Datetime.newInstanceGmt(2026, 9, 7, 10, 0, 0);
    scalar.endInstant = Datetime.newInstanceGmt(2026, 9, 7, 11, 0, 0);
    item.endInstant = Datetime.newInstanceGmt(2026, 9, 7, 11, 0, 0);
    List<ChronoFlowResult> single = ChronoCompareAction.run(
      new List<ChronoCompareAction.Request>{ scalar, null }
    );
    Assert.isTrue(
      single[0].success,
      single[0].errorMessage == null
        ? 'Scalar succeeds'
        : single[0].errorMessage
    );
    Assert.isFalse(single[1].success);
    Assert.areEqual(0, ChronoCompareAction.run(null).size());
    ChronoCompareCollectionAction.Request collectionRequest = new ChronoCompareCollectionAction.Request();
    collectionRequest.items = new List<ChronoCompareInput>{ item, null };
    ChronoCompareCollectionAction.Request empty = new ChronoCompareCollectionAction.Request();
    empty.items = new List<ChronoCompareInput>();
    List<ChronoFlowCollectionResult> results = ChronoCompareCollectionAction.run(
      new List<ChronoCompareCollectionAction.Request>{
        collectionRequest,
        empty,
        null,
        new ChronoCompareCollectionAction.Request()
      }
    );
    Assert.isTrue(results[0].results[0].success);
    Assert.isFalse(results[0].results[1].success);
    Assert.isFalse(results[0].success);
    Assert.isTrue(results[1].success);
    Assert.areEqual(0, results[1].results.size());
    Assert.isFalse(results[2].success);
    Assert.isFalse(results[3].success);
    Assert.areEqual(0, ChronoCompareCollectionAction.run(null).size());
  }
  @IsTest
  static void periodBoundaryContracts() {
    ChronoPeriodBoundaryAction.Request scalar = new ChronoPeriodBoundaryAction.Request();
    ChronoPeriodBoundaryInput item = new ChronoPeriodBoundaryInput();
    scalar.valueType = 'PlainDate';
    item.valueType = 'PlainDate';
    scalar.dateValue = Date.newInstance(2026, 9, 7);
    item.dateValue = Date.newInstance(2026, 9, 7);
    scalar.unit = 'month';
    item.unit = 'month';
    scalar.boundary = 'end';
    item.boundary = 'end';
    List<ChronoFlowResult> single = ChronoPeriodBoundaryAction.run(
      new List<ChronoPeriodBoundaryAction.Request>{ scalar, null }
    );
    Assert.isTrue(
      single[0].success,
      single[0].errorMessage == null
        ? 'Scalar succeeds'
        : single[0].errorMessage
    );
    Assert.isFalse(single[1].success);
    Assert.areEqual(0, ChronoPeriodBoundaryAction.run(null).size());
    ChronoPeriodBoundaryCollectionAction.Request collectionRequest = new ChronoPeriodBoundaryCollectionAction.Request();
    collectionRequest.items = new List<ChronoPeriodBoundaryInput>{ item, null };
    ChronoPeriodBoundaryCollectionAction.Request empty = new ChronoPeriodBoundaryCollectionAction.Request();
    empty.items = new List<ChronoPeriodBoundaryInput>();
    List<ChronoFlowCollectionResult> results = ChronoPeriodBoundaryCollectionAction.run(
      new List<ChronoPeriodBoundaryCollectionAction.Request>{
        collectionRequest,
        empty,
        null,
        new ChronoPeriodBoundaryCollectionAction.Request()
      }
    );
    Assert.isTrue(results[0].results[0].success);
    Assert.isFalse(results[0].results[1].success);
    Assert.isFalse(results[0].success);
    Assert.isTrue(results[1].success);
    Assert.areEqual(0, results[1].results.size());
    Assert.isFalse(results[2].success);
    Assert.isFalse(results[3].success);
    Assert.areEqual(0, ChronoPeriodBoundaryCollectionAction.run(null).size());
  }
  @IsTest
  static void roundContracts() {
    ChronoRoundAction.Request scalar = new ChronoRoundAction.Request();
    ChronoRoundInput item = new ChronoRoundInput();
    scalar.valueType = 'PlainTime';
    item.valueType = 'PlainTime';
    scalar.value = '12:37';
    item.value = '12:37';
    scalar.unit = 'minute';
    item.unit = 'minute';
    scalar.increment = 15;
    item.increment = 15;
    List<ChronoFlowResult> single = ChronoRoundAction.run(
      new List<ChronoRoundAction.Request>{ scalar, null }
    );
    Assert.isTrue(
      single[0].success,
      single[0].errorMessage == null
        ? 'Scalar succeeds'
        : single[0].errorMessage
    );
    Assert.isFalse(single[1].success);
    Assert.areEqual(0, ChronoRoundAction.run(null).size());
    ChronoRoundCollectionAction.Request collectionRequest = new ChronoRoundCollectionAction.Request();
    collectionRequest.items = new List<ChronoRoundInput>{ item, null };
    ChronoRoundCollectionAction.Request empty = new ChronoRoundCollectionAction.Request();
    empty.items = new List<ChronoRoundInput>();
    List<ChronoFlowCollectionResult> results = ChronoRoundCollectionAction.run(
      new List<ChronoRoundCollectionAction.Request>{
        collectionRequest,
        empty,
        null,
        new ChronoRoundCollectionAction.Request()
      }
    );
    Assert.isTrue(results[0].results[0].success);
    Assert.isFalse(results[0].results[1].success);
    Assert.isFalse(results[0].success);
    Assert.isTrue(results[1].success);
    Assert.areEqual(0, results[1].results.size());
    Assert.isFalse(results[2].success);
    Assert.isFalse(results[3].success);
    Assert.areEqual(0, ChronoRoundCollectionAction.run(null).size());
  }
  @IsTest
  static void resolveLocalContracts() {
    ChronoResolveLocalAction.Request scalar = new ChronoResolveLocalAction.Request();
    ChronoResolveLocalInput item = new ChronoResolveLocalInput();
    scalar.valueType = 'PlainDateTime';
    item.valueType = 'PlainDateTime';
    scalar.dateValue = Date.newInstance(2026, 10, 25);
    item.dateValue = Date.newInstance(2026, 10, 25);
    scalar.timeValue = '01:30';
    item.timeValue = '01:30';
    scalar.timeZoneId = 'Europe/London';
    item.timeZoneId = 'Europe/London';
    scalar.resolution = 'later';
    item.resolution = 'later';
    List<ChronoFlowResult> single = ChronoResolveLocalAction.run(
      new List<ChronoResolveLocalAction.Request>{ scalar, null }
    );
    Assert.isTrue(
      single[0].success,
      single[0].errorMessage == null
        ? 'Scalar succeeds'
        : single[0].errorMessage
    );
    Assert.isFalse(single[1].success);
    Assert.areEqual(0, ChronoResolveLocalAction.run(null).size());
    ChronoResolveLocalCollectionAction.Request collectionRequest = new ChronoResolveLocalCollectionAction.Request();
    collectionRequest.items = new List<ChronoResolveLocalInput>{ item, null };
    ChronoResolveLocalCollectionAction.Request empty = new ChronoResolveLocalCollectionAction.Request();
    empty.items = new List<ChronoResolveLocalInput>();
    List<ChronoFlowCollectionResult> results = ChronoResolveLocalCollectionAction.run(
      new List<ChronoResolveLocalCollectionAction.Request>{
        collectionRequest,
        empty,
        null,
        new ChronoResolveLocalCollectionAction.Request()
      }
    );
    Assert.isTrue(results[0].results[0].success);
    Assert.isFalse(results[0].results[1].success);
    Assert.isFalse(results[0].success);
    Assert.isTrue(results[1].success);
    Assert.areEqual(0, results[1].results.size());
    Assert.isFalse(results[2].success);
    Assert.isFalse(results[3].success);
    Assert.areEqual(0, ChronoResolveLocalCollectionAction.run(null).size());
  }
  @IsTest
  static void calendarDifferenceContracts() {
    ChronoCalendarDifferenceAction.Request scalar = new ChronoCalendarDifferenceAction.Request();
    ChronoCalendarDifferenceInput item = new ChronoCalendarDifferenceInput();
    scalar.valueType = 'PlainDate';
    item.valueType = 'PlainDate';
    scalar.dateValue = Date.newInstance(2026, 9, 7);
    item.dateValue = Date.newInstance(2026, 9, 7);
    scalar.endDate = Date.newInstance(2026, 9, 8);
    item.endDate = Date.newInstance(2026, 9, 8);
    List<ChronoFlowResult> single = ChronoCalendarDifferenceAction.run(
      new List<ChronoCalendarDifferenceAction.Request>{ scalar, null }
    );
    Assert.isTrue(
      single[0].success,
      single[0].errorMessage == null
        ? 'Scalar succeeds'
        : single[0].errorMessage
    );
    Assert.isFalse(single[1].success);
    Assert.areEqual(0, ChronoCalendarDifferenceAction.run(null).size());
    ChronoCalendarDifferenceCollectionAction.Request collectionRequest = new ChronoCalendarDifferenceCollectionAction.Request();
    collectionRequest.items = new List<ChronoCalendarDifferenceInput>{
      item,
      null
    };
    ChronoCalendarDifferenceCollectionAction.Request empty = new ChronoCalendarDifferenceCollectionAction.Request();
    empty.items = new List<ChronoCalendarDifferenceInput>();
    List<ChronoFlowCollectionResult> results = ChronoCalendarDifferenceCollectionAction.run(
      new List<ChronoCalendarDifferenceCollectionAction.Request>{
        collectionRequest,
        empty,
        null,
        new ChronoCalendarDifferenceCollectionAction.Request()
      }
    );
    Assert.isTrue(results[0].results[0].success);
    Assert.isFalse(results[0].results[1].success);
    Assert.isFalse(results[0].success);
    Assert.isTrue(results[1].success);
    Assert.areEqual(0, results[1].results.size());
    Assert.isFalse(results[2].success);
    Assert.isFalse(results[3].success);
    Assert.areEqual(
      0,
      ChronoCalendarDifferenceCollectionAction.run(null).size()
    );
  }
}
