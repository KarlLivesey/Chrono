// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoApiContractTest {
  @IsTest
  static void partialValuesUseActualComponents() {
    ChronoPlainMonthDay day = new ChronoPlainMonthDay();
    day.month = 2;
    day.day = 29;
    Assert.areEqual('--02-29', ChronoPlainMonthDayService.toIsoString(day));
    Assert.areEqual(
      Date.newInstance(2024, 2, 29),
      ChronoPlainMonthDayService.toPlainDate(day, 2024).value
    );
    try {
      ChronoPlainMonthDayService.toPlainDate(day, 2023);
      Assert.fail('A leap day cannot become a date in a non-leap year.');
    } catch (ChronoException ex) {
      Assert.isTrue(ex.getMessage().contains('requested year'));
    }
    ChronoPlainYearMonth month = new ChronoPlainYearMonth();
    month.year = 2024;
    month.month = 12;
    ChronoPlainYearMonth shifted = ChronoPlainYearMonthService.addMonths(
      month,
      2
    );
    Assert.areEqual(
      '2025-02',
      ChronoPlainYearMonthService.toIsoString(shifted)
    );
    Assert.areEqual(
      12,
      month.month,
      'Arithmetic must leave the input independent.'
    );
    Assert.areEqual('2024-12', ChronoPlainYearMonthService.toIsoString(month));
    month.year = 0;
    try {
      ChronoPlainYearMonthService.validate(month);
      Assert.fail('An out-of-range year must be rejected.');
    } catch (ChronoException ex) {
      Assert.isTrue(ex.getMessage().contains('Year'));
    }
    day.day = 30;
    try {
      ChronoPlainMonthDayService.validate(day);
      Assert.fail('Impossible partial components must be rejected.');
    } catch (ChronoException ex) {
      Assert.isTrue(ex.getMessage().contains('Invalid day'));
    }
    day.month = null;
    try {
      ChronoPlainMonthDayService.validate(day);
      Assert.fail('Incomplete data must be rejected.');
    } catch (ChronoException ex) {
      Assert.isTrue(ex.getMessage().contains('Month'));
    }
  }
  @IsTest
  static void nullPolicyUsesTheSafeDefault() {
    ChronoPlainDateTime local = ChronoPlainDateTimeService.parseIso(
      '2026-09-07T08:00'
    );
    ChronoZonedDateTime zoned = ChronoPlainDateTimeService.toZonedDateTime(
      local,
      'Europe/London',
      null
    );
    Assert.areEqual('Europe/London', zoned.timeZoneId);
    Assert.areEqual(
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addDays(zoned, 1)
      ),
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.addDays(zoned, 1, null)
      )
    );
    ChronoZonedDateTimeService.addMonths(zoned, 1, null);
    ChronoZonedDateTimeService.addYears(zoned, 1, null);
    ChronoZonedDateTimeService.add(
      zoned,
      ChronoDurationService.parseIso('P1D'),
      null
    );
    local = ChronoPlainDateTimeService.parseIso('2026-10-25T01:30');
    try {
      ChronoPlainDateTimeService.toZonedDateTime(local, 'Europe/London', null);
      Assert.fail('Omitting a policy must still reject repeated times.');
    } catch (ChronoException ex) {
      Assert.isTrue(ex.getMessage().contains('repeated'));
    }
    try {
      ChronoZonedDateTimeService.addDays(zoned, 1, 'invalid');
      Assert.fail('Unsupported non-null policy text must be rejected.');
    } catch (ChronoException ex) {
      Assert.isTrue(ex.getMessage().contains('Disambiguation'));
    }
    OperatingHours absent;
    try {
      ChronoZonedDateTimeService.addHours(zoned, 1, absent);
      Assert.fail(
        'Missing required schedule must never mean unrestricted time.'
      );
    } catch (ChronoException ex) {
      Assert.isNotNull(ex.getMessage());
    }
  }
  @IsTest
  static void elapsedDifferenceHasAnExplicitDirection() {
    ChronoInstant first = ChronoInstantService.parseIso('2026-03-29T00:30Z');
    ChronoInstant second = ChronoInstantService.parseIso('2026-03-29T01:30Z');
    Assert.areEqual(
      'PT3600.000S',
      ChronoDurationService.toIsoString(
        ChronoInstantService.elapsedDifference(first, second)
      )
    );
    Assert.areEqual(
      '-PT3600.000S',
      ChronoDurationService.toIsoString(
        ChronoInstantService.elapsedDifference(second, first)
      )
    );
    ChronoZonedDateTime before = ChronoInstantService.toZonedDateTime(
      first,
      'Europe/London'
    );
    ChronoZonedDateTime after = ChronoInstantService.toZonedDateTime(
      second,
      'Europe/London'
    );
    Assert.areEqual(
      'PT3600.000S',
      ChronoDurationService.toIsoString(
        ChronoZonedDateTimeService.elapsedDifference(before, after)
      )
    );
    Assert.areEqual(
      '-PT3600.000S',
      ChronoDurationService.toIsoString(
        ChronoDurationService.negate(
          ChronoZonedDateTimeService.elapsedDifference(before, after)
        )
      )
    );
  }
  @SuppressWarnings('PMD.NcssCount')
  @IsTest
  static void nativeServiceOverloadsPreserveTheirTypes() {
    Datetime instantNative = Datetime.newInstanceGmt(2026, 1, 31, 23, 30, 0);
    ChronoInstant instant = ChronoInstantService.create(instantNative);
    Assert.areEqual(instantNative, ChronoInstantService.toDatetime(instant));
    Assert.areEqual(
      '2026-01-31T23:30:00.000Z',
      ChronoInstantService.toIsoString(instant)
    );
    Assert.areEqual(
      '2026-02-01T00:30:00.000Z',
      ChronoInstantService.toIsoString(
        ChronoInstantService.addHours(instant, 1)
      )
    );
    Assert.areEqual(
      '2026-02-01T00:30:00.000Z',
      ChronoInstantService.toIsoString(
        ChronoInstantService.addHours(instantNative, 1)
      )
    );
    Assert.areEqual(
      '2026-01-31T23:31:00.000Z',
      ChronoInstantService.toIsoString(
        ChronoInstantService.addMinutes(instant, 1)
      )
    );
    Assert.areEqual(
      '2026-01-31T23:31:00.000Z',
      ChronoInstantService.toIsoString(
        ChronoInstantService.addMinutes(instantNative, 1)
      )
    );
    Assert.areEqual(
      '2026-01-31T23:30:01.000Z',
      ChronoInstantService.toIsoString(
        ChronoInstantService.addSeconds(instant, 1)
      )
    );
    Assert.areEqual(
      '2026-01-31T23:30:01.000Z',
      ChronoInstantService.toIsoString(
        ChronoInstantService.addSeconds(instantNative, 1)
      )
    );
    Assert.areEqual(
      '2026-01-31T23:30:00.001Z',
      ChronoInstantService.toIsoString(
        ChronoInstantService.addMilliseconds(instant, 1)
      )
    );
    Assert.areEqual(
      '2026-01-31T23:30:00.001Z',
      ChronoInstantService.toIsoString(
        ChronoInstantService.addMilliseconds(instantNative, 1)
      )
    );
    Assert.areEqual(
      '2026-01-31T23:30:00.000+00:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(
        ChronoInstantService.toZonedDateTime(instant, 'Europe/London')
      )
    );
    Assert.areEqual(
      '2026-01-31T23:30:00.000+00:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(
        ChronoInstantService.toZonedDateTime(instantNative, 'Europe/London')
      )
    );
    ChronoInstantService.validate(instant);

    Time clockNative = Time.newInstance(23, 30, 0, 500);
    ChronoPlainTime clock = ChronoPlainTimeService.create(clockNative);
    Assert.areEqual(clockNative, ChronoPlainTimeService.toTime(clock));
    Assert.areEqual('23:30:00.500', ChronoPlainTimeService.toIsoString(clock));
    Assert.areEqual(
      '01:30:00.500',
      ChronoPlainTimeService.toIsoString(
        ChronoPlainTimeService.addHours(clock, 2)
      )
    );
    Assert.areEqual(
      '01:30:00.500',
      ChronoPlainTimeService.toIsoString(
        ChronoPlainTimeService.addHours(clockNative, 2)
      )
    );
    Assert.areEqual(
      '23:31:00.500',
      ChronoPlainTimeService.toIsoString(
        ChronoPlainTimeService.addMinutes(clock, 1)
      )
    );
    Assert.areEqual(
      '23:31:00.500',
      ChronoPlainTimeService.toIsoString(
        ChronoPlainTimeService.addMinutes(clockNative, 1)
      )
    );
    Assert.areEqual(
      '23:30:01.500',
      ChronoPlainTimeService.toIsoString(
        ChronoPlainTimeService.addSeconds(clock, 1)
      )
    );
    Assert.areEqual(
      '23:30:01.500',
      ChronoPlainTimeService.toIsoString(
        ChronoPlainTimeService.addSeconds(clockNative, 1)
      )
    );
    Assert.areEqual(
      '23:30:01.500',
      ChronoPlainTimeService.toIsoString(
        ChronoPlainTimeService.addMilliseconds(clock, 1000)
      )
    );
    Assert.areEqual(
      '23:30:01.500',
      ChronoPlainTimeService.toIsoString(
        ChronoPlainTimeService.addMilliseconds(clockNative, 1000)
      )
    );
    Assert.areEqual(
      '2026-02-01T23:30:00.500',
      ChronoPlainDateTimeService.toIsoString(
        ChronoPlainTimeService.toPlainDateTime(
          clock,
          Date.newInstance(2026, 2, 1)
        )
      )
    );
    ChronoPlainTimeService.validate(clock);

    Date localDate = Date.newInstance(2026, 1, 31);
    Time localTime = Time.newInstance(23, 30, 0, 500);
    ChronoPlainDateTime local = ChronoPlainDateTimeService.create(
      localDate,
      localTime
    );
    Assert.areEqual(
      '2026-01-31T23:30:00.500',
      ChronoPlainDateTimeService.toIsoString(local)
    );
    Assert.areEqual(localDate, ChronoPlainDateTimeService.toDate(local));
    Assert.areEqual(localTime, ChronoPlainDateTimeService.toTime(local));
    Assert.areEqual(
      localDate,
      ChronoPlainDateTimeService.toPlainDate(local).value
    );
    Assert.areEqual(
      localTime,
      ChronoPlainDateTimeService.toPlainTime(local).value
    );
    Assert.areEqual(
      '2026-02-01T23:30:00.500',
      ChronoPlainDateTimeService.toIsoString(
        ChronoPlainDateTimeService.addDays(local, 1)
      )
    );
    Assert.areEqual(
      '2026-02-28T23:30:00.500',
      ChronoPlainDateTimeService.toIsoString(
        ChronoPlainDateTimeService.addMonths(local, 1)
      )
    );
    Assert.areEqual(
      '2027-01-31T23:30:00.500',
      ChronoPlainDateTimeService.toIsoString(
        ChronoPlainDateTimeService.addYears(local, 1)
      )
    );
    Assert.areEqual(
      '2026-02-01T00:30:00.500',
      ChronoPlainDateTimeService.toIsoString(
        ChronoPlainDateTimeService.addHours(local, 1)
      )
    );
    Assert.areEqual(
      '2026-01-31T23:31:00.500',
      ChronoPlainDateTimeService.toIsoString(
        ChronoPlainDateTimeService.addMinutes(local, 1)
      )
    );
    Assert.areEqual(
      '2026-01-31T23:30:01.500',
      ChronoPlainDateTimeService.toIsoString(
        ChronoPlainDateTimeService.addMilliseconds(local, 1000)
      )
    );
    Assert.areEqual(
      '2026-03-02T02:30:00.500',
      ChronoPlainDateTimeService.toIsoString(
        ChronoPlainDateTimeService.add(
          local,
          ChronoDurationService.parseIso('P1M1DT3H')
        )
      )
    );
    Assert.areEqual(
      '2026-01-31T23:30:00.500+00:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(
        ChronoPlainDateTimeService.toZonedDateTime(local, 'Europe/London')
      )
    );
    Assert.areEqual(
      '2026-01-31T23:30:00.500+00:00[Europe/London]',
      ChronoZonedDateTimeService.toIsoString(
        ChronoPlainDateTimeService.toZonedDateTime(
          local,
          'Europe/London',
          'reject'
        )
      )
    );
    ChronoPlainDateTimeService.validate(local);
  }
  @IsTest
  static void fiscalEndpointsComposeWithRanges() {
    List<ChronoFiscalPeriodAction.Request> requests = new List<ChronoFiscalPeriodAction.Request>();
    for (
      String kind : new List<String>{
        'PlainDate',
        'PlainDateTime',
        'ZonedDateTime'
      }
    ) {
      ChronoFiscalPeriodAction.Request item = new ChronoFiscalPeriodAction.Request();
      item.valueType = kind;
      item.value = kind == 'PlainDate'
        ? '2026-03-07'
        : (kind == 'PlainDateTime'
            ? '2026-03-07T12:00'
            : '2026-03-07T12:00Z[Europe/London]');
      item.calendarSource = 'monthBased';
      item.startMonth = 1;
      item.period = 'month';
      requests.add(item);
    }
    List<ChronoFiscalResult> periods = ChronoFiscalPeriodAction.run(requests);
    for (Integer i = 0; i < periods.size(); i++) {
      ChronoFiscalResult period = periods[i];
      Assert.isTrue(period.success, 'Fiscal period: ' + period.errorMessage);
      Assert.areEqual(Date.newInstance(2026, 3, 31), period.lastDate);
      Assert.areEqual(Date.newInstance(2026, 4, 1), period.endExclusiveDate);
      ChronoRangeToolsAction.Request range = new ChronoRangeToolsAction.Request();
      range.operation = 'contains';
      range.valueType = requests[i].valueType;
      range.value = period.startValue;
      range.endValue = period.endExclusiveValue;
      range.pointValue = i == 0
        ? '2026-03-31'
        : (i == 1
            ? '2026-03-31T23:59:59.999'
            : '2026-03-31T23:59:59.999+01:00[Europe/London]');
      ChronoRangeResult result = ChronoRangeToolsAction.run(
        new List<ChronoRangeToolsAction.Request>{ range }
      )[0];
      Assert.isTrue(result.success, 'Range: ' + result.errorMessage);
      Assert.isTrue(
        result.containsValue,
        'The last date/tick belongs to the fiscal range.'
      );
      range.pointValue = period.endExclusiveValue;
      Assert.isFalse(
        ChronoRangeToolsAction.run(
            new List<ChronoRangeToolsAction.Request>{ range }
          )[0]
          .containsValue
      );
    }
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 3, 31, 23, 0, 0),
      periods[2].endExclusiveInstant,
      'Use the endpoint offset after the DST change.'
    );
    Assert.areEqual(
      (31L * 24 - 1) * 3600000,
      periods[2].endExclusiveInstant.getTime() -
      periods[2].startInstant.getTime()
    );
  }
  @IsTest
  static void zeroCalendarUnitsPreserveRepeatedOccurrence() {
    ChronoZonedDateTime source = ChronoZonedDateTimeService.parseIso(
      '2026-10-25T01:30:00.000+00:00[Europe/London]'
    );
    for (
      String policy : new List<String>{ null, 'reject', 'earlier', 'later' }
    ) {
      List<ChronoZonedDateTime> results = new List<ChronoZonedDateTime>{
        ChronoZonedDateTimeService.addDays(source, 0, policy),
        ChronoZonedDateTimeService.addMonths(source, 0, policy),
        ChronoZonedDateTimeService.addYears(source, 0, policy)
      };
      for (ChronoZonedDateTime result : results) {
        Assert.areEqual(source.instant, result.instant);
        result.instant = null;
        Assert.isNotNull(source.instant, 'Zero returns an independent value.');
      }
    }
    try {
      ChronoZonedDateTimeService.addDays(source, 0, 'invalid');
      Assert.fail('Zero must still validate policy.');
    } catch (ChronoException ex) {
      Assert.isTrue(ex.getMessage().contains('Disambiguation'));
    }
  }
}
