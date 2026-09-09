// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Resolves wall-clock values using Karl's sampled-offset resolver. */
public with sharing class ChronoZoneResolver {
  public static List<Datetime> resolve(
    Date localDate,
    Time localTime,
    String zoneId
  ) {
    ChronoSupport.requireValue(localDate, 'Date');
    ChronoSupport.requireValue(localTime, 'Time');
    Datetime wallClock = Datetime.newInstanceGmt(localDate, localTime);
    Set<Integer> offsets = sampleOffsets(localDate, zoneId);
    List<Datetime> matches = new List<Datetime>();
    for (Integer offset : offsets) {
      Datetime candidate = Datetime.newInstance(wallClock.getTime() - offset);
      if (ChronoSupport.localValue(candidate, zoneId) == wallClock) {
        matches.add(candidate);
      }
    }
    matches.sort();
    return matches;
  }
  /** @description Samples nearby offsets for exact resolution and explicit picker gap corrections. */
  public static Set<Integer> sampleOffsets(Date localDate, String zoneId) {
    TimeZone zone = ChronoSupport.zone(zoneId);
    Datetime midnight = Datetime.newInstanceGmt(
      localDate,
      Time.newInstance(0, 0, 0, 0)
    );
    Set<Integer> offsets = new Set<Integer>();
    for (Integer hour = -72; hour <= 72; hour += 6) {
      offsets.add(zone.getOffset(midnight.addHours(hour)));
    }
    return offsets;
  }
  public static Datetime choose(
    ChronoPlainDateTime local,
    String zoneId,
    String disambiguation
  ) {
    if (
      !new Set<String>{ 'reject', 'earlier', 'later' }.contains(disambiguation)
    ) {
      throw new ChronoException(
        'Disambiguation must be reject, earlier or later.'
      );
    }
    List<Datetime> matches = resolve(
      ChronoPlainDateTimeService.toDate(local),
      ChronoPlainDateTimeService.toTime(local),
      zoneId
    );
    if (matches.isEmpty()) {
      throw new ChronoException(
        'Local datetime does not exist in ' + zoneId + '.'
      );
    }
    if (matches.size() > 1 && disambiguation == 'reject') {
      throw new ChronoException(
        'Local datetime is repeated in ' + zoneId + '; choose earlier or later.'
      );
    }
    return disambiguation == 'later' ? matches[matches.size() - 1] : matches[0];
  }
}
