// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoHolidaysTest {
  private static Holiday recurring(String kind) {
    return new Holiday(
      IsRecurrence = true,
      RecurrenceType = kind,
      RecurrenceStartDate = Date.newInstance(2026, 1, 1),
      RecurrenceInterval = 1,
      IsAllDay = true
    );
  }
  @IsTest
  static void dailyWeeklyAndBounds() {
    Holiday daily = recurring('RecursDaily');
    daily.RecurrenceInterval = 2;
    Assert.isTrue(
      ChronoHolidays.occurs(daily, Date.newInstance(2026, 1, 3)),
      'Every second day'
    );
    Assert.isFalse(
      ChronoHolidays.occurs(daily, Date.newInstance(2026, 1, 2)),
      'Intervening day'
    );
    Assert.isFalse(
      ChronoHolidays.occurs(daily, Date.newInstance(2025, 12, 31)),
      'Before start'
    );
    daily.RecurrenceEndDateOnly = Date.newInstance(2026, 1, 3);
    Assert.isFalse(
      ChronoHolidays.occurs(daily, Date.newInstance(2026, 1, 5)),
      'After end'
    );
    Holiday weekdays = recurring('RecursEveryWeekday');
    Assert.isTrue(
      ChronoHolidays.occurs(weekdays, Date.newInstance(2026, 1, 2)),
      'Friday'
    );
    Assert.isFalse(
      ChronoHolidays.occurs(weekdays, Date.newInstance(2026, 1, 3)),
      'Saturday'
    );
    Holiday weekly = recurring('RecursWeekly');
    weekly.RecurrenceDayOfWeekMask = 10;
    weekly.RecurrenceInterval = 2;
    Assert.isTrue(
      ChronoHolidays.occurs(weekly, Date.newInstance(2026, 1, 12)),
      'Alternate week Monday'
    );
    Assert.isTrue(
      ChronoHolidays.occurs(weekly, Date.newInstance(2026, 1, 14)),
      'Alternate week Wednesday'
    );
    Assert.isFalse(
      ChronoHolidays.occurs(weekly, Date.newInstance(2026, 1, 5)),
      'Excluded week'
    );
  }
  @IsTest
  static void monthlyAndAnnualDates() {
    Holiday monthly = recurring('RecursMonthly');
    monthly.RecurrenceDayOfMonth = 31;
    Assert.isTrue(
      ChronoHolidays.occurs(monthly, Date.newInstance(2026, 1, 31)),
      'Month day'
    );
    Assert.isFalse(
      ChronoHolidays.occurs(monthly, Date.newInstance(2026, 2, 28)),
      'No invented February 31'
    );
    Holiday nth = recurring('RecursMonthlyNth');
    nth.RecurrenceDayOfWeekMask = 2;
    nth.RecurrenceInstance = 'Last';
    Assert.isTrue(
      ChronoHolidays.occurs(nth, Date.newInstance(2026, 8, 31)),
      'Last Monday in August'
    );
    Assert.isFalse(
      ChronoHolidays.occurs(nth, Date.newInstance(2026, 8, 24)),
      'Penultimate Monday'
    );
    nth.RecurrenceInstance = 'Second';
    Assert.isTrue(
      ChronoHolidays.occurs(nth, Date.newInstance(2026, 8, 10)),
      'Second Monday'
    );
    Holiday yearly = recurring('RecursYearly');
    yearly.RecurrenceMonthOfYear = 'December';
    yearly.RecurrenceDayOfMonth = 25;
    Assert.isTrue(
      ChronoHolidays.occurs(yearly, Date.newInstance(2026, 12, 25)),
      'Christmas'
    );
    Assert.isFalse(
      ChronoHolidays.occurs(yearly, Date.newInstance(2026, 11, 25)),
      'Wrong month'
    );
    Holiday annualNth = recurring('RecursYearlyNth');
    annualNth.RecurrenceMonthOfYear = 'August';
    annualNth.RecurrenceInstance = 'Last';
    annualNth.RecurrenceDayOfWeekMask = 2;
    Assert.isTrue(
      ChronoHolidays.occurs(annualNth, Date.newInstance(2027, 8, 30)),
      'Next annual bank holiday'
    );
  }
  @IsTest
  static void missingRecurrenceDetailsFailClearly() {
    Holiday invalid = recurring('RecursWeekly');
    try {
      ChronoHolidays.occurs(invalid, Date.newInstance(2026, 1, 5));
      Assert.fail('Missing weekday mask');
    } catch (ChronoException expected) {
      Assert.isTrue(
        expected.getMessage().contains('mask'),
        'Missing mask diagnostic'
      );
    }
    invalid.RecurrenceInterval = 0;
    try {
      ChronoHolidays.occurs(invalid, Date.newInstance(2026, 1, 5));
      Assert.fail('Invalid interval');
    } catch (ChronoException expected) {
      Assert.isTrue(
        expected.getMessage().contains('positive'),
        'Interval diagnostic'
      );
    }
  }

  @IsTest
  static void anyDayMonthlyAndYearlyOrdinal() {
    Holiday holiday = recurring('RecursMonthlyNth');
    holiday.RecurrenceDayOfWeekMask = 127;
    holiday.RecurrenceInstance = 'Second';
    Assert.isTrue(
      ChronoHolidays.occurs(holiday, Date.newInstance(2026, 2, 2)),
      'Second calendar day'
    );
    Assert.isFalse(
      ChronoHolidays.occurs(holiday, Date.newInstance(2026, 2, 3)),
      'Not every weekday in the second week'
    );
    holiday.RecurrenceInstance = 'Last';
    Assert.isTrue(
      ChronoHolidays.occurs(holiday, Date.newInstance(2026, 2, 28)),
      'Last calendar day'
    );
    Assert.isFalse(
      ChronoHolidays.occurs(holiday, Date.newInstance(2026, 2, 27)),
      'Only the last day'
    );
    holiday.RecurrenceType = 'RecursYearlyNth';
    holiday.RecurrenceMonthOfYear = 'February';
    Assert.isTrue(
      ChronoHolidays.occurs(holiday, Date.newInstance(2028, 2, 29)),
      'Annual last day honours leap year'
    );
  }
}
