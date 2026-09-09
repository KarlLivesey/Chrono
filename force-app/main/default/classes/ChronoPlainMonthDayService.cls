// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Stable public API for PlainMonthDay values. Internal operations own validation and calculations. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoPlainMonthDayService { // NOPMD -- Public overloads retain the existing consumer contract.
  /**
   * @description Constructs an partial date.
   * @param month Month.
   * @param day Day.
   */
  global static ChronoPlainMonthDay create(Integer month, Integer day) {
    return ChronoPlainMonthDayOperations.create(month, day);
  }
  /**
   * @description Parses a partial date.
   * @param value ISO partial date.
   * @return The resulting value.
   */
  global static ChronoPlainMonthDay parseIso(String value) {
    return ChronoPlainMonthDayOperations.parseIso(value);
  }
  /**
   * @description Serialises a partial date.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static String toIsoString(ChronoPlainMonthDay source) {
    return ChronoPlainMonthDayOperations.toIsoString(source);
  }
  /**
   * @description Completes the date, rejecting invalid calendar components.
   * @param year Missing date component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDate toPlainDate(
    ChronoPlainMonthDay source,
    Integer year
  ) {
    return ChronoPlainMonthDayOperations.toPlainDate(source, year);
  }
  /** @description Rejects incomplete or invalid data before use. */
  global static void validate(ChronoPlainMonthDay source) {
    ChronoPlainMonthDayOperations.validate(source);
  }
}
