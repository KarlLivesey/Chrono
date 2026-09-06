// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/**
 * @description An immutable duration with calendar and elapsed components.
 */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Deliberate subscriber-facing managed-package API.
global with sharing class ChronoDuration {
  private final Integer months;
  private final Integer days;
  private final Long milliseconds;
  /**
   * @description Constructs an immutable duration with calendar and elapsed components.
   * @param months Signed calendar months.
   * @param days Signed calendar days.
   * @param milliseconds Signed elapsed milliseconds.
   */
  global ChronoDuration(Integer months, Integer days, Long milliseconds) {
    ChronoSupport.requireValue(months, 'Months');
    ChronoSupport.requireValue(days, 'Days');
    ChronoSupport.requireValue(milliseconds, 'Milliseconds');
    Boolean positive = months > 0 || days > 0 || milliseconds > 0;
    Boolean negative = months < 0 || days < 0 || milliseconds < 0;
    if (positive && negative) {
      throw new ChronoException('Duration components must have the same sign.');
    }
    this.months = months;
    this.days = days;
    this.milliseconds = milliseconds;
  }
  /**
   * @description Returns the months component.
   * @return The resulting value.
   */
  global Integer getMonths() {
    return months;
  }
  /**
   * @description Returns the days component.
   * @return The resulting value.
   */
  global Integer getDays() {
    return days;
  }
  /**
   * @description Returns the milliseconds component.
   * @return The resulting value.
   */
  global Long getMilliseconds() {
    return milliseconds;
  }
  /**
   * @description Reverses the sign of every component.
   * @return The resulting value.
   */
  global ChronoDuration negated() {
    return new ChronoDuration(-months, -days, -milliseconds);
  }
  /**
   * @description Reverses the sign of every component.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static ChronoDuration negated(ChronoDuration source) {
    return source.negated();
  }
  /**
   * @description Returns elapsed milliseconds; calendar units require a relative value.
   * @return The resulting value.
   */
  global Long toMilliseconds() {
    if (months != 0 || days != 0) {
      throw new ChronoException(
        'Calendar months and days require a relative date/time.'
      );
    }
    return milliseconds;
  }
  /**
   * @description Returns elapsed milliseconds; calendar units require a relative value.
   * @param source Value to operate on.
   * @return The resulting value.
   */
  global static Long toMilliseconds(ChronoDuration source) {
    return source.toMilliseconds();
  }
  /**
   * @description Constructs an elapsed duration.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  global static ChronoDuration ofHours(Integer amount) {
    return new ChronoDuration(0, 0, ChronoSupport.hours(amount));
  }
  /**
   * @description Parses an ISO duration, preserving calendar and elapsed components.
   * @param value ISO duration with one sign; milliseconds maximum precision.
   * @return The resulting value.
   */
  global static ChronoDuration parse(String value) {
    ChronoSupport.requireValue(value, 'Duration');
    Matcher parts = Pattern.compile(
        '^(-)?P(?:(\\d+)Y)?(?:(\\d+)M)?(?:(\\d+)W)?(?:(\\d+)D)?(?:T(?:(\\d+)H)?(?:(\\d+)M)?(?:(\\d+(?:\\.\\d{1,3})?)S)?)?$'
      )
      .matcher(value);
    if (
      !parts.matches() ||
      value == 'P' ||
      value == '-P' ||
      value.endsWith('T')
    ) {
      throw new ChronoException('Invalid ISO duration.');
    }
    Integer sign = parts.group(1) == null ? 1 : -1;
    Integer parsedMonths = component(parts, 2) * 12 + component(parts, 3);
    Integer parsedDays = component(parts, 4) * 7 + component(parts, 5);
    Long clockMillis =
      ((Long) component(parts, 6)) * 3600000L +
      ((Long) component(parts, 7)) * 60000L;
    if (parts.group(8) != null) {
      clockMillis += (Decimal.valueOf(parts.group(8)) * 1000).longValue();
    }
    return new ChronoDuration(
      sign * parsedMonths,
      sign * parsedDays,
      sign * clockMillis
    );
  }
  private static Integer component(Matcher parts, Integer groupNumber) {
    return parts.group(groupNumber) == null
      ? 0
      : Integer.valueOf(parts.group(groupNumber));
  }
  /**
   * @description Serialises as months, days and seconds without assuming a day length.
   * @return The resulting value.
   */
  global override String toString() {
    Boolean negative = months < 0 || days < 0 || milliseconds < 0;
    String result = negative ? '-P' : 'P';
    if (months != 0) {
      result += String.valueOf(Math.abs(months)) + 'M';
    }
    if (days != 0) {
      result += String.valueOf(Math.abs(days)) + 'D';
    }
    if (milliseconds != 0) {
      result +=
        'T' +
        String.valueOf(((Decimal) Math.abs(milliseconds)).divide(1000, 3)) +
        'S';
    }
    return result == 'P' ? 'PT0S' : result;
  }
}
