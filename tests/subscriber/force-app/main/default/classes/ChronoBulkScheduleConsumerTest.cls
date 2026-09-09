// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
// Exact package query budgets are asserted by the corresponding in-package tests.
// Subscriber Limits counters do not include the skel namespace.
@IsTest
private class ChronoBulkScheduleConsumerTest {
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
  private static skel.ChronoDifferenceInput difference(Id scheduleId) {
    skel.ChronoDifferenceInput item = new skel.ChronoDifferenceInput();
    item.operatingHoursId = scheduleId;
    item.startValue = '2026-08-28T16:30+01:00[Europe/London]';
    item.endValue = '2026-09-01T09:30+01:00[Europe/London]';
    return item;
  }

  private static skel.ChronoFindWorkingTimeInput findRequest(
    skel.ChronoCheckWorkingTimeInput check
  ) {
    skel.ChronoFindWorkingTimeInput find = new skel.ChronoFindWorkingTimeInput();
    find.valueType = check.valueType;
    find.value = check.value;
    find.operatingHoursId = check.operatingHoursId;
    find.direction = 'next';
    return find;
  }
  @IsTest
  static void directDifferenceLoadsAllSchedulesOnce() {
    List<OperatingHours> hours = schedules();
    List<skel.ChronoDifferenceInput> inputs = new List<skel.ChronoDifferenceInput>();
    for (Integer i = 0; i < 200; i++) {
      inputs.add(difference(hours[Math.mod(i, 2)].Id));
    }
    inputs.add(null);
    Test.startTest();
    List<skel.ChronoDurationCalculationResult> rows = skel.ChronoCalculationService.difference(
      inputs
    );
    Test.stopTest();
    Assert.areEqual(201, rows.size());
    for (Integer i = 0; i < 200; i++) {
      Assert.isTrue(
        rows[i].success,
        'Expected success: ' + rows[i].errorMessage
      );
      Assert.areEqual(
        Math.mod(i, 2) == 0 ? 3600000L : 5400000L,
        rows[i].value.milliseconds
      );
    }
    Assert.isFalse(rows[200].success);
    rows[0].value.milliseconds = 0;
    Assert.areEqual(3600000L, rows[2].value.milliseconds);
  }
  @IsTest
  static void directCalendarServicesBatchSavedSchedules() {
    List<OperatingHours> hours = schedules();
    List<skel.ChronoCheckWorkingTimeInput> checks = new List<skel.ChronoCheckWorkingTimeInput>();
    List<skel.ChronoFindWorkingTimeInput> finds = new List<skel.ChronoFindWorkingTimeInput>();
    List<skel.ChronoWorkingDaysInput> days = new List<skel.ChronoWorkingDaysInput>();
    for (Integer i = 0; i < 200; i++) {
      String scheduleId = hours[Math.mod(i, 2)].Id;
      skel.ChronoCheckWorkingTimeInput check = new skel.ChronoCheckWorkingTimeInput();
      check.valueType = 'ZonedDateTime';
      check.value = '2026-08-31T10:00+01:00[Europe/London]';
      check.operatingHoursId = scheduleId;
      checks.add(check);
      finds.add(findRequest(check));
      days.add(workingDayRequest(scheduleId));
    }
    checks.add(null);
    finds.add(null);
    days.add(null);
    Test.startTest();
    List<skel.ChronoWorkingTimeCheckResult> checked = skel.ChronoWorkingTimeService.check(
      checks
    );
    List<skel.ChronoValueResult> found = skel.ChronoWorkingTimeService.find(
      finds
    );
    List<skel.ChronoValueResult> added = skel.ChronoWorkingTimeService.addDays(
      days
    );
    Test.stopTest();
    for (Integer i = 0; i < 200; i++) {
      Assert.isTrue(
        checked[i].success,
        'Expected success: ' + checked[i].errorMessage
      );
      Assert.isFalse(checked[i].isOpen);
      Assert.isTrue(
        found[i].success,
        'Expected success: ' + found[i].errorMessage
      );
      Assert.areEqual(
        Datetime.newInstanceGmt(2026, 9, 1, Math.mod(i, 2) == 0 ? 8 : 9, 0, 0),
        found[i].value.zonedDateTime.instant
      );
      Assert.isTrue(
        added[i].success,
        'Expected success: ' + added[i].errorMessage
      );
      Assert.areEqual(
        Date.newInstance(2026, 9, 1),
        added[i].value.plainDate.value
      );
    }
    Assert.isFalse(checked[200].success);
    Assert.isFalse(found[200].success);
    Assert.isFalse(added[200].success);
  }
  @IsTest
  static void directAvailabilityAndRecurrenceShareScheduleLoads() {
    List<OperatingHours> hours = schedules();
    List<skel.ChronoAvailabilityInput> windows = new List<skel.ChronoAvailabilityInput>();
    List<skel.ChronoRecurrenceInput> recurrences = new List<skel.ChronoRecurrenceInput>();
    for (Integer i = 0; i < 200; i++) {
      String scheduleId = hours[Math.mod(i, 2)].Id;
      skel.ChronoAvailabilityInput window = new skel.ChronoAvailabilityInput();
      window.operation = 'windows';
      window.valueType = 'Instant';
      window.timeZoneId = 'Europe/London';
      window.value = '2026-09-01T08:00Z';
      window.endValue = '2026-09-01T10:00Z';
      window.operatingHoursId = scheduleId;
      windows.add(window);
      skel.ChronoRecurrenceInput recurrence = new skel.ChronoRecurrenceInput();
      recurrence.operation = 'nthWorkingDay';
      recurrence.valueType = 'PlainDate';
      recurrence.value = '2026-08-01';
      recurrence.ordinal = -1;
      recurrence.operatingHoursId = scheduleId;
      recurrences.add(recurrence);
    }
    windows.add(null);
    recurrences.add(null);
    Test.startTest();
    List<skel.ChronoAvailabilityResult> available = skel.ChronoAvailabilityService.evaluate(
      windows
    );
    List<skel.ChronoRecurrenceResult> recurring = skel.ChronoRecurrenceService.generate(
      recurrences
    );
    Test.stopTest();
    for (Integer i = 0; i < 200; i++) {
      Assert.isTrue(
        available[i].success,
        'Expected success: ' + available[i].errorMessage
      );
      Assert.areEqual(
        Math.mod(i, 2) == 0 ? 7200000L : 3600000L,
        available[i].milliseconds
      );
      Assert.isTrue(
        recurring[i].success,
        'Expected success: ' + recurring[i].errorMessage
      );
      Assert.areEqual('2026-08-28', recurring[i].value);
    }
    Assert.isFalse(available[200].success);
    Assert.isFalse(recurring[200].success);
    available[0].ranges.clear();
    Assert.areEqual(1, available[2].ranges.size());
  }
  private static skel.ChronoWorkingDaysInput workingDayRequest(
    String scheduleId
  ) {
    skel.ChronoWorkingDaysInput day = new skel.ChronoWorkingDaysInput();
    day.valueType = 'PlainDate';
    day.value = '2026-08-28';
    day.operatingHoursId = scheduleId;
    day.amount = 1;
    return day;
  }
}
