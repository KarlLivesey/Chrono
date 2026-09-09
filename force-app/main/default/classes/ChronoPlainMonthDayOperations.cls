// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal implementation; callers use ChronoPlainMonthDayService. Validates data before use. */
public with sharing class ChronoPlainMonthDayOperations {
  /**
   * @description Constructs an partial date.
   * @param month Month.
   * @param day Day.
   */
  public static ChronoPlainMonthDay create(Integer month, Integer day) {
    ChronoPlainMonthDay result = new ChronoPlainMonthDay();

    result.month = month;
    result.day = day;
    validate(result);
    return result;
  }
  /**
   * @description Parses a partial date.
   * @param value ISO partial date.
   * @return The resulting value.
   */
  public static ChronoPlainMonthDay parseIso(String value) {
    ChronoSupport.requireMatch(value, '--\\d{2}-\\d{2}', 'partial date');
    List<String> parts = value.substring(2).split('-');
    return ChronoPlainMonthDayOperations.create(
      Integer.valueOf(parts[0]),
      Integer.valueOf(parts[1])
    );
  }
  /**
   * @description Serialises a partial date.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static String toIsoString(ChronoPlainMonthDay source) {
    ChronoPlainMonthDayOperations.validate(source);
    return '--' +
      ChronoIso.pad(source.month, 2) +
      '-' +
      ChronoIso.pad(source.day, 2);
  }
  /**
   * @description Completes the date, rejecting invalid calendar components.
   * @param year Missing date component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDate toPlainDate(
    ChronoPlainMonthDay source,
    Integer year
  ) {
    ChronoPlainMonthDayOperations.validate(source);
    ChronoSupport.requireValue(year, 'Year');
    if (
      year < 1 ||
      year > 9999 ||
      source.day > Date.daysInMonth(year, source.month)
    ) {
      throw new ChronoException(
        'This month and day do not exist in the requested year.'
      );
    }
    Date completed = Date.newInstance(year, source.month, source.day);
    if (
      completed.year() != year ||
      completed.month() != source.month ||
      completed.day() != source.day
    ) {
      throw new ChronoException(
        'This month and day do not exist in the requested year.'
      );
    }
    return ChronoPlainDateOperations.create(completed);
  }
  /** @description Rejects incomplete or invalid data before use. */
  public static void validate(ChronoPlainMonthDay source) {
    ChronoSupport.requireValue(source, 'Value');
    ChronoSupport.requireValue(source.month, 'Month');
    ChronoSupport.requireValue(source.day, 'Day');
    if (source.month < 1 || source.month > 12) {
      throw new ChronoException('Month must be 1–12.');
    }
    if (source.day < 1 || source.day > Date.daysInMonth(2000, source.month)) {
      throw new ChronoException('Invalid day for this month.');
    }
  }
}
