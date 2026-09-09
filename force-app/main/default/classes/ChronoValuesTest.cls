// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoValuesTest {
  @IsTest
  static void nativeAndIsoRoundTrips() {
    ChronoPlainDate day = ChronoPlainDateService.parseIso('2024-02-29');
    Assert.areEqual(
      Date.newInstance(2024, 2, 29),
      ChronoPlainDateService.toDate(day),
      'Native date'
    );
    Assert.areEqual(
      '2024-02-29',
      ChronoPlainDateService.toIsoString(day),
      'ISO date'
    );
    ChronoPlainTime clock = ChronoPlainTimeService.parseIso('23:59:59.123');
    Assert.areEqual(
      Time.newInstance(23, 59, 59, 123),
      ChronoPlainTimeService.toTime(clock),
      'Native time'
    );
    Assert.areEqual(
      '23:59:59.123',
      ChronoPlainTimeService.toIsoString(clock),
      'ISO time'
    );
    ChronoPlainDateTime local = ChronoPlainDateService.toPlainDateTime(
      day,
      ChronoPlainTimeService.toTime(clock)
    );
    Assert.areEqual(
      '2024-02-29T23:59:59.123',
      ChronoPlainDateTimeService.toIsoString(local),
      'Local datetime'
    );
    Assert.areEqual(
      ChronoPlainDateTimeService.toIsoString(local),
      ChronoPlainDateTimeService.toIsoString(
        ChronoPlainDateTimeService.parseIso(
          ChronoPlainDateTimeService.toIsoString(local)
        )
      ),
      'Local round trip'
    );
    ChronoInstant instant = ChronoInstantService.parseIso(
      '2024-03-01T05:29:59.123+05:30'
    );
    Assert.areEqual(
      '2024-02-29T23:59:59.123Z',
      ChronoInstantService.toIsoString(instant),
      'Offset conversion'
    );
    Assert.areEqual(
      123,
      ChronoInstantService.toDatetime(instant).millisecondGmt(),
      'Millisecond preservation'
    );
    Assert.areEqual(
      ChronoInstantService.toIsoString(instant),
      ChronoInstantService.toIsoString(
        ChronoInstantService.parseIso(ChronoInstantService.toIsoString(instant))
      ),
      'Instant round trip'
    );
    ChronoZonedDateTime zoned = ChronoInstantService.toZonedDateTime(
      instant,
      'Asia/Tokyo'
    );
    Assert.areEqual(
      '2024-03-01T08:59:59.123+09:00[Asia/Tokyo]',
      ChronoZonedDateTimeService.toIsoString(zoned),
      'Zoned output'
    );
    Assert.areEqual(
      ChronoInstantService.toDatetime(instant),
      ChronoZonedDateTimeService.toDatetime(
        ChronoZonedDateTimeService.parseIso(
          ChronoZonedDateTimeService.toIsoString(zoned)
        )
      ),
      'Zoned round trip'
    );
  }
  @IsTest
  static void partialDatesAndMonthArithmetic() {
    ChronoPlainDate day = ChronoPlainDateService.parseIso('2024-01-31');
    Assert.areEqual(
      '2024-02-29',
      ChronoPlainDateService.toIsoString(
        ChronoPlainDateService.addMonths(day, 1)
      ),
      'Leap month clamps'
    );
    Assert.areEqual(
      '2024-02-29',
      ChronoPlainDateService.toIsoString(
        ChronoPlainDateService.addMonths(day, 1)
      ),
      'Static matches instance'
    );
    Assert.areEqual(
      '2024-02-29',
      ChronoPlainDateService.toIsoString(
        ChronoPlainDateService.addMonths(ChronoPlainDateService.toDate(day), 1)
      ),
      'Native static'
    );
    Assert.areEqual(
      '2024-01-31',
      ChronoPlainDateService.toIsoString(day),
      'Immutable input'
    );
    Assert.areEqual(
      '2025-02-28',
      ChronoPlainDateService.toIsoString(
        ChronoPlainDateService.addYears(
          ChronoPlainDateService.parseIso('2024-02-29'),
          1
        )
      ),
      'Leap year clamp'
    );
    ChronoPlainYearMonth month = ChronoPlainYearMonthService.parseIso(
      '2024-12'
    );
    Assert.areEqual(
      '2025-01',
      ChronoPlainYearMonthService.toIsoString(
        ChronoPlainYearMonthService.addMonths(month, 1)
      ),
      'Year rollover'
    );
    Assert.areEqual(
      '2024-12-15',
      ChronoPlainDateService.toIsoString(
        ChronoPlainYearMonthService.toPlainDate(month, 15)
      ),
      'Complete year-month'
    );
    ChronoPlainMonthDay annual = ChronoPlainMonthDayService.parseIso('--02-29');
    Assert.areEqual(
      '--02-29',
      ChronoPlainMonthDayService.toIsoString(annual),
      'Annual leap date retained'
    );
    Assert.areEqual(
      '2024-02-29',
      ChronoPlainDateService.toIsoString(
        ChronoPlainMonthDayService.toPlainDate(annual, 2024)
      ),
      'Complete month-day'
    );
    Assert.areEqual(
      '2024-01',
      ChronoPlainYearMonthService.toIsoString(
        ChronoPlainDateService.toPlainYearMonth(day)
      ),
      'Extract year-month'
    );
    Assert.areEqual(
      '--01-31',
      ChronoPlainMonthDayService.toIsoString(
        ChronoPlainDateService.toPlainMonthDay(day)
      ),
      'Extract month-day'
    );
  }
  @IsTest
  static void arithmeticCarriesAndBothCallStyles() {
    ChronoPlainTime timeValue = ChronoPlainTimeService.parseIso('23:30');
    Assert.areEqual(
      '00:30:00.000',
      ChronoPlainTimeService.toIsoString(
        ChronoPlainTimeService.addHours(timeValue, 1)
      ),
      'Wrap midnight'
    );
    Assert.areEqual(
      ChronoPlainTimeService.toIsoString(
        ChronoPlainTimeService.addHours(timeValue, 1)
      ),
      ChronoPlainTimeService.toIsoString(
        ChronoPlainTimeService.addHours(timeValue, 1)
      ),
      'Static time'
    );
    Assert.areEqual(
      '22:30:00.000',
      ChronoPlainTimeService.toIsoString(
        ChronoPlainTimeService.addHours(
          ChronoPlainTimeService.toTime(timeValue),
          -1
        )
      ),
      'Native static time'
    );
    ChronoPlainDateTime local = ChronoPlainDateTimeService.parseIso(
      '2026-12-31T23:30'
    );
    Assert.areEqual(
      '2027-01-01T00:30:00.000',
      ChronoPlainDateTimeService.toIsoString(
        ChronoPlainDateTimeService.addHours(local, 1)
      ),
      'Carry date'
    );
    Assert.areEqual(
      ChronoPlainDateTimeService.toIsoString(
        ChronoPlainDateTimeService.addHours(local, 1)
      ),
      ChronoPlainDateTimeService.toIsoString(
        ChronoPlainDateTimeService.addHours(local, 1)
      ),
      'Static local'
    );
    ChronoInstant instant = ChronoInstantService.parseIso('2026-12-31T23:30Z');
    Assert.areEqual(
      '2027-01-01T00:30:00.000Z',
      ChronoInstantService.toIsoString(
        ChronoInstantService.addHours(
          ChronoInstantService.toDatetime(instant),
          1
        )
      ),
      'Static native instant'
    );
    Assert.areEqual(
      3600000L,
      ChronoDurationService.toMilliseconds(
        ChronoInstantService.elapsedDifference(
          instant,
          ChronoInstantService.addHours(instant, 1)
        )
      ),
      'Elapsed difference'
    );
  }
  @IsTest
  static void calendarDaysDifferFromElapsedHours() {
    ChronoZonedDateTime start = ChronoZonedDateTimeService.parseIso(
      '2026-03-28T12:00:00+00:00[Europe/London]'
    );
    Assert.areEqual(
      '2026-03-29T12:00:00.000+01:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addDays(start, 1)
      ),
      'Calendar day retains clock'
    );
    Assert.areEqual(
      '2026-03-29T13:00:00.000+01:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(start, 24)
      ),
      '24 elapsed hours'
    );
    Assert.areEqual(
      23L * 3600000,
      ChronoDurationService.toMilliseconds(
        ChronoZonedDateTimeService.elapsedDifference(
          start,
          ChronoZonedDateTimeService.addDays(start, 1)
        )
      ),
      'Spring day is 23 hours'
    );
    Assert.areEqual(
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(start, 1)
      ),
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(start, 1)
      ),
      'Static zoned'
    );
    Assert.areEqual(
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(start, 1)
      ),
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(
          ChronoZonedDateTimeService.toDatetime(start),
          'Europe/London',
          1
        )
      ),
      'Native static zoned'
    );
    Assert.areEqual(
      ChronoZonedDateTimeService.toDatetime(start),
      ChronoZonedDateTimeService.toDatetime(
        ChronoZonedDateTimeService.withTimeZone(start, 'America/New_York')
      ),
      'Change view retains instant'
    );
    ChronoZonedDateTime autumn = ChronoZonedDateTimeService.parseIso(
      '2026-10-24T12:00:00+01:00[Europe/London]'
    );
    Assert.areEqual(
      25L * 3600000,
      ChronoDurationService.toMilliseconds(
        ChronoZonedDateTimeService.elapsedDifference(
          autumn,
          ChronoZonedDateTimeService.addDays(autumn, 1)
        )
      ),
      'Autumn day is 25 hours'
    );
  }
  @IsTest
  static void durationsPreserveCalendarSemantics() {
    ChronoDuration duration = ChronoDurationService.parseIso(
      'P1Y2M3DT4H5M6.007S'
    );
    Assert.areEqual(
      14,
      ChronoDurationService.getMonths(duration),
      'Years to months'
    );
    Assert.areEqual(
      3,
      ChronoDurationService.getDays(duration),
      'Calendar days'
    );
    Assert.areEqual(
      14706007L,
      ChronoDurationService.getMilliseconds(duration),
      'Clock milliseconds'
    );
    Assert.areEqual(
      ChronoDurationService.toIsoString(duration),
      ChronoDurationService.toIsoString(
        ChronoDurationService.parseIso(
          ChronoDurationService.toIsoString(duration)
        )
      ),
      'Duration round trip'
    );
    Assert.areEqual(
      '-PT3600.000S',
      ChronoDurationService.toIsoString(
        ChronoDurationService.negate(ChronoDurationService.ofHours(1))
      ),
      'Negative duration'
    );
    Assert.areEqual(
      'PT0S',
      ChronoDurationService.toIsoString(ChronoDurationService.create(0, 0, 0L)),
      'Zero duration'
    );
    Assert.areEqual(
      14,
      ChronoDurationService.getDays(ChronoDurationService.parseIso('P2W')),
      'Weeks'
    );
    ChronoZonedDateTime start = ChronoZonedDateTimeService.parseIso(
      '2026-03-28T12:00:00Z[Europe/London]'
    );
    Assert.areEqual(
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addDays(start, 1)
      ),
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.add(
          start,
          ChronoDurationService.parseIso('P1D')
        )
      ),
      'Duration calendar day'
    );
    Assert.areEqual(
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(start, 24)
      ),
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.add(
          start,
          ChronoDurationService.parseIso('PT24H')
        )
      ),
      'Duration elapsed day'
    );
    try {
      ChronoDurationService.toMilliseconds(duration);
      Assert.fail('Calendar duration must require a relative date');
    } catch (ChronoException expected) {
      Assert.isTrue(
        expected.getMessage().contains('relative'),
        'Explicit calendar error'
      );
    }
  }
  @IsTest
  static void rejectsUnsupportedAndAmbiguousInputs() {
    List<String> badDates = new List<String>{
      null,
      '2026-2-01',
      '2026-02-01[u-ca=japanese]'
    };
    for (String input : badDates) {
      try {
        ChronoPlainDateService.parseIso(input);
        Assert.fail('Invalid date accepted');
      } catch (ChronoException expected) {
        Assert.isNotNull(expected.getMessage(), 'Diagnostic');
      }
    }
    try {
      ChronoPlainTimeService.parseIso('12:00:00.123x');
      Assert.fail('Malformed fractional seconds accepted');
    } catch (ChronoException expected) {
      Assert.isNotNull(expected.getMessage(), 'Format error');
    }
    try {
      ChronoZonedDateTimeService.parseIso(
        '2026-07-01T12:00:00Z[Europe/London]'
      );
      Assert.fail('Wrong offset accepted');
    } catch (ChronoException expected) {
      Assert.isTrue(
        expected.getMessage().contains('offset'),
        'Offset mismatch'
      );
    }
    try {
      ChronoZonedDateTimeService.create(Datetime.now(), 'invalid/zone');
      Assert.fail('Unknown zone accepted');
    } catch (ChronoException expected) {
      Assert.isTrue(expected.getMessage().contains('Unknown'), 'Unknown zone');
    }
    try {
      ChronoDurationService.create(1, -1, 0L);
      Assert.fail('Mixed signs accepted');
    } catch (ChronoException expected) {
      Assert.isTrue(expected.getMessage().contains('sign'), 'Sign validation');
    }
  }
  @IsTest
  static void independentOfRunningUsersZone() {
    User runner = [
      SELECT Id, TimeZoneSidKey
      FROM User
      WHERE Id = :UserInfo.getUserId()
    ];
    runner.TimeZoneSidKey = 'Pacific/Auckland';
    update runner;
    System.runAs(runner) {
      ChronoZonedDateTime value = ChronoPlainDateTimeService.toZonedDateTime(
        ChronoPlainDateTimeService.parseIso('2026-01-15T09:30'),
        'America/New_York'
      );
      Assert.areEqual(
        '2026-01-15T14:30:00.000Z',
        ChronoInstantService.toIsoString(
          ChronoZonedDateTimeService.toInstant(value)
        ),
        'Explicit zone independent of user'
      );
    }
  }

  @IsTest
  static void invalidCalendarComponentsNeverRollForward() {
    for (
      String input : new List<String>{
        '2026-02-31',
        '2026-13-01',
        '2026-00-01',
        '2026-01-00'
      }
    ) {
      try {
        ChronoPlainDateService.parseIso(input);
        Assert.fail('Invalid date rolled forward: ' + input);
      } catch (ChronoException expected) {
        Assert.isNotNull(expected.getMessage(), 'Calendar validation');
      }
    }
    try {
      ChronoPlainTimeService.parseIso('24:00');
      Assert.fail('Invalid time accepted');
    } catch (ChronoException expected) {
      Assert.isNotNull(expected.getMessage(), 'Time validation');
    }
    try {
      ChronoPlainYearMonthService.create(2026, 13);
      Assert.fail('Invalid month accepted');
    } catch (ChronoException expected) {
      Assert.isNotNull(expected.getMessage(), 'Year-month validation');
    }
    try {
      ChronoPlainMonthDayService.create(2, 30);
      Assert.fail('Invalid month-day accepted');
    } catch (ChronoException expected) {
      Assert.isNotNull(expected.getMessage(), 'Month-day validation');
    }
    try {
      ChronoPlainMonthDayService.toPlainDate(
        ChronoPlainMonthDayService.create(2, 29),
        2026
      );
      Assert.fail('Non-leap year rolled forward');
    } catch (ChronoException expected) {
      Assert.isNotNull(expected.getMessage(), 'Leap date validation');
    }
    try {
      ChronoPlainYearMonthService.toPlainDate(
        ChronoPlainYearMonthService.create(2026, 2),
        31
      );
      Assert.fail('Invalid completion rolled forward');
    } catch (ChronoException expected) {
      Assert.isNotNull(expected.getMessage(), 'Completed date validation');
    }
  }
}
