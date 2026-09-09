// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal implementation; callers use ChronoPlainDateService. Validates data before use. */
public with sharing class ChronoPlainDateOperations {
  /**
   * @description Constructs an date value.
   * @param value Native Salesforce value.
   */
  public static ChronoPlainDate create(Date value) {
    ChronoPlainDate result = new ChronoPlainDate();

    ChronoDates.validate(value);
    result.value = value;

    return result;
  }
  /**
   * @description Parses an ISO representation.
   * @param value ISO representation.
   * @return The resulting value.
   */
  public static ChronoPlainDate parseIso(String value) {
    return ChronoPlainDateOperations.create(ChronoIso.parseDate(value));
  }
  /**
   * @description Serialises an ISO representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static String toIsoString(ChronoPlainDate source) {
    ChronoPlainDateOperations.validate(source);
    return ChronoIso.dateText(source.value);
  }
  /**
   * @description Returns the native Salesforce value.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static Date toDate(ChronoPlainDate source) {
    ChronoPlainDateOperations.validate(source);
    return source.value;
  }
  /**
   * @description Adds calendar days using native date arithmetic.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDate addDays(
    ChronoPlainDate source,
    Integer amount
  ) {
    ChronoPlainDateOperations.validate(source);
    return ChronoPlainDateOperations.create(
      ChronoDates.addDays(source.value, amount)
    );
  }
  /**
   * @description Adds calendar days using native date arithmetic.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDate addDays(Date source, Integer amount) {
    return ChronoPlainDateOperations.addDays(
      ChronoPlainDateOperations.create(source),
      amount
    );
  }
  /**
   * @description Adds calendar months using native date arithmetic.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDate addMonths(
    ChronoPlainDate source,
    Integer amount
  ) {
    ChronoPlainDateOperations.validate(source);
    return ChronoPlainDateOperations.create(
      ChronoDates.addMonths(source.value, amount)
    );
  }
  /**
   * @description Adds calendar months using native date arithmetic.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDate addMonths(Date source, Integer amount) {
    return ChronoPlainDateOperations.addMonths(
      ChronoPlainDateOperations.create(source),
      amount
    );
  }
  /**
   * @description Adds calendar years using native date arithmetic.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDate addYears(
    ChronoPlainDate source,
    Integer amount
  ) {
    ChronoPlainDateOperations.validate(source);
    return ChronoPlainDateOperations.create(
      ChronoDates.addYears(source.value, amount)
    );
  }
  /**
   * @description Adds calendar years using native date arithmetic.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDate addYears(Date source, Integer amount) {
    return ChronoPlainDateOperations.addYears(
      ChronoPlainDateOperations.create(source),
      amount
    );
  }
  /**
   * @description Combines the date with a local time.
   * @param localTime Local time.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDateTime toPlainDateTime(
    ChronoPlainDate source,
    Time localTime
  ) {
    ChronoPlainDateOperations.validate(source);
    return ChronoPlainDateTimeOperations.create(source.value, localTime);
  }
  /**
   * @description Extracts the year and month.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainYearMonth toPlainYearMonth(ChronoPlainDate source) {
    ChronoPlainDateOperations.validate(source);
    return ChronoPlainYearMonthOperations.create(
      source.value.year(),
      source.value.month()
    );
  }
  /**
   * @description Extracts the month and day.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainMonthDay toPlainMonthDay(ChronoPlainDate source) {
    ChronoPlainDateOperations.validate(source);
    return ChronoPlainMonthDayOperations.create(
      source.value.month(),
      source.value.day()
    );
  }
  /** @description Rejects incomplete or invalid data before use. */
  public static void validate(ChronoPlainDate source) {
    ChronoSupport.requireValue(source, 'Value');
    ChronoDates.validate(source.value);
  }
}
