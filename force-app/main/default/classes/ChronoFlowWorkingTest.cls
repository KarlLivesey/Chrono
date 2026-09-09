// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoFlowWorkingTest {
  @TestSetup
  static void holiday() {
    insert new Holiday(
      Name = 'Chrono Flow bank holiday',
      ActivityDate = Date.newInstance(2026, 8, 31),
      IsAllDay = true
    );
  }
  private static List<OperatingHours> schedules() {
    List<OperatingHours> hours = new List<OperatingHours>{
      new OperatingHours(Name = 'London', TimeZone = 'Europe/London'),
      new OperatingHours(Name = 'UTC', TimeZone = 'GMT')
    };
    insert hours;
    List<TimeSlot> slots = new List<TimeSlot>();
    for (OperatingHours schedule : hours) {
      for (
        String day : new List<String>{
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday'
        }
      ) {
        slots.add(
          new TimeSlot(
            OperatingHoursId = schedule.Id,
            DayOfWeek = day,
            Type = 'Normal',
            StartTime = Time.newInstance(9, 0, 0, 0),
            EndTime = Time.newInstance(17, 0, 0, 0)
          )
        );
      }
    }
    insert slots;
    Holiday bank = [
      SELECT Id
      FROM Holiday
      WHERE Name = 'Chrono Flow bank holiday'
    ];
    insert new List<OperatingHoursHoliday>{
      new OperatingHoursHoliday(
        OperatingHoursId = hours[0].Id,
        HolidayId = bank.Id
      ),
      new OperatingHoursHoliday(
        OperatingHoursId = hours[1].Id,
        HolidayId = bank.Id
      )
    };
    return hours;
  }
  private static ChronoWorkingTimeInput input(Id scheduleId) {
    ChronoWorkingTimeInput item = new ChronoWorkingTimeInput();
    item.scheduleType = 'OperatingHours';
    item.scheduleId = scheduleId;
    item.startValue = '2026-08-28T16:30+01:00[Europe/London]';
    item.timeZoneId = 'Europe/London';
    item.amount = 1;
    item.unit = 'hours';
    return item;
  }
  @IsTest
  static void bulkSchedulesAndDuplicateWork() {
    List<OperatingHours> hours = schedules();
    List<ChronoWorkingTimeInput> items = new List<ChronoWorkingTimeInput>();
    for (Integer i = 0; i < 200; i++) {
      items.add(input(hours[Math.mod(i, 2)].Id));
    }
    Test.startTest();
    Integer beforeQueries = Limits.getQueries();
    List<ChronoFlowResult> results = runWorkingTime(items);
    Integer queries = Limits.getQueries() - beforeQueries;
    Test.stopTest();
    Assert.areEqual(
      3,
      queries,
      'Three queries across all schedules and interviews'
    );
    Assert.areEqual(
      '2026-09-01T09:30:00.000+01:00[Europe/London]',
      results[0].value,
      'Skip weekend and Monday holiday'
    );
    Assert.areEqual(
      '2026-08-28T17:30:00.000+01:00[Europe/London]',
      results[1].value,
      'Other schedule uses own zone'
    );
    Assert.areEqual(200, results.size(), 'Interview count');
    results[0].value = 'changed';
    Assert.areEqual(
      '2026-09-01T09:30:00.000+01:00[Europe/London]',
      results[2].value,
      'Independent result copies'
    );
  }
  @IsTest
  static void bulkServiceReturnsIndependentTypedValues() {
    List<OperatingHours> hours = schedules();
    List<ChronoWorkingTimeInput> requests = new List<ChronoWorkingTimeInput>();
    for (Integer i = 0; i < 200; i++) {
      requests.add(input(hours[Math.mod(i, 2)].Id));
    }
    String original = JSON.serialize(requests);
    Test.startTest();
    Integer beforeQueries = Limits.getQueries();
    List<ChronoWorkingTimeResult> results = ChronoWorkingTimeService.add(
      requests
    );
    Assert.areEqual(3, Limits.getQueries() - beforeQueries);
    Test.stopTest();
    Assert.areEqual(200, results.size());
    for (Integer i = 0; i < 200; i++) {
      Assert.isTrue(
        results[i].success,
        'Item ' + i + ': ' + results[i].errorMessage
      );
      Assert.isNull(results[i].errorMessage);
      Assert.areEqual(
        Math.mod(i, 2) == 0
          ? '2026-09-01T09:30:00.000+01:00[Europe/London]'
          : '2026-08-28T17:30:00.000+01:00[Europe/London]',
        ChronoZonedDateTimeService.toIsoString(results[i].value)
      );
    }
    Assert.areEqual(
      original,
      JSON.serialize(requests),
      'Requests remain unchanged'
    );
    Datetime expected = results[2].value.instant;
    results[0].value.instant = expected.addDays(1);
    results[0].value.timeZoneId = 'America/New_York';
    results[0].success = false;
    Assert.areEqual(
      expected,
      results[2].value.instant,
      'Nested values are independent'
    );
    Assert.areEqual('Europe/London', results[2].value.timeZoneId);
    Assert.isTrue(results[2].success);
  }
  @IsTest
  static void serviceErrorsEmptyInputsAndLaterInvocation() {
    List<OperatingHours> hours = schedules();
    ChronoWorkingTimeInput invalid = input(hours[0].Id);
    invalid.startInstant = Datetime.now();
    ChronoWorkingTimeInput badZone = input(hours[0].Id);
    badZone.timeZoneId = 'Not/AZone';
    ChronoWorkingTimeInput valid = input(hours[0].Id);
    Test.startTest();
    Integer beforeQueries = Limits.getQueries();
    Assert.areEqual(0, ChronoWorkingTimeService.add(null).size());
    Assert.areEqual(
      0,
      ChronoWorkingTimeService.add(new List<ChronoWorkingTimeInput>()).size()
    );
    Assert.areEqual(beforeQueries, Limits.getQueries());
    List<ChronoWorkingTimeResult> results = ChronoWorkingTimeService.add(
      new List<ChronoWorkingTimeInput>{ null, invalid, badZone, valid }
    );
    for (Integer i = 0; i < 3; i++) {
      Assert.isFalse(results[i].success);
      Assert.isNotNull(results[i].errorMessage);
      Assert.isNull(results[i].value);
    }
    Assert.isTrue(results[3].success);
    valid.amount = 2;
    List<ChronoWorkingTimeResult> later = ChronoWorkingTimeService.add(
      new List<ChronoWorkingTimeInput>{ valid }
    );
    Assert.areEqual(
      '2026-09-01T10:30:00.000+01:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(later[0].value)
    );
    Assert.areEqual(
      '2026-09-01T09:30:00.000+01:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(results[3].value)
    );
    Test.stopTest();
  }
  @IsTest
  static void workingCollectionsAndNegativeMinutes() {
    List<OperatingHours> hours = schedules();
    ChronoWorkingTimeInput forward = input(hours[0].Id);
    ChronoWorkingTimeInput backwards = input(hours[0].Id);
    backwards.startValue = '2026-09-01T09:30+01:00[Europe/London]';
    backwards.amount = -60;
    backwards.unit = 'minutes';
    ChronoWorkingTimeCollectionAction.Request row = new ChronoWorkingTimeCollectionAction.Request();
    row.items = new List<ChronoWorkingTimeInput>{ forward, backwards };
    List<ChronoWorkingTimeCollectionAction.Request> requests = new List<ChronoWorkingTimeCollectionAction.Request>();
    for (Integer i = 0; i < 200; i++) {
      requests.add(row);
    }
    Test.startTest();
    Integer beforeQueries = Limits.getQueries();
    List<ChronoFlowCollectionResult> results = ChronoWorkingTimeCollectionAction.run(
      requests
    );
    Integer queries = Limits.getQueries() - beforeQueries;
    Test.stopTest();
    Assert.areEqual(
      3,
      queries,
      'Collection items share queries across interviews'
    );
    Assert.areEqual(200, results.size(), 'Outer count');
    Assert.areEqual(
      '2026-08-28T16:30:00.000+01:00[Europe/London]',
      results[199].results[1].value,
      'Negative working minutes'
    );
    Assert.areEqual(0, runWorkingTime(null).size(), 'Empty scalar invocation');
    Assert.areEqual(
      0,
      ChronoWorkingTimeCollectionAction.run(null).size(),
      'Empty collection invocation'
    );
  }
  @IsTest
  static void malformedSchedulesDoNotPoisonValidItems() {
    List<OperatingHours> hours = schedules();
    OperatingHours empty = new OperatingHours(Name = 'Empty', TimeZone = 'GMT');
    insert empty;
    ChronoWorkingTimeInput bad = input(hours[0].Id);
    bad.scheduleId = 'not-an-id';
    ChronoWorkingTimeInput wrong = input(hours[0].Id);
    wrong.scheduleId = UserInfo.getUserId();
    ChronoWorkingTimeInput unit = input(hours[0].Id);
    unit.unit = 'days';
    ChronoWorkingTimeInput type = input(hours[0].Id);
    type.scheduleType = 'Nope';
    Test.startTest();
    List<ChronoFlowResult> results = runWorkingTime(
      new List<ChronoWorkingTimeInput>{
        bad,
        wrong,
        input(empty.Id),
        unit,
        type,
        null,
        input(hours[0].Id)
      }
    );
    Test.stopTest();
    for (Integer i = 0; i < 6; i++) {
      Assert.isFalse(results[i].success, 'Invalid item ' + i);
      Assert.isNotNull(results[i].errorMessage, 'Actionable diagnostic');
    }
    Assert.isTrue(
      results[6].success,
      'Unexpected failure: ' + results[6].errorMessage
    );
    ChronoWorkingTimeCollectionAction.Request missing = new ChronoWorkingTimeCollectionAction.Request();
    Assert.isFalse(
      ChronoWorkingTimeCollectionAction.run(
          new List<ChronoWorkingTimeCollectionAction.Request>{ missing }
        )[0]
        .success,
      'Missing collection diagnostic'
    );
  }
  @IsTest
  static void businessHoursUsesNativeService() {
    BusinessHours hours = [
      SELECT Id
      FROM BusinessHours
      WHERE IsDefault = TRUE
      LIMIT 1
    ];
    ChronoWorkingTimeInput item = input(hours.Id);
    item.scheduleType = 'BusinessHours';
    item.startValue = null;
    item.startInstant = Datetime.newInstanceGmt(2026, 8, 28, 15, 30, 0);
    Datetime expected = System.BusinessHours.addGmt(
      hours.Id,
      item.startInstant,
      3600000L
    );
    Test.startTest();
    Integer beforeQueries = Limits.getQueries();
    List<ChronoFlowResult> results = runWorkingTime(
      new List<ChronoWorkingTimeInput>{ item, item }
    );
    Integer queries = Limits.getQueries() - beforeQueries;
    Test.stopTest();
    Assert.areEqual(1, queries, 'One permission-aware schedule lookup');
    Assert.isTrue(
      results[0].success,
      'Unexpected failure: ' + results[0].errorMessage
    );
    Assert.areEqual(
      expected,
      results[1].instantValue,
      'Native holiday and working-time service'
    );
  }
  private static ChronoDifferenceInput difference(Id scheduleId) {
    ChronoDifferenceInput item = new ChronoDifferenceInput();
    item.operatingHoursId = scheduleId;
    item.startValue = '2026-08-28T16:30+01:00[Europe/London]';
    item.endValue = '2026-09-01T09:30+01:00[Europe/London]';
    return item;
  }
  @IsTest
  static void differenceSharesSchedulesAndCalculations() {
    List<OperatingHours> hours = schedules();
    List<Object> items = new List<Object>();
    for (Integer i = 0; i < 200; i++) {
      items.add(difference(hours[Math.mod(i, 2)].Id));
    }
    ChronoFlowBatch batch = new ChronoFlowBatch('Difference');
    Test.startTest();
    Integer beforeQueries = Limits.getQueries();
    List<ChronoFlowResult> results = batch.run(items);
    Assert.areEqual(
      3,
      Limits.getQueries() - beforeQueries,
      'Schedules loaded once'
    );
    Test.stopTest();
    Assert.areEqual(2, batch.computationCount, 'Identical calculations reused');
    Assert.areEqual(200, results.size(), 'Interview order retained');
    Assert.areEqual(
      3600000L,
      results[0].milliseconds,
      'One open hour excluding weekend and bank holiday'
    );
    Assert.areEqual(
      5400000L,
      results[1].milliseconds,
      'UTC schedule has 90 open minutes on Friday'
    );
    Assert.areEqual('PT3600.000S', results[0].value, 'ISO duration output');
    results[0].milliseconds = 0;
    Assert.areEqual(
      3600000L,
      results[2].milliseconds,
      'Cached results are independent'
    );
  }
  @IsTest
  static void differenceScalarAndCollectionContracts() {
    List<OperatingHours> hours = schedules();
    ChronoDifferenceInput forward = difference(hours[0].Id);
    ChronoDifferenceInput reverse = difference(hours[0].Id);
    reverse.startValue = forward.endValue;
    reverse.endValue = forward.startValue;
    ChronoDifferenceCollectionAction.Request row = new ChronoDifferenceCollectionAction.Request();
    row.items = new List<ChronoDifferenceInput>{ forward, reverse };
    List<ChronoDifferenceCollectionAction.Request> requests = new List<ChronoDifferenceCollectionAction.Request>();
    for (Integer i = 0; i < 200; i++) {
      requests.add(row);
    }
    Test.startTest();
    Integer beforeQueries = Limits.getQueries();
    List<ChronoFlowCollectionResult> results = ChronoDifferenceCollectionAction.run(
      requests
    );
    Assert.areEqual(
      3,
      Limits.getQueries() - beforeQueries,
      'Collections share schedule queries'
    );
    Test.stopTest();
    Assert.areEqual(200, results.size(), 'Outer interview count');
    Assert.areEqual(
      -3600000L,
      results[199].results[1].milliseconds,
      'Inner order and negative difference'
    );
    results[0].results[0].value = 'changed';
    Assert.areEqual(
      'PT3600.000S',
      results[1].results[0].value,
      'Independent collection values'
    );
    ChronoDifferenceAction.Request scalar = new ChronoDifferenceAction.Request();
    scalar.startInstant = ChronoZonedDateTimeService.toDatetime(
      ChronoZonedDateTimeService.parseIso(forward.startValue)
    );
    scalar.endInstant = ChronoZonedDateTimeService.toDatetime(
      ChronoZonedDateTimeService.parseIso(forward.endValue)
    );
    scalar.operatingHoursId = hours[0].Id;
    Assert.areEqual(
      3600000L,
      ChronoDifferenceAction.run(
          new List<ChronoDifferenceAction.Request>{ scalar }
        )[0]
        .milliseconds,
      'Scalar native input forwards schedule ID'
    );
  }
  @IsTest
  static void differenceFailuresAndDefaultElapsedAreIndependent() {
    List<OperatingHours> hours = schedules();
    OperatingHours empty = new OperatingHours(Name = 'Empty', TimeZone = 'GMT');
    insert empty;
    ChronoDifferenceInput bad = difference(hours[0].Id);
    bad.operatingHoursId = 'bad-id';
    ChronoDifferenceInput wrong = difference(UserInfo.getUserId());
    ChronoDifferenceInput raw = difference(null);
    Test.startTest();
    Integer beforeQueries = Limits.getQueries();
    ChronoFlowResult elapsed = new ChronoFlowBatch('Difference')
      .run(new List<Object>{ raw })[0];
    Assert.areEqual(
      0,
      Limits.getQueries() - beforeQueries,
      'No queries without a schedule'
    );
    List<ChronoFlowResult> results = new ChronoFlowBatch('Difference')
      .run(
        new List<Object>{
          bad,
          wrong,
          difference(empty.Id),
          null,
          raw,
          difference(hours[0].Id)
        }
      );
    Test.stopTest();
    Assert.areEqual(
      320400000L,
      elapsed.milliseconds,
      'Unrestricted difference remains 89 hours'
    );
    for (Integer i = 0; i < 4; i++) {
      Assert.isFalse(results[i].success, 'Bad item ' + i);
      Assert.isNotNull(results[i].errorMessage, 'Useful item error');
    }
    Assert.areEqual(
      elapsed.milliseconds,
      results[4].milliseconds,
      'Invalid schedules cannot affect raw difference'
    );
    Assert.areEqual(
      3600000L,
      results[5].milliseconds,
      'Valid schedule survives bad items'
    );
  }
  private static List<ChronoFlowResult> runWorkingTime(
    List<ChronoWorkingTimeInput> items
  ) {
    if (items == null) {
      return ChronoWorkingTimeAction.run(null);
    }
    List<ChronoWorkingTimeAction.Request> wrappers = new List<ChronoWorkingTimeAction.Request>();
    for (ChronoWorkingTimeInput item : items) {
      wrappers.add(
        item == null
          ? null
          : (ChronoWorkingTimeAction.Request) JSON.deserialize(
              JSON.serialize(item),
              ChronoWorkingTimeAction.Request.class
            )
      );
    }
    return ChronoWorkingTimeAction.run(wrappers);
  }
}
