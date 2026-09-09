// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Validates the data-only service API, native overloads and protection against altered data. */
@IsTest
private class ChronoCallStylesTest {
  @IsTest
  static void datesAreIndependentData() {
    ChronoPlainDate source = ChronoPlainDateService.parseIso('2024-02-28');
    ChronoPlainDate changed = ChronoPlainDateService.addDays(source, 2);
    Assert.areEqual('2024-03-01', ChronoPlainDateService.toIsoString(changed));
    changed.value = Date.newInstance(2000, 1, 1);
    Assert.areEqual(Date.newInstance(2024, 2, 28), source.value);
    Assert.areEqual(
      '2024-03-01',
      ChronoPlainDateService.toIsoString(
        ChronoPlainDateService.addDays(source.value, 2)
      )
    );
    Assert.areEqual(
      '2024-04-28',
      ChronoPlainDateService.toIsoString(
        ChronoPlainDateService.addMonths(source.value, 2)
      )
    );
    Assert.areEqual(
      '2026-02-28',
      ChronoPlainDateService.toIsoString(
        ChronoPlainDateService.addYears(source.value, 2)
      )
    );
  }
  @IsTest
  static void incompleteDataIsRejected() {
    try {
      ChronoPlainDateService.addDays(new ChronoPlainDate(), 1);
      Assert.fail('An empty value must be rejected.');
    } catch (ChronoException ex) {
      Assert.areEqual('Date is required.', ex.getMessage());
    }
    try {
      ChronoPlainDateTimeService.toIsoString(new ChronoPlainDateTime());
      Assert.fail('An empty clock must be rejected.');
    } catch (ChronoException ex) {
      Assert.areEqual('Date is required.', ex.getMessage());
    }
    try {
      ChronoInstantService.toDatetime(new ChronoInstant());
      Assert.fail('An empty instant must be rejected.');
    } catch (ChronoException ex) {
      Assert.areEqual('Datetime is required.', ex.getMessage());
    }
    try {
      ChronoPlainTimeService.toTime(new ChronoPlainTime());
      Assert.fail('An empty time must be rejected.');
    } catch (ChronoException ex) {
      Assert.isTrue(ex.getMessage().contains('value'));
    }
  }
  @IsTest
  static void nativeTimeOverloadsWrapAtMidnight() {
    Time source = Time.newInstance(23, 59, 59, 900);
    Assert.areEqual(
      '00:59:59.900',
      ChronoPlainTimeService.toIsoString(
        ChronoPlainTimeService.addHours(source, 1)
      )
    );
    Assert.areEqual(
      '00:00:59.900',
      ChronoPlainTimeService.toIsoString(
        ChronoPlainTimeService.addMinutes(source, 1)
      )
    );
    Assert.areEqual(
      '00:00:00.900',
      ChronoPlainTimeService.toIsoString(
        ChronoPlainTimeService.addSeconds(source, 1)
      )
    );
    Assert.areEqual(
      '00:00:00.100',
      ChronoPlainTimeService.toIsoString(
        ChronoPlainTimeService.addMilliseconds(source, 200L)
      )
    );
  }
  @IsTest
  static void nativeInstantOverloadsKeepElapsedTime() {
    Datetime source = Datetime.newInstanceGmt(2026, 3, 29, 0, 30, 0);
    Assert.areEqual(
      '2026-03-29T01:30:00.000Z',
      ChronoInstantService.toIsoString(ChronoInstantService.addHours(source, 1))
    );
    Assert.areEqual(
      '2026-03-29T00:31:00.000Z',
      ChronoInstantService.toIsoString(
        ChronoInstantService.addMinutes(source, 1)
      )
    );
    Assert.areEqual(
      '2026-03-29T00:30:01.000Z',
      ChronoInstantService.toIsoString(
        ChronoInstantService.addSeconds(source, 1)
      )
    );
    Assert.areEqual(
      '2026-03-29T00:30:00.001Z',
      ChronoInstantService.toIsoString(
        ChronoInstantService.addMilliseconds(source, 1L)
      )
    );
  }
  @IsTest
  static void zonedServicesDistinguishCalendarAndElapsedTime() {
    ChronoZonedDateTime source = ChronoZonedDateTimeService.parseIso(
      '2026-03-28T12:00:00.000+00:00[Europe/London]'
    );
    Assert.areEqual(
      '2026-03-29T12:00:00.000+01:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addDays(source, 1)
      )
    );
    Assert.areEqual(
      '2026-03-29T13:00:00.000+01:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addHours(
          source.instant,
          source.timeZoneId,
          24
        )
      )
    );
    Assert.areEqual(
      '2026-03-28T12:00:00.000+00:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(source)
    );
    source.timeZoneId = 'Not/AZone';
    try {
      ChronoZonedDateTimeService.addHours(source, 1);
      Assert.fail('An altered zone must be validated.');
    } catch (ChronoException ex) {
      Assert.isTrue(ex.getMessage().contains('zone'));
    }
  }
  @IsTest
  static void durationsRejectAlteredSignsAndTruncatePrecision() {
    ChronoDuration value = ChronoDurationService.parseIso('-PT1.987654321S');
    Assert.areEqual(-1987L, value.milliseconds);
    Assert.areEqual(
      'PT1.987S',
      ChronoDurationService.toIsoString(ChronoDurationService.negate(value))
    );
    value.days = 1;
    try {
      ChronoDurationService.toIsoString(value);
      Assert.fail('Mixed signs must be rejected.');
    } catch (ChronoException ex) {
      Assert.isTrue(ex.getMessage().contains('same sign'));
    }
  }
  @IsTest
  static void partialDatesValidateTheirActualComponents() {
    ChronoPlainYearMonth month = ChronoPlainYearMonthService.parseIso(
      '2024-02'
    );
    Assert.areEqual(
      '2024-02-29',
      ChronoPlainDateService.toIsoString(
        ChronoPlainYearMonthService.toPlainDate(month, 29)
      )
    );
    month.month = 13;
    try {
      ChronoPlainYearMonthService.toIsoString(month);
      Assert.fail('Invalid month must be rejected.');
    } catch (ChronoException ex) {
      Assert.isTrue(ex.getMessage().contains('Month'));
    }
    ChronoPlainMonthDay day = ChronoPlainMonthDayService.parseIso('--02-29');
    Assert.areEqual(
      '2024-02-29',
      ChronoPlainDateService.toIsoString(
        ChronoPlainMonthDayService.toPlainDate(day, 2024)
      )
    );
    day.day = 30;
    try {
      ChronoPlainMonthDayService.toIsoString(day);
      Assert.fail('Invalid day must be rejected.');
    } catch (ChronoException ex) {
      Assert.isTrue(ex.getMessage().contains('Invalid day'));
    }
  }
  @IsTest
  static void explicitlyAssignedDataIsUsable() {
    ChronoPlainDateTime source = new ChronoPlainDateTime();
    source.localDate = Date.newInstance(2026, 9, 8);
    source.localTime = Time.newInstance(9, 30, 0, 0);
    ChronoZonedDateTime zoned = ChronoPlainDateTimeService.toZonedDateTime(
      source,
      'Europe/London'
    );
    Assert.areEqual(
      '2026-09-08T09:30:00.000+01:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(zoned)
    );
    Assert.areEqual(
      '2026-09-08T08:30:00.000Z',
      ChronoInstantService.toIsoString(
        ChronoZonedDateTimeService.toInstant(zoned)
      )
    );
  }
}
