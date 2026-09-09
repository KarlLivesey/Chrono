// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoFlowScheduleOpsTest {
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
  private static ChronoOperationInput input(Id id, String type, String value) {
    ChronoOperationInput result = new ChronoOperationInput();
    result.operatingHoursId = id;
    result.source.valueType = type;
    result.source.value = value;
    return result;
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
  @IsTest
  static void membershipDatesAndInstantsUsesScheduleZone() {
    Id id = schedules()[0].Id;
    ChronoOperationInput value = input(
      id,
      'ZonedDateTime',
      '2026-08-28T11:30-04:00[America/New_York]'
    );
    Assert.isTrue(
      run('CheckWorkingTime', value).isOpen,
      '16:30 London is open'
    );
    value.source.value = '2026-08-28T12:00-04:00[America/New_York]';
    Assert.isFalse(
      run('CheckWorkingTime', value).isOpen,
      '17:00 closing boundary is excluded'
    );
    value = input(id, 'PlainDate', '2026-08-31');
    Assert.isFalse(
      run('CheckWorkingTime', value).isOpen,
      'Bank holiday has no opening'
    );
    value.source.value = '2026-09-01';
    Assert.isTrue(
      run('CheckWorkingTime', value).isOpen,
      'Date checks for any opening, not just midnight'
    );
  }
  @IsTest
  static void nextAndPreviousSkipClosuresAndPreserveOpenValues() {
    Id id = schedules()[0].Id;
    ChronoOperationInput value = input(
      id,
      'ZonedDateTime',
      '2026-08-29T12:00+01:00[Europe/London]'
    );
    value.direction = 'next';
    Assert.areEqual(
      '2026-09-01T09:00:00.000+01:00[Europe/London]',
      run('FindWorkingTime', value).value
    );
    value.direction = 'previous';
    Assert.areEqual(
      '2026-08-28T16:59:59.999+01:00[Europe/London]',
      run('FindWorkingTime', value).value
    );
    value.source.value = '2026-08-28T16:30+01:00[Europe/London]';
    Assert.areEqual(
      '2026-08-28T16:30:00.000+01:00[Europe/London]',
      run('FindWorkingTime', value).value,
      'Already open remains unchanged'
    );
    value = input(id, 'PlainDate', '2026-08-31');
    value.direction = 'next';
    Assert.areEqual('2026-09-01', run('FindWorkingTime', value).value);
    value = input(id, 'PlainDateTime', '2026-08-29T12:00');
    value.source.timeZoneId = 'Europe/London';
    value.direction = 'next';
    Assert.areEqual(
      '2026-09-01T09:00:00.000+01:00[Europe/London]',
      run('FindWorkingTime', value).value
    );
  }
  @IsTest
  static void missingSlotsIsConfigurationError() {
    OperatingHours closed = new OperatingHours(
      Name = 'Closed',
      TimeZone = 'GMT'
    );
    insert closed;
    ChronoOperationInput value = input(
      closed.Id,
      'Instant',
      '2026-09-01T10:00Z'
    );
    ChronoFlowResult result = new ChronoFlowBatch('CheckWorkingTime')
      .run(new List<Object>{ value })[0];
    Assert.isFalse(result.success);
    Assert.isTrue(
      result.errorMessage.contains('no normal time slots'),
      'An unconfigured schedule must not be treated as valid closed hours'
    );
  }
  @IsTest
  static void schedulesLoadOnceAndErrorsStayWithItems() {
    List<OperatingHours> hours = schedules();
    List<Object> inputs = new List<Object>();
    for (Integer i = 0; i < 200; i++) {
      inputs.add(
        input(hours[Math.mod(i, 2)].Id, 'Instant', '2026-08-28T15:30Z')
      );
    }
    inputs.add(input(null, 'Instant', '2026-08-28T15:30Z'));
    ChronoOperationInput malformed = input(
      null,
      'Instant',
      '2026-08-28T15:30Z'
    );
    malformed.operatingHoursId = 'not an id';
    inputs.add(malformed);
    ChronoFlowBatch batch = new ChronoFlowBatch('CheckWorkingTime');
    Test.startTest();
    Integer before = Limits.getQueries();
    List<ChronoFlowResult> results = batch.run(inputs);
    Integer used = Limits.getQueries() - before;
    Test.stopTest();
    Assert.areEqual(3, used);
    Assert.areEqual(4, batch.computationCount);
    Assert.areEqual(202, results.size());
    Assert.isFalse(results[200].success);
    Assert.isFalse(results[201].success);
    results[0].isOpen = false;
    Assert.isTrue(results[2].isOpen, 'Results are independently mutable');
  }
  @IsTest
  static void collectionInterviewsKeepBothOrders() {
    Id id = schedules()[0].Id;
    List<ChronoFindWorkingTimeCollectionAction.Request> interviews = new List<ChronoFindWorkingTimeCollectionAction.Request>();
    for (Integer i = 0; i < 200; i++) {
      ChronoFindWorkingTimeInput good = new ChronoFindWorkingTimeInput();
      good.valueType = 'PlainDate';
      good.value = '2026-08-31';
      good.operatingHoursId = id;
      good.direction = 'next';
      ChronoFindWorkingTimeCollectionAction.Request request = new ChronoFindWorkingTimeCollectionAction.Request();
      request.items = new List<ChronoFindWorkingTimeInput>{ good, null };
      interviews.add(request);
    }
    Test.startTest();
    Integer before = Limits.getQueries();
    List<ChronoFlowCollectionResult> results = ChronoFindWorkingTimeCollectionAction.run(
      interviews
    );
    Integer used = Limits.getQueries() - before;
    Test.stopTest();
    Assert.areEqual(3, used);
    Assert.areEqual(200, results.size());
    Assert.areEqual('2026-09-01', results[199].results[0].value);
    Assert.isFalse(results[199].results[1].success);
    Assert.isFalse(results[199].success);
    results[0].results[0].value = 'changed';
    Assert.areEqual('2026-09-01', results[1].results[0].value);
  }
}
