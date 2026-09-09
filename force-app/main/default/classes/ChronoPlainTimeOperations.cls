// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal implementation; callers use ChronoPlainTimeService. Validates data before use. */
public with sharing class ChronoPlainTimeOperations {
  /**
   * @description Constructs an time value.
   * @param value Native Salesforce value.
   */
  public static ChronoPlainTime create(Time value) {
    ChronoPlainTime result = new ChronoPlainTime();

    ChronoSupport.requireValue(value, 'Value');
    result.value = value;

    return result;
  }
  /**
   * @description Parses an ISO representation.
   * @param value ISO representation.
   * @return The resulting value.
   */
  public static ChronoPlainTime parseIso(String value) {
    return ChronoPlainTimeOperations.create(ChronoIso.parseTime(value));
  }
  /**
   * @description Serialises an ISO representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static String toIsoString(ChronoPlainTime source) {
    ChronoPlainTimeOperations.validate(source);
    return ChronoIso.timeText(source.value);
  }
  /**
   * @description Returns the native Salesforce value.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static Time toTime(ChronoPlainTime source) {
    ChronoPlainTimeOperations.validate(source);
    return source.value;
  }
  /**
   * @description Adds hours and wraps at midnight.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainTime addHours(
    ChronoPlainTime source,
    Integer amount
  ) {
    ChronoPlainTimeOperations.validate(source);
    return ChronoPlainTimeOperations.addMilliseconds(
      source,
      ((Long) amount) * 3600000L
    );
  }
  /**
   * @description Adds hours and wraps at midnight.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainTime addHours(Time source, Integer amount) {
    return ChronoPlainTimeOperations.addHours(
      ChronoPlainTimeOperations.create(source),
      amount
    );
  }
  /**
   * @description Adds minutes and wraps at midnight.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainTime addMinutes(
    ChronoPlainTime source,
    Integer amount
  ) {
    ChronoPlainTimeOperations.validate(source);
    return ChronoPlainTimeOperations.addMilliseconds(
      source,
      ((Long) amount) * 60000L
    );
  }
  /**
   * @description Adds minutes and wraps at midnight.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainTime addMinutes(Time source, Integer amount) {
    return ChronoPlainTimeOperations.addMinutes(
      ChronoPlainTimeOperations.create(source),
      amount
    );
  }
  /**
   * @description Adds seconds and wraps at midnight.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainTime addSeconds(
    ChronoPlainTime source,
    Integer amount
  ) {
    ChronoPlainTimeOperations.validate(source);
    return ChronoPlainTimeOperations.addMilliseconds(
      source,
      ((Long) amount) * 1000L
    );
  }
  /**
   * @description Adds seconds and wraps at midnight.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainTime addSeconds(Time source, Integer amount) {
    return ChronoPlainTimeOperations.addSeconds(
      ChronoPlainTimeOperations.create(source),
      amount
    );
  }
  /**
   * @description Adds milliseconds and wraps at midnight.
   * @param amount Signed milliseconds.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainTime addMilliseconds(
    ChronoPlainTime source,
    Long amount
  ) {
    ChronoPlainTimeOperations.validate(source);
    ChronoSupport.requireValue(amount, 'Milliseconds');
    return ChronoPlainTimeOperations.create(
      source.value.addMilliseconds(Math.mod(amount, 86400000L).intValue())
    );
  }
  /**
   * @description Adds milliseconds and wraps at midnight.
   * @param amount Signed milliseconds.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainTime addMilliseconds(Time source, Long amount) {
    return ChronoPlainTimeOperations.addMilliseconds(
      ChronoPlainTimeOperations.create(source),
      amount
    );
  }
  /**
   * @description Combines this time with a local date.
   * @param localDate Local date.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDateTime toPlainDateTime(
    ChronoPlainTime source,
    Date localDate
  ) {
    ChronoPlainTimeOperations.validate(source);
    return ChronoPlainDateTimeOperations.create(localDate, source.value);
  }
  /** @description Rejects incomplete or invalid data before use. */
  public static void validate(ChronoPlainTime source) {
    ChronoSupport.requireValue(source, 'Value');
    ChronoSupport.requireValue(source.value, 'value');
  }
}
