// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Stable public API for PlainDate values. Internal operations own validation and calculations. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoPlainDateService { // NOPMD -- Public overloads retain the existing consumer contract.
  /**
   * @description Constructs an date value.
   * @param value Native Salesforce value.
   */
  global static ChronoPlainDate create(Date value) {
    return ChronoPlainDateOperations.create(value);
  }
  /**
   * @description Parses an ISO representation.
   * @param value ISO representation.
   * @return The resulting value.
   */
  global static ChronoPlainDate parseIso(String value) {
    return ChronoPlainDateOperations.parseIso(value);
  }
  /**
   * @description Serialises an ISO representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static String toIsoString(ChronoPlainDate source) {
    return ChronoPlainDateOperations.toIsoString(source);
  }
  /**
   * @description Returns the native Salesforce value.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static Date toDate(ChronoPlainDate source) {
    return ChronoPlainDateOperations.toDate(source);
  }
  /**
   * @description Adds calendar days using native date arithmetic.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDate addDays(
    ChronoPlainDate source,
    Integer amount
  ) {
    return ChronoPlainDateOperations.addDays(source, amount);
  }
  /**
   * @description Adds calendar days using native date arithmetic.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDate addDays(Date source, Integer amount) {
    return ChronoPlainDateOperations.addDays(source, amount);
  }
  /**
   * @description Adds calendar months using native date arithmetic.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDate addMonths(
    ChronoPlainDate source,
    Integer amount
  ) {
    return ChronoPlainDateOperations.addMonths(source, amount);
  }
  /**
   * @description Adds calendar months using native date arithmetic.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDate addMonths(Date source, Integer amount) {
    return ChronoPlainDateOperations.addMonths(source, amount);
  }
  /**
   * @description Adds calendar years using native date arithmetic.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDate addYears(
    ChronoPlainDate source,
    Integer amount
  ) {
    return ChronoPlainDateOperations.addYears(source, amount);
  }
  /**
   * @description Adds calendar years using native date arithmetic.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDate addYears(Date source, Integer amount) {
    return ChronoPlainDateOperations.addYears(source, amount);
  }
  /**
   * @description Combines the date with a local time.
   * @param localTime Local time.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime toPlainDateTime(
    ChronoPlainDate source,
    Time localTime
  ) {
    return ChronoPlainDateOperations.toPlainDateTime(source, localTime);
  }
  /**
   * @description Extracts the year and month.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainYearMonth toPlainYearMonth(ChronoPlainDate source) {
    return ChronoPlainDateOperations.toPlainYearMonth(source);
  }
  /**
   * @description Extracts the month and day.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainMonthDay toPlainMonthDay(ChronoPlainDate source) {
    return ChronoPlainDateOperations.toPlainMonthDay(source);
  }
  /** @description Rejects incomplete or invalid data before use. */
  global static void validate(ChronoPlainDate source) {
    ChronoPlainDateOperations.validate(source);
  }
}
