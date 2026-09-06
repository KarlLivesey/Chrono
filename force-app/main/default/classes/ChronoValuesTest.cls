// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoValuesTest {
  @IsTest
  static void nativeAndIsoRoundTrips() {
    ChronoPlainDate day = ChronoPlainDate.parse('2024-02-29');
    Assert.areEqual(Date.newInstance(2024, 2, 29), day.toDate(), 'Native date');
    Assert.areEqual('2024-02-29', day.toString(), 'ISO date');
    ChronoPlainTime clock = ChronoPlainTime.parse('23:59:59.123');
    Assert.areEqual(
      Time.newInstance(23, 59, 59, 123),
      clock.toTime(),
      'Native time'
    );
    Assert.areEqual('23:59:59.123', clock.toString(), 'ISO time');
    ChronoPlainDateTime local = day.toPlainDateTime(clock.toTime());
    Assert.areEqual(
      '2024-02-29T23:59:59.123',
      local.toString(),
      'Local datetime'
    );
    Assert.areEqual(
      local.toString(),
      ChronoPlainDateTime.parse(local.toString()).toString(),
      'Local round trip'
    );
    ChronoInstant instant = ChronoInstant.parse(
      '2024-03-01T05:29:59.123+05:30'
    );
    Assert.areEqual(
      '2024-02-29T23:59:59.123Z',
      instant.toString(),
      'Offset conversion'
    );
    Assert.areEqual(
      123,
      instant.toDatetime().millisecondGmt(),
      'Millisecond preservation'
    );
    Assert.areEqual(
      instant.toString(),
      ChronoInstant.parse(instant.toString()).toString(),
      'Instant round trip'
    );
    ChronoZonedDateTime zoned = instant.toZonedDateTime('Asia/Tokyo');
    Assert.areEqual(
      '2024-03-01T08:59:59.123+09:00[Asia/Tokyo]',
      zoned.toString(),
      'Zoned output'
    );
    Assert.areEqual(
      instant.toDatetime(),
      ChronoZonedDateTime.parse(zoned.toString()).toDatetime(),
      'Zoned round trip'
    );
  }
  @IsTest
  static void partialDatesAndMonthArithmetic() {
    ChronoPlainDate day = ChronoPlainDate.parse('2024-01-31');
    Assert.areEqual(
      '2024-02-29',
      day.addMonths(1).toString(),
      'Leap month clamps'
    );
    Assert.areEqual(
      '2024-02-29',
      ChronoPlainDate.addMonths(day, 1).toString(),
      'Static matches instance'
    );
    Assert.areEqual(
      '2024-02-29',
      ChronoPlainDate.addMonths(day.toDate(), 1).toString(),
      'Native static'
    );
    Assert.areEqual('2024-01-31', day.toString(), 'Immutable input');
    Assert.areEqual(
      '2025-02-28',
      ChronoPlainDate.parse('2024-02-29').addYears(1).toString(),
      'Leap year clamp'
    );
    ChronoPlainYearMonth month = ChronoPlainYearMonth.parse('2024-12');
    Assert.areEqual('2025-01', month.addMonths(1).toString(), 'Year rollover');
    Assert.areEqual(
      '2024-12-15',
      month.toPlainDate(15).toString(),
      'Complete year-month'
    );
    ChronoPlainMonthDay annual = ChronoPlainMonthDay.parse('--02-29');
    Assert.areEqual('--02-29', annual.toString(), 'Annual leap date retained');
    Assert.areEqual(
      '2024-02-29',
      annual.toPlainDate(2024).toString(),
      'Complete month-day'
    );
    Assert.areEqual(
      '2024-01',
      day.toPlainYearMonth().toString(),
      'Extract year-month'
    );
    Assert.areEqual(
      '--01-31',
      day.toPlainMonthDay().toString(),
      'Extract month-day'
    );
  }
  @IsTest
  static void arithmeticCarriesAndBothCallStyles() {
    ChronoPlainTime timeValue = ChronoPlainTime.parse('23:30');
    Assert.areEqual(
      '00:30:00.000',
      timeValue.addHours(1).toString(),
      'Wrap midnight'
    );
    Assert.areEqual(
      timeValue.addHours(1).toString(),
      ChronoPlainTime.addHours(timeValue, 1).toString(),
      'Static time'
    );
    Assert.areEqual(
      '22:30:00.000',
      ChronoPlainTime.addHours(timeValue.toTime(), -1).toString(),
      'Native static time'
    );
    ChronoPlainDateTime local = ChronoPlainDateTime.parse('2026-12-31T23:30');
    Assert.areEqual(
      '2027-01-01T00:30:00.000',
      local.addHours(1).toString(),
      'Carry date'
    );
    Assert.areEqual(
      local.addHours(1).toString(),
      ChronoPlainDateTime.addHours(local, 1).toString(),
      'Static local'
    );
    ChronoInstant instant = ChronoInstant.parse('2026-12-31T23:30Z');
    Assert.areEqual(
      '2027-01-01T00:30:00.000Z',
      ChronoInstant.addHours(instant.toDatetime(), 1).toString(),
      'Static native instant'
    );
    Assert.areEqual(
      3600000L,
      instant.until(instant.addHours(1)).toMilliseconds(),
      'Elapsed difference'
    );
  }
  @IsTest
  static void calendarDaysDifferFromElapsedHours() {
    ChronoZonedDateTime start = ChronoZonedDateTime.parse(
      '2026-03-28T12:00:00+00:00[Europe/London]'
    );
    Assert.areEqual(
      '2026-03-29T12:00:00.000+01:00[Europe/London]',
      start.addDays(1).toString(),
      'Calendar day retains clock'
    );
    Assert.areEqual(
      '2026-03-29T13:00:00.000+01:00[Europe/London]',
      start.addHours(24).toString(),
      '24 elapsed hours'
    );
    Assert.areEqual(
      23L * 3600000,
      start.until(start.addDays(1)).toMilliseconds(),
      'Spring day is 23 hours'
    );
    Assert.areEqual(
      start.addHours(1).toString(),
      ChronoZonedDateTime.addHours(start, 1).toString(),
      'Static zoned'
    );
    Assert.areEqual(
      start.addHours(1).toString(),
      ChronoZonedDateTime.addHours(start.toDatetime(), 'Europe/London', 1)
        .toString(),
      'Native static zoned'
    );
    Assert.areEqual(
      start.toDatetime(),
      start.withTimeZone('America/New_York').toDatetime(),
      'Change view retains instant'
    );
    ChronoZonedDateTime autumn = ChronoZonedDateTime.parse(
      '2026-10-24T12:00:00+01:00[Europe/London]'
    );
    Assert.areEqual(
      25L * 3600000,
      autumn.until(autumn.addDays(1)).toMilliseconds(),
      'Autumn day is 25 hours'
    );
  }
  @IsTest
  static void durationsPreserveCalendarSemantics() {
    ChronoDuration duration = ChronoDuration.parse('P1Y2M3DT4H5M6.007S');
    Assert.areEqual(14, duration.getMonths(), 'Years to months');
    Assert.areEqual(3, duration.getDays(), 'Calendar days');
    Assert.areEqual(
      14706007L,
      duration.getMilliseconds(),
      'Clock milliseconds'
    );
    Assert.areEqual(
      duration.toString(),
      ChronoDuration.parse(duration.toString()).toString(),
      'Duration round trip'
    );
    Assert.areEqual(
      '-PT3600.000S',
      ChronoDuration.ofHours(1).negated().toString(),
      'Negative duration'
    );
    Assert.areEqual(
      'PT0S',
      new ChronoDuration(0, 0, 0L).toString(),
      'Zero duration'
    );
    Assert.areEqual(14, ChronoDuration.parse('P2W').getDays(), 'Weeks');
    ChronoZonedDateTime start = ChronoZonedDateTime.parse(
      '2026-03-28T12:00:00Z[Europe/London]'
    );
    Assert.areEqual(
      start.addDays(1).toString(),
      start.add(ChronoDuration.parse('P1D')).toString(),
      'Duration calendar day'
    );
    Assert.areEqual(
      start.addHours(24).toString(),
      start.add(ChronoDuration.parse('PT24H')).toString(),
      'Duration elapsed day'
    );
    try {
      duration.toMilliseconds();
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
        ChronoPlainDate.parse(input);
        Assert.fail('Invalid date accepted');
      } catch (ChronoException expected) {
        Assert.isNotNull(expected.getMessage(), 'Diagnostic');
      }
    }
    try {
      ChronoPlainTime.parse('12:00:00.1234');
      Assert.fail('Sub-millisecond time accepted');
    } catch (ChronoException expected) {
      Assert.isNotNull(expected.getMessage(), 'Precision error');
    }
    try {
      ChronoZonedDateTime.parse('2026-07-01T12:00:00Z[Europe/London]');
      Assert.fail('Wrong offset accepted');
    } catch (ChronoException expected) {
      Assert.isTrue(
        expected.getMessage().contains('offset'),
        'Offset mismatch'
      );
    }
    try {
      new ChronoZonedDateTime(Datetime.now(), 'invalid/zone');
      Assert.fail('Unknown zone accepted');
    } catch (ChronoException expected) {
      Assert.isTrue(expected.getMessage().contains('Unknown'), 'Unknown zone');
    }
    try {
      new ChronoDuration(1, -1, 0L);
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
      ChronoZonedDateTime value = ChronoPlainDateTime.parse('2026-01-15T09:30')
        .toZonedDateTime('America/New_York');
      Assert.areEqual(
        '2026-01-15T14:30:00.000Z',
        value.toInstant().toString(),
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
        ChronoPlainDate.parse(input);
        Assert.fail('Invalid date rolled forward: ' + input);
      } catch (ChronoException expected) {
        Assert.isNotNull(expected.getMessage(), 'Calendar validation');
      }
    }
    try {
      ChronoPlainTime.parse('24:00');
      Assert.fail('Invalid time accepted');
    } catch (ChronoException expected) {
      Assert.isNotNull(expected.getMessage(), 'Time validation');
    }
    try {
      new ChronoPlainYearMonth(2026, 13);
      Assert.fail('Invalid month accepted');
    } catch (ChronoException expected) {
      Assert.isNotNull(expected.getMessage(), 'Year-month validation');
    }
    try {
      new ChronoPlainMonthDay(2, 30);
      Assert.fail('Invalid month-day accepted');
    } catch (ChronoException expected) {
      Assert.isNotNull(expected.getMessage(), 'Month-day validation');
    }
    try {
      new ChronoPlainMonthDay(2, 29).toPlainDate(2026);
      Assert.fail('Non-leap year rolled forward');
    } catch (ChronoException expected) {
      Assert.isNotNull(expected.getMessage(), 'Leap date validation');
    }
    try {
      new ChronoPlainYearMonth(2026, 2).toPlainDate(31);
      Assert.fail('Invalid completion rolled forward');
    } catch (ChronoException expected) {
      Assert.isNotNull(expected.getMessage(), 'Completed date validation');
    }
  }
}
