// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Shared exact occurrences and nearest valid clock-gap boundaries for Apex and UI adapters. */
public with sharing class ChronoLocalCandidates {
  public static List<ChronoPickerOption> resolveLocal(
    String dateValue,
    String timeValue,
    String timeZoneId
  ) {
    Date day = ChronoIso.parseDate(dateValue);
    Time clockValue = ChronoIso.parseTime(timeValue);
    List<Datetime> matches = ChronoZoneResolver.resolve(
      day,
      clockValue,
      timeZoneId
    );
    List<ChronoPickerOption> result = new List<ChronoPickerOption>();
    for (Integer i = 0; i < matches.size(); i++) {
      result.add(
        ChronoPickerOptions.create(
          matches[i],
          timeZoneId,
          matches.size() == 1 ? 'exact' : (i == 0 ? 'earlier' : 'later')
        )
      );
    }
    if (!matches.isEmpty()) {
      return result;
    }
    return gapOptions(Datetime.newInstanceGmt(day, clockValue), timeZoneId);
  }
  // Find the last/first valid millisecond around the actual transition.
  // Core resolution still rejects gaps.
  private static List<ChronoPickerOption> gapOptions(
    Datetime wallClock,
    String zoneId
  ) {
    TimeZone zone = ChronoSupport.zone(zoneId);
    Datetime beforeInstant;
    Datetime afterInstant;
    Datetime beforeLocal;
    Datetime afterLocal;
    for (
      Integer offset : ChronoZoneResolver.sampleOffsets(
        wallClock.dateGmt(),
        zoneId
      )
    ) {
      Datetime candidate = Datetime.newInstance(wallClock.getTime() - offset);
      Datetime local = ChronoSupport.localValue(candidate, zoneId);
      if (nearerBefore(local, beforeLocal, wallClock)) {
        beforeLocal = local;
        beforeInstant = candidate;
      }
      if (nearerAfter(local, afterLocal, wallClock)) {
        afterLocal = local;
        afterInstant = candidate;
      }
    }
    if (
      beforeInstant == null ||
      afterInstant == null ||
      wallClock.getTime() - beforeLocal.getTime() !=
      afterLocal.getTime() - wallClock.getTime()
    ) {
      throw new ChronoException(
        'Cannot offer a safe clock-change correction. Choose another local time.'
      );
    }
    Long upper = transition(beforeInstant, afterInstant, zone);
    Long lower = upper - 1;
    return new List<ChronoPickerOption>{
      ChronoPickerOptions.create(
        Datetime.newInstance(lower),
        zoneId,
        'backward'
      ),
      ChronoPickerOptions.create(Datetime.newInstance(upper), zoneId, 'forward')
    };
  }
  private static Boolean nearerBefore(
    Datetime local,
    Datetime best,
    Datetime requested
  ) {
    return local < requested && (best == null || local > best);
  }
  private static Boolean nearerAfter(
    Datetime local,
    Datetime best,
    Datetime requested
  ) {
    return local > requested && (best == null || local < best);
  }
  private static Long transition(
    Datetime beforeInstant,
    Datetime afterInstant,
    TimeZone zone
  ) {
    Long lower = beforeInstant.getTime();
    Long upper = afterInstant.getTime();
    Integer initialOffset = zone.getOffset(beforeInstant);
    while (upper - lower > 1) {
      Long middle = lower + (upper - lower) / 2;
      if (zone.getOffset(Datetime.newInstance(middle)) == initialOffset) {
        lower = middle;
      } else {
        upper = middle;
      }
    }
    return upper;
  }
}
