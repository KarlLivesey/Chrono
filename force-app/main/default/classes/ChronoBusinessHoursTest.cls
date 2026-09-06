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
    ChronoZonedDateTime start = ChronoInstant.parse('2026-08-28T15:30Z')
      .toZonedDateTime('Europe/London');
    Datetime expected = System.BusinessHours.addGmt(
      schedule.Id,
      start.toDatetime(),
      3600000L
    );
    Assert.areEqual(
      expected,
      start.addHours(1, schedule).toDatetime(),
      'Native business hours delegation'
    );
    Assert.areEqual(
      expected,
      ChronoZonedDateTime.addHours(start, 1, schedule).toDatetime(),
      'Static business hours'
    );
    Assert.areEqual(
      expected,
      ChronoZonedDateTime.addHours(
          start.toDatetime(),
          'Europe/London',
          1,
          schedule
        )
        .toDatetime(),
      'Native static business hours'
    );
    Assert.areEqual(
      expected,
      start.addMinutes(60, schedule).toDatetime(),
      'Business minutes'
    );
    Assert.areEqual(
      expected,
      ChronoZonedDateTime.addMinutes(start, 60, schedule).toDatetime(),
      'Static business minutes'
    );
    Assert.areEqual(
      expected,
      ChronoZonedDateTime.addMinutes(
          start.toDatetime(),
          'Europe/London',
          60,
          schedule
        )
        .toDatetime(),
      'Native static business minutes'
    );
  }
}
