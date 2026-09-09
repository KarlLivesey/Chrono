// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Stable public API for Duration values. Internal operations own validation and calculations. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoDurationService { // NOPMD -- Public overloads retain the existing consumer contract.
  /**
   * @description Constructs an duration with calendar and elapsed components.
   * @param months Signed calendar months.
   * @param days Signed calendar days.
   * @param milliseconds Signed elapsed milliseconds.
   */
  global static ChronoDuration create(
    Integer months,
    Integer days,
    Long milliseconds
  ) {
    return ChronoDurationOperations.create(months, days, milliseconds);
  }
  /**
   * @description Returns the months component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static Integer getMonths(ChronoDuration source) {
    return ChronoDurationOperations.getMonths(source);
  }
  /**
   * @description Returns the days component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static Integer getDays(ChronoDuration source) {
    return ChronoDurationOperations.getDays(source);
  }
  /**
   * @description Returns the milliseconds component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static Long getMilliseconds(ChronoDuration source) {
    return ChronoDurationOperations.getMilliseconds(source);
  }
  /**
   * @description Reverses the sign of every component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static ChronoDuration negate(ChronoDuration source) {
    return ChronoDurationOperations.negate(source);
  }
  /**
   * @description Returns elapsed milliseconds; calendar units require a relative value.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static Long toMilliseconds(ChronoDuration source) {
    return ChronoDurationOperations.toMilliseconds(source);
  }
  /**
   * @description Constructs an elapsed duration.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoDuration ofHours(Integer amount) {
    return ChronoDurationOperations.ofHours(amount);
  }
  /**
   * @description Parses an ISO duration, preserving calendar and elapsed components.
   * @param value ISO duration with one sign; sub-millisecond digits are truncated.
   * @return The resulting value.
   */
  global static ChronoDuration parseIso(String value) {
    return ChronoDurationOperations.parseIso(value);
  }
  /**
   * @description Serialises as months, days and seconds without assuming a day length.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  global static String toIsoString(ChronoDuration source) {
    return ChronoDurationOperations.toIsoString(source);
  }
  /** @description Rejects incomplete or invalid data before use. */
  global static void validate(ChronoDuration source) {
    ChronoDurationOperations.validate(source);
  }
}
