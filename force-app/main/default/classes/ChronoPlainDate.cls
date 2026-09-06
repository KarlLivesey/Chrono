// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/**
 * @description An immutable Date value.
 */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Deliberate subscriber-facing managed-package API.
global with sharing class ChronoPlainDate { // NOPMD - Aggregate complexity counts required delegating overloads; per-method rules remain active.
  private final Date value;
  /**
   * @description Constructs an immutable date value.
   * @param value Native Salesforce value.
   */
  global ChronoPlainDate(Date value) {
    ChronoSupport.requireValue(value, 'Value');
    this.value = value;
  }
  /**
   * @description Parses an ISO representation.
   * @param value ISO representation.
   * @return The resulting value.
   */
  global static ChronoPlainDate parse(String value) {
    return new ChronoPlainDate(ChronoIso.parseDate(value));
  }
  /**
   * @description Serialises an ISO representation.
   * @return The resulting value.
   */
  global override String toString() {
    return ChronoIso.dateText(value);
  }
  /**
   * @description Returns the native Salesforce value.
   * @return The resulting value.
   */
  global Date toDate() {
    return value;
  }
  /**
   * @description Returns the native Salesforce value.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static Date toDate(ChronoPlainDate source) {
    return source.toDate();
  }
  /**
   * @description Adds calendar days using native date arithmetic.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoPlainDate addDays(Integer amount) {
    return new ChronoPlainDate(value.addDays(amount));
  }
  /**
   * @description Adds calendar days using native date arithmetic.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainDate addDays(
    ChronoPlainDate source,
    Integer amount
  ) {
    return source.addDays(amount);
  }
  /**
   * @description Adds calendar days using native date arithmetic.
   * @param source Native value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainDate addDays(Date source, Integer amount) {
    return new ChronoPlainDate(source).addDays(amount);
  }
  /**
   * @description Adds calendar months using native date arithmetic.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoPlainDate addMonths(Integer amount) {
    return new ChronoPlainDate(value.addMonths(amount));
  }
  /**
   * @description Adds calendar months using native date arithmetic.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainDate addMonths(
    ChronoPlainDate source,
    Integer amount
  ) {
    return source.addMonths(amount);
  }
  /**
   * @description Adds calendar months using native date arithmetic.
   * @param source Native value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainDate addMonths(Date source, Integer amount) {
    return new ChronoPlainDate(source).addMonths(amount);
  }
  /**
   * @description Adds calendar years using native date arithmetic.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoPlainDate addYears(Integer amount) {
    return new ChronoPlainDate(value.addYears(amount));
  }
  /**
   * @description Adds calendar years using native date arithmetic.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainDate addYears(
    ChronoPlainDate source,
    Integer amount
  ) {
    return source.addYears(amount);
  }
  /**
   * @description Adds calendar years using native date arithmetic.
   * @param source Native value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainDate addYears(Date source, Integer amount) {
    return new ChronoPlainDate(source).addYears(amount);
  }
  /**
   * @description Combines this date with a local time.
   * @param localTime Local time.
   * @return The resulting value.
   */
  global ChronoPlainDateTime toPlainDateTime(Time localTime) {
    return new ChronoPlainDateTime(value, localTime);
  }
  /**
   * @description Combines this date with a local time.
   * @param source Value to operate on.
   * @param localTime Local time.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime toPlainDateTime(
    ChronoPlainDate source,
    Time localTime
  ) {
    return source.toPlainDateTime(localTime);
  }
  /**
   * @description Extracts the year and month.
   * @return The resulting value.
   */
  global ChronoPlainYearMonth toPlainYearMonth() {
    return new ChronoPlainYearMonth(value.year(), value.month());
  }
  /**
   * @description Extracts the year and month.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static ChronoPlainYearMonth toPlainYearMonth(ChronoPlainDate source) {
    return source.toPlainYearMonth();
  }
  /**
   * @description Extracts the month and day.
   * @return The resulting value.
   */
  global ChronoPlainMonthDay toPlainMonthDay() {
    return new ChronoPlainMonthDay(value.month(), value.day());
  }
  /**
   * @description Extracts the month and day.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static ChronoPlainMonthDay toPlainMonthDay(ChronoPlainDate source) {
    return source.toPlainMonthDay();
  }
}
