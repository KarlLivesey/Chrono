// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Finds Salesforce offset changes using hourly samples and millisecond bisection. Searches are bounded to 366 days. */
public with sharing class ChronoZoneTransitions {
  // Salesforce exposes offsets rather than a transition table. Hourly bracketing assumes no two changes within one hour.
  private static Integer samples = 0;
  public static void search(
    ChronoZoneToolsInput input,
    Datetime anchor,
    ChronoZoneResult result
  ) {
    new Search(input, anchor, result).run();
  }
  private class Search {
    private final ChronoZoneToolsInput input;
    private final ChronoZoneResult result;
    private final TimeZone zone;
    private final Boolean backwards;
    private final Long anchor;
    private Long start;
    private Long finish;
    private Search(
      ChronoZoneToolsInput input,
      Datetime anchor,
      ChronoZoneResult result
    ) {
      this.input = input;
      this.result = result;
      this.anchor = anchor.getTime();
      backwards = input.operation == 'previousTransition';
      zone = ChronoSupport.zone(result.timeZoneId);
      bounds();
      result.transitionValues = new List<String>();
      result.offsetsBefore = new List<Integer>();
      result.offsetsAfter = new List<Integer>();
    }
    private void bounds() {
      Integer days = searchDays(input.searchDays);
      start = anchor;
      if (input.operation == 'transitions') {
        ChronoSupport.requireValue(input.endInstant, 'Search end');
        finish = input.endInstant.getTime();
        if (finish <= start || finish - start > 366L * 86400000) {
          throw new ChronoException(
            'Transition interval must be positive and at most 366 days.'
          );
        }
      } else {
        finish = start + (backwards ? -1L : 1L) * days * 86400000L;
      }
      if (backwards) {
        Long swap = start;
        start = finish;
        finish = swap;
      }
    }
    private void run() {
      if (input.operation == 'transitions') {
        appendLowerBoundary();
      }
      scan();
      if (backwards && result.transitionValues.isEmpty()) {
        appendLowerBoundary();
      }
      result.found = !result.transitionValues.isEmpty();
    }
    private void scan() {
      Long cursor = backwards ? finish - 1 : start;
      Integer prior = zone.getOffset(Datetime.newInstance(cursor));
      while (backwards ? cursor > start : cursor < finish) {
        requireBudget();
        Long next = backwards
          ? Math.max(start, cursor - 3600000)
          : Math.min(finish, cursor + 3600000);
        Integer current = zone.getOffset(Datetime.newInstance(next));
        if (current != prior && record(cursor, next)) {
          break;
        }
        cursor = next;
        prior = current;
      }
    }
    private void appendLowerBoundary() {
      if (
        zone.getOffset(Datetime.newInstance(start - 1)) !=
        zone.getOffset(Datetime.newInstance(start))
      ) {
        append(result, start, zone);
      }
    }
    private Boolean record(Long cursor, Long next) {
      Long transition = boundary(
        Math.min(cursor, next),
        Math.max(cursor, next),
        zone
      );
      // Listing is [start,end); navigation is strictly before or after its anchor.
      if (
        transition >= finish ||
        (input.operation != 'transitions' &&
        transition == anchor)
      ) {
        return false;
      }
      append(result, transition, zone);
      return input.operation != 'transitions';
    }
  }
  private static Integer searchDays(Integer value) {
    Integer days = value == null ? 366 : value;
    if (days < 1 || days > 366) {
      throw new ChronoException('Search days must be 1–366.');
    }
    return days;
  }
  private static void requireBudget() {
    if (++samples > 40000) {
      throw new ChronoException(
        'Too many distinct transition searches in one transaction. Use a smaller search window.'
      );
    }
  }
  private static Long boundary(Long lower, Long upper, TimeZone zone) {
    Integer initial = zone.getOffset(Datetime.newInstance(lower));
    while (upper - lower > 1) {
      Long middle = lower + (upper - lower) / 2;
      if (zone.getOffset(Datetime.newInstance(middle)) == initial) {
        lower = middle;
      } else {
        upper = middle;
      }
    }
    return upper;
  }
  private static void append(
    ChronoZoneResult result,
    Long transition,
    TimeZone zone
  ) {
    result.transitionValues.add(
      ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.create(
          Datetime.newInstance(transition),
          result.timeZoneId
        )
      )
    );
    result.offsetsBefore.add(
      zone.getOffset(Datetime.newInstance(transition - 1)) / 1000
    );
    result.offsetsAfter.add(
      zone.getOffset(Datetime.newInstance(transition)) / 1000
    );
  }
}
