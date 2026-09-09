// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoBusinessHoursTest {
  @IsTest
  static void usesNativeBusinessHoursBehaviour() {
    BusinessHours schedule = [
      SELECT Id
      FROM BusinessHours
      WHERE IsDefault = TRUE
      LIMIT 1
    ];
    ChronoZonedDateTime start = ChronoInstantService.toZonedDateTime(
      ChronoInstantService.parseIso('2026-08-28T15:30Z'),
      'Europe/London'
    );
    Datetime expected = System.BusinessHours.addGmt(
      schedule.Id,
      ChronoZonedDateTimeService.toDatetime(start),
      3600000L
    );
    Assert.areEqual(
      expected,
      ChronoZonedDateTimeService.toDatetime(
        ChronoZonedDateTimeService.addHours(start, 1, schedule)
      ),
      'Native business hours delegation'
    );
    Assert.areEqual(
      expected,
      ChronoZonedDateTimeService.toDatetime(
        ChronoZonedDateTimeService.addHours(start, 1, schedule)
      ),
      'Static business hours'
    );
    Assert.areEqual(
      expected,
      ChronoZonedDateTimeService.toDatetime(
        ChronoZonedDateTimeService.addHours(
          ChronoZonedDateTimeService.toDatetime(start),
          'Europe/London',
          1,
          schedule
        )
      ),
      'Native static business hours'
    );
    Assert.areEqual(
      expected,
      ChronoZonedDateTimeService.toDatetime(
        ChronoZonedDateTimeService.addMinutes(start, 60, schedule)
      ),
      'Business minutes'
    );
    Assert.areEqual(
      expected,
      ChronoZonedDateTimeService.toDatetime(
        ChronoZonedDateTimeService.addMinutes(start, 60, schedule)
      ),
      'Static business minutes'
    );
    Assert.areEqual(
      expected,
      ChronoZonedDateTimeService.toDatetime(
        ChronoZonedDateTimeService.addMinutes(
          ChronoZonedDateTimeService.toDatetime(start),
          'Europe/London',
          60,
          schedule
        )
      ),
      'Native static business minutes'
    );
  }
}
