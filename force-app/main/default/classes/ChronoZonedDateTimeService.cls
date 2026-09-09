// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Stable public API for ZonedDateTime values. Internal operations own validation and calculations. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoZonedDateTimeService { // NOPMD -- Public overloads retain the existing consumer contract.
  /**
   * @description Constructs an instant with a named time zone.
   * @param instant Native exact instant.
   * @param zoneId Salesforce time-zone ID.
   */
  global static ChronoZonedDateTime create(Datetime instant, String zoneId) {
    return ChronoZonedDateTimeOperations.create(instant, zoneId);
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static Datetime toDatetime(ChronoZonedDateTime source) {
    return ChronoZonedDateTimeOperations.toDatetime(source);
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static String getTimeZoneId(ChronoZonedDateTime source) {
    return ChronoZonedDateTimeOperations.getTimeZoneId(source);
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoInstant toInstant(ChronoZonedDateTime source) {
    return ChronoZonedDateTimeOperations.toInstant(source);
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime toPlainDateTime(
    ChronoZonedDateTime source
  ) {
    return ChronoZonedDateTimeOperations.toPlainDateTime(source);
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static Date toDate(ChronoZonedDateTime source) {
    return ChronoZonedDateTimeOperations.toDate(source);
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static Time toTime(ChronoZonedDateTime source) {
    return ChronoZonedDateTimeOperations.toTime(source);
  }
  /**
   * @description Views the same instant in another zone.
   * @param targetZoneId New Salesforce time-zone ID.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime withTimeZone(
    ChronoZonedDateTime source,
    String targetZoneId
  ) {
    return ChronoZonedDateTimeOperations.withTimeZone(source, targetZoneId);
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addHours(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    return ChronoZonedDateTimeOperations.addHours(source, amount);
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addHours(
    Datetime source,
    String zoneId,
    Integer amount
  ) {
    return ChronoZonedDateTimeOperations.addHours(source, zoneId, amount);
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addMinutes(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    return ChronoZonedDateTimeOperations.addMinutes(source, amount);
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addMinutes(
    Datetime source,
    String zoneId,
    Integer amount
  ) {
    return ChronoZonedDateTimeOperations.addMinutes(source, zoneId, amount);
  }
  /**
   * @description Adds elapsed seconds.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addSeconds(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    return ChronoZonedDateTimeOperations.addSeconds(source, amount);
  }
  /**
   * @description Adds elapsed seconds.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addSeconds(
    Datetime source,
    String zoneId,
    Integer amount
  ) {
    return ChronoZonedDateTimeOperations.addSeconds(source, zoneId, amount);
  }
  /**
   * @description Adds elapsed milliseconds.
   * @param amount Signed elapsed milliseconds.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addMilliseconds(
    ChronoZonedDateTime source,
    Long amount
  ) {
    return ChronoZonedDateTimeOperations.addMilliseconds(source, amount);
  }
  /**
   * @description Adds local calendar days; rejects gaps and overlaps.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addDays(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    return ChronoZonedDateTimeOperations.addDays(source, amount);
  }
  /**
   * @description Adds local calendar days; rejects gaps and overlaps.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addDays(
    ChronoZonedDateTime source,
    Integer amount,
    String disambiguation
  ) {
    return ChronoZonedDateTimeOperations.addDays(
      source,
      amount,
      disambiguation
    );
  }
  /**
   * @description Adds local calendar months; rejects gaps and overlaps.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addMonths(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    return ChronoZonedDateTimeOperations.addMonths(source, amount);
  }
  /**
   * @description Adds local calendar months; rejects gaps and overlaps.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addMonths(
    ChronoZonedDateTime source,
    Integer amount,
    String disambiguation
  ) {
    return ChronoZonedDateTimeOperations.addMonths(
      source,
      amount,
      disambiguation
    );
  }
  /**
   * @description Adds local calendar years; rejects gaps and overlaps.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addYears(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    return ChronoZonedDateTimeOperations.addYears(source, amount);
  }
  /**
   * @description Adds local calendar years; rejects gaps and overlaps.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addYears(
    ChronoZonedDateTime source,
    Integer amount,
    String disambiguation
  ) {
    return ChronoZonedDateTimeOperations.addYears(
      source,
      amount,
      disambiguation
    );
  }
  /**
   * @description Adds months and days locally, then elapsed milliseconds.
   * @param duration Amount to add.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime add(
    ChronoZonedDateTime source,
    ChronoDuration duration
  ) {
    return ChronoZonedDateTimeOperations.add(source, duration);
  }
  /**
   * @description Adds months and days locally, then elapsed milliseconds.
   * @param duration Amount to add.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime add(
    ChronoZonedDateTime source,
    ChronoDuration duration,
    String disambiguation
  ) {
    return ChronoZonedDateTimeOperations.add(source, duration, disambiguation);
  }
  /**
   * @description Returns the elapsed difference between instants.
   * @param other End value.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoDuration elapsedDifference(
    ChronoZonedDateTime source,
    ChronoZonedDateTime other
  ) {
    return ChronoZonedDateTimeOperations.elapsedDifference(source, other);
  }
  /**
   * @description Serialises the local datetime, offset and named zone.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static String toIsoString(ChronoZonedDateTime source) {
    return ChronoZonedDateTimeOperations.toIsoString(source);
  }
  /**
   * @description Parses a zoned datetime and validates its offset against the zone.
   * @param value ISO datetime with offset and bracketed zone.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime parseIso(String value) {
    return ChronoZonedDateTimeOperations.parseIso(value);
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addHours(
    ChronoZonedDateTime source,
    Integer amount,
    OperatingHours schedule
  ) {
    return ChronoZonedDateTimeOperations.addHours(source, amount, schedule);
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Source, units and native schedule records are distinct API inputs.
  global static ChronoZonedDateTime addHours(
    Datetime source,
    String zoneId,
    Integer amount,
    OperatingHours schedule
  ) {
    return ChronoZonedDateTimeOperations.addHours(
      source,
      zoneId,
      amount,
      schedule
    );
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addHours(
    ChronoZonedDateTime source,
    Integer amount,
    BusinessHours schedule
  ) {
    return ChronoZonedDateTimeOperations.addHours(source, amount, schedule);
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Source, units and native schedule records are distinct API inputs.
  global static ChronoZonedDateTime addHours(
    Datetime source,
    String zoneId,
    Integer amount,
    BusinessHours schedule
  ) {
    return ChronoZonedDateTimeOperations.addHours(
      source,
      zoneId,
      amount,
      schedule
    );
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addMinutes(
    ChronoZonedDateTime source,
    Integer amount,
    OperatingHours schedule
  ) {
    return ChronoZonedDateTimeOperations.addMinutes(source, amount, schedule);
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Source, units and native schedule records are distinct API inputs.
  global static ChronoZonedDateTime addMinutes(
    Datetime source,
    String zoneId,
    Integer amount,
    OperatingHours schedule
  ) {
    return ChronoZonedDateTimeOperations.addMinutes(
      source,
      zoneId,
      amount,
      schedule
    );
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addMinutes(
    ChronoZonedDateTime source,
    Integer amount,
    BusinessHours schedule
  ) {
    return ChronoZonedDateTimeOperations.addMinutes(source, amount, schedule);
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Source, units and native schedule records are distinct API inputs.
  global static ChronoZonedDateTime addMinutes(
    Datetime source,
    String zoneId,
    Integer amount,
    BusinessHours schedule
  ) {
    return ChronoZonedDateTimeOperations.addMinutes(
      source,
      zoneId,
      amount,
      schedule
    );
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Source, units and native schedule records are distinct API inputs.
  global static ChronoZonedDateTime addHours(
    ChronoZonedDateTime source,
    Integer amount,
    OperatingHours schedule,
    List<TimeSlot> slots,
    List<Holiday> holidays
  ) {
    return ChronoZonedDateTimeOperations.addHours(
      source,
      amount,
      schedule,
      slots,
      holidays
    );
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Source, units and native schedule records are distinct API inputs.
  global static ChronoZonedDateTime addHours(
    Datetime source,
    String zoneId,
    Integer amount,
    OperatingHours schedule,
    List<TimeSlot> slots,
    List<Holiday> holidays
  ) {
    return ChronoZonedDateTimeOperations.addHours(
      source,
      zoneId,
      amount,
      schedule,
      slots,
      holidays
    );
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Source, units and native schedule records are distinct API inputs.
  global static ChronoZonedDateTime addMinutes(
    ChronoZonedDateTime source,
    Integer amount,
    OperatingHours schedule,
    List<TimeSlot> slots,
    List<Holiday> holidays
  ) {
    return ChronoZonedDateTimeOperations.addMinutes(
      source,
      amount,
      schedule,
      slots,
      holidays
    );
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Source, units and native schedule records are distinct API inputs.
  global static ChronoZonedDateTime addMinutes(
    Datetime source,
    String zoneId,
    Integer amount,
    OperatingHours schedule,
    List<TimeSlot> slots,
    List<Holiday> holidays
  ) {
    return ChronoZonedDateTimeOperations.addMinutes(
      source,
      zoneId,
      amount,
      schedule,
      slots,
      holidays
    );
  }
  /** @description Rejects incomplete or invalid data before use. */
  global static void validate(ChronoZonedDateTime source) {
    ChronoZonedDateTimeOperations.validate(source);
  }
}
