// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/**
 * @description A zone-free immutable date and time.
 */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Deliberate subscriber-facing managed-package API.
global with sharing class ChronoPlainDateTime { // NOPMD - Aggregate complexity counts required delegating overloads; per-method rules remain active.
  private final Date localDate;
  private final Time localTime;
  /**
   * @description Constructs a zone-free immutable date and time.
   * @param localDate Local date.
   * @param localTime Local time.
   */
  global ChronoPlainDateTime(Date localDate, Time localTime) {
    ChronoSupport.requireValue(localDate, 'Date');
    ChronoSupport.requireValue(localTime, 'Time');
    this.localDate = localDate;
    this.localTime = localTime;
  }
  /**
   * @description Parses a zone-free local datetime.
   * @param value ISO local date and time.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime parse(String value) {
    Datetime parsed = ChronoIso.parseLocal(value);
    return new ChronoPlainDateTime(parsed.dateGmt(), parsed.timeGmt());
  }
  /**
   * @description Serialises the local date and time.
   * @return The resulting value.
   */
  global override String toString() {
    return ChronoIso.dateText(localDate) + 'T' + ChronoIso.timeText(localTime);
  }
  /**
   * @description Returns the local component.
   * @return The resulting value.
   */
  global Date toDate() {
    return localDate;
  }
  /**
   * @description Returns the local component.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static Date toDate(ChronoPlainDateTime source) {
    return source.toDate();
  }
  /**
   * @description Returns the local component.
   * @return The resulting value.
   */
  global Time toTime() {
    return localTime;
  }
  /**
   * @description Returns the local component.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static Time toTime(ChronoPlainDateTime source) {
    return source.toTime();
  }
  /**
   * @description Returns the local component.
   * @return The resulting value.
   */
  global ChronoPlainDate toPlainDate() {
    return new ChronoPlainDate(localDate);
  }
  /**
   * @description Returns the local component.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static ChronoPlainDate toPlainDate(ChronoPlainDateTime source) {
    return source.toPlainDate();
  }
  /**
   * @description Returns the local component.
   * @return The resulting value.
   */
  global ChronoPlainTime toPlainTime() {
    return new ChronoPlainTime(localTime);
  }
  /**
   * @description Returns the local component.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static ChronoPlainTime toPlainTime(ChronoPlainDateTime source) {
    return source.toPlainTime();
  }
  /**
   * @description Adds calendar days.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoPlainDateTime addDays(Integer amount) {
    return new ChronoPlainDateTime(localDate.addDays(amount), localTime);
  }
  /**
   * @description Adds calendar days.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime addDays(
    ChronoPlainDateTime source,
    Integer amount
  ) {
    return source.addDays(amount);
  }
  /**
   * @description Adds calendar months.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoPlainDateTime addMonths(Integer amount) {
    return new ChronoPlainDateTime(localDate.addMonths(amount), localTime);
  }
  /**
   * @description Adds calendar months.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime addMonths(
    ChronoPlainDateTime source,
    Integer amount
  ) {
    return source.addMonths(amount);
  }
  /**
   * @description Adds calendar years.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoPlainDateTime addYears(Integer amount) {
    return new ChronoPlainDateTime(localDate.addYears(amount), localTime);
  }
  /**
   * @description Adds calendar years.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime addYears(
    ChronoPlainDateTime source,
    Integer amount
  ) {
    return source.addYears(amount);
  }
  /**
   * @description Adds wall-clock hours.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoPlainDateTime addHours(Integer amount) {
    return addMilliseconds(ChronoSupport.hours(amount));
  }
  /**
   * @description Adds wall-clock hours.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime addHours(
    ChronoPlainDateTime source,
    Integer amount
  ) {
    return source.addHours(amount);
  }
  /**
   * @description Adds wall-clock minutes.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoPlainDateTime addMinutes(Integer amount) {
    return addMilliseconds(ChronoSupport.minutes(amount));
  }
  /**
   * @description Adds wall-clock minutes.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime addMinutes(
    ChronoPlainDateTime source,
    Integer amount
  ) {
    return source.addMinutes(amount);
  }
  /**
   * @description Adds wall-clock milliseconds, carrying across midnight.
   * @param amount Signed wall-clock milliseconds.
   * @return The resulting value.
   */
  global ChronoPlainDateTime addMilliseconds(Long amount) {
    Datetime shifted = ChronoSupport.shift(
      Datetime.newInstanceGmt(localDate, localTime),
      amount
    );
    return new ChronoPlainDateTime(shifted.dateGmt(), shifted.timeGmt());
  }
  /**
   * @description Adds wall-clock milliseconds, carrying across midnight.
   * @param source Value to operate on.
   * @param amount Signed wall-clock milliseconds.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime addMilliseconds(
    ChronoPlainDateTime source,
    Long amount
  ) {
    return source.addMilliseconds(amount);
  }
  /**
   * @description Resolves the local datetime; rejects skipped or repeated times.
   * @param zoneId Salesforce time-zone ID.
   * @return The resulting value.
   */
  global ChronoZonedDateTime toZonedDateTime(String zoneId) {
    return toZonedDateTime(zoneId, 'reject');
  }
  /**
   * @description Resolves the local datetime; rejects skipped or repeated times.
   * @param source Value to operate on.
   * @param zoneId Salesforce time-zone ID.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime toZonedDateTime(
    ChronoPlainDateTime source,
    String zoneId
  ) {
    return source.toZonedDateTime(zoneId);
  }
  /**
   * @description Resolves the local datetime with explicit overlap handling.
   * @param zoneId Salesforce time-zone ID.
   * @param disambiguation reject, earlier or later; skipped times always fail.
   * @return The resulting value.
   */
  global ChronoZonedDateTime toZonedDateTime(
    String zoneId,
    String disambiguation
  ) {
    return new ChronoZonedDateTime(
      ChronoZoneResolver.choose(this, zoneId, disambiguation),
      zoneId
    );
  }
  /**
   * @description Resolves the local datetime with explicit overlap handling.
   * @param source Value to operate on.
   * @param zoneId Salesforce time-zone ID.
   * @param disambiguation reject, earlier or later; skipped times always fail.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime toZonedDateTime(
    ChronoPlainDateTime source,
    String zoneId,
    String disambiguation
  ) {
    return source.toZonedDateTime(zoneId, disambiguation);
  }
  /**
   * @description Adds months, then days, then wall-clock milliseconds.
   * @param duration Amount to add.
   * @return The resulting value.
   */
  global ChronoPlainDateTime add(ChronoDuration duration) {
    return addMonths(duration.getMonths())
      .addDays(duration.getDays())
      .addMilliseconds(duration.getMilliseconds());
  }
  /**
   * @description Adds months, then days, then wall-clock milliseconds.
   * @param source Value to operate on.
   * @param duration Amount to add.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime add(
    ChronoPlainDateTime source,
    ChronoDuration duration
  ) {
    return source.add(duration);
  }
}
