// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Stable public API for PlainDateTime values. Internal operations own validation and calculations. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoPlainDateTimeService { // NOPMD -- Public overloads retain the existing consumer contract.
  /**
   * @description Constructs a zone-free date and time.
   * @param localDate Local date.
   * @param localTime Local time.
   */
  global static ChronoPlainDateTime create(Date localDate, Time localTime) {
    return ChronoPlainDateTimeOperations.create(localDate, localTime);
  }
  /**
   * @description Parses a zone-free local datetime.
   * @param value ISO local date and time.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime parseIso(String value) {
    return ChronoPlainDateTimeOperations.parseIso(value);
  }
  /**
   * @description Serialises the local date and time.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static String toIsoString(ChronoPlainDateTime source) {
    return ChronoPlainDateTimeOperations.toIsoString(source);
  }
  /**
   * @description Returns the local component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static Date toDate(ChronoPlainDateTime source) {
    return ChronoPlainDateTimeOperations.toDate(source);
  }
  /**
   * @description Returns the local component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static Time toTime(ChronoPlainDateTime source) {
    return ChronoPlainDateTimeOperations.toTime(source);
  }
  /**
   * @description Returns the local component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDate toPlainDate(ChronoPlainDateTime source) {
    return ChronoPlainDateTimeOperations.toPlainDate(source);
  }
  /**
   * @description Returns the local component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainTime toPlainTime(ChronoPlainDateTime source) {
    return ChronoPlainDateTimeOperations.toPlainTime(source);
  }
  /**
   * @description Adds calendar days.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime addDays(
    ChronoPlainDateTime source,
    Integer amount
  ) {
    return ChronoPlainDateTimeOperations.addDays(source, amount);
  }
  /**
   * @description Adds calendar months.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime addMonths(
    ChronoPlainDateTime source,
    Integer amount
  ) {
    return ChronoPlainDateTimeOperations.addMonths(source, amount);
  }
  /**
   * @description Adds calendar years.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime addYears(
    ChronoPlainDateTime source,
    Integer amount
  ) {
    return ChronoPlainDateTimeOperations.addYears(source, amount);
  }
  /**
   * @description Adds wall-clock hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime addHours(
    ChronoPlainDateTime source,
    Integer amount
  ) {
    return ChronoPlainDateTimeOperations.addHours(source, amount);
  }
  /**
   * @description Adds wall-clock minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime addMinutes(
    ChronoPlainDateTime source,
    Integer amount
  ) {
    return ChronoPlainDateTimeOperations.addMinutes(source, amount);
  }
  /**
   * @description Adds wall-clock milliseconds, carrying across midnight.
   * @param amount Signed wall-clock milliseconds.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime addMilliseconds(
    ChronoPlainDateTime source,
    Long amount
  ) {
    return ChronoPlainDateTimeOperations.addMilliseconds(source, amount);
  }
  /**
   * @description Resolves the local datetime; rejects skipped or repeated times.
   * @param zoneId Salesforce time-zone ID.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime toZonedDateTime(
    ChronoPlainDateTime source,
    String zoneId
  ) {
    return ChronoPlainDateTimeOperations.toZonedDateTime(source, zoneId);
  }
  /**
   * @description Resolves local time in the supplied zone; nonexistent times always reject.
   * @param zoneId Salesforce time-zone ID.
   * @param source Value to operate on; validated before use.
   * @param disambiguation reject (also the null/omitted default), earlier or later for repeated times.
   * @return A new zoned value. Throws ChronoException for invalid data, zones or policies, gaps, or rejected overlaps.
   */
  global static ChronoZonedDateTime toZonedDateTime(
    ChronoPlainDateTime source,
    String zoneId,
    String disambiguation
  ) {
    return ChronoPlainDateTimeOperations.toZonedDateTime(
      source,
      zoneId,
      disambiguation
    );
  }
  /**
   * @description Adds months, then days, then wall-clock milliseconds.
   * @param duration Amount to add.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime add(
    ChronoPlainDateTime source,
    ChronoDuration duration
  ) {
    return ChronoPlainDateTimeOperations.add(source, duration);
  }
  /** @description Rejects incomplete or invalid data before use. */
  global static void validate(ChronoPlainDateTime source) {
    ChronoPlainDateTimeOperations.validate(source);
  }
}
