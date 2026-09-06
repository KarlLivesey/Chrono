// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal evaluation of Salesforce holiday recurrence dates. */
public with sharing class ChronoHolidays {
  private static final List<String> MONTHS = new List<String>{
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  };
  private static final List<Integer> DAY_BITS = new List<Integer>{
    1,
    2,
    4,
    8,
    16,
    32,
    64
  };
  public static Integer weekday(Date day) {
    return Math.mod(
      Math.mod(Date.newInstance(1900, 1, 7).daysBetween(day), 7) + 7,
      7
    );
  }
  public static Boolean occurs(Holiday holiday, Date day) {
    if (!holiday.IsRecurrence) {
      return holiday.ActivityDate == day;
    }
    Date start = holiday.RecurrenceStartDate;
    if (start == null) {
      throw new ChronoException('Recurring holiday has no start date.');
    }
    if (
      day < start ||
      (holiday.RecurrenceEndDateOnly != null &&
      day > holiday.RecurrenceEndDateOnly)
    ) {
      return false;
    }
    return matchesRecurrence(holiday, day, recurrenceInterval(holiday));
  }
  private static Integer recurrenceInterval(Holiday holiday) {
    Integer interval = holiday.RecurrenceInterval == null
      ? 1
      : holiday.RecurrenceInterval;
    if (interval < 1) {
      throw new ChronoException(
        'Holiday recurrence interval must be positive.'
      );
    }
    return interval;
  }
  private static Boolean matchesRecurrence(
    Holiday holiday,
    Date day,
    Integer interval
  ) {
    Date start = holiday.RecurrenceStartDate;
    switch on holiday.RecurrenceType {
      when 'RecursDaily' {
        return Math.mod(start.daysBetween(day), interval) == 0;
      }
      when 'RecursEveryWeekday' {
        return weekday(day) >= 1 && weekday(day) <= 5;
      }
      when 'RecursWeekly' {
        Integer weeks =
          start.addDays(-weekday(start))
            .daysBetween(day.addDays(-weekday(day))) / 7;
        return Math.mod(weeks, interval) == 0 && matchesWeekday(holiday, day);
      }
      when 'RecursMonthly', 'RecursMonthlyNth' {
        Integer months =
          (day.year() - start.year()) * 12 +
          day.month() -
          start.month();
        return Math.mod(months, interval) == 0 && matchesMonthDay(holiday, day);
      }
      when 'RecursYearly', 'RecursYearlyNth' {
        return Math.mod(day.year() - start.year(), interval) == 0 &&
          MONTHS[day.month() - 1] == holiday.RecurrenceMonthOfYear &&
          matchesMonthDay(holiday, day);
      }
      when else {
        throw new ChronoException(
          'Unsupported holiday recurrence: ' + holiday.RecurrenceType
        );
      }
    }
  }
  private static Boolean matchesWeekday(Holiday holiday, Date day) {
    if (holiday.RecurrenceDayOfWeekMask == null) {
      throw new ChronoException('Recurring holiday has no weekday mask.');
    }
    return Math.mod(
        holiday.RecurrenceDayOfWeekMask / DAY_BITS[weekday(day)],
        2
      ) == 1;
  }
  private static Boolean matchesMonthDay(Holiday holiday, Date day) {
    if (!holiday.RecurrenceType.endsWith('Nth')) {
      return day.day() == holiday.RecurrenceDayOfMonth;
    }
    if (holiday.RecurrenceDayOfWeekMask == 127) {
      return matchesAnyDay(holiday, day);
    }
    if (!matchesWeekday(holiday, day)) {
      return false;
    }
    if (holiday.RecurrenceInstance == 'Last') {
      return day.addDays(7).month() != day.month();
    }
    List<String> instances = new List<String>{
      'First',
      'Second',
      'Third',
      'Fourth'
    };
    Integer occurrence = instances.indexOf(holiday.RecurrenceInstance) + 1;
    if (occurrence == 0) {
      throw new ChronoException('Invalid holiday recurrence instance.');
    }
    return (day.day() - 1) / 7 + 1 == occurrence;
  }

  private static Boolean matchesAnyDay(Holiday holiday, Date day) {
    if (holiday.RecurrenceInstance == 'Last') {
      return day.addDays(1).month() != day.month();
    }
    List<String> instances = new List<String>{
      'First',
      'Second',
      'Third',
      'Fourth'
    };
    Integer occurrence = instances.indexOf(holiday.RecurrenceInstance) + 1;
    if (occurrence == 0) {
      throw new ChronoException('Invalid holiday recurrence instance.');
    }
    return day.day() == occurrence;
  }
}
