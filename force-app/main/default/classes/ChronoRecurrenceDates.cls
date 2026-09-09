// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Calendar-only occurrence selection. No timezone conversion or queries. */
public with sharing class ChronoRecurrenceDates {
  public static List<Date> choose(ChronoRecurrenceInput input, Date anchor) {
    switch on input.operation {
      when 'weekday' {
        return new List<Date>{ weekday(input, anchor) };
      }
      when 'nthWeekday' {
        return nthWeekday(input, anchor);
      }
      when 'annual' {
        return annual(input, anchor);
      }
      when else {
        throw new ChronoException('Unsupported calendar occurrence operation.');
      }
    }
  }
  private static Integer direction(String value) {
    String selected = String.isBlank(value) ? 'next' : value;
    ChronoSupport.choice(
      selected,
      new Set<String>{ 'next', 'previous' },
      'direction'
    );
    return selected == 'next' ? 1 : -1;
  }
  private static Date weekday(ChronoRecurrenceInput input, Date anchor) {
    requireWeekday(input.weekday);
    Integer direction = direction(input.direction);
    Integer distance = Math.mod(
      (input.weekday - ChronoRecurrenceRule.weekday(anchor)) * direction + 7,
      7
    );
    if (distance == 0 && input.inclusive != true) {
      distance = 7;
    }
    return anchor.addDays(distance * direction);
  }
  private static List<Date> nthWeekday(
    ChronoRecurrenceInput input,
    Date anchor
  ) {
    requireWeekday(input.weekday);
    requireOrdinal(input.ordinal, 5);
    List<Date> days = new List<Date>();
    Date first = Date.newInstance(anchor.year(), anchor.month(), 1);
    for (
      Integer offset = 0;
      offset < Date.daysInMonth(anchor.year(), anchor.month());
      offset++
    ) {
      Date day = first.addDays(offset);
      if (ChronoRecurrenceRule.weekday(day) == input.weekday) {
        days.add(day);
      }
    }
    return nth(days, input.ordinal);
  }
  private static List<Date> annual(ChronoRecurrenceInput input, Date anchor) {
    ChronoSupport.requireValue(input.month, 'Month');
    ChronoSupport.requireValue(input.day, 'Day');
    ChronoPlainMonthDayService.parseIso(
      '--' + ChronoIso.pad(input.month, 2) + '-' + ChronoIso.pad(input.day, 2)
    );
    Integer direction = direction(input.direction);
    for (Integer offset = 0; offset <= 8; offset++) {
      Integer year = anchor.year() + offset * direction;
      if (input.day > Date.daysInMonth(year, input.month)) {
        continue;
      }
      Date day = Date.newInstance(year, input.month, input.day);
      if (day == anchor && input.inclusive == true) {
        return new List<Date>{ day };
      }
      if (anchor.daysBetween(day) * direction > 0) {
        return new List<Date>{ day };
      }
    }
    return new List<Date>();
  }
  public static List<Date> nth(List<Date> days, Integer ordinal) {
    Integer index = ordinal > 0 ? ordinal - 1 : days.size() + ordinal;
    return index < 0 ||
      index >= days.size()
      ? new List<Date>()
      : new List<Date>{ days[index] };
  }
  public static void requireOrdinal(Integer ordinal, Integer maximum) {
    if (
      ordinal == null ||
      ordinal == 0 ||
      (ordinal < -maximum ||
      ordinal > maximum)
    ) {
      throw new ChronoException(
        'Occurrence must be a nonzero integer between -' +
          maximum +
          ' and ' +
          maximum +
          '.'
      );
    }
  }
  private static void requireWeekday(Integer value) {
    if (value == null || value < 1 || value > 7) {
      throw new ChronoException('Weekday must be 1 Monday through 7 Sunday.');
    }
  }
}
