// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Protects the four-digit ISO calendar contract before native Apex arithmetic. */
public with sharing class ChronoDates {
  private static final Long MIN_INSTANT = Datetime.newInstanceGmt(
      1,
      1,
      1,
      0,
      0,
      0
    )
    .getTime();
  private static final Long MAX_INSTANT =
    Datetime.newInstanceGmt(9999, 12, 31, 23, 59, 59).getTime() + 999;
  public static void validate(Date value) {
    ChronoSupport.requireValue(value, 'Date');
    if (value.year() < 1 || value.year() > 9999) {
      throw new ChronoException(
        'Date is outside the supported ISO range 0001–9999.'
      );
    }
  }
  public static void validateInstant(Datetime value) {
    ChronoSupport.requireValue(value, 'Datetime');
    // Native year extraction loses the era for instants before year 1.
    if (value.getTime() < MIN_INSTANT || value.getTime() > MAX_INSTANT) {
      throw new ChronoException(
        'Datetime is outside the supported ISO range 0001–9999.'
      );
    }
  }
  public static Date addDays(Date value, Integer amount) {
    validate(value);
    ChronoSupport.requireValue(amount, 'Days');
    if (
      amount < Date.newInstance(1, 1, 1).daysBetween(value) * -1 ||
      amount > value.daysBetween(Date.newInstance(9999, 12, 31))
    ) {
      throw new ChronoException(
        'Date arithmetic exceeds the supported ISO range 0001–9999.'
      );
    }
    return value.addDays(amount);
  }
  public static Date addMonths(Date value, Long amount) {
    validate(value);
    ChronoSupport.requireValue(amount, 'Months');
    Long monthIndex = (value.year() - 1) * 12 + value.month() - 1;
    if (amount < -monthIndex || amount > 119987 - monthIndex) {
      throw new ChronoException(
        'Date arithmetic exceeds the supported ISO range 0001–9999.'
      );
    }
    return value.addMonths(amount.intValue());
  }
  public static Date addYears(Date value, Integer amount) {
    ChronoSupport.requireValue(amount, 'Years');
    return addMonths(value, (Long) amount * 12);
  }
}
