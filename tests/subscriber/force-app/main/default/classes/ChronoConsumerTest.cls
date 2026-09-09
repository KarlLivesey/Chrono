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
    skel.ChronoPlainDate day = skel.ChronoPlainDateService.create(
      Date.newInstance(2024, 2, 29)
    );
    skel.ChronoPlainTime clock = skel.ChronoPlainTimeService.create(
      Time.newInstance(9, 30, 0, 123)
    );
    skel.ChronoPlainDateTime local = skel.ChronoPlainDateTimeService.create(
      skel.ChronoPlainDateService.toDate(day),
      skel.ChronoPlainTimeService.toTime(clock)
    );
    skel.ChronoZonedDateTime zoned = skel.ChronoPlainDateTimeService.toZonedDateTime(
      local,
      'Europe/London'
    );
    skel.ChronoInstant instant = skel.ChronoInstantService.create(
      skel.ChronoZonedDateTimeService.toDatetime(zoned)
    );
    skel.ChronoPlainYearMonth month = skel.ChronoPlainYearMonthService.create(
      2024,
      2
    );
    skel.ChronoPlainMonthDay annual = skel.ChronoPlainMonthDayService.create(
      2,
      29
    );
    skel.ChronoDuration duration = skel.ChronoDurationService.create(
      0,
      0,
      3600000L
    );
    Assert.areEqual(
      '2024-02-29',
      skel.ChronoPlainDateService.toIsoString(day),
      'Global date service'
    );
    Assert.areEqual(
      '09:30:00.123',
      skel.ChronoPlainTimeService.toIsoString(clock),
      'Global native time'
    );
    Assert.areEqual(
      '2024-02-29T10:30:00.123+00:00[Europe/London]',
      skel.ChronoZonedDateTimeService.toIsoString(
        skel.ChronoZonedDateTimeService.addHours(zoned, 1)
      ),
      'Source-first service arithmetic across namespace'
    );
    Assert.areEqual(
      skel.ChronoZonedDateTimeService.toIsoString(
        skel.ChronoZonedDateTimeService.addHours(zoned, 1)
      ),
      skel.ChronoZonedDateTimeService.toIsoString(
        skel.ChronoZonedDateTimeService.addHours(
          skel.ChronoZonedDateTimeService.toDatetime(zoned),
          'Europe/London',
          1
        )
      ),
      'Native static overload across namespace'
    );
    Assert.areEqual(
      skel.ChronoZonedDateTimeService.toIsoString(
        skel.ChronoZonedDateTimeService.addHours(zoned, 1)
      ),
      skel.ChronoZonedDateTimeService.toIsoString(
        skel.ChronoZonedDateTimeService.add(zoned, duration)
      ),
      'Global duration signature'
    );
    Assert.areEqual(
      '2024-02-29T09:30:00.123Z',
      skel.ChronoInstantService.toIsoString(instant),
      'Global instant'
    );
    Assert.areEqual(
      '2024-02',
      skel.ChronoPlainYearMonthService.toIsoString(month),
      'Year-month'
    );
    Assert.areEqual(
      '--02-29',
      skel.ChronoPlainMonthDayService.toIsoString(annual),
      'Month-day'
    );
    Assert.areEqual(
      skel.ChronoZonedDateTimeService.toDatetime(zoned),
      skel.ChronoZonedDateTimeService.toDatetime(
        skel.ChronoZonedDateTimeService.parseIso(
          skel.ChronoZonedDateTimeService.toIsoString(zoned)
        )
      ),
      'Global parser'
    );
    try {
      skel.ChronoPlainDateTimeService.toZonedDateTime(local, 'invalid/zone');
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
      skel.ChronoZonedDateTime friday = skel.ChronoZonedDateTimeService.parseIso(
        '2026-08-28T16:30+01:00[Europe/London]'
      );
      String expected = '2026-09-01T09:30:00.000+01:00[Europe/London]';
      Assert.areEqual(
        expected,
        skel.ChronoZonedDateTimeService.toIsoString(
          skel.ChronoZonedDateTimeService.addHours(friday, 1, schedule)
        ),
        'Packaged instance skips weekend and bank holiday'
      );
      Assert.areEqual(
        expected,
        skel.ChronoZonedDateTimeService.toIsoString(
          skel.ChronoZonedDateTimeService.addHours(friday, 1, schedule)
        ),
        'Packaged static accepts standard object'
      );
      Assert.areEqual(
        expected,
        skel.ChronoZonedDateTimeService.toIsoString(
          skel.ChronoZonedDateTimeService.addHours(
            skel.ChronoZonedDateTimeService.toDatetime(friday),
            'Europe/London',
            1,
            schedule
          )
        ),
        'Native overload accepts standard object'
      );
      Assert.areEqual(
        skel.ChronoZonedDateTimeService.toDatetime(friday),
        skel.ChronoZonedDateTimeService.toDatetime(
          skel.ChronoZonedDateTimeService.addHours(
            skel.ChronoZonedDateTimeService.addHours(friday, 1, schedule),
            -1,
            schedule
          )
        ),
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
    skel.ChronoZonedDateTime start = skel.ChronoZonedDateTimeService.create(
      Datetime.newInstanceGmt(2026, 8, 28, 15, 30, 0),
      'Europe/London'
    );
    Assert.areEqual(
      System.BusinessHours.addGmt(
        schedule.Id,
        skel.ChronoZonedDateTimeService.toDatetime(start),
        3600000L
      ),
      skel.ChronoZonedDateTimeService.toDatetime(
        skel.ChronoZonedDateTimeService.addHours(start, 1, schedule)
      ),
      'Native BusinessHours overload available across namespace'
    );
  }

  @IsTest
  static void invalidDatesRemainInvalidAcrossNamespace() {
    try {
      skel.ChronoPlainDateService.parseIso('2026-02-31');
      Assert.fail('Invalid date rolled forward');
    } catch (skel.ChronoException expected) {
      Assert.isTrue(
        expected.getMessage().contains('Invalid'),
        'Subscriber receives validation error'
      );
    }
    try {
      skel.ChronoPlainMonthDayService.toPlainDate(
        skel.ChronoPlainMonthDayService.parseIso('--02-29'),
        2026
      );
      Assert.fail('Leap date rolled forward');
    } catch (skel.ChronoException expected) {
      Assert.isNotNull(expected.getMessage(), 'Invalid completion is rejected');
    }
  }
}
