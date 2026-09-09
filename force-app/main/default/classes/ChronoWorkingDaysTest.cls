// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoWorkingDaysTest {
  private static ChronoWorkingDaysInput input() {
    ChronoWorkingDaysInput result = new ChronoWorkingDaysInput();
    result.valueType = 'ZonedDateTime';
    result.value = '2026-08-28T11:30-04:00[America/New_York]';
    result.amount = 1;
    result.operatingHours = new OperatingHours(TimeZone = 'Europe/London');
    result.timeSlots = new List<TimeSlot>();
    for (
      String day : new List<String>{
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday'
      }
    ) {
      result.timeSlots.add(
        new TimeSlot(
          DayOfWeek = day,
          StartTime = Time.newInstance(9, 0, 0, 0),
          EndTime = Time.newInstance(17, 0, 0, 0)
        )
      );
    }
    result.holidays = new List<Holiday>{
      new Holiday(ActivityDate = Date.newInstance(2026, 8, 31), IsAllDay = true)
    };
    return result;
  }
  private static ChronoOperationResult run(ChronoWorkingDaysInput input) {
    return (ChronoOperationResult) new ChronoCatalogueBatch('WorkingDays')
      .run(new List<Object>{ input })[0];
  }
  @IsTest
  static void skipsHolidayAndPreservesScheduleClockAndDisplayZone() {
    ChronoWorkingDaysInput input = input();
    ChronoOperationResult result = run(input);
    Assert.isTrue(
      result.success,
      result.errorMessage == null ? 'Expected success' : result.errorMessage
    );
    Assert.areEqual(
      '2026-09-01T11:30:00.000-04:00[America/New_York]',
      result.value
    );
    input.value = result.value;
    input.amount = -1;
    Assert.areEqual(
      '2026-08-28T11:30:00.000-04:00[America/New_York]',
      run(input).value
    );
  }
  @IsTest
  static void nativeDatesAndClockPoliciesAreExplicit() {
    ChronoWorkingDaysInput input = input();
    input.valueType = 'PlainDate';
    input.value = null;
    input.dateValue = Date.newInstance(2026, 8, 28);
    Assert.areEqual(Date.newInstance(2026, 9, 1), run(input).dateValue);
    input.valueType = 'PlainDateTime';
    input.timeZoneId = 'Europe/London';
    input.timeValue = '18:00';
    input.closedTimePolicy = 'reject';
    Assert.isFalse(run(input).success);
    input.closedTimePolicy = 'next';
    Assert.areEqual('2026-09-02T09:00:00.000', run(input).value);
    input.closedTimePolicy = 'previous';
    Assert.areEqual('2026-09-01T16:59:59.999', run(input).value);
  }
  @IsTest
  static void mutableResultsAndFailuresAreIsolatedAcrossCollections() {
    ChronoWorkingDaysCollectionAction.Request request = new ChronoWorkingDaysCollectionAction.Request();
    request.items = new List<ChronoWorkingDaysInput>{ input(), null, input() };
    Test.startTest();
    Integer queries = Limits.getQueries();
    Integer dml = Limits.getDmlStatements();
    List<ChronoFlowCollectionResult> result = ChronoWorkingDaysCollectionAction.run(
      new List<ChronoWorkingDaysCollectionAction.Request>{ request, request }
    );
    Assert.areEqual(queries, Limits.getQueries());
    Assert.areEqual(dml, Limits.getDmlStatements());
    Test.stopTest();
    Assert.isFalse(result[0].success);
    Assert.areEqual(3, result[0].results.size());
    Assert.isFalse(result[0].results[1].success);
    result[0].results[0].value = 'changed';
    Assert.areEqual(
      '2026-09-01T11:30:00.000-04:00[America/New_York]',
      result[1].results[0].value
    );
  }
  @IsTest
  static void searchIsBounded() {
    ChronoWorkingDaysInput input = input();
    input.amount = 3661;
    Assert.isFalse(run(input).success);
  }
  @IsTest
  static void zeroDaysPreservesRepeatedInstantAndStillChecksClosedPolicy() {
    ChronoWorkingDaysInput request = input();
    request.amount = 0;
    request.value = '2026-10-25T01:30:00.000+00:00[Europe/London]';
    request.timeSlots = new List<TimeSlot>{
      new TimeSlot(
        DayOfWeek = 'Sunday',
        StartTime = Time.newInstance(0, 0, 0, 0),
        EndTime = Time.newInstance(4, 0, 0, 0)
      )
    };
    for (String policy : new List<String>{ 'reject', 'earlier', 'later' }) {
      request.disambiguation = policy;
      List<ChronoValueResult> results = ChronoWorkingTimeService.addDays(
        new List<ChronoWorkingDaysInput>{ request, null, request }
      );
      Assert.isTrue(
        results[0].success,
        results[0].errorMessage == null
          ? 'Zero-day calculation succeeds'
          : results[0].errorMessage
      );
      Assert.areEqual(
        Datetime.newInstanceGmt(2026, 10, 25, 1, 30, 0),
        results[0].value.zonedDateTime.instant
      );
      Assert.isFalse(results[1].success);
      results[0].value.zonedDateTime.instant = null;
      Assert.isNotNull(results[2].value.zonedDateTime.instant);
    }
    request.timeSlots = new List<TimeSlot>();
    request.closedTimePolicy = 'reject';
    Assert.isFalse(
      run(request).success,
      'Zero days still honours the closed-time policy.'
    );
  }
}
