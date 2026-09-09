// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal implementation; callers use ChronoPlainYearMonthService. Validates data before use. */
public with sharing class ChronoPlainYearMonthOperations {
  /**
   * @description Constructs an partial date.
   * @param year Year.
   * @param month Month.
   */
  public static ChronoPlainYearMonth create(Integer year, Integer month) {
    ChronoPlainYearMonth result = new ChronoPlainYearMonth();

    result.year = year;
    result.month = month;
    validate(result);
    return result;
  }
  /**
   * @description Parses a partial date.
   * @param value ISO partial date.
   * @return The resulting value.
   */
  public static ChronoPlainYearMonth parseIso(String value) {
    ChronoSupport.requireMatch(value, '\\d{4}-\\d{2}', 'partial date');
    List<String> parts = value.split('-');
    return ChronoPlainYearMonthOperations.create(
      Integer.valueOf(parts[0]),
      Integer.valueOf(parts[1])
    );
  }
  /**
   * @description Serialises a partial date.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static String toIsoString(ChronoPlainYearMonth source) {
    ChronoPlainYearMonthOperations.validate(source);
    return ChronoIso.pad(source.year, 4) + '-' + ChronoIso.pad(source.month, 2);
  }
  /**
   * @description Completes the date, rejecting invalid calendar components.
   * @param day Missing date component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDate toPlainDate(
    ChronoPlainYearMonth source,
    Integer day
  ) {
    ChronoPlainYearMonthOperations.validate(source);
    ChronoSupport.requireValue(day, 'Day');
    if (day < 1 || day > Date.daysInMonth(source.year, source.month)) {
      throw new ChronoException('Invalid day for this year and month.');
    }
    Date completed = Date.newInstance(source.year, source.month, day);
    if (completed.month() != source.month || completed.day() != day) {
      throw new ChronoException('Invalid day for this year and month.');
    }
    return ChronoPlainDateOperations.create(completed);
  }
  /**
   * @description Adds calendar months.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainYearMonth addMonths(
    ChronoPlainYearMonth source,
    Integer amount
  ) {
    ChronoPlainYearMonthOperations.validate(source);
    Date shifted = ChronoDates.addMonths(
      Date.newInstance(source.year, source.month, 1),
      amount
    );
    return ChronoPlainYearMonthOperations.create(
      shifted.year(),
      shifted.month()
    );
  }
  /** @description Rejects incomplete or invalid data before use. */
  public static void validate(ChronoPlainYearMonth source) {
    ChronoSupport.requireValue(source, 'Value');
    ChronoSupport.requireValue(source.year, 'Year');
    ChronoSupport.requireValue(source.month, 'Month');
    if (source.month < 1 || source.month > 12) {
      throw new ChronoException('Month must be 1–12.');
    }
    if (source.year < 1 || source.year > 9999) {
      throw new ChronoException('Year must be 1–9999.');
    }
  }
}
