// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Stable public API for PlainYearMonth values. Internal operations own validation and calculations. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoPlainYearMonthService { // NOPMD -- Public overloads retain the existing consumer contract.
  /**
   * @description Constructs an partial date.
   * @param year Year.
   * @param month Month.
   */
  global static ChronoPlainYearMonth create(Integer year, Integer month) {
    return ChronoPlainYearMonthOperations.create(year, month);
  }
  /**
   * @description Parses a partial date.
   * @param value ISO partial date.
   * @return The resulting value.
   */
  global static ChronoPlainYearMonth parseIso(String value) {
    return ChronoPlainYearMonthOperations.parseIso(value);
  }
  /**
   * @description Serialises a partial date.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static String toIsoString(ChronoPlainYearMonth source) {
    return ChronoPlainYearMonthOperations.toIsoString(source);
  }
  /**
   * @description Completes the date, rejecting invalid calendar components.
   * @param day Missing date component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDate toPlainDate(
    ChronoPlainYearMonth source,
    Integer day
  ) {
    return ChronoPlainYearMonthOperations.toPlainDate(source, day);
  }
  /**
   * @description Adds calendar months.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainYearMonth addMonths(
    ChronoPlainYearMonth source,
    Integer amount
  ) {
    return ChronoPlainYearMonthOperations.addMonths(source, amount);
  }
  /** @description Rejects incomplete or invalid data before use. */
  global static void validate(ChronoPlainYearMonth source) {
    ChronoPlainYearMonthOperations.validate(source);
  }
}
