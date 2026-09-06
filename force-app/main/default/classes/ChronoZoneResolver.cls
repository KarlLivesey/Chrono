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
    TimeZone zone = ChronoSupport.zone(zoneId);
    Datetime wallClock = Datetime.newInstanceGmt(localDate, localTime);
    Set<Integer> offsets = new Set<Integer>{ zone.getOffset(wallClock) };
    Datetime midnight = Datetime.newInstanceGmt(
      localDate,
      Time.newInstance(0, 0, 0, 0)
    );
    for (Integer day = -3; day <= 3; day++) {
      offsets.add(zone.getOffset(midnight.addDays(day)));
    }
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
    List<Datetime> matches = resolve(local.toDate(), local.toTime(), zoneId);
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
