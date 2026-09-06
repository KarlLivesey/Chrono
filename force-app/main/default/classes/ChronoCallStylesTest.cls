// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** Tests the requested equivalence of instance, static and native-input call styles. Semantic edge cases are tested separately. */
@IsTest
private class ChronoCallStylesTest {
  @IsTest
  static void plaindateCallStyles() {
    ChronoPlainDate value = ChronoPlainDate.parse('2024-02-28');
    Assert.areEqual(
      String.valueOf(value.toDate()),
      String.valueOf(ChronoPlainDate.toDate(value)),
      'toDate static'
    );
    Assert.areEqual(
      String.valueOf(value.addDays(2)),
      String.valueOf(ChronoPlainDate.addDays(value, 2)),
      'addDays static'
    );
    Assert.areEqual(
      String.valueOf(value.addDays(2)),
      String.valueOf(ChronoPlainDate.addDays(value.toDate(), 2)),
      'addDays native'
    );
    Assert.areEqual(
      String.valueOf(value.addMonths(2)),
      String.valueOf(ChronoPlainDate.addMonths(value, 2)),
      'addMonths static'
    );
    Assert.areEqual(
      String.valueOf(value.addMonths(2)),
      String.valueOf(ChronoPlainDate.addMonths(value.toDate(), 2)),
      'addMonths native'
    );
    Assert.areEqual(
      String.valueOf(value.addYears(2)),
      String.valueOf(ChronoPlainDate.addYears(value, 2)),
      'addYears static'
    );
    Assert.areEqual(
      String.valueOf(value.addYears(2)),
      String.valueOf(ChronoPlainDate.addYears(value.toDate(), 2)),
      'addYears native'
    );
    Assert.areEqual(
      String.valueOf(value.toPlainDateTime(Time.newInstance(12, 34, 56, 789))),
      String.valueOf(
        ChronoPlainDate.toPlainDateTime(
          value,
          Time.newInstance(12, 34, 56, 789)
        )
      ),
      'toPlainDateTime static'
    );
    Assert.areEqual(
      String.valueOf(value.toPlainYearMonth()),
      String.valueOf(ChronoPlainDate.toPlainYearMonth(value)),
      'toPlainYearMonth static'
    );
    Assert.areEqual(
      String.valueOf(value.toPlainMonthDay()),
      String.valueOf(ChronoPlainDate.toPlainMonthDay(value)),
      'toPlainMonthDay static'
    );
  }
  @IsTest
  static void plaintimeCallStyles() {
    ChronoPlainTime value = ChronoPlainTime.parse('12:34:56.789');
    Assert.areEqual(
      String.valueOf(value.toTime()),
      String.valueOf(ChronoPlainTime.toTime(value)),
      'toTime static'
    );
    Assert.areEqual(
      String.valueOf(value.addHours(2)),
      String.valueOf(ChronoPlainTime.addHours(value, 2)),
      'addHours static'
    );
    Assert.areEqual(
      String.valueOf(value.addHours(2)),
      String.valueOf(ChronoPlainTime.addHours(value.toTime(), 2)),
      'addHours native'
    );
    Assert.areEqual(
      String.valueOf(value.addMinutes(2)),
      String.valueOf(ChronoPlainTime.addMinutes(value, 2)),
      'addMinutes static'
    );
    Assert.areEqual(
      String.valueOf(value.addMinutes(2)),
      String.valueOf(ChronoPlainTime.addMinutes(value.toTime(), 2)),
      'addMinutes native'
    );
    Assert.areEqual(
      String.valueOf(value.addSeconds(2)),
      String.valueOf(ChronoPlainTime.addSeconds(value, 2)),
      'addSeconds static'
    );
    Assert.areEqual(
      String.valueOf(value.addSeconds(2)),
      String.valueOf(ChronoPlainTime.addSeconds(value.toTime(), 2)),
      'addSeconds native'
    );
    Assert.areEqual(
      String.valueOf(value.addMilliseconds(1234L)),
      String.valueOf(ChronoPlainTime.addMilliseconds(value, 1234L)),
      'addMilliseconds static'
    );
    Assert.areEqual(
      String.valueOf(value.addMilliseconds(1234L)),
      String.valueOf(ChronoPlainTime.addMilliseconds(value.toTime(), 1234L)),
      'addMilliseconds native'
    );
    Assert.areEqual(
      String.valueOf(value.toPlainDateTime(Date.newInstance(2024, 2, 28))),
      String.valueOf(
        ChronoPlainTime.toPlainDateTime(value, Date.newInstance(2024, 2, 28))
      ),
      'toPlainDateTime static'
    );
  }
  @IsTest
  static void plaindatetimeCallStyles() {
    ChronoPlainDateTime value = ChronoPlainDateTime.parse(
      '2024-02-28T12:34:56.789'
    );
    Assert.areEqual(
      String.valueOf(value.toDate()),
      String.valueOf(ChronoPlainDateTime.toDate(value)),
      'toDate static'
    );
    Assert.areEqual(
      String.valueOf(value.toTime()),
      String.valueOf(ChronoPlainDateTime.toTime(value)),
      'toTime static'
    );
    Assert.areEqual(
      String.valueOf(value.toPlainDate()),
      String.valueOf(ChronoPlainDateTime.toPlainDate(value)),
      'toPlainDate static'
    );
    Assert.areEqual(
      String.valueOf(value.toPlainTime()),
      String.valueOf(ChronoPlainDateTime.toPlainTime(value)),
      'toPlainTime static'
    );
    Assert.areEqual(
      String.valueOf(value.addDays(2)),
      String.valueOf(ChronoPlainDateTime.addDays(value, 2)),
      'addDays static'
    );
    Assert.areEqual(
      String.valueOf(value.addMonths(2)),
      String.valueOf(ChronoPlainDateTime.addMonths(value, 2)),
      'addMonths static'
    );
    Assert.areEqual(
      String.valueOf(value.addYears(2)),
      String.valueOf(ChronoPlainDateTime.addYears(value, 2)),
      'addYears static'
    );
    Assert.areEqual(
      String.valueOf(value.addHours(2)),
      String.valueOf(ChronoPlainDateTime.addHours(value, 2)),
      'addHours static'
    );
    Assert.areEqual(
      String.valueOf(value.addMinutes(2)),
      String.valueOf(ChronoPlainDateTime.addMinutes(value, 2)),
      'addMinutes static'
    );
    Assert.areEqual(
      String.valueOf(value.addMilliseconds(1234L)),
      String.valueOf(ChronoPlainDateTime.addMilliseconds(value, 1234L)),
      'addMilliseconds static'
    );
    Assert.areEqual(
      String.valueOf(value.toZonedDateTime('Europe/London')),
      String.valueOf(
        ChronoPlainDateTime.toZonedDateTime(value, 'Europe/London')
      ),
      'toZonedDateTime static'
    );
    Assert.areEqual(
      String.valueOf(value.toZonedDateTime('Europe/London', 'earlier')),
      String.valueOf(
        ChronoPlainDateTime.toZonedDateTime(value, 'Europe/London', 'earlier')
      ),
      'toZonedDateTime static'
    );
    Assert.areEqual(
      String.valueOf(value.add(ChronoDuration.ofHours(2))),
      String.valueOf(ChronoPlainDateTime.add(value, ChronoDuration.ofHours(2))),
      'add static'
    );
  }
  @IsTest
  static void instantCallStyles() {
    ChronoInstant value = ChronoInstant.parse('2024-02-28T12:34:56.789Z');
    Assert.areEqual(
      String.valueOf(value.toDatetime()),
      String.valueOf(ChronoInstant.toDatetime(value)),
      'toDatetime static'
    );
    Assert.areEqual(
      String.valueOf(value.addHours(2)),
      String.valueOf(ChronoInstant.addHours(value, 2)),
      'addHours static'
    );
    Assert.areEqual(
      String.valueOf(value.addHours(2)),
      String.valueOf(ChronoInstant.addHours(value.toDatetime(), 2)),
      'addHours native'
    );
    Assert.areEqual(
      String.valueOf(value.addMinutes(2)),
      String.valueOf(ChronoInstant.addMinutes(value, 2)),
      'addMinutes static'
    );
    Assert.areEqual(
      String.valueOf(value.addMinutes(2)),
      String.valueOf(ChronoInstant.addMinutes(value.toDatetime(), 2)),
      'addMinutes native'
    );
    Assert.areEqual(
      String.valueOf(value.addSeconds(2)),
      String.valueOf(ChronoInstant.addSeconds(value, 2)),
      'addSeconds static'
    );
    Assert.areEqual(
      String.valueOf(value.addSeconds(2)),
      String.valueOf(ChronoInstant.addSeconds(value.toDatetime(), 2)),
      'addSeconds native'
    );
    Assert.areEqual(
      String.valueOf(value.addMilliseconds(1234L)),
      String.valueOf(ChronoInstant.addMilliseconds(value, 1234L)),
      'addMilliseconds static'
    );
    Assert.areEqual(
      String.valueOf(value.addMilliseconds(1234L)),
      String.valueOf(ChronoInstant.addMilliseconds(value.toDatetime(), 1234L)),
      'addMilliseconds native'
    );
    Assert.areEqual(
      String.valueOf(value.toZonedDateTime('Europe/London')),
      String.valueOf(ChronoInstant.toZonedDateTime(value, 'Europe/London')),
      'toZonedDateTime static'
    );
    Assert.areEqual(
      String.valueOf(value.toZonedDateTime('Europe/London')),
      String.valueOf(
        ChronoInstant.toZonedDateTime(value.toDatetime(), 'Europe/London')
      ),
      'toZonedDateTime native'
    );
    Assert.areEqual(
      String.valueOf(
        value.until(ChronoInstant.parse('2024-02-28T12:34:56.789Z'))
      ),
      String.valueOf(
        ChronoInstant.until(
          value,
          ChronoInstant.parse('2024-02-28T12:34:56.789Z')
        )
      ),
      'until static'
    );
  }
  @IsTest
  static void zoneddatetimeCallStyles() {
    ChronoZonedDateTime value = ChronoZonedDateTime.parse(
      '2024-02-28T12:34:56.789Z[Europe/London]'
    );
    Assert.areEqual(
      String.valueOf(value.toDatetime()),
      String.valueOf(ChronoZonedDateTime.toDatetime(value)),
      'toDatetime static'
    );
    Assert.areEqual(
      String.valueOf(value.getTimeZoneId()),
      String.valueOf(ChronoZonedDateTime.getTimeZoneId(value)),
      'getTimeZoneId static'
    );
    Assert.areEqual(
      String.valueOf(value.toInstant()),
      String.valueOf(ChronoZonedDateTime.toInstant(value)),
      'toInstant static'
    );
    Assert.areEqual(
      String.valueOf(value.toPlainDateTime()),
      String.valueOf(ChronoZonedDateTime.toPlainDateTime(value)),
      'toPlainDateTime static'
    );
    Assert.areEqual(
      String.valueOf(value.toDate()),
      String.valueOf(ChronoZonedDateTime.toDate(value)),
      'toDate static'
    );
    Assert.areEqual(
      String.valueOf(value.toTime()),
      String.valueOf(ChronoZonedDateTime.toTime(value)),
      'toTime static'
    );
    Assert.areEqual(
      String.valueOf(value.withTimeZone('Europe/London')),
      String.valueOf(ChronoZonedDateTime.withTimeZone(value, 'Europe/London')),
      'withTimeZone static'
    );
    Assert.areEqual(
      String.valueOf(value.addHours(2)),
      String.valueOf(ChronoZonedDateTime.addHours(value, 2)),
      'addHours static'
    );
    Assert.areEqual(
      String.valueOf(value.addHours(2)),
      String.valueOf(
        ChronoZonedDateTime.addHours(value.toDatetime(), 'Europe/London', 2)
      ),
      'addHours native'
    );
    Assert.areEqual(
      String.valueOf(value.addMinutes(2)),
      String.valueOf(ChronoZonedDateTime.addMinutes(value, 2)),
      'addMinutes static'
    );
    Assert.areEqual(
      String.valueOf(value.addMinutes(2)),
      String.valueOf(
        ChronoZonedDateTime.addMinutes(value.toDatetime(), 'Europe/London', 2)
      ),
      'addMinutes native'
    );
    Assert.areEqual(
      String.valueOf(value.addSeconds(2)),
      String.valueOf(ChronoZonedDateTime.addSeconds(value, 2)),
      'addSeconds static'
    );
    Assert.areEqual(
      String.valueOf(value.addSeconds(2)),
      String.valueOf(
        ChronoZonedDateTime.addSeconds(value.toDatetime(), 'Europe/London', 2)
      ),
      'addSeconds native'
    );
    Assert.areEqual(
      String.valueOf(value.addMilliseconds(1234L)),
      String.valueOf(ChronoZonedDateTime.addMilliseconds(value, 1234L)),
      'addMilliseconds static'
    );
    Assert.areEqual(
      String.valueOf(value.addDays(2)),
      String.valueOf(ChronoZonedDateTime.addDays(value, 2)),
      'addDays static'
    );
    Assert.areEqual(
      String.valueOf(value.addDays(2, 'earlier')),
      String.valueOf(ChronoZonedDateTime.addDays(value, 2, 'earlier')),
      'addDays static'
    );
    Assert.areEqual(
      String.valueOf(value.addMonths(2)),
      String.valueOf(ChronoZonedDateTime.addMonths(value, 2)),
      'addMonths static'
    );
    Assert.areEqual(
      String.valueOf(value.addMonths(2, 'earlier')),
      String.valueOf(ChronoZonedDateTime.addMonths(value, 2, 'earlier')),
      'addMonths static'
    );
    Assert.areEqual(
      String.valueOf(value.addYears(2)),
      String.valueOf(ChronoZonedDateTime.addYears(value, 2)),
      'addYears static'
    );
    Assert.areEqual(
      String.valueOf(value.addYears(2, 'earlier')),
      String.valueOf(ChronoZonedDateTime.addYears(value, 2, 'earlier')),
      'addYears static'
    );
    Assert.areEqual(
      String.valueOf(value.add(ChronoDuration.ofHours(2))),
      String.valueOf(ChronoZonedDateTime.add(value, ChronoDuration.ofHours(2))),
      'add static'
    );
    Assert.areEqual(
      String.valueOf(value.add(ChronoDuration.ofHours(2), 'earlier')),
      String.valueOf(
        ChronoZonedDateTime.add(value, ChronoDuration.ofHours(2), 'earlier')
      ),
      'add static'
    );
    Assert.areEqual(
      String.valueOf(
        value.until(
          ChronoZonedDateTime.parse('2024-02-28T12:34:56.789Z[Europe/London]')
        )
      ),
      String.valueOf(
        ChronoZonedDateTime.until(
          value,
          ChronoZonedDateTime.parse('2024-02-28T12:34:56.789Z[Europe/London]')
        )
      ),
      'until static'
    );
  }
  @IsTest
  static void plainyearmonthCallStyles() {
    ChronoPlainYearMonth value = ChronoPlainYearMonth.parse('2024-02');
    Assert.areEqual(
      String.valueOf(value.toPlainDate(2)),
      String.valueOf(ChronoPlainYearMonth.toPlainDate(value, 2)),
      'toPlainDate static'
    );
    Assert.areEqual(
      String.valueOf(value.addMonths(2)),
      String.valueOf(ChronoPlainYearMonth.addMonths(value, 2)),
      'addMonths static'
    );
  }
  @IsTest
  static void plainmonthdayCallStyles() {
    ChronoPlainMonthDay value = ChronoPlainMonthDay.parse('--02-28');
    Assert.areEqual(
      String.valueOf(value.toPlainDate(2024)),
      String.valueOf(ChronoPlainMonthDay.toPlainDate(value, 2024)),
      'toPlainDate static'
    );
  }
  @IsTest
  static void durationCallStyles() {
    ChronoDuration value = ChronoDuration.ofHours(2);
    Assert.areEqual(
      String.valueOf(value.negated()),
      String.valueOf(ChronoDuration.negated(value)),
      'negated static'
    );
    Assert.areEqual(
      String.valueOf(value.toMilliseconds()),
      String.valueOf(ChronoDuration.toMilliseconds(value)),
      'toMilliseconds static'
    );
  }
}
