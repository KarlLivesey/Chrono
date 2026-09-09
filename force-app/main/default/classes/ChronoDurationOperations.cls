// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal implementation; callers use ChronoDurationService. Validates data before use. */
public with sharing class ChronoDurationOperations { // NOPMD -- Aggregate covers independent conversions and required native/schedule overloads; method rules remain active.
  private static final Pattern ISO_PATTERN = Pattern.compile(
    '^(-)?P(?:(\\d+)Y)?(?:(\\d+)M)?(?:(\\d+)W)?(?:(\\d+)D)?(?:T(?:(\\d+)H)?(?:(\\d+)M)?(?:(\\d+(?:\\.\\d+)?)S)?)?$'
  );
  /**
   * @description Constructs an duration with calendar and elapsed components.
   * @param months Signed calendar months.
   * @param days Signed calendar days.
   * @param milliseconds Signed elapsed milliseconds.
   */
  public static ChronoDuration create(
    Integer months,
    Integer days,
    Long milliseconds
  ) {
    ChronoDuration result = new ChronoDuration();

    result.months = months;
    result.days = days;
    result.milliseconds = milliseconds;
    validate(result);

    return result;
  }
  /**
   * @description Returns the months component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static Integer getMonths(ChronoDuration source) {
    ChronoDurationOperations.validate(source);
    return source.months;
  }
  /**
   * @description Returns the days component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static Integer getDays(ChronoDuration source) {
    ChronoDurationOperations.validate(source);
    return source.days;
  }
  /**
   * @description Returns the milliseconds component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static Long getMilliseconds(ChronoDuration source) {
    ChronoDurationOperations.validate(source);
    return source.milliseconds;
  }
  /**
   * @description Reverses the sign of every component.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoDuration negate(ChronoDuration source) {
    ChronoDurationOperations.validate(source);
    return ChronoDurationOperations.create(
      ChronoNumbers.calendar(-(Decimal) source.months),
      ChronoNumbers.calendar(-(Decimal) source.days),
      ChronoNumbers.milliseconds(-(Decimal) source.milliseconds)
    );
  }
  /**
   * @description Returns elapsed milliseconds; calendar units require a relative value.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static Long toMilliseconds(ChronoDuration source) {
    ChronoDurationOperations.validate(source);
    if (source.months != 0 || source.days != 0) {
      throw new ChronoException(
        'Calendar months and days require a relative date/time.'
      );
    }
    return source.milliseconds;
  }
  /**
   * @description Constructs an elapsed duration.
   * @param amount Signed number of units.
   * @return The resulting value.
   */
  public static ChronoDuration ofHours(Integer amount) {
    return ChronoDurationOperations.create(0, 0, ChronoSupport.hours(amount));
  }
  /**
   * @description Parses an ISO duration, preserving calendar and elapsed components.
   * @param value ISO duration with one sign; sub-millisecond digits are truncated.
   * @return The resulting value.
   */
  public static ChronoDuration parseIso(String value) {
    ChronoSupport.requireValue(value, 'Duration');
    Matcher parts = ISO_PATTERN.matcher(value);
    if (
      !parts.matches() ||
      value == 'P' ||
      value == '-P' ||
      value.endsWith('T')
    ) {
      throw new ChronoException('Invalid ISO duration.');
    }
    Integer sign = parts.group(1) == null ? 1 : -1;
    Decimal parsedMonths =
      ChronoDurationOperations.component(parts, 2) * 12 +
      ChronoDurationOperations.component(parts, 3);
    Decimal parsedDays =
      ChronoDurationOperations.component(parts, 4) * 7 +
      ChronoDurationOperations.component(parts, 5);
    Decimal clockMillis =
      ChronoDurationOperations.component(parts, 6) * 3600000 +
      ChronoDurationOperations.component(parts, 7) * 60000;
    if (parts.group(8) != null) {
      clockMillis += ChronoDurationOperations.secondsMilliseconds(
        parts.group(8)
      );
    }
    return ChronoDurationOperations.create(
      ChronoNumbers.calendar(sign * parsedMonths),
      ChronoNumbers.calendar(sign * parsedDays),
      ChronoNumbers.milliseconds(sign * clockMillis)
    );
  }
  /**
   * @description Parses an ISO duration, preserving calendar and elapsed components.
   * @param value ISO duration with one sign; sub-millisecond digits are truncated.
   * @return The resulting value.
   */
  private static Decimal secondsMilliseconds(String secondsText) {
    Integer point = secondsText.indexOf('.');
    if (point >= 0 && secondsText.length() > point + 4) {
      secondsText = secondsText.substring(0, point + 4);
    }
    return Decimal.valueOf(secondsText) * 1000;
  }
  /**
   * @description Parses an ISO duration, preserving calendar and elapsed components.
   * @param value ISO duration with one sign; sub-millisecond digits are truncated.
   * @return The resulting value.
   */
  private static Decimal component(Matcher parts, Integer groupNumber) {
    return parts.group(groupNumber) == null
      ? 0
      : Decimal.valueOf(parts.group(groupNumber));
  }
  /**
   * @description Serialises as months, days and seconds without assuming a day length.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static String toIsoString(ChronoDuration source) {
    ChronoDurationOperations.validate(source);
    Boolean negative =
      source.months < 0 ||
      source.days < 0 ||
      source.milliseconds < 0;
    String result = negative ? '-P' : 'P';
    if (source.months != 0) {
      result += String.valueOf(((Decimal) source.months).abs()) + 'M';
    }
    if (source.days != 0) {
      result += String.valueOf(((Decimal) source.days).abs()) + 'D';
    }
    if (source.milliseconds != 0) {
      result +=
        'T' +
        String.valueOf(((Decimal) source.milliseconds).abs().divide(1000, 3)) +
        'S';
    }
    return result == 'P' ? 'PT0S' : result;
  }
  /** @description Rejects incomplete or invalid data before use. */
  public static void validate(ChronoDuration source) {
    ChronoSupport.requireValue(source, 'Value');
    ChronoSupport.requireValue(source.months, 'months');
    ChronoSupport.requireValue(source.days, 'days');
    ChronoSupport.requireValue(source.milliseconds, 'milliseconds');
    if (
      (source.months > 0 || source.days > 0 || source.milliseconds > 0) &&
      (source.months < 0 ||
      source.days < 0 ||
      source.milliseconds < 0)
    ) {
      throw new ChronoException('Duration components must have the same sign.');
    }
  }
}
