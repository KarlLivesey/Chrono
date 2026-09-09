// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Stable public API for PlainTime values. Internal operations own validation and calculations. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoPlainTimeService { // NOPMD -- Public overloads retain the existing consumer contract.
  /**
   * @description Constructs an time value.
   * @param value Native Salesforce value.
   */
  global static ChronoPlainTime create(Time value) {
    return ChronoPlainTimeOperations.create(value);
  }
  /**
   * @description Parses an ISO representation.
   * @param value ISO representation.
   * @return The resulting value.
   */
  global static ChronoPlainTime parseIso(String value) {
    return ChronoPlainTimeOperations.parseIso(value);
  }
  /**
   * @description Serialises an ISO representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static String toIsoString(ChronoPlainTime source) {
    return ChronoPlainTimeOperations.toIsoString(source);
  }
  /**
   * @description Returns the native Salesforce value.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static Time toTime(ChronoPlainTime source) {
    return ChronoPlainTimeOperations.toTime(source);
  }
  /**
   * @description Adds hours and wraps at midnight.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainTime addHours(
    ChronoPlainTime source,
    Integer amount
  ) {
    return ChronoPlainTimeOperations.addHours(source, amount);
  }
  /**
   * @description Adds hours and wraps at midnight.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainTime addHours(Time source, Integer amount) {
    return ChronoPlainTimeOperations.addHours(source, amount);
  }
  /**
   * @description Adds minutes and wraps at midnight.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainTime addMinutes(
    ChronoPlainTime source,
    Integer amount
  ) {
    return ChronoPlainTimeOperations.addMinutes(source, amount);
  }
  /**
   * @description Adds minutes and wraps at midnight.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainTime addMinutes(Time source, Integer amount) {
    return ChronoPlainTimeOperations.addMinutes(source, amount);
  }
  /**
   * @description Adds seconds and wraps at midnight.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainTime addSeconds(
    ChronoPlainTime source,
    Integer amount
  ) {
    return ChronoPlainTimeOperations.addSeconds(source, amount);
  }
  /**
   * @description Adds seconds and wraps at midnight.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainTime addSeconds(Time source, Integer amount) {
    return ChronoPlainTimeOperations.addSeconds(source, amount);
  }
  /**
   * @description Adds milliseconds and wraps at midnight.
   * @param amount Signed milliseconds.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainTime addMilliseconds(
    ChronoPlainTime source,
    Long amount
  ) {
    return ChronoPlainTimeOperations.addMilliseconds(source, amount);
  }
  /**
   * @description Adds milliseconds and wraps at midnight.
   * @param amount Signed milliseconds.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainTime addMilliseconds(Time source, Long amount) {
    return ChronoPlainTimeOperations.addMilliseconds(source, amount);
  }
  /**
   * @description Combines this time with a local date.
   * @param localDate Local date.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime toPlainDateTime(
    ChronoPlainTime source,
    Date localDate
  ) {
    return ChronoPlainTimeOperations.toPlainDateTime(source, localDate);
  }
  /** @description Rejects incomplete or invalid data before use. */
  global static void validate(ChronoPlainTime source) {
    ChronoPlainTimeOperations.validate(source);
  }
}
