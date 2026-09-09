// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Projects native instants into data-only picker options. */
public with sharing class ChronoPickerOptions {
  public static ChronoPickerOption create(
    Datetime instant,
    String zoneId,
    String direction
  ) {
    Datetime local = ChronoSupport.localValue(instant, zoneId);
    ChronoPickerOption result = new ChronoPickerOption();
    result.instantValue = instant;
    result.localValue =
      ChronoIso.dateText(local.dateGmt()) +
      'T' +
      ChronoIso.timeText(local.timeGmt());
    result.offsetSeconds = ChronoSupport.zone(zoneId).getOffset(instant) / 1000;
    result.choice = direction;
    return result;
  }
}
