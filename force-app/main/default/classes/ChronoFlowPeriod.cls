// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Calendar boundaries using local dates and real zone transitions, never fixed 24-hour zoned days. */
public with sharing class ChronoFlowPeriod {
  public static ChronoOperationResult execute(ChronoOperationInput input) {
    ChronoOperationValue value = new ChronoOperationValue(input.source);
    ChronoSupport.choice(
      input.unit,
      new Set<String>{ 'day', 'week', 'month', 'quarter', 'year' },
      'period'
    );
    ChronoSupport.choice(
      input.boundary,
      new Set<String>{ 'start', 'end' },
      'boundary'
    );
    Date day = value.wallClock().dateGmt();
    Date start = periodStart(day, input.unit, input.weekStartsOn);
    Date finish = nextPeriod(start, input.unit);
    if (value.source.valueType == 'PlainDate') {
      return new ChronoFlowValue(
          'PlainDate',
          ChronoPlainDateService.create(
            input.boundary == 'start' ? start : finish.addDays(-1)
          )
        )
        .result();
    }
    if (value.isExact()) {
      return value.fromInstant(
        input.boundary == 'start'
          ? startOfDay(start, value.zoneId)
          : Datetime.newInstance(startOfDay(finish, value.zoneId).getTime() - 1)
      );
    }
    Datetime local = Datetime.newInstanceGmt(
      input.boundary == 'start' ? start : finish,
      Time.newInstance(0, 0, 0, 0)
    );
    return value.fromWall(
      input.boundary == 'start'
        ? local
        : Datetime.newInstance(local.getTime() - 1)
    );
  }
  public static Datetime startOfDay(Date day, String zoneId) {
    List<ChronoPickerOption> options = ChronoLocalCandidates.resolveLocal(
      ChronoIso.dateText(day),
      '00:00:00.000',
      zoneId
    );
    // First occurrence starts repeated dates; the forward boundary starts a date whose midnight is skipped.
    return options[0].choice == 'backward'
      ? options[1].instantValue
      : options[0].instantValue;
  }
  public static Date periodStart(Date day, String unit, Integer weekStartsOn) {
    if (unit == 'quarter') {
      return Date.newInstance(day.year(), ((day.month() - 1) / 3) * 3 + 1, 1);
    }
    if (unit == 'month') {
      return Date.newInstance(day.year(), day.month(), 1);
    }
    if (unit == 'year') {
      return Date.newInstance(day.year(), 1, 1);
    }
    if (unit == 'week') {
      Integer first = weekStartsOn == null ? 1 : weekStartsOn;
      if (first < 1 || first > 7) {
        throw new ChronoException(
          'Week starts on must be 1 (Monday) through 7 (Sunday).'
        );
      }
      Integer weekday =
        Math.mod(
          Math.mod(Date.newInstance(1900, 1, 1).daysBetween(day), 7) + 7,
          7
        ) + 1;
      return day.addDays(-Math.mod(weekday - first + 7, 7));
    }
    return day;
  }
  private static Date nextPeriod(Date start, String unit) {
    if (unit == 'year') {
      return start.addYears(1);
    }
    if (unit == 'quarter') {
      return start.addMonths(3);
    }
    if (unit == 'month') {
      return start.addMonths(1);
    }
    return start.addDays(unit == 'week' ? 7 : 1);
  }
}
