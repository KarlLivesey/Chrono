// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/**
 * @description An immutable Time value.
 */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Deliberate subscriber-facing managed-package API.
global with sharing class ChronoPlainTime { // NOPMD - Aggregate complexity counts required delegating overloads; per-method rules remain active.
  private final Time value;
  /**
   * @description Constructs an immutable time value.
   * @param value Native Salesforce value.
   */
  global ChronoPlainTime(Time value) {
    ChronoSupport.requireValue(value, 'Value');
    this.value = value;
  }
  /**
   * @description Parses an ISO representation.
   * @param value ISO representation.
   * @return The resulting value.
   */
  global static ChronoPlainTime parse(String value) {
    return new ChronoPlainTime(ChronoIso.parseTime(value));
  }
  /**
   * @description Serialises an ISO representation.
   * @return The resulting value.
   */
  global override String toString() {
    return ChronoIso.timeText(value);
  }
  /**
   * @description Returns the native Salesforce value.
   * @return The resulting value.
   */
  global Time toTime() {
    return value;
  }
  /**
   * @description Returns the native Salesforce value.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static Time toTime(ChronoPlainTime source) {
    return source.toTime();
  }
  /**
   * @description Adds hours and wraps at midnight.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoPlainTime addHours(Integer amount) {
    return addMilliseconds(((Long) amount) * 3600000L);
  }
  /**
   * @description Adds hours and wraps at midnight.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainTime addHours(
    ChronoPlainTime source,
    Integer amount
  ) {
    return source.addHours(amount);
  }
  /**
   * @description Adds hours and wraps at midnight.
   * @param source Native value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainTime addHours(Time source, Integer amount) {
    return new ChronoPlainTime(source).addHours(amount);
  }
  /**
   * @description Adds minutes and wraps at midnight.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoPlainTime addMinutes(Integer amount) {
    return addMilliseconds(((Long) amount) * 60000L);
  }
  /**
   * @description Adds minutes and wraps at midnight.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainTime addMinutes(
    ChronoPlainTime source,
    Integer amount
  ) {
    return source.addMinutes(amount);
  }
  /**
   * @description Adds minutes and wraps at midnight.
   * @param source Native value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainTime addMinutes(Time source, Integer amount) {
    return new ChronoPlainTime(source).addMinutes(amount);
  }
  /**
   * @description Adds seconds and wraps at midnight.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoPlainTime addSeconds(Integer amount) {
    return addMilliseconds(((Long) amount) * 1000L);
  }
  /**
   * @description Adds seconds and wraps at midnight.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainTime addSeconds(
    ChronoPlainTime source,
    Integer amount
  ) {
    return source.addSeconds(amount);
  }
  /**
   * @description Adds seconds and wraps at midnight.
   * @param source Native value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainTime addSeconds(Time source, Integer amount) {
    return new ChronoPlainTime(source).addSeconds(amount);
  }
  /**
   * @description Adds milliseconds and wraps at midnight.
   * @param amount Signed milliseconds.
   * @return The resulting value.
   */
  global ChronoPlainTime addMilliseconds(Long amount) {
    ChronoSupport.requireValue(amount, 'Milliseconds');
    return new ChronoPlainTime(
      value.addMilliseconds(Math.mod(amount, 86400000L).intValue())
    );
  }
  /**
   * @description Adds milliseconds and wraps at midnight.
   * @param source Value to operate on.
   * @param amount Signed milliseconds.
   * @return The resulting value.
   */
  global static ChronoPlainTime addMilliseconds(
    ChronoPlainTime source,
    Long amount
  ) {
    return source.addMilliseconds(amount);
  }
  /**
   * @description Adds milliseconds and wraps at midnight.
   * @param source Native value to operate on.
   * @param amount Signed milliseconds.
   * @return The resulting value.
   */
  global static ChronoPlainTime addMilliseconds(Time source, Long amount) {
    return new ChronoPlainTime(source).addMilliseconds(amount);
  }
  /**
   * @description Combines this time with a local date.
   * @param localDate Local date.
   * @return The resulting value.
   */
  global ChronoPlainDateTime toPlainDateTime(Date localDate) {
    return new ChronoPlainDateTime(localDate, value);
  }
  /**
   * @description Combines this time with a local date.
   * @param source Value to operate on.
   * @param localDate Local date.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime toPlainDateTime(
    ChronoPlainTime source,
    Date localDate
  ) {
    return source.toPlainDateTime(localDate);
  }
}
