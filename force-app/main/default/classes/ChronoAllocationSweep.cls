// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Sweeps half-open block boundaries in time order, preserving configured priority. */
public with sharing class ChronoAllocationSweep {
  private Map<Long, List<Integer>> starts = new Map<Long, List<Integer>>();
  private Map<Long, List<Integer>> ends = new Map<Long, List<Integer>>();
  public ChronoTimeAllocationResult allocate(ChronoAllocationRules rules) {
    Set<Long> ticks = new Set<Long>{ rules.bounds.start, rules.bounds.finish };
    for (
      ChronoAllocationWindows.Window window : new ChronoAllocationWindows(rules)
        .build()
    ) {
      add(starts, window.span.start, window.block);
      add(ends, window.span.finish, window.block);
      ticks.add(window.span.start);
      ticks.add(window.span.finish);
    }
    List<Long> ordered = new List<Long>(ticks);
    ordered.sort();
    Map<Integer, Integer> active = new Map<Integer, Integer>();
    ChronoAllocationLedger ledger = new ChronoAllocationLedger(rules);
    for (Integer i = 0; i < ordered.size() - 1; i++) {
      updateActive(active, ends.get(ordered[i]), -1);
      updateActive(active, starts.get(ordered[i]), 1);
      List<Integer> matches = new List<Integer>(active.keySet());
      matches.sort();
      ledger.credit(ordered[i], ordered[i + 1], matches);
    }
    return ledger.complete();
  }
  private static void add(
    Map<Long, List<Integer>> events,
    Long tick,
    Integer index
  ) {
    if (!events.containsKey(tick)) {
      events.put(tick, new List<Integer>());
    }
    events.get(tick).add(index);
  }
  private static void updateActive(
    Map<Integer, Integer> active,
    List<Integer> changes,
    Integer delta
  ) {
    if (changes == null) {
      return;
    }
    for (Integer index : changes) {
      Integer count =
        (active.containsKey(index) ? active.get(index) : 0) + delta;
      if (count == 0) {
        active.remove(index);
      } else {
        active.put(index, count);
      }
    }
  }
}
