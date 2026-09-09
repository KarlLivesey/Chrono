// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Checked numeric conversions before Apex can wrap overflowing values. */
public with sharing class ChronoNumbers {
  private static final Decimal MIN_CALENDAR = -2147483648L;
  private static final Decimal MAX_CALENDAR = 2147483647L;
  private static final Decimal MIN_MILLISECONDS = Decimal.valueOf(
    '-9223372036854775808'
  );
  private static final Decimal MAX_MILLISECONDS = 9223372036854775807L;
  public static Integer calendar(Decimal value) {
    ChronoSupport.requireValue(value, 'Calendar amount');
    if (
      value < MIN_CALENDAR ||
      value > MAX_CALENDAR ||
      value != value.setScale(0, RoundingMode.DOWN)
    ) {
      throw new ChronoException(
        'Calendar amount exceeds the supported whole-integer range.'
      );
    }
    return value.intValue();
  }
  /** @description Truncates fractional milliseconds towards zero, then checks the signed Long range. */
  public static Long milliseconds(Decimal value) {
    ChronoSupport.requireValue(value, 'Milliseconds');
    Decimal whole = value.setScale(0, RoundingMode.DOWN);
    if (whole < MIN_MILLISECONDS || whole > MAX_MILLISECONDS) {
      throw new ChronoException(
        'Duration exceeds the supported millisecond range.'
      );
    }
    return whole.longValue();
  }
}
