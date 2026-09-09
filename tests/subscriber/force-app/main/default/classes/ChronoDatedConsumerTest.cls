// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoDatedConsumerTest {
  private static OperatingHours hours() {
    return new OperatingHours(
      Name = 'London weekdays',
      TimeZone = 'Europe/London'
    );
  }
  private static List<TimeSlot> slots() {
    List<TimeSlot> result = new List<TimeSlot>();
    for (
      String day : new List<String>{
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday'
      }
    ) {
      result.add(
        new TimeSlot(
          DayOfWeek = day,
          Type = 'Normal',
          StartTime = Time.newInstance(9, 0, 0, 0),
          EndTime = Time.newInstance(17, 0, 0, 0)
        )
      );
    }
    return result;
  }
  private static List<Holiday> holidays() {
    return new List<Holiday>{
      new Holiday(
        Name = 'Bank holiday',
        ActivityDate = Date.newInstance(2026, 8, 31),
        IsAllDay = true
      )
    };
  }
  private static skel.ChronoWorkingTimeInput addInput() {
    skel.ChronoWorkingTimeInput input = new skel.ChronoWorkingTimeInput();
    input.startValue = '2026-08-28T16:30';
    input.timeZoneId = 'Europe/London';
    input.scheduleType = 'OperatingHours';
    input.operatingHours = hours();
    input.timeSlots = slots();
    input.holidays = holidays();
    input.amount = 1;
    input.unit = 'hours';
    return input;
  }
  private static skel.ChronoDifferenceInput difference(
    String start,
    String finish
  ) {
    skel.ChronoDifferenceInput input = new skel.ChronoDifferenceInput();
    input.startValue = start;
    input.endValue = finish;
    input.timeZoneId = 'Europe/London';
    return input;
  }
  @IsTest
  static void localDateElapsedCountsActualDstDayLength() {
    skel.ChronoDifferenceInput spring = difference('2026-03-29', '2026-03-30');
    skel.ChronoDifferenceInput autumn = difference(null, null);
    autumn.startDate = Date.newInstance(2026, 10, 25);
    autumn.endDate = Date.newInstance(2026, 10, 26);
    skel.ChronoDifferenceInput reverse = difference('2026-03-30', '2026-03-29');
    Test.startTest();
    List<skel.ChronoDurationCalculationResult> rows = skel.ChronoCalculationService.difference(
      new List<skel.ChronoDifferenceInput>{ spring, autumn, reverse }
    );
    Assert.areEqual(0, Limits.getQueries());
    Test.stopTest();
    for (skel.ChronoDurationCalculationResult row : rows) {
      Assert.isTrue(row.success, ('Expected success: ' + row.errorMessage));
    }
    Assert.areEqual(23 * 3600000L, rows[0].value.milliseconds);
    Assert.areEqual(25 * 3600000L, rows[1].value.milliseconds);
    Assert.areEqual(-23 * 3600000L, rows[2].value.milliseconds);
  }
  @IsTest
  static void mixedRepresentationsAndIndependentEndpointZones() {
    skel.ChronoDifferenceInput input = difference(null, '2026-09-07T09:00');
    input.startDate = Date.newInstance(2026, 9, 7);
    input.startTime = '09:00';
    input.endTimeZoneId = 'America/New_York';
    skel.ChronoDifferenceInput exact = difference(
      '2026-09-07T09:00+01:00[Europe/London]',
      null
    );
    exact.endInstant = Datetime.newInstanceGmt(2026, 9, 7, 13, 0, 0);
    exact.timeZoneId = null;
    List<skel.ChronoDurationCalculationResult> rows = skel.ChronoCalculationService.difference(
      new List<skel.ChronoDifferenceInput>{ input, exact }
    );
    for (skel.ChronoDurationCalculationResult row : rows) {
      Assert.isTrue(row.success, ('Expected success: ' + row.errorMessage));
      Assert.areEqual(5 * 3600000L, row.value.milliseconds);
    }
  }
  @IsTest
  static void gapsRepeatsAndConflictingInputsAreIsolated() {
    skel.ChronoDifferenceInput repeat = difference(
      '2026-10-25T01:30',
      '2026-10-25T01:30'
    );
    repeat.disambiguation = 'earlier';
    repeat.endDisambiguation = 'later';
    skel.ChronoDifferenceInput gap = difference(
      '2026-03-29T01:30',
      '2026-03-29T03:00'
    );
    skel.ChronoDifferenceInput ambiguous = difference(
      '2026-10-25T01:30',
      '2026-10-25T03:00'
    );
    skel.ChronoDifferenceInput noZone = difference('2026-09-07', '2026-09-08');
    noZone.timeZoneId = null;
    skel.ChronoDifferenceInput conflict = difference(
      '2026-09-07',
      '2026-09-08'
    );
    conflict.startDate = Date.newInstance(2026, 9, 7);
    List<skel.ChronoDurationCalculationResult> rows = skel.ChronoCalculationService.difference(
      new List<skel.ChronoDifferenceInput>{
        repeat,
        gap,
        ambiguous,
        noZone,
        conflict
      }
    );
    Assert.isTrue(
      rows[0].success,
      ('Expected success: ' + rows[0].errorMessage)
    );
    Assert.areEqual(3600000L, rows[0].value.milliseconds);
    for (Integer i = 1; i < rows.size(); i++) {
      Assert.isFalse(rows[i].success, 'Expected isolated failure ' + i);
    }
  }
  @IsTest
  static void unsavedSchedulesBulkAddUsesLocalInputAndIndependentResults() {
    skel.ChronoWorkingTimeInput local = addInput();
    skel.ChronoWorkingTimeInput nativeClock = addInput();
    nativeClock.startValue = null;
    nativeClock.startDate = Date.newInstance(2026, 8, 28);
    nativeClock.startTime = '16:30';
    skel.ChronoWorkingTimeInput dateOnly = addInput();
    dateOnly.startValue = '2026-08-28';
    List<skel.ChronoWorkingTimeInput> requests = new List<skel.ChronoWorkingTimeInput>();
    for (Integer i = 0; i < 200; i++) {
      requests.add(Math.mod(i, 2) == 0 ? local : nativeClock);
    }
    requests.add(dateOnly);
    requests.add(null);
    Test.startTest();
    List<skel.ChronoWorkingTimeResult> rows = skel.ChronoWorkingTimeService.add(
      requests
    );
    Assert.areEqual(0, Limits.getQueries());
    Assert.areEqual(0, Limits.getDmlStatements());
    Test.stopTest();
    for (Integer i = 0; i < 200; i++) {
      Assert.isTrue(
        rows[i].success,
        ('Expected success: ' + rows[i].errorMessage)
      );
      Assert.areEqual(
        Datetime.newInstanceGmt(2026, 9, 1, 8, 30, 0),
        rows[i].value.instant
      );
    }
    Assert.isTrue(
      rows[200].success,
      ('Expected success: ' + rows[200].errorMessage)
    );
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 8, 28, 9, 0, 0),
      rows[200].value.instant
    );
    Assert.isFalse(rows[201].success);
    rows[0].value.instant = null;
    Assert.isNotNull(rows[2].value.instant);
    Assert.areEqual('2026-08-28T16:30', local.startValue);
  }
  @IsTest
  static void suppliedDifferencePreservesSignedMilliseconds() {
    skel.ChronoDifferenceInput input = difference(
      '2026-08-28T16:30:00.001',
      '2026-09-01T09:30'
    );
    input.operatingHours = hours();
    input.timeSlots = slots();
    input.holidays = holidays();
    skel.ChronoDifferenceInput reverse = difference(
      input.endValue,
      input.startValue
    );
    reverse.operatingHours = hours();
    reverse.timeSlots = slots();
    reverse.holidays = holidays();
    Test.startTest();
    List<skel.ChronoDurationCalculationResult> rows = skel.ChronoCalculationService.difference(
      new List<skel.ChronoDifferenceInput>{ input, reverse }
    );
    Assert.areEqual(0, Limits.getQueries());
    Test.stopTest();
    Assert.isTrue(
      rows[0].success,
      ('Expected success: ' + rows[0].errorMessage)
    );
    Assert.isTrue(
      rows[1].success,
      ('Expected success: ' + rows[1].errorMessage)
    );
    Assert.areEqual(3599999L, rows[0].value.milliseconds);
    Assert.areEqual(-3599999L, rows[1].value.milliseconds);
  }
  @IsTest
  static void suppliedChecksAndNavigationKeepDateSemantics() {
    skel.ChronoCheckWorkingTimeInput open = new skel.ChronoCheckWorkingTimeInput();
    open.valueType = 'PlainDate';
    open.dateValue = Date.newInstance(2026, 8, 28);
    open.operatingHours = hours();
    open.timeSlots = slots();
    open.holidays = holidays();
    skel.ChronoCheckWorkingTimeInput closed = new skel.ChronoCheckWorkingTimeInput();
    closed.valueType = 'PlainDate';
    closed.value = '2026-08-31';
    closed.operatingHours = hours();
    closed.timeSlots = slots();
    closed.holidays = holidays();
    skel.ChronoFindWorkingTimeInput find = new skel.ChronoFindWorkingTimeInput();
    find.valueType = 'PlainDate';
    find.value = closed.value;
    find.direction = 'next';
    find.operatingHours = hours();
    find.timeSlots = slots();
    find.holidays = holidays();
    Test.startTest();
    List<skel.ChronoWorkingTimeCheckResult> checks = skel.ChronoWorkingTimeService.check(
      new List<skel.ChronoCheckWorkingTimeInput>{ open, closed }
    );
    List<skel.ChronoValueResult> found = skel.ChronoWorkingTimeService.find(
      new List<skel.ChronoFindWorkingTimeInput>{ find }
    );
    Assert.areEqual(0, Limits.getQueries());
    Test.stopTest();
    Assert.isTrue(
      checks[0].success,
      ('Expected success: ' + checks[0].errorMessage)
    );
    Assert.isTrue(checks[0].isOpen);
    Assert.isFalse(checks[1].isOpen);
    Assert.isTrue(
      found[0].success,
      ('Expected success: ' + found[0].errorMessage)
    );
    Assert.areEqual(
      Date.newInstance(2026, 9, 1),
      found[0].value.plainDate.value
    );
  }
  @IsTest
  static void contradictoryAndOrphanSchedulesDoNotBecomeUnrestricted() {
    skel.ChronoDifferenceInput orphan = difference('2026-09-07', '2026-09-08');
    orphan.holidays = holidays();
    skel.ChronoWorkingTimeInput business = addInput();
    business.scheduleType = 'BusinessHours';
    skel.ChronoWorkingTimeInput conflict = addInput();
    conflict.scheduleId = UserInfo.getUserId();
    List<skel.ChronoWorkingTimeResult> rows = skel.ChronoWorkingTimeService.add(
      new List<skel.ChronoWorkingTimeInput>{ business, conflict, addInput() }
    );
    Assert.isFalse(rows[0].success);
    Assert.isFalse(rows[1].success);
    Assert.isTrue(
      rows[2].success,
      ('Expected success: ' + rows[2].errorMessage)
    );
    Assert.isFalse(
      skel.ChronoCalculationService.difference(
          new List<skel.ChronoDifferenceInput>{ orphan }
        )[0]
        .success
    );
  }
  @IsTest
  static void scalarFlowAdaptersPassNativeScheduleAndEndpointFields() {
    skel.ChronoWorkingTimeAction.Request add = new skel.ChronoWorkingTimeAction.Request();
    add.startDate = Date.newInstance(2026, 8, 28);
    add.startTime = '16:30';
    add.timeZoneId = 'Europe/London';
    add.amount = 1;
    add.unit = 'hours';
    add.scheduleType = 'OperatingHours';
    add.operatingHours = hours();
    add.timeSlots = slots();
    add.holidays = holidays();
    skel.ChronoFlowResult added = skel.ChronoWorkingTimeAction.run(
      new List<skel.ChronoWorkingTimeAction.Request>{ add }
    )[0];
    Assert.isTrue(added.success, ('Expected success: ' + added.errorMessage));
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 9, 1, 8, 30, 0),
      added.instantValue
    );
    skel.ChronoDifferenceAction.Request diff = new skel.ChronoDifferenceAction.Request();
    diff.startDate = add.startDate;
    diff.startTime = add.startTime;
    diff.endDate = Date.newInstance(2026, 9, 1);
    diff.endTime = '09:30';
    diff.timeZoneId = add.timeZoneId;
    diff.operatingHours = hours();
    diff.timeSlots = slots();
    diff.holidays = holidays();
    skel.ChronoFlowResult elapsed = skel.ChronoDifferenceAction.run(
      new List<skel.ChronoDifferenceAction.Request>{ diff }
    )[0];
    Assert.isTrue(
      elapsed.success,
      ('Expected success: ' + elapsed.errorMessage)
    );
    Assert.areEqual(3600000L, elapsed.milliseconds);
  }
  @IsTest
  static void scalarCheckAndFindPassNativeRecords() {
    skel.ChronoCheckWorkingTimeAction.Request check = new skel.ChronoCheckWorkingTimeAction.Request();
    check.valueType = 'PlainDate';
    check.dateValue = Date.newInstance(2026, 8, 31);
    check.operatingHours = hours();
    check.timeSlots = slots();
    check.holidays = holidays();
    skel.ChronoFlowResult checked = skel.ChronoCheckWorkingTimeAction.run(
      new List<skel.ChronoCheckWorkingTimeAction.Request>{ check }
    )[0];
    Assert.isTrue(
      checked.success,
      ('Expected success: ' + checked.errorMessage)
    );
    Assert.isFalse(checked.isOpen);
    skel.ChronoFindWorkingTimeAction.Request find = new skel.ChronoFindWorkingTimeAction.Request();
    find.valueType = 'PlainDate';
    find.dateValue = check.dateValue;
    find.direction = 'previous';
    find.operatingHours = hours();
    find.timeSlots = slots();
    find.holidays = holidays();
    skel.ChronoFlowResult found = skel.ChronoFindWorkingTimeAction.run(
      new List<skel.ChronoFindWorkingTimeAction.Request>{ find }
    )[0];
    Assert.isTrue(found.success, ('Expected success: ' + found.errorMessage));
    Assert.areEqual(Date.newInstance(2026, 8, 28), found.dateValue);
  }
  @IsTest
  static void collectionFlowKeepsOuterAndInnerOrder() {
    skel.ChronoWorkingTimeCollectionAction.Request first = new skel.ChronoWorkingTimeCollectionAction.Request();
    first.items = new List<skel.ChronoWorkingTimeInput>{ addInput(), null };
    skel.ChronoWorkingTimeCollectionAction.Request second = new skel.ChronoWorkingTimeCollectionAction.Request();
    second.items = new List<skel.ChronoWorkingTimeInput>{ addInput() };
    Test.startTest();
    List<skel.ChronoFlowCollectionResult> rows = skel.ChronoWorkingTimeCollectionAction.run(
      new List<skel.ChronoWorkingTimeCollectionAction.Request>{ first, second }
    );
    Assert.areEqual(0, Limits.getQueries());
    Test.stopTest();
    Assert.areEqual(2, rows.size());
    Assert.areEqual(2, rows[0].results.size());
    Assert.areEqual(1, rows[1].results.size());
    Assert.isTrue(
      rows[0].results[0].success,
      ('Expected success: ' + rows[0].results[0].errorMessage)
    );
    Assert.isFalse(rows[0].results[1].success);
    rows[0].results[0].instantValue = null;
    Assert.isNotNull(rows[1].results[0].instantValue);
  }
}
