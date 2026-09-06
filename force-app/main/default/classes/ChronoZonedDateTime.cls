// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/**
 * @description An immutable instant with a named time zone.
 */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Deliberate subscriber-facing managed-package API.
global with sharing class ChronoZonedDateTime { // NOPMD - Aggregate complexity counts required delegating overloads; per-method rules remain active.
  private final Datetime instant;
  private final String zoneId;
  /**
   * @description Constructs an immutable instant with a named time zone.
   * @param instant Native exact instant.
   * @param zoneId Salesforce time-zone ID.
   */
  global ChronoZonedDateTime(Datetime instant, String zoneId) {
    ChronoSupport.requireValue(instant, 'Datetime');
    ChronoSupport.zone(zoneId);
    this.instant = instant;
    this.zoneId = zoneId;
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @return The resulting value.
   */
  global Datetime toDatetime() {
    return instant;
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static Datetime toDatetime(ChronoZonedDateTime source) {
    return source.toDatetime();
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @return The resulting value.
   */
  global String getTimeZoneId() {
    return zoneId;
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static String getTimeZoneId(ChronoZonedDateTime source) {
    return source.getTimeZoneId();
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @return The resulting value.
   */
  global ChronoInstant toInstant() {
    return new ChronoInstant(instant);
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static ChronoInstant toInstant(ChronoZonedDateTime source) {
    return source.toInstant();
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @return The resulting value.
   */
  global ChronoPlainDateTime toPlainDateTime() {
    Datetime local = ChronoSupport.localValue(instant, zoneId);
    return new ChronoPlainDateTime(local.dateGmt(), local.timeGmt());
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static ChronoPlainDateTime toPlainDateTime(
    ChronoZonedDateTime source
  ) {
    return source.toPlainDateTime();
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @return The resulting value.
   */
  global Date toDate() {
    return toPlainDateTime().toDate();
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static Date toDate(ChronoZonedDateTime source) {
    return source.toDate();
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @return The resulting value.
   */
  global Time toTime() {
    return toPlainDateTime().toTime();
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static Time toTime(ChronoZonedDateTime source) {
    return source.toTime();
  }
  /**
   * @description Views the same instant in another zone.
   * @param targetZoneId New Salesforce time-zone ID.
   * @return The resulting value.
   */
  global ChronoZonedDateTime withTimeZone(String targetZoneId) {
    return new ChronoZonedDateTime(instant, targetZoneId);
  }
  /**
   * @description Views the same instant in another zone.
   * @param source Value to operate on.
   * @param targetZoneId New Salesforce time-zone ID.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime withTimeZone(
    ChronoZonedDateTime source,
    String targetZoneId
  ) {
    return source.withTimeZone(targetZoneId);
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoZonedDateTime addHours(Integer amount) {
    return addMilliseconds(ChronoSupport.hours(amount));
  }
  /**
   * @description Adds elapsed hours.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addHours(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    return source.addHours(amount);
  }
  /**
   * @description Adds elapsed hours to a native instant.
   * @param source Native instant.
   * @param zoneId Time zone for the result.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addHours(
    Datetime source,
    String zoneId,
    Integer amount
  ) {
    return new ChronoZonedDateTime(source, zoneId).addHours(amount);
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoZonedDateTime addMinutes(Integer amount) {
    return addMilliseconds(ChronoSupport.minutes(amount));
  }
  /**
   * @description Adds elapsed minutes.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addMinutes(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    return source.addMinutes(amount);
  }
  /**
   * @description Adds elapsed minutes to a native instant.
   * @param source Native instant.
   * @param zoneId Time zone for the result.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addMinutes(
    Datetime source,
    String zoneId,
    Integer amount
  ) {
    return new ChronoZonedDateTime(source, zoneId).addMinutes(amount);
  }
  /**
   * @description Adds elapsed seconds.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoZonedDateTime addSeconds(Integer amount) {
    return addMilliseconds(((Long) amount) * 1000L);
  }
  /**
   * @description Adds elapsed seconds.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addSeconds(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    return source.addSeconds(amount);
  }
  /**
   * @description Adds elapsed seconds to a native instant.
   * @param source Native instant.
   * @param zoneId Time zone for the result.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addSeconds(
    Datetime source,
    String zoneId,
    Integer amount
  ) {
    return new ChronoZonedDateTime(source, zoneId).addSeconds(amount);
  }
  /**
   * @description Adds elapsed milliseconds.
   * @param amount Signed elapsed milliseconds.
   * @return The resulting value.
   */
  global ChronoZonedDateTime addMilliseconds(Long amount) {
    return new ChronoZonedDateTime(
      ChronoSupport.shift(instant, amount),
      zoneId
    );
  }
  /**
   * @description Adds elapsed milliseconds.
   * @param source Value to operate on.
   * @param amount Signed elapsed milliseconds.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addMilliseconds(
    ChronoZonedDateTime source,
    Long amount
  ) {
    return source.addMilliseconds(amount);
  }
  /**
   * @description Adds local calendar days; rejects gaps and overlaps.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoZonedDateTime addDays(Integer amount) {
    return addDays(amount, 'reject');
  }
  /**
   * @description Adds local calendar days; rejects gaps and overlaps.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addDays(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    return source.addDays(amount);
  }
  /**
   * @description Adds local calendar days with overlap handling.
   * @param amount Signed number of units.
   * @param disambiguation reject, earlier or later; gaps fail.
   * @return The resulting value.
   */
  global ChronoZonedDateTime addDays(Integer amount, String disambiguation) {
    return toPlainDateTime()
      .addDays(amount)
      .toZonedDateTime(zoneId, disambiguation);
  }
  /**
   * @description Adds local calendar days with overlap handling.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @param disambiguation reject, earlier or later; gaps fail.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addDays(
    ChronoZonedDateTime source,
    Integer amount,
    String disambiguation
  ) {
    return source.addDays(amount, disambiguation);
  }
  /**
   * @description Adds local calendar months; rejects gaps and overlaps.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoZonedDateTime addMonths(Integer amount) {
    return addMonths(amount, 'reject');
  }
  /**
   * @description Adds local calendar months; rejects gaps and overlaps.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addMonths(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    return source.addMonths(amount);
  }
  /**
   * @description Adds local calendar months with overlap handling.
   * @param amount Signed number of units.
   * @param disambiguation reject, earlier or later; gaps fail.
   * @return The resulting value.
   */
  global ChronoZonedDateTime addMonths(Integer amount, String disambiguation) {
    return toPlainDateTime()
      .addMonths(amount)
      .toZonedDateTime(zoneId, disambiguation);
  }
  /**
   * @description Adds local calendar months with overlap handling.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @param disambiguation reject, earlier or later; gaps fail.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addMonths(
    ChronoZonedDateTime source,
    Integer amount,
    String disambiguation
  ) {
    return source.addMonths(amount, disambiguation);
  }
  /**
   * @description Adds local calendar years; rejects gaps and overlaps.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global ChronoZonedDateTime addYears(Integer amount) {
    return addYears(amount, 'reject');
  }
  /**
   * @description Adds local calendar years; rejects gaps and overlaps.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addYears(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    return source.addYears(amount);
  }
  /**
   * @description Adds local calendar years with overlap handling.
   * @param amount Signed number of units.
   * @param disambiguation reject, earlier or later; gaps fail.
   * @return The resulting value.
   */
  global ChronoZonedDateTime addYears(Integer amount, String disambiguation) {
    return toPlainDateTime()
      .addYears(amount)
      .toZonedDateTime(zoneId, disambiguation);
  }
  /**
   * @description Adds local calendar years with overlap handling.
   * @param source Value to operate on.
   * @param amount Signed number of units.
   * @param disambiguation reject, earlier or later; gaps fail.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime addYears(
    ChronoZonedDateTime source,
    Integer amount,
    String disambiguation
  ) {
    return source.addYears(amount, disambiguation);
  }
  /**
   * @description Adds months and days locally, then elapsed milliseconds.
   * @param duration Amount to add.
   * @return The resulting value.
   */
  global ChronoZonedDateTime add(ChronoDuration duration) {
    return add(duration, 'reject');
  }
  /**
   * @description Adds months and days locally, then elapsed milliseconds.
   * @param source Value to operate on.
   * @param duration Amount to add.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime add(
    ChronoZonedDateTime source,
    ChronoDuration duration
  ) {
    return source.add(duration);
  }
  /**
   * @description Adds calendar components then elapsed time.
   * @param duration Amount to add.
   * @param disambiguation reject, earlier or later; gaps fail.
   * @return The resulting value.
   */
  global ChronoZonedDateTime add(
    ChronoDuration duration,
    String disambiguation
  ) {
    ChronoZonedDateTime base = this;
    if (duration.getMonths() != 0 || duration.getDays() != 0) {
      base = toPlainDateTime()
        .addMonths(duration.getMonths())
        .addDays(duration.getDays())
        .toZonedDateTime(zoneId, disambiguation);
    }
    return base.addMilliseconds(duration.getMilliseconds());
  }
  /**
   * @description Adds calendar components then elapsed time.
   * @param source Value to operate on.
   * @param duration Amount to add.
   * @param disambiguation reject, earlier or later; gaps fail.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime add(
    ChronoZonedDateTime source,
    ChronoDuration duration,
    String disambiguation
  ) {
    return source.add(duration, disambiguation);
  }
  /**
   * @description Returns the elapsed difference between instants.
   * @param other End value.
   * @return The resulting value.
   */
  global ChronoDuration until(ChronoZonedDateTime other) {
    return toInstant().until(other.toInstant());
  }
  /**
   * @description Returns the elapsed difference between instants.
   * @param source Value to operate on.
   * @param other End value.
   * @return The resulting value.
   */
  global static ChronoDuration until(
    ChronoZonedDateTime source,
    ChronoZonedDateTime other
  ) {
    return source.until(other);
  }
  /**
   * @description Serialises the local datetime, offset and named zone.
   * @return The resulting value.
   */
  global override String toString() {
    Integer offset = ChronoSupport.zone(zoneId).getOffset(instant) / 1000;
    Integer magnitude = Math.abs(offset);
    String suffix =
      (offset < 0 ? '-' : '+') +
      ChronoIso.pad(magnitude / 3600, 2) +
      ':' +
      ChronoIso.pad(Math.mod(magnitude / 60, 60), 2);
    if (Math.mod(magnitude, 60) != 0) {
      throw new ChronoException(
        'ISO output requires a whole-minute UTC offset.'
      );
    }
    return toPlainDateTime().toString() + suffix + '[' + zoneId + ']';
  }
  /**
   * @description Parses a zoned datetime and validates its offset against the zone.
   * @param value ISO datetime with offset and bracketed zone.
   * @return The resulting value.
   */
  global static ChronoZonedDateTime parse(String value) {
    ChronoSupport.requireValue(value, 'Zoned datetime');
    Integer bracket = value.indexOf('[');
    if (
      bracket < 0 ||
      !value.endsWith(']') ||
      value.substring(bracket + 1).contains('[')
    ) {
      throw new ChronoException(
        'Expected datetime with offset and one [time-zone] annotation.'
      );
    }
    String parsedZone = value.substring(bracket + 1, value.length() - 1);
    String instantText = value.substring(0, bracket);
    Datetime parsed = ChronoIso.parseInstant(instantText);
    Datetime local = ChronoIso.parseLocal(
      instantText.endsWith('Z')
        ? instantText.substring(0, instantText.length() - 1)
        : instantText.substring(0, instantText.length() - 6)
    );
    if (ChronoSupport.localValue(parsed, parsedZone) != local) {
      throw new ChronoException(
        'UTC offset does not match the named time zone.'
      );
    }
    return new ChronoZonedDateTime(parsed, parsedZone);
  }

  /**
   * @description Adds signed working Hours, skipping closed periods in the schedule's zone. Returns a new value in this value's zone.
   * @param amount Working units to add.
   * @param schedule Saved Salesforce schedule; read in the caller's context.
   * @return Result after consuming the working time.
   */
  global ChronoZonedDateTime addHours(Integer amount, OperatingHours schedule) {
    ChronoSupport.requireValue(schedule, 'Schedule');
    ChronoSupport.requireValue(schedule.Id, 'Saved schedule ID');
    return new ChronoZonedDateTime(
      new ChronoWorkingTime(schedule)
        .addMilliseconds(instant, ChronoSupport.hours(amount)),
      zoneId
    );
  }
  /**
   * @description Static equivalent of the schedule-aware instance method.
   * @param source Zoned starting value.
   * @param amount Working units to add.
   * @param schedule Saved Salesforce schedule.
   * @return Result in the source value's zone.
   */
  global static ChronoZonedDateTime addHours(
    ChronoZonedDateTime source,
    Integer amount,
    OperatingHours schedule
  ) {
    return source.addHours(amount, schedule);
  }
  /**
   * @description Adds working units to a native instant with an explicit result zone.
   * @param source Native starting instant.
   * @param zoneId Time zone for the returned value.
   * @param amount Working units to add.
   * @param schedule Saved Salesforce schedule.
   * @return Result in the specified zone.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Native instant, explicit zone, amount and schedule are required.
  global static ChronoZonedDateTime addHours(
    Datetime source,
    String zoneId,
    Integer amount,
    OperatingHours schedule
  ) {
    return new ChronoZonedDateTime(source, zoneId).addHours(amount, schedule);
  }

  /**
   * @description Adds signed working Hours, skipping closed periods in the schedule's zone. Returns a new value in this value's zone.
   * @param amount Working units to add.
   * @param schedule Saved Salesforce schedule; read in the caller's context.
   * @return Result after consuming the working time.
   */
  global ChronoZonedDateTime addHours(Integer amount, BusinessHours schedule) {
    ChronoSupport.requireValue(schedule, 'Schedule');
    ChronoSupport.requireValue(schedule.Id, 'Saved schedule ID');
    return new ChronoZonedDateTime(
      System.BusinessHours.addGmt(
        schedule.Id,
        instant,
        ChronoSupport.hours(amount)
      ),
      zoneId
    );
  }
  /**
   * @description Static equivalent of the schedule-aware instance method.
   * @param source Zoned starting value.
   * @param amount Working units to add.
   * @param schedule Saved Salesforce schedule.
   * @return Result in the source value's zone.
   */
  global static ChronoZonedDateTime addHours(
    ChronoZonedDateTime source,
    Integer amount,
    BusinessHours schedule
  ) {
    return source.addHours(amount, schedule);
  }
  /**
   * @description Adds working units to a native instant with an explicit result zone.
   * @param source Native starting instant.
   * @param zoneId Time zone for the returned value.
   * @param amount Working units to add.
   * @param schedule Saved Salesforce schedule.
   * @return Result in the specified zone.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Native instant, explicit zone, amount and schedule are required.
  global static ChronoZonedDateTime addHours(
    Datetime source,
    String zoneId,
    Integer amount,
    BusinessHours schedule
  ) {
    return new ChronoZonedDateTime(source, zoneId).addHours(amount, schedule);
  }

  /**
   * @description Adds signed working Minutes, skipping closed periods in the schedule's zone. Returns a new value in this value's zone.
   * @param amount Working units to add.
   * @param schedule Saved Salesforce schedule; read in the caller's context.
   * @return Result after consuming the working time.
   */
  global ChronoZonedDateTime addMinutes(
    Integer amount,
    OperatingHours schedule
  ) {
    ChronoSupport.requireValue(schedule, 'Schedule');
    ChronoSupport.requireValue(schedule.Id, 'Saved schedule ID');
    return new ChronoZonedDateTime(
      new ChronoWorkingTime(schedule)
        .addMilliseconds(instant, ChronoSupport.minutes(amount)),
      zoneId
    );
  }
  /**
   * @description Static equivalent of the schedule-aware instance method.
   * @param source Zoned starting value.
   * @param amount Working units to add.
   * @param schedule Saved Salesforce schedule.
   * @return Result in the source value's zone.
   */
  global static ChronoZonedDateTime addMinutes(
    ChronoZonedDateTime source,
    Integer amount,
    OperatingHours schedule
  ) {
    return source.addMinutes(amount, schedule);
  }
  /**
   * @description Adds working units to a native instant with an explicit result zone.
   * @param source Native starting instant.
   * @param zoneId Time zone for the returned value.
   * @param amount Working units to add.
   * @param schedule Saved Salesforce schedule.
   * @return Result in the specified zone.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Native instant, explicit zone, amount and schedule are required.
  global static ChronoZonedDateTime addMinutes(
    Datetime source,
    String zoneId,
    Integer amount,
    OperatingHours schedule
  ) {
    return new ChronoZonedDateTime(source, zoneId).addMinutes(amount, schedule);
  }

  /**
   * @description Adds signed working Minutes, skipping closed periods in the schedule's zone. Returns a new value in this value's zone.
   * @param amount Working units to add.
   * @param schedule Saved Salesforce schedule; read in the caller's context.
   * @return Result after consuming the working time.
   */
  global ChronoZonedDateTime addMinutes(
    Integer amount,
    BusinessHours schedule
  ) {
    ChronoSupport.requireValue(schedule, 'Schedule');
    ChronoSupport.requireValue(schedule.Id, 'Saved schedule ID');
    return new ChronoZonedDateTime(
      System.BusinessHours.addGmt(
        schedule.Id,
        instant,
        ChronoSupport.minutes(amount)
      ),
      zoneId
    );
  }
  /**
   * @description Static equivalent of the schedule-aware instance method.
   * @param source Zoned starting value.
   * @param amount Working units to add.
   * @param schedule Saved Salesforce schedule.
   * @return Result in the source value's zone.
   */
  global static ChronoZonedDateTime addMinutes(
    ChronoZonedDateTime source,
    Integer amount,
    BusinessHours schedule
  ) {
    return source.addMinutes(amount, schedule);
  }
  /**
   * @description Adds working units to a native instant with an explicit result zone.
   * @param source Native starting instant.
   * @param zoneId Time zone for the returned value.
   * @param amount Working units to add.
   * @param schedule Saved Salesforce schedule.
   * @return Result in the specified zone.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Native instant, explicit zone, amount and schedule are required.
  global static ChronoZonedDateTime addMinutes(
    Datetime source,
    String zoneId,
    Integer amount,
    BusinessHours schedule
  ) {
    return new ChronoZonedDateTime(source, zoneId).addMinutes(amount, schedule);
  }
}
