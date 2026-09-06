// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoWorkingTimeTest {
  @TestSetup
  static void holidaySetup() {
    insert new Holiday(
      Name = 'Chrono bank holiday',
      ActivityDate = Date.newInstance(2026, 8, 31),
      IsAllDay = true
    );
    insert new Holiday(
      Name = 'Chrono partial',
      ActivityDate = Date.newInstance(2026, 9, 1),
      IsAllDay = false,
      StartTimeInMinutes = 600,
      EndTimeInMinutes = 660
    );
  }
  private static OperatingHours weekdays() {
    OperatingHours schedule = new OperatingHours(
      Name = 'Chrono weekdays',
      TimeZone = 'Europe/London'
    );
    insert schedule;
    List<TimeSlot> slots = new List<TimeSlot>();
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
    insert slots;
    Holiday bank = [SELECT Id FROM Holiday WHERE Name = 'Chrono bank holiday'];
    insert new OperatingHoursHoliday(
      OperatingHoursId = schedule.Id,
      HolidayId = bank.Id
    );
    return schedule;
  }
  @IsTest
  static void fridayToTuesdayAndBackBothCallStyles() {
    OperatingHours schedule = weekdays();
    ChronoZonedDateTime friday = ChronoZonedDateTime.parse(
      '2026-08-28T16:30+01:00[Europe/London]'
    );
    String expected = '2026-09-01T09:30:00.000+01:00[Europe/London]';
    Assert.areEqual(
      expected,
      friday.addHours(1, schedule).toString(),
      'Skip weekend and Monday bank holiday'
    );
    Assert.areEqual(
      expected,
      ChronoZonedDateTime.addHours(friday, 1, schedule).toString(),
      'Static Chrono input'
    );
    Assert.areEqual(
      expected,
      ChronoZonedDateTime.addHours(
          friday.toDatetime(),
          'Europe/London',
          1,
          schedule
        )
        .toString(),
      'Static native input'
    );
    Assert.areEqual(
      friday.toString(),
      ChronoZonedDateTime.parse(expected).addHours(-1, schedule).toString(),
      'Working subtraction crosses closures'
    );
    Assert.areEqual(
      friday.toString(),
      friday.addHours(0, schedule).toString(),
      'Zero is identity'
    );
    Assert.areEqual(
      '2026-08-28T16:30:00.000+01:00[Europe/London]',
      friday.toString(),
      'Source remains unchanged'
    );
  }
  @IsTest
  static void partialHolidayAndScheduleZone() {
    OperatingHours schedule = weekdays();
    Holiday partial = [SELECT Id FROM Holiday WHERE Name = 'Chrono partial'];
    insert new OperatingHoursHoliday(
      OperatingHoursId = schedule.Id,
      HolidayId = partial.Id
    );
    ChronoZonedDateTime start = ChronoZonedDateTime.parse(
      '2026-09-01T09:30+01:00[Europe/London]'
    );
    Assert.areEqual(
      '2026-09-01T11:30:00.000+01:00[Europe/London]',
      start.addHours(1, schedule).toString(),
      'Partial holiday skips 10-11'
    );
    ChronoZonedDateTime utc = start.withTimeZone('UTC');
    Assert.areEqual(
      '2026-09-01T10:30:00.000Z',
      utc.addHours(1, schedule).toInstant().toString(),
      'Schedule zone controls availability'
    );
    Assert.areEqual(
      'UTC',
      utc.addHours(1, schedule).getTimeZoneId(),
      'Result retains source zone'
    );
    Assert.areEqual(
      start.addHours(1, schedule).toString(),
      ChronoZonedDateTime.addMinutes(start, 60, schedule).toString(),
      'Minutes equal hours'
    );
  }
  @IsTest
  static void closedStartAndBoundary() {
    OperatingHours schedule = weekdays();
    ChronoZonedDateTime morning = ChronoZonedDateTime.parse(
      '2026-08-28T08:00+01:00[Europe/London]'
    );
    Assert.areEqual(
      '2026-08-28T10:00:00.000+01:00[Europe/London]',
      morning.addHours(1, schedule).toString(),
      'Closed start advances to opening'
    );
    Assert.areEqual(
      '2026-08-28T17:00:00.000+01:00[Europe/London]',
      morning.addHours(8, schedule).toString(),
      'Eight open hours reach closing'
    );
    Assert.areEqual(
      '2026-09-01T10:00:00.000+01:00[Europe/London]',
      morning.addHours(9, schedule).toString(),
      'Exact closing continues next opening'
    );
  }
  @IsTest
  static void elapsedWorkingTimeAcrossDst() {
    OperatingHours schedule = new OperatingHours(
      Name = 'Chrono overnight',
      TimeZone = 'Europe/London'
    );
    insert schedule;
    insert new TimeSlot(
      OperatingHoursId = schedule.Id,
      DayOfWeek = 'Sunday',
      Type = 'Normal',
      StartTime = Time.newInstance(0, 0, 0, 0),
      EndTime = Time.newInstance(4, 0, 0, 0)
    );
    ChronoZonedDateTime spring = ChronoZonedDateTime.parse(
      '2026-03-29T00:30Z[Europe/London]'
    );
    Assert.areEqual(
      '2026-03-29T03:30:00.000+01:00[Europe/London]',
      spring.addHours(2, schedule).toString(),
      'Spring forward consumes elapsed open time'
    );
    ChronoZonedDateTime autumn = ChronoZonedDateTime.parse(
      '2026-10-25T00:30+01:00[Europe/London]'
    );
    Assert.areEqual(
      '2026-10-25T02:30:00.000+00:00[Europe/London]',
      autumn.addHours(3, schedule).toString(),
      'Autumn repeats an hour of open time'
    );
  }
  @IsTest
  static void rejectsMissingAndEmptySchedule() {
    OperatingHours schedule = new OperatingHours(
      Name = 'Chrono empty',
      TimeZone = 'GMT'
    );
    insert schedule;
    try {
      new ChronoWorkingTime(schedule);
      Assert.fail('Empty schedule accepted');
    } catch (ChronoException expected) {
      Assert.isTrue(
        expected.getMessage().contains('no normal'),
        'Clear empty schedule error'
      );
    }
    try {
      new ChronoWorkingTime(new OperatingHours());
      Assert.fail('Unsaved schedule accepted');
    } catch (ChronoException expected) {
      Assert.isTrue(expected.getMessage().contains('ID'), 'Saved ID required');
    }
  }

  @IsTest
  static void repeatedNarrowWindowsDoNotCountClosedTime() {
    OperatingHours schedule = new OperatingHours(
      Name = 'Chrono short window',
      TimeZone = 'Europe/London'
    );
    insert schedule;
    insert new TimeSlot(
      OperatingHoursId = schedule.Id,
      DayOfWeek = 'Sunday',
      Type = 'Normal',
      StartTime = Time.newInstance(1, 15, 0, 0),
      EndTime = Time.newInstance(1, 30, 0, 0)
    );
    ChronoZonedDateTime start = ChronoZonedDateTime.parse(
      '2026-10-25T01:15+01:00[Europe/London]'
    );
    Assert.areEqual(
      '2026-10-25T01:20:00.000+00:00[Europe/London]',
      start.addMinutes(20, schedule).toString(),
      'Skip the closed clock interval between repeated openings'
    );
    Assert.areEqual(
      start.toDatetime(),
      start.addMinutes(20, schedule).addMinutes(-20, schedule).toDatetime(),
      'Reverse through separate repeated windows'
    );
  }
  @IsTest
  static void gapWindowOnlyCountsRealOpeningTime() {
    OperatingHours schedule = new OperatingHours(
      Name = 'Chrono spring window',
      TimeZone = 'Europe/London'
    );
    insert schedule;
    insert new TimeSlot(
      OperatingHoursId = schedule.Id,
      DayOfWeek = 'Sunday',
      Type = 'Normal',
      StartTime = Time.newInstance(1, 30, 0, 0),
      EndTime = Time.newInstance(3, 0, 0, 0)
    );
    ChronoZonedDateTime start = ChronoZonedDateTime.parse(
      '2026-03-29T00:00Z[Europe/London]'
    );
    Assert.areEqual(
      '2026-03-29T02:30:00.000+01:00[Europe/London]',
      start.addMinutes(30, schedule).toString(),
      'Opening starts when clock jumps to 02:00; nonexistent minutes do not count'
    );
  }
}
