// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal implementation; callers use ChronoInstantService. Validates data before use. */
public with sharing class ChronoInstantOperations {
  /**
   * @description Constructs an datetime value.
   * @param value Native Salesforce value.
   */
  public static ChronoInstant create(Datetime value) {
    ChronoInstant result = new ChronoInstant();

    ChronoSupport.requireValue(value, 'Value');
    result.value = value;

    validate(result);
    return result;
  }
  /**
   * @description Parses an ISO representation.
   * @param value ISO representation.
   * @return The resulting value.
   */
  public static ChronoInstant parseIso(String value) {
    return ChronoInstantOperations.create(ChronoIso.parseInstant(value));
  }
  /**
   * @description Serialises an ISO representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static String toIsoString(ChronoInstant source) {
    ChronoInstantOperations.validate(source);
    return ChronoIso.dateText(source.value.dateGmt()) +
      'T' +
      ChronoIso.timeText(source.value.timeGmt()) +
      'Z';
  }
  /**
   * @description Returns the native Salesforce value.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static Datetime toDatetime(ChronoInstant source) {
    ChronoInstantOperations.validate(source);
    return source.value;
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoInstant addHours(ChronoInstant source, Integer amount) {
    ChronoInstantOperations.validate(source);
    return ChronoInstantOperations.addMilliseconds(
      source,
      ChronoSupport.hours(amount)
    );
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoInstant addHours(Datetime source, Integer amount) {
    return ChronoInstantOperations.addHours(
      ChronoInstantOperations.create(source),
      amount
    );
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoInstant addMinutes(ChronoInstant source, Integer amount) {
    ChronoInstantOperations.validate(source);
    return ChronoInstantOperations.addMilliseconds(
      source,
      ChronoSupport.minutes(amount)
    );
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoInstant addMinutes(Datetime source, Integer amount) {
    return ChronoInstantOperations.addMinutes(
      ChronoInstantOperations.create(source),
      amount
    );
  }
  /**
   * @description Adds elapsed seconds.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoInstant addSeconds(ChronoInstant source, Integer amount) {
    ChronoInstantOperations.validate(source);
    return ChronoInstantOperations.addMilliseconds(
      source,
      ((Long) amount) * 1000L
    );
  }
  /**
   * @description Adds elapsed seconds.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoInstant addSeconds(Datetime source, Integer amount) {
    return ChronoInstantOperations.addSeconds(
      ChronoInstantOperations.create(source),
      amount
    );
  }
  /**
   * @description Adds elapsed milliseconds.
   * @param amount Signed elapsed milliseconds.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoInstant addMilliseconds(
    ChronoInstant source,
    Long amount
  ) {
    ChronoInstantOperations.validate(source);
    return ChronoInstantOperations.create(
      ChronoSupport.shift(source.value, amount)
    );
  }
  /**
   * @description Adds elapsed milliseconds.
   * @param amount Signed elapsed milliseconds.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoInstant addMilliseconds(Datetime source, Long amount) {
    return ChronoInstantOperations.addMilliseconds(
      ChronoInstantOperations.create(source),
      amount
    );
  }
  /**
   * @description Views this instant in a time zone.
   * @param zoneId Salesforce time-zone ID.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime toZonedDateTime(
    ChronoInstant source,
    String zoneId
  ) {
    ChronoInstantOperations.validate(source);
    return ChronoZonedDateTimeOperations.create(source.value, zoneId);
  }
  /**
   * @description Views this instant in a time zone.
   * @param zoneId Salesforce time-zone ID.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime toZonedDateTime(
    Datetime source,
    String zoneId
  ) {
    return ChronoInstantOperations.toZonedDateTime(
      ChronoInstantOperations.create(source),
      zoneId
    );
  }
  /**
   * @description Returns the elapsed difference to another instant.
   * @param other End instant.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoDuration elapsedDifference(
    ChronoInstant source,
    ChronoInstant other
  ) {
    ChronoInstantOperations.validate(source);
    ChronoInstantOperations.validate(other);
    return ChronoDurationOperations.create(
      0,
      0,
      ChronoInstantOperations.toDatetime(other).getTime() -
      source.value.getTime()
    );
  }
  /** @description Rejects incomplete or invalid data before use. */
  public static void validate(ChronoInstant source) {
    ChronoSupport.requireValue(source, 'Value');
    ChronoDates.validateInstant(source.value);
  }
}
