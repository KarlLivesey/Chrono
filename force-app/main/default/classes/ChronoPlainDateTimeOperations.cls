// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal implementation; callers use ChronoPlainDateTimeService. Validates data before use. */
public with sharing class ChronoPlainDateTimeOperations {
  /**
   * @description Constructs a zone-free date and time.
   * @param localDate Local date.
   * @param localTime Local time.
   */
  public static ChronoPlainDateTime create(Date localDate, Time localTime) {
    ChronoPlainDateTime result = new ChronoPlainDateTime();

    ChronoDates.validate(localDate);
    ChronoSupport.requireValue(localTime, 'Time');
    result.localDate = localDate;
    result.localTime = localTime;

    return result;
  }
  /**
   * @description Parses a zone-free local datetime.
   * @param value ISO local date and time.
   * @return The resulting value.
   */
  public static ChronoPlainDateTime parseIso(String value) {
    Datetime parsed = ChronoIso.parseLocal(value);
    return ChronoPlainDateTimeOperations.create(
      parsed.dateGmt(),
      parsed.timeGmt()
    );
  }
  /**
   * @description Serialises the local date and time.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static String toIsoString(ChronoPlainDateTime source) {
    ChronoPlainDateTimeOperations.validate(source);
    return ChronoIso.dateText(source.localDate) +
      'T' +
      ChronoIso.timeText(source.localTime);
  }
  /**
   * @description Returns the local component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static Date toDate(ChronoPlainDateTime source) {
    ChronoPlainDateTimeOperations.validate(source);
    return source.localDate;
  }
  /**
   * @description Returns the local component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static Time toTime(ChronoPlainDateTime source) {
    ChronoPlainDateTimeOperations.validate(source);
    return source.localTime;
  }
  /**
   * @description Returns the local component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDate toPlainDate(ChronoPlainDateTime source) {
    ChronoPlainDateTimeOperations.validate(source);
    return ChronoPlainDateOperations.create(source.localDate);
  }
  /**
   * @description Returns the local component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainTime toPlainTime(ChronoPlainDateTime source) {
    ChronoPlainDateTimeOperations.validate(source);
    return ChronoPlainTimeOperations.create(source.localTime);
  }
  /**
   * @description Adds calendar days.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDateTime addDays(
    ChronoPlainDateTime source,
    Integer amount
  ) {
    ChronoPlainDateTimeOperations.validate(source);
    return ChronoPlainDateTimeOperations.create(
      ChronoDates.addDays(source.localDate, amount),
      source.localTime
    );
  }
  /**
   * @description Adds calendar months.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDateTime addMonths(
    ChronoPlainDateTime source,
    Integer amount
  ) {
    ChronoPlainDateTimeOperations.validate(source);
    return ChronoPlainDateTimeOperations.create(
      ChronoDates.addMonths(source.localDate, amount),
      source.localTime
    );
  }
  /**
   * @description Adds calendar years.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDateTime addYears(
    ChronoPlainDateTime source,
    Integer amount
  ) {
    ChronoPlainDateTimeOperations.validate(source);
    return ChronoPlainDateTimeOperations.create(
      ChronoDates.addYears(source.localDate, amount),
      source.localTime
    );
  }
  /**
   * @description Adds wall-clock hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDateTime addHours(
    ChronoPlainDateTime source,
    Integer amount
  ) {
    ChronoPlainDateTimeOperations.validate(source);
    return ChronoPlainDateTimeOperations.addMilliseconds(
      source,
      ChronoSupport.hours(amount)
    );
  }
  /**
   * @description Adds wall-clock minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDateTime addMinutes(
    ChronoPlainDateTime source,
    Integer amount
  ) {
    ChronoPlainDateTimeOperations.validate(source);
    return ChronoPlainDateTimeOperations.addMilliseconds(
      source,
      ChronoSupport.minutes(amount)
    );
  }
  /**
   * @description Adds wall-clock milliseconds, carrying across midnight.
   * @param amount Signed wall-clock milliseconds.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDateTime addMilliseconds(
    ChronoPlainDateTime source,
    Long amount
  ) {
    ChronoPlainDateTimeOperations.validate(source);
    Datetime shifted = ChronoSupport.shift(
      Datetime.newInstanceGmt(source.localDate, source.localTime),
      amount
    );
    return ChronoPlainDateTimeOperations.create(
      shifted.dateGmt(),
      shifted.timeGmt()
    );
  }
  /**
   * @description Resolves the local datetime; rejects skipped or repeated times.
   * @param zoneId Salesforce time-zone ID.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime toZonedDateTime(
    ChronoPlainDateTime source,
    String zoneId
  ) {
    ChronoPlainDateTimeOperations.validate(source);
    return ChronoPlainDateTimeOperations.toZonedDateTime(
      source,
      zoneId,
      'reject'
    );
  }
  /**
   * @description Resolves local time in the supplied zone; nonexistent times always reject.
   * @param zoneId Salesforce time-zone ID.
   * @param source Value to operate on; validated before use.
   * @param disambiguation reject (also the null/omitted default), earlier or later for repeated times.
   * @return A new zoned value. Throws ChronoException for invalid data, zones or policies, gaps, or rejected overlaps.
   */
  public static ChronoZonedDateTime toZonedDateTime(
    ChronoPlainDateTime source,
    String zoneId,
    String disambiguation
  ) {
    ChronoPlainDateTimeOperations.validate(source);
    return ChronoZonedDateTimeOperations.create(
      ChronoZoneResolver.choose(
        source,
        zoneId,
        disambiguation == null ? 'reject' : disambiguation
      ),
      zoneId
    );
  }
  /**
   * @description Adds months, then days, then wall-clock milliseconds.
   * @param duration Amount to add.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDateTime add(
    ChronoPlainDateTime source,
    ChronoDuration duration
  ) {
    ChronoPlainDateTimeOperations.validate(source);
    ChronoDurationOperations.validate(duration);
    return ChronoPlainDateTimeOperations.addMilliseconds(
      ChronoPlainDateTimeOperations.addDays(
        ChronoPlainDateTimeOperations.addMonths(
          source,
          ChronoDurationOperations.getMonths(duration)
        ),
        ChronoDurationOperations.getDays(duration)
      ),
      ChronoDurationOperations.getMilliseconds(duration)
    );
  }
  /** @description Rejects incomplete or invalid data before use. */
  public static void validate(ChronoPlainDateTime source) {
    ChronoSupport.requireValue(source, 'Value');
    ChronoDates.validate(source.localDate);
    ChronoSupport.requireValue(source.localTime, 'localTime');
  }
}
