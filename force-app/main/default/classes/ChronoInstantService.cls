// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Stable public API for Instant values. Internal operations own validation and calculations. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoInstantService { // NOPMD -- Public overloads retain the existing consumer contract.
  /**
   * @description Constructs an datetime value.
   * @param value Native Salesforce value.
   */
  global static ChronoInstant create(Datetime value) {
    return ChronoInstantOperations.create(value);
  }
  /**
   * @description Parses an ISO representation.
   * @param value ISO representation.
   * @return The resulting value.
   */
  global static ChronoInstant parseIso(String value) {
    return ChronoInstantOperations.parseIso(value);
  }
  /**
   * @description Serialises an ISO representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static String toIsoString(ChronoInstant source) {
    return ChronoInstantOperations.toIsoString(source);
  }
  /**
   * @description Returns the native Salesforce value.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static Datetime toDatetime(ChronoInstant source) {
    return ChronoInstantOperations.toDatetime(source);
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoInstant addHours(ChronoInstant source, Integer amount) {
    return ChronoInstantOperations.addHours(source, amount);
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoInstant addHours(Datetime source, Integer amount) {
    return ChronoInstantOperations.addHours(source, amount);
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoInstant addMinutes(ChronoInstant source, Integer amount) {
    return ChronoInstantOperations.addMinutes(source, amount);
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoInstant addMinutes(Datetime source, Integer amount) {
    return ChronoInstantOperations.addMinutes(source, amount);
  }
  /**
   * @description Adds elapsed seconds.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoInstant addSeconds(ChronoInstant source, Integer amount) {
    return ChronoInstantOperations.addSeconds(source, amount);
  }
  /**
   * @description Adds elapsed seconds.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoInstant addSeconds(Datetime source, Integer amount) {
    return ChronoInstantOperations.addSeconds(source, amount);
  }
  /**
   * @description Adds elapsed milliseconds.
   * @param amount Signed elapsed milliseconds.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoInstant addMilliseconds(
    ChronoInstant source,
    Long amount
  ) {
    return ChronoInstantOperations.addMilliseconds(source, amount);
  }
  /**
   * @description Adds elapsed milliseconds.
   * @param amount Signed elapsed milliseconds.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoInstant addMilliseconds(Datetime source, Long amount) {
    return ChronoInstantOperations.addMilliseconds(source, amount);
  }
  /**
   * @description Views this instant in a time zone.
   * @param zoneId Salesforce time-zone ID.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime toZonedDateTime(
    ChronoInstant source,
    String zoneId
  ) {
    return ChronoInstantOperations.toZonedDateTime(source, zoneId);
  }
  /**
   * @description Views this instant in a time zone.
   * @param zoneId Salesforce time-zone ID.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime toZonedDateTime(
    Datetime source,
    String zoneId
  ) {
    return ChronoInstantOperations.toZonedDateTime(source, zoneId);
  }
  /**
   * @description Returns the elapsed difference to another instant.
   * @param other End instant.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoDuration elapsedDifference(
    ChronoInstant source,
    ChronoInstant other
  ) {
    return ChronoInstantOperations.elapsedDifference(source, other);
  }
  /** @description Rejects incomplete or invalid data before use. */
  global static void validate(ChronoInstant source) {
    ChronoInstantOperations.validate(source);
  }
}
