// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoWorkingTimeTest {
  @IsTest
  static void closedWeekdaysStillValidateApplicableHolidays() {
    OperatingHours hours = new OperatingHours(TimeZone = 'Europe/London');
    List<TimeSlot> slots = new List<TimeSlot>{
      new TimeSlot(
        DayOfWeek = 'Monday',
        StartTime = Time.newInstance(9, 0, 0, 0),
        EndTime = Time.newInstance(17, 0, 0, 0)
      )
    };
    List<Holiday> holidays = new List<Holiday>{
      new Holiday(
        ActivityDate = Date.newInstance(2026, 8, 29),
        IsAllDay = false,
        StartTimeInMinutes = 660,
        EndTimeInMinutes = 600
      )
    };
    try {
      ChronoZonedDateTimeService.addHours(
        Datetime.newInstanceGmt(2026, 8, 28, 12, 0, 0),
        'Europe/London',
        1,
        hours,
        slots,
        holidays
      );
      Assert.fail('A closed Saturday must not conceal invalid holiday times.');
    } catch (ChronoException expected) {
      Assert.isTrue(
        expected.getMessage().contains('holiday'),
        'Holiday validation'
      );
    }
  }
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
    ChronoZonedDateTime friday = ChronoZonedDateTimeService.parseIso(
      '2026-08-28T16:30+01:00[Europe/London]'
    );
    String expected = '2026-09-01T09:30:00.000+01:00[Europe/London]';
    Assert.areEqual(
      expected,
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(friday, 1, schedule)
      ),
      'Skip weekend and Monday bank holiday'
    );
    Assert.areEqual(
      expected,
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(friday, 1, schedule)
      ),
      'Static Chrono input'
    );
    Assert.areEqual(
      expected,
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(
          ChronoZonedDateTimeService.toDatetime(friday),
          'Europe/London',
          1,
          schedule
        )
      ),
      'Static native input'
    );
    Assert.areEqual(
      ChronoZonedDateTimeService.toIsoString(friday),
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(
          ChronoZonedDateTimeService.parseIso(expected),
          -1,
          schedule
        )
      ),
      'Working subtraction crosses closures'
    );
    Assert.areEqual(
      ChronoZonedDateTimeService.toIsoString(friday),
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(friday, 0, schedule)
      ),
      'Zero is identity'
    );
    Assert.areEqual(
      '2026-08-28T16:30:00.000+01:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(friday),
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
    ChronoZonedDateTime start = ChronoZonedDateTimeService.parseIso(
      '2026-09-01T09:30+01:00[Europe/London]'
    );
    Assert.areEqual(
      '2026-09-01T11:30:00.000+01:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(start, 1, schedule)
      ),
      'Partial holiday skips 10-11'
    );
    ChronoZonedDateTime utc = ChronoZonedDateTimeService.withTimeZone(
      start,
      'UTC'
    );
    Assert.areEqual(
      '2026-09-01T10:30:00.000Z',
      ChronoInstantService.toIsoString(
        ChronoZonedDateTimeService.toInstant(
          ChronoZonedDateTimeService.addHours(utc, 1, schedule)
        )
      ),
      'Schedule zone controls availability'
    );
    Assert.areEqual(
      'UTC',
      ChronoZonedDateTimeService.getTimeZoneId(
        ChronoZonedDateTimeService.addHours(utc, 1, schedule)
      ),
      'Result retains source zone'
    );
    Assert.areEqual(
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(start, 1, schedule)
      ),
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addMinutes(start, 60, schedule)
      ),
      'Minutes equal hours'
    );
  }
  @IsTest
  static void closedStartAndBoundary() {
    OperatingHours schedule = weekdays();
    ChronoZonedDateTime morning = ChronoZonedDateTimeService.parseIso(
      '2026-08-28T08:00+01:00[Europe/London]'
    );
    Assert.areEqual(
      '2026-08-28T10:00:00.000+01:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(morning, 1, schedule)
      ),
      'Closed start advances to opening'
    );
    Assert.areEqual(
      '2026-08-28T17:00:00.000+01:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(morning, 8, schedule)
      ),
      'Eight open hours reach closing'
    );
    Assert.areEqual(
      '2026-09-01T10:00:00.000+01:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(morning, 9, schedule)
      ),
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
    ChronoZonedDateTime spring = ChronoZonedDateTimeService.parseIso(
      '2026-03-29T00:30Z[Europe/London]'
    );
    Assert.areEqual(
      '2026-03-29T03:30:00.000+01:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(spring, 2, schedule)
      ),
      'Spring forward consumes elapsed open time'
    );
    ChronoZonedDateTime autumn = ChronoZonedDateTimeService.parseIso(
      '2026-10-25T00:30+01:00[Europe/London]'
    );
    Assert.areEqual(
      '2026-10-25T02:30:00.000+00:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(autumn, 3, schedule)
      ),
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
    ChronoZonedDateTime start = ChronoZonedDateTimeService.parseIso(
      '2026-10-25T01:15+01:00[Europe/London]'
    );
    Assert.areEqual(
      '2026-10-25T01:20:00.000+00:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addMinutes(start, 20, schedule)
      ),
      'Skip the closed clock interval between repeated openings'
    );
    Assert.areEqual(
      ChronoZonedDateTimeService.toDatetime(start),
      ChronoZonedDateTimeService.toDatetime(
        ChronoZonedDateTimeService.addMinutes(
          ChronoZonedDateTimeService.addMinutes(start, 20, schedule),
          -20,
          schedule
        )
      ),
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
    ChronoZonedDateTime start = ChronoZonedDateTimeService.parseIso(
      '2026-03-29T00:00Z[Europe/London]'
    );
    Assert.areEqual(
      '2026-03-29T02:30:00.000+01:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addMinutes(start, 30, schedule)
      ),
      'Opening starts when clock jumps to 02:00; nonexistent minutes do not count'
    );
  }
  @IsTest
  static void differenceClipsMergesAndSubtractsHolidays() {
    ChronoWorkingTime schedule = new ChronoWorkingTime(
      new OperatingHours(TimeZone = 'Europe/London'),
      new List<TimeSlot>{
        new TimeSlot(
          DayOfWeek = 'Tuesday',
          StartTime = Time.newInstance(9, 0, 0, 0),
          EndTime = Time.newInstance(12, 0, 0, 0)
        ),
        new TimeSlot(
          DayOfWeek = 'Tuesday',
          StartTime = Time.newInstance(11, 0, 0, 0),
          EndTime = Time.newInstance(17, 0, 0, 0)
        )
      },
      new List<Holiday>{
        new Holiday(
          ActivityDate = Date.newInstance(2026, 9, 1),
          IsAllDay = false,
          StartTimeInMinutes = 600,
          EndTimeInMinutes = 660
        )
      }
    );
    Datetime start = Datetime.newInstanceGmt(2026, 9, 1, 8, 30, 0);
    Datetime finish = Datetime.newInstanceGmt(2026, 9, 1, 10, 30, 0);
    Assert.areEqual(
      3600000L,
      schedule.differenceMilliseconds(start, finish),
      'Subtract partial holiday in schedule zone'
    );
    Assert.areEqual(
      -3600000L,
      schedule.differenceMilliseconds(finish, start),
      'Signed result'
    );
    Assert.areEqual(
      0L,
      schedule.differenceMilliseconds(start, start),
      'Equal instants'
    );
    Assert.areEqual(
      25200000L,
      schedule.differenceMilliseconds(start.addHours(-2), finish.addHours(8)),
      'Seven hours; overlapping slots counted once'
    );
    Assert.areEqual(
      0L,
      schedule.differenceMilliseconds(start.addDays(1), finish.addDays(1)),
      'Entirely closed interval'
    );
    Assert.areEqual(
      1L,
      schedule.differenceMilliseconds(
        start,
        Datetime.newInstance(start.getTime() + 1)
      ),
      'Millisecond boundary'
    );
    try {
      schedule.differenceMilliseconds(start, start.addDays(3661));
      Assert.fail('Unbounded date range accepted');
    } catch (ChronoException expected) {
      Assert.isTrue(
        expected.getMessage().contains('3660'),
        'Bounded range diagnostic'
      );
    }
  }
  @IsTest
  static void differenceCountsOnlyRealDstWindows() {
    ChronoWorkingTime schedule = new ChronoWorkingTime(
      new OperatingHours(TimeZone = 'Europe/London'),
      new List<TimeSlot>{
        new TimeSlot(
          DayOfWeek = 'Sunday',
          StartTime = Time.newInstance(0, 0, 0, 0),
          EndTime = Time.newInstance(4, 0, 0, 0)
        )
      },
      null
    );
    Datetime spring = Datetime.newInstanceGmt(2026, 3, 29, 0, 0, 0);
    Datetime autumn = Datetime.newInstanceGmt(2026, 10, 24, 23, 0, 0);
    Assert.areEqual(
      10800000L,
      schedule.differenceMilliseconds(spring, spring.addHours(6)),
      'Spring opening has three real hours'
    );
    Assert.areEqual(
      18000000L,
      schedule.differenceMilliseconds(autumn, autumn.addHours(6)),
      'Autumn opening has five real hours'
    );
    ChronoWorkingTime narrow = new ChronoWorkingTime(
      new OperatingHours(TimeZone = 'Europe/London'),
      new List<TimeSlot>{
        new TimeSlot(
          DayOfWeek = 'Sunday',
          StartTime = Time.newInstance(1, 15, 0, 0),
          EndTime = Time.newInstance(1, 30, 0, 0)
        )
      },
      null
    );
    Assert.areEqual(
      1800000L,
      narrow.differenceMilliseconds(autumn, autumn.addHours(5)),
      'Both repeated fifteen-minute windows count; gap between stays closed'
    );
    Assert.areEqual(
      0L,
      narrow.differenceMilliseconds(spring, spring.addHours(5)),
      'Nonexistent spring window contributes nothing'
    );
  }
  @IsTest
  static void differenceIncludesDatesVisitedDuringMidnightRollback() {
    ChronoWorkingTime schedule = new ChronoWorkingTime(
      new OperatingHours(TimeZone = 'America/St_Johns'),
      new List<TimeSlot>{
        new TimeSlot(
          DayOfWeek = 'Sunday',
          StartTime = Time.newInstance(0, 0, 0, 0),
          EndTime = Time.newInstance(0, 1, 0, 0)
        )
      },
      null
    );
    // At 00:01 on 1 November 2009, the clock returned to 23:01 on 31 October.
    Datetime start = Datetime.newInstanceGmt(2009, 11, 1, 2, 30, 30);
    Datetime finish = Datetime.newInstanceGmt(2009, 11, 1, 3, 0, 0);
    Assert.areEqual(
      30000L,
      schedule.differenceMilliseconds(start, finish),
      'Count the open half-minute before returning to the previous date'
    );
    Assert.areEqual(
      60000L,
      schedule.differenceMilliseconds(start.addMinutes(-1), finish),
      'Count visited Sunday even when both endpoints are Saturday locally'
    );
  }
}
