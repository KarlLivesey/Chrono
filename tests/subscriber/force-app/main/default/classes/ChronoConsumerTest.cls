// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoConsumerTest {
  @TestSetup
  static void holidaySetup() {
    insert new Holiday(
      Name = 'Chrono subscriber bank holiday',
      ActivityDate = Date.newInstance(2026, 8, 31),
      IsAllDay = true
    );
  }
  @IsTest
  static void allValueTypesAccessibleOutsideNamespace() {
    skel.ChronoPlainDate day = new skel.ChronoPlainDate(
      Date.newInstance(2024, 2, 29)
    );
    skel.ChronoPlainTime clock = new skel.ChronoPlainTime(
      Time.newInstance(9, 30, 0, 123)
    );
    skel.ChronoPlainDateTime local = new skel.ChronoPlainDateTime(
      day.toDate(),
      clock.toTime()
    );
    skel.ChronoZonedDateTime zoned = local.toZonedDateTime('Europe/London');
    skel.ChronoInstant instant = new skel.ChronoInstant(zoned.toDatetime());
    skel.ChronoPlainYearMonth month = new skel.ChronoPlainYearMonth(2024, 2);
    skel.ChronoPlainMonthDay annual = new skel.ChronoPlainMonthDay(2, 29);
    skel.ChronoDuration duration = new skel.ChronoDuration(0, 0, 3600000L);
    Assert.areEqual(
      '2024-02-29',
      day.toString(),
      'Global constructor and override'
    );
    Assert.areEqual('09:30:00.123', clock.toString(), 'Global native time');
    Assert.areEqual(
      zoned.addHours(1).toString(),
      skel.ChronoZonedDateTime.addHours(zoned, 1).toString(),
      'Instance/static equivalence across namespace'
    );
    Assert.areEqual(
      zoned.addHours(1).toString(),
      skel.ChronoZonedDateTime.addHours(zoned.toDatetime(), 'Europe/London', 1)
        .toString(),
      'Native static overload across namespace'
    );
    Assert.areEqual(
      zoned.addHours(1).toString(),
      zoned.add(duration).toString(),
      'Global duration signature'
    );
    Assert.areEqual(
      '2024-02-29T09:30:00.123Z',
      instant.toString(),
      'Global instant'
    );
    Assert.areEqual('2024-02', month.toString(), 'Year-month');
    Assert.areEqual('--02-29', annual.toString(), 'Month-day');
    Assert.areEqual(
      zoned.toDatetime(),
      skel.ChronoZonedDateTime.parse(zoned.toString()).toDatetime(),
      'Global parser'
    );
    try {
      local.toZonedDateTime('invalid/zone');
      Assert.fail('Invalid zone accepted');
    } catch (skel.ChronoException expected) {
      Assert.isTrue(
        expected.getMessage().contains('Unknown'),
        'Subscriber can catch global exception'
      );
    }
  }
  @IsTest
  static void standardOperatingHoursAndHolidaysAcrossNamespace() {
    System.runAs(new User(Id = UserInfo.getUserId())) {
      OperatingHours schedule = new OperatingHours(
        Name = 'Subscriber weekdays',
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
            StartTime = Time.newInstance(9, 0, 0, 0),
            EndTime = Time.newInstance(17, 0, 0, 0),
            Type = 'Normal'
          )
        );
      }
      insert slots;
      Holiday bank = [
        SELECT Id
        FROM Holiday
        WHERE Name = 'Chrono subscriber bank holiday'
      ];
      insert new OperatingHoursHoliday(
        OperatingHoursId = schedule.Id,
        HolidayId = bank.Id
      );
      skel.ChronoZonedDateTime friday = skel.ChronoZonedDateTime.parse(
        '2026-08-28T16:30+01:00[Europe/London]'
      );
      String expected = '2026-09-01T09:30:00.000+01:00[Europe/London]';
      Assert.areEqual(
        expected,
        friday.addHours(1, schedule).toString(),
        'Packaged instance skips weekend and bank holiday'
      );
      Assert.areEqual(
        expected,
        skel.ChronoZonedDateTime.addHours(friday, 1, schedule).toString(),
        'Packaged static accepts standard object'
      );
      Assert.areEqual(
        expected,
        skel.ChronoZonedDateTime.addHours(
            friday.toDatetime(),
            'Europe/London',
            1,
            schedule
          )
          .toString(),
        'Native overload accepts standard object'
      );
      Assert.areEqual(
        friday.toDatetime(),
        friday.addHours(1, schedule).addHours(-1, schedule).toDatetime(),
        'Reverse working time'
      );
    }
  }
  @IsTest
  static void nativeBusinessHoursAcrossNamespace() {
    BusinessHours schedule = [
      SELECT Id
      FROM BusinessHours
      WHERE IsDefault = TRUE
      LIMIT 1
    ];
    skel.ChronoZonedDateTime start = new skel.ChronoZonedDateTime(
      Datetime.newInstanceGmt(2026, 8, 28, 15, 30, 0),
      'Europe/London'
    );
    Assert.areEqual(
      System.BusinessHours.addGmt(schedule.Id, start.toDatetime(), 3600000L),
      skel.ChronoZonedDateTime.addHours(start, 1, schedule).toDatetime(),
      'Native BusinessHours overload available across namespace'
    );
  }

  @IsTest
  static void invalidDatesRemainInvalidAcrossNamespace() {
    try {
      skel.ChronoPlainDate.parse('2026-02-31');
      Assert.fail('Invalid date rolled forward');
    } catch (skel.ChronoException expected) {
      Assert.isTrue(
        expected.getMessage().contains('Invalid'),
        'Subscriber receives validation error'
      );
    }
    try {
      skel.ChronoPlainMonthDay.parse('--02-29').toPlainDate(2026);
      Assert.fail('Leap date rolled forward');
    } catch (skel.ChronoException expected) {
      Assert.isNotNull(expected.getMessage(), 'Invalid completion is rejected');
    }
  }
}
