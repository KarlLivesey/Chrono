// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/**
 * @description An immutable Datetime value.
 */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Deliberate subscriber-facing managed-package API.
global with sharing class ChronoInstant { // NOPMD - Aggregate complexity counts required delegating overloads; per-method rules remain active.
  private final Datetime value;
  /**
   * @description Constructs an immutable datetime value.
   * @param value Native Salesforce value.
   */
  global ChronoInstant(Datetime value) {
    ChronoSupport.requireValue(value, 'Value');
    this.value = value;
  }
  /**
   * @description Parses an ISO representation.
   * @param value ISO representation.
   * @return The resulting value.
   */
  global static ChronoInstant parse(String value) {
    return new ChronoInstant(ChronoIso.parseInstant(value));
  }
  /**
   * @description Serialises an ISO representation.
   * @return The resulting value.
   */
  global override String toString() {
    return ChronoIso.dateText(value.dateGmt()) +
      'T' +
      ChronoIso.timeText(value.timeGmt()) +
      'Z';
  }
  /**
   * @description Returns the native Salesforce value.
   * @return The resulting value.
   */
  global Datetime toDatetime() {
    return value;
  }
  /**
   * @description Returns the native Salesforce value.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static Datetime toDatetime(ChronoInstant source) {
    return source.toDatetime();
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoInstant addHours(Integer amount) {
    return addMilliseconds(ChronoSupport.hours(amount));
  }
  /**
   * @description Adds elapsed hours.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoInstant addHours(ChronoInstant source, Integer amount) {
    return source.addHours(amount);
  }
  /**
   * @description Adds elapsed hours.
   * @param source Native value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoInstant addHours(Datetime source, Integer amount) {
    return new ChronoInstant(source).addHours(amount);
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoInstant addMinutes(Integer amount) {
    return addMilliseconds(ChronoSupport.minutes(amount));
  }
  /**
   * @description Adds elapsed minutes.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoInstant addMinutes(ChronoInstant source, Integer amount) {
    return source.addMinutes(amount);
  }
  /**
   * @description Adds elapsed minutes.
   * @param source Native value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoInstant addMinutes(Datetime source, Integer amount) {
    return new ChronoInstant(source).addMinutes(amount);
  }
  /**
   * @description Adds elapsed seconds.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoInstant addSeconds(Integer amount) {
    return addMilliseconds(((Long) amount) * 1000L);
  }
  /**
   * @description Adds elapsed seconds.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoInstant addSeconds(ChronoInstant source, Integer amount) {
    return source.addSeconds(amount);
  }
  /**
   * @description Adds elapsed seconds.
   * @param source Native value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoInstant addSeconds(Datetime source, Integer amount) {
    return new ChronoInstant(source).addSeconds(amount);
  }
  /**
   * @description Adds elapsed milliseconds.
   * @param amount Signed elapsed milliseconds.
   * @return The resulting value.
   */
  global ChronoInstant addMilliseconds(Long amount) {
    return new ChronoInstant(ChronoSupport.shift(value, amount));
  }
  /**
   * @description Adds elapsed milliseconds.
   * @param source Value to operate on.
   * @param amount Signed elapsed milliseconds.
   * @return The resulting value.
   */
  global static ChronoInstant addMilliseconds(
    ChronoInstant source,
    Long amount
  ) {
    return source.addMilliseconds(amount);
  }
  /**
   * @description Adds elapsed milliseconds.
   * @param source Native value to operate on.
   * @param amount Signed elapsed milliseconds.
   * @return The resulting value.
   */
  global static ChronoInstant addMilliseconds(Datetime source, Long amount) {
    return new ChronoInstant(source).addMilliseconds(amount);
  }
  /**
   * @description Views this instant in a time zone.
   * @param zoneId Salesforce time-zone ID.
   * @return The resulting value.
   */
  global ChronoZonedDateTime toZonedDateTime(String zoneId) {
    return new ChronoZonedDateTime(value, zoneId);
  }
  /**
   * @description Views this instant in a time zone.
   * @param source Value to operate on.
   * @param zoneId Salesforce time-zone ID.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime toZonedDateTime(
    ChronoInstant source,
    String zoneId
  ) {
    return source.toZonedDateTime(zoneId);
  }
  /**
   * @description Views this instant in a time zone.
   * @param source Native value to operate on.
   * @param zoneId Salesforce time-zone ID.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime toZonedDateTime(
    Datetime source,
    String zoneId
  ) {
    return new ChronoInstant(source).toZonedDateTime(zoneId);
  }
  /**
   * @description Returns the elapsed difference to another instant.
   * @param other End instant.
   * @return The resulting value.
   */
  global ChronoDuration until(ChronoInstant other) {
    return new ChronoDuration(
      0,
      0,
      other.toDatetime().getTime() - value.getTime()
    );
  }
  /**
   * @description Returns the elapsed difference to another instant.
   * @param source Value to operate on.
   * @param other End instant.
   * @return The resulting value.
   */
  global static ChronoDuration until(
    ChronoInstant source,
    ChronoInstant other
  ) {
    return source.until(other);
  }
}
