// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/**
 * @description An immutable partial date.
 */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Deliberate subscriber-facing managed-package API.
global with sharing class ChronoPlainYearMonth {
  private final Date value;
  /**
   * @description Constructs an immutable partial date.
   * @param year Year.
   * @param month Month.
   */
  global ChronoPlainYearMonth(Integer year, Integer month) {
    value = Date.newInstance(year, month, 1);
    if (value.year() != year || value.month() != month) {
      throw new ChronoException('Invalid partial date components.');
    }
  }
  /**
   * @description Parses a partial date.
   * @param value ISO partial date.
   * @return The resulting value.
   */
  global static ChronoPlainYearMonth parse(String value) {
    ChronoSupport.requireMatch(value, '\\d{4}-\\d{2}', 'partial date');
    List<String> parts = value.split('-');
    return new ChronoPlainYearMonth(
      Integer.valueOf(parts[0]),
      Integer.valueOf(parts[1])
    );
  }
  /**
   * @description Serialises a partial date.
   * @return The resulting value.
   */
  global override String toString() {
    return ChronoIso.pad(value.year(), 4) +
      '-' +
      ChronoIso.pad(value.month(), 2);
  }
  /**
   * @description Completes the date, rejecting invalid calendar components.
   * @param day Missing date component.
   * @return The resulting value.
   */
  global ChronoPlainDate toPlainDate(Integer day) {
    Date completed = Date.newInstance(value.year(), value.month(), day);
    if (completed.month() != value.month() || completed.day() != day) {
      throw new ChronoException('Invalid day for this year and month.');
    }
    return new ChronoPlainDate(completed);
  }
  /**
   * @description Completes the date, rejecting invalid calendar components.
   * @param source Value to operate on.
   * @param day Missing date component.
   * @return The resulting value.
   */
  global static ChronoPlainDate toPlainDate(
    ChronoPlainYearMonth source,
    Integer day
  ) {
    return source.toPlainDate(day);
  }
  /**
   * @description Adds calendar months.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoPlainYearMonth addMonths(Integer amount) {
    Date shifted = value.addMonths(amount);
    return new ChronoPlainYearMonth(shifted.year(), shifted.month());
  }
  /**
   * @description Adds calendar months.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainYearMonth addMonths(
    ChronoPlainYearMonth source,
    Integer amount
  ) {
    return source.addMonths(amount);
  }
}
