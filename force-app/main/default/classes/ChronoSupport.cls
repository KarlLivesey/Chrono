// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal native-value validation and ISO representation helpers. */
public with sharing class ChronoSupport {
  public static void requireValue(Object value, String label) {
    if (value == null) {
      throw new ChronoException(label + ' is required.');
    }
  }
  public static void requireMatch(
    String value,
    String expression,
    String label
  ) {
    if (value == null || !Pattern.matches(expression, value)) {
      throw new ChronoException('Invalid ' + label + ': ' + value);
    }
  }
  public static TimeZone zone(String zoneId) {
    if (String.isBlank(zoneId)) {
      throw new ChronoException('Time-zone ID is required.');
    }
    TimeZone result = TimeZone.getTimeZone(zoneId);
    if (
      result.getID() == 'GMT' &&
      !new Set<String>{ 'GMT', 'UTC', 'Etc/UTC', 'Etc/GMT', 'Z' }
        .contains(zoneId)
    ) {
      throw new ChronoException('Unknown time-zone ID: ' + zoneId);
    }
    return result;
  }
  public static Datetime localValue(Datetime instant, String zoneId) {
    requireValue(instant, 'Datetime');
    return Datetime.newInstance(
      instant.getTime() + zone(zoneId).getOffset(instant)
    );
  }
  public static Long hours(Integer amount) {
    requireValue(amount, 'Hours');
    return ((Long) amount) * 3600000L;
  }
  public static Long minutes(Integer amount) {
    requireValue(amount, 'Minutes');
    return ((Long) amount) * 60000L;
  }
  public static Datetime shift(Datetime value, Long millis) {
    requireValue(millis, 'Milliseconds');
    return Datetime.newInstance(value.getTime() + millis);
  }
}
