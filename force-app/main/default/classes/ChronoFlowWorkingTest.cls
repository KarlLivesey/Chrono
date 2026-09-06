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
    List<Object> items = new List<Object>();
    for (Integer i = 0; i < 200; i++) {
      items.add(input(hours[Math.mod(i, 2)].Id));
    }
    ChronoFlowBatch batch = new ChronoFlowBatch('WorkingTime');
    Test.startTest();
    Integer beforeQueries = Limits.getQueries();
    List<ChronoFlowResult> results = batch.run(items);
    Integer queries = Limits.getQueries() - beforeQueries;
    Test.stopTest();
    Assert.areEqual(
      3,
      queries,
      'Three queries across all schedules and interviews'
    );
    Assert.areEqual(
      2,
      batch.computationCount,
      'One computation per complete distinct input'
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
