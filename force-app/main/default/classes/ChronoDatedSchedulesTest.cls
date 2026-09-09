// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoDatedSchedulesTest {
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
  private static ChronoWorkingTimeInput addInput() {
    ChronoWorkingTimeInput input = new ChronoWorkingTimeInput();
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
  private static ChronoDifferenceInput difference(String start, String finish) {
    ChronoDifferenceInput input = new ChronoDifferenceInput();
    input.startValue = start;
    input.endValue = finish;
    input.timeZoneId = 'Europe/London';
    return input;
  }
  @IsTest
  static void localDateElapsedCountsActualDstDayLength() {
    ChronoDifferenceInput spring = difference('2026-03-29', '2026-03-30');
    ChronoDifferenceInput autumn = difference(null, null);
    autumn.startDate = Date.newInstance(2026, 10, 25);
    autumn.endDate = Date.newInstance(2026, 10, 26);
    ChronoDifferenceInput reverse = difference('2026-03-30', '2026-03-29');
    Test.startTest();
    List<ChronoDurationCalculationResult> rows = ChronoCalculationService.difference(
      new List<ChronoDifferenceInput>{ spring, autumn, reverse }
    );
    Assert.areEqual(0, Limits.getQueries());
    Test.stopTest();
    for (ChronoDurationCalculationResult row : rows) {
      Assert.isTrue(row.success, ('Expected success: ' + row.errorMessage));
    }
    Assert.areEqual(23 * 3600000L, rows[0].value.milliseconds);
    Assert.areEqual(25 * 3600000L, rows[1].value.milliseconds);
    Assert.areEqual(-23 * 3600000L, rows[2].value.milliseconds);
  }
  @IsTest
  static void mixedRepresentationsAndIndependentEndpointZones() {
    ChronoDifferenceInput input = difference(null, '2026-09-07T09:00');
    input.startDate = Date.newInstance(2026, 9, 7);
    input.startTime = '09:00';
    input.endTimeZoneId = 'America/New_York';
    ChronoDifferenceInput exact = difference(
      '2026-09-07T09:00+01:00[Europe/London]',
      null
    );
    exact.endInstant = Datetime.newInstanceGmt(2026, 9, 7, 13, 0, 0);
    exact.timeZoneId = null;
    List<ChronoDurationCalculationResult> rows = ChronoCalculationService.difference(
      new List<ChronoDifferenceInput>{ input, exact }
    );
    for (ChronoDurationCalculationResult row : rows) {
      Assert.isTrue(row.success, ('Expected success: ' + row.errorMessage));
      Assert.areEqual(5 * 3600000L, row.value.milliseconds);
    }
  }
  @IsTest
  static void gapsRepeatsAndConflictingInputsAreIsolated() {
    ChronoDifferenceInput repeat = difference(
      '2026-10-25T01:30',
      '2026-10-25T01:30'
    );
    repeat.disambiguation = 'earlier';
    repeat.endDisambiguation = 'later';
    ChronoDifferenceInput gap = difference(
      '2026-03-29T01:30',
      '2026-03-29T03:00'
    );
    ChronoDifferenceInput ambiguous = difference(
      '2026-10-25T01:30',
      '2026-10-25T03:00'
    );
    ChronoDifferenceInput noZone = difference('2026-09-07', '2026-09-08');
    noZone.timeZoneId = null;
    ChronoDifferenceInput conflict = difference('2026-09-07', '2026-09-08');
    conflict.startDate = Date.newInstance(2026, 9, 7);
    List<ChronoDurationCalculationResult> rows = ChronoCalculationService.difference(
      new List<ChronoDifferenceInput>{
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
    ChronoWorkingTimeInput local = addInput();
    ChronoWorkingTimeInput nativeClock = addInput();
    nativeClock.startValue = null;
    nativeClock.startDate = Date.newInstance(2026, 8, 28);
    nativeClock.startTime = '16:30';
    ChronoWorkingTimeInput dateOnly = addInput();
    dateOnly.startValue = '2026-08-28';
    List<ChronoWorkingTimeInput> requests = new List<ChronoWorkingTimeInput>();
    for (Integer i = 0; i < 200; i++) {
      requests.add(Math.mod(i, 2) == 0 ? local : nativeClock);
    }
    requests.add(dateOnly);
    requests.add(null);
    Test.startTest();
    List<ChronoWorkingTimeResult> rows = ChronoWorkingTimeService.add(requests);
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
    ChronoDifferenceInput input = difference(
      '2026-08-28T16:30:00.001',
      '2026-09-01T09:30'
    );
    input.operatingHours = hours();
    input.timeSlots = slots();
    input.holidays = holidays();
    ChronoDifferenceInput reverse = difference(
      input.endValue,
      input.startValue
    );
    reverse.operatingHours = hours();
    reverse.timeSlots = slots();
    reverse.holidays = holidays();
    Test.startTest();
    List<ChronoDurationCalculationResult> rows = ChronoCalculationService.difference(
      new List<ChronoDifferenceInput>{ input, reverse }
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
    ChronoCheckWorkingTimeInput open = new ChronoCheckWorkingTimeInput();
    open.valueType = 'PlainDate';
    open.dateValue = Date.newInstance(2026, 8, 28);
    open.operatingHours = hours();
    open.timeSlots = slots();
    open.holidays = holidays();
    ChronoCheckWorkingTimeInput closed = new ChronoCheckWorkingTimeInput();
    closed.valueType = 'PlainDate';
    closed.value = '2026-08-31';
    closed.operatingHours = hours();
    closed.timeSlots = slots();
    closed.holidays = holidays();
    ChronoFindWorkingTimeInput find = new ChronoFindWorkingTimeInput();
    find.valueType = 'PlainDate';
    find.value = closed.value;
    find.direction = 'next';
    find.operatingHours = hours();
    find.timeSlots = slots();
    find.holidays = holidays();
    Test.startTest();
    List<ChronoWorkingTimeCheckResult> checks = ChronoWorkingTimeService.check(
      new List<ChronoCheckWorkingTimeInput>{ open, closed }
    );
    List<ChronoValueResult> found = ChronoWorkingTimeService.find(
      new List<ChronoFindWorkingTimeInput>{ find }
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
    ChronoDifferenceInput orphan = difference('2026-09-07', '2026-09-08');
    orphan.holidays = holidays();
    ChronoWorkingTimeInput business = addInput();
    business.scheduleType = 'BusinessHours';
    ChronoWorkingTimeInput conflict = addInput();
    conflict.scheduleId = UserInfo.getUserId();
    List<ChronoWorkingTimeResult> rows = ChronoWorkingTimeService.add(
      new List<ChronoWorkingTimeInput>{ business, conflict, addInput() }
    );
    Assert.isFalse(rows[0].success);
    Assert.isFalse(rows[1].success);
    Assert.isTrue(
      rows[2].success,
      ('Expected success: ' + rows[2].errorMessage)
    );
    Assert.isFalse(
      ChronoCalculationService.difference(
          new List<ChronoDifferenceInput>{ orphan }
        )[0]
        .success
    );
  }
  @IsTest
  static void scalarFlowAdaptersPassNativeScheduleAndEndpointFields() {
    ChronoWorkingTimeAction.Request add = new ChronoWorkingTimeAction.Request();
    add.startDate = Date.newInstance(2026, 8, 28);
    add.startTime = '16:30';
    add.timeZoneId = 'Europe/London';
    add.amount = 1;
    add.unit = 'hours';
    add.scheduleType = 'OperatingHours';
    add.operatingHours = hours();
    add.timeSlots = slots();
    add.holidays = holidays();
    ChronoFlowResult added = ChronoWorkingTimeAction.run(
      new List<ChronoWorkingTimeAction.Request>{ add }
    )[0];
    Assert.isTrue(added.success, ('Expected success: ' + added.errorMessage));
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 9, 1, 8, 30, 0),
      added.instantValue
    );
    ChronoDifferenceAction.Request diff = new ChronoDifferenceAction.Request();
    diff.startDate = add.startDate;
    diff.startTime = add.startTime;
    diff.endDate = Date.newInstance(2026, 9, 1);
    diff.endTime = '09:30';
    diff.timeZoneId = add.timeZoneId;
    diff.operatingHours = hours();
    diff.timeSlots = slots();
    diff.holidays = holidays();
    ChronoFlowResult elapsed = ChronoDifferenceAction.run(
      new List<ChronoDifferenceAction.Request>{ diff }
    )[0];
    Assert.isTrue(
      elapsed.success,
      ('Expected success: ' + elapsed.errorMessage)
    );
    Assert.areEqual(3600000L, elapsed.milliseconds);
  }
  @IsTest
  static void scalarCheckAndFindPassNativeRecords() {
    ChronoCheckWorkingTimeAction.Request check = new ChronoCheckWorkingTimeAction.Request();
    check.valueType = 'PlainDate';
    check.dateValue = Date.newInstance(2026, 8, 31);
    check.operatingHours = hours();
    check.timeSlots = slots();
    check.holidays = holidays();
    ChronoFlowResult checked = ChronoCheckWorkingTimeAction.run(
      new List<ChronoCheckWorkingTimeAction.Request>{ check }
    )[0];
    Assert.isTrue(
      checked.success,
      ('Expected success: ' + checked.errorMessage)
    );
    Assert.isFalse(checked.isOpen);
    ChronoFindWorkingTimeAction.Request find = new ChronoFindWorkingTimeAction.Request();
    find.valueType = 'PlainDate';
    find.dateValue = check.dateValue;
    find.direction = 'previous';
    find.operatingHours = hours();
    find.timeSlots = slots();
    find.holidays = holidays();
    ChronoFlowResult found = ChronoFindWorkingTimeAction.run(
      new List<ChronoFindWorkingTimeAction.Request>{ find }
    )[0];
    Assert.isTrue(found.success, ('Expected success: ' + found.errorMessage));
    Assert.areEqual(Date.newInstance(2026, 8, 28), found.dateValue);
  }
  @IsTest
  static void collectionFlowKeepsOuterAndInnerOrder() {
    ChronoWorkingTimeCollectionAction.Request first = new ChronoWorkingTimeCollectionAction.Request();
    first.items = new List<ChronoWorkingTimeInput>{ addInput(), null };
    ChronoWorkingTimeCollectionAction.Request second = new ChronoWorkingTimeCollectionAction.Request();
    second.items = new List<ChronoWorkingTimeInput>{ addInput() };
    Test.startTest();
    List<ChronoFlowCollectionResult> rows = ChronoWorkingTimeCollectionAction.run(
      new List<ChronoWorkingTimeCollectionAction.Request>{ first, second }
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

  private class BatchInputs {
    public List<ChronoWorkingTimeInput> adds = new List<ChronoWorkingTimeInput>();
    public List<ChronoDifferenceInput> differences = new List<ChronoDifferenceInput>();
    public List<ChronoCheckWorkingTimeInput> checks = new List<ChronoCheckWorkingTimeInput>();
    public List<ChronoFindWorkingTimeInput> finds = new List<ChronoFindWorkingTimeInput>();
  }
  private static OperatingHours savedSchedule() {
    OperatingHours saved = hours();
    insert saved;
    List<TimeSlot> savedSlots = slots();
    for (TimeSlot slot : savedSlots) {
      slot.OperatingHoursId = saved.Id;
    }
    insert savedSlots;
    return saved;
  }
  private static BatchInputs mixedInputs() {
    OperatingHours saved = savedSchedule();
    BatchInputs batch = new BatchInputs();
    for (Integer i = 0; i < 200; i++) {
      ChronoWorkingTimeInput add = addInput();
      ChronoDifferenceInput diff = difference(
        '2026-08-28T16:30',
        '2026-09-01T09:30'
      );
      ChronoCheckWorkingTimeInput check = new ChronoCheckWorkingTimeInput();
      check.valueType = 'PlainDate';
      check.value = '2026-08-31';
      ChronoFindWorkingTimeInput find = new ChronoFindWorkingTimeInput();
      find.valueType = 'PlainDate';
      find.value = check.value;
      find.direction = 'next';
      if (Math.mod(i, 2) == 0) {
        diff.operatingHours = hours();
        diff.timeSlots = slots();
        diff.holidays = holidays();
        check.operatingHours = hours();
        check.timeSlots = slots();
        check.holidays = holidays();
        find.operatingHours = hours();
        find.timeSlots = slots();
        find.holidays = holidays();
      } else {
        add.operatingHours = null;
        add.timeSlots = null;
        add.holidays = null;
        add.scheduleId = saved.Id;
        diff.operatingHoursId = saved.Id;
        check.operatingHoursId = saved.Id;
        find.operatingHoursId = saved.Id;
      }
      batch.adds.add(add);
      batch.differences.add(diff);
      batch.checks.add(check);
      batch.finds.add(find);
    }
    return batch;
  }
  private static void verifyMixed(
    Integer i,
    ChronoWorkingTimeResult added,
    ChronoDurationCalculationResult elapsed
  ) {
    Boolean nativeRecords = Math.mod(i, 2) == 0;
    Assert.isTrue(added.success, 'Add: ' + added.errorMessage);
    Assert.isTrue(elapsed.success, 'Difference: ' + elapsed.errorMessage);
    Assert.areEqual(
      nativeRecords
        ? Datetime.newInstanceGmt(2026, 9, 1, 8, 30, 0)
        : Datetime.newInstanceGmt(2026, 8, 31, 8, 30, 0),
      added.value.instant
    );
    Assert.areEqual(
      nativeRecords ? 3600000L : 9 * 3600000L,
      elapsed.value.milliseconds
    );
  }
  @IsTest
  static void mixedSavedAndNativeBatchesLoadOnce() {
    BatchInputs batch = mixedInputs();
    Test.startTest();
    List<ChronoWorkingTimeResult> added = ChronoWorkingTimeService.add(
      batch.adds
    );
    Assert.areEqual(3, Limits.getQueries());
    List<ChronoDurationCalculationResult> elapsed = ChronoCalculationService.difference(
      batch.differences
    );
    Assert.areEqual(6, Limits.getQueries());
    List<ChronoWorkingTimeCheckResult> checked = ChronoWorkingTimeService.check(
      batch.checks
    );
    Assert.areEqual(9, Limits.getQueries());
    List<ChronoValueResult> found = ChronoWorkingTimeService.find(batch.finds);
    Assert.areEqual(12, Limits.getQueries());
    Assert.areEqual(0, Limits.getDmlStatements());
    Test.stopTest();
    for (Integer i = 0; i < 200; i++) {
      Assert.isTrue(checked[i].success, 'Check: ' + checked[i].errorMessage);
      Assert.areEqual(Math.mod(i, 2) != 0, checked[i].isOpen);
      Assert.isTrue(found[i].success, 'Find: ' + found[i].errorMessage);
      Assert.areEqual(
        Math.mod(i, 2) == 0
          ? Date.newInstance(2026, 9, 1)
          : Date.newInstance(2026, 8, 31),
        found[i].value.plainDate.value
      );
      verifyMixed(i, added[i], elapsed[i]);
    }
  }
}
