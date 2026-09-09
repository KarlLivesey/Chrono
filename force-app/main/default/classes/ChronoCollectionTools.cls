// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Stable collection operations with semantic exact-time comparison and explicit calendar grouping. */
public with sharing class ChronoCollectionTools implements ChronoActionOperation { // NOPMD -- Aggregate covers independent collection operations; per-method limits still apply.
  public static ChronoValuesResult execute(ChronoCollectionToolsInput input) {
    ChronoSupport.requireValue(input, 'Input');
    List<ChronoConvertInput> sources = ChronoCollectionValues.sources(input);
    ChronoValuesResult result = new ChronoValuesResult();
    result.success = true;
    result.count = sources.size();
    if (input.operation == 'sumDurations') {
      return sumDurations(sources, result);
    }
    List<ChronoCollectionValues.Entry> entries = new List<ChronoCollectionValues.Entry>();
    for (Integer index = 0; index < sources.size(); index++) {
      entries.add(ChronoCollectionValues.entry(sources[index], index, input));
    }
    List<ChronoCollectionValues.Entry> ordered = new List<ChronoCollectionValues.Entry>();
    ordered.addAll(entries);
    ChronoCollectionValues.sortEntries(ordered);
    Set<String> unique = new Set<String>();
    for (ChronoCollectionValues.Entry item : entries) {
      unique.add(ChronoCollectionValues.key(item));
    }
    result.uniqueCount = unique.size();
    if (!ordered.isEmpty()) {
      result.earliestValue = ordered[0].iso;
      result.latestValue = ordered[ordered.size() - 1].iso;
    }
    entries = chooseEntries(input, entries, ordered);
    if (
      new Set<String>{ 'earliest', 'latest', 'nearest' }
        .contains(input.operation)
    ) {
      result.value = entries.isEmpty() ? null : entries[0].iso;
    }
    result.values = new List<String>();
    result.indexes = new List<Integer>();
    result.groupKeys = new List<String>();
    for (ChronoCollectionValues.Entry item : entries) {
      result.values.add(item.iso);
      result.indexes.add(item.index);
      if (input.operation == 'group') {
        result.groupKeys.add(groupKey(item, input));
      }
    }
    return result;
  }
  private static List<ChronoCollectionValues.Entry> chooseEntries(
    ChronoCollectionToolsInput input,
    List<ChronoCollectionValues.Entry> original,
    List<ChronoCollectionValues.Entry> sorted
  ) {
    switch on input.operation {
      when 'earliest' {
        return sorted.isEmpty()
          ? sorted
          : new List<ChronoCollectionValues.Entry>{ sorted[0] };
      }
      when 'latest' {
        return sorted.isEmpty()
          ? sorted
          : new List<ChronoCollectionValues.Entry>{ sorted[sorted.size() - 1] };
      }
      when 'summary', 'group' {
        return original;
      }
      when 'deduplicate' {
        return distinct(original);
      }
      when 'sort' {
        return sortDirection(sorted, input.direction);
      }
      when 'filter' {
        return filterEntries(original, input);
      }
      when 'nearest' {
        return nearest(original, input);
      }
      when else {
        throw new ChronoException('Choose a supported collection operation.');
      }
    }
  }
  private static List<ChronoCollectionValues.Entry> sortDirection(
    List<ChronoCollectionValues.Entry> sorted,
    String direction
  ) {
    if (String.isBlank(direction) || direction == 'ascending') {
      return sorted;
    }
    ChronoSupport.choice(
      direction,
      new Set<String>{ 'descending' },
      'sort direction'
    );
    // Reverse value groups, preserving original order inside each equal group.
    List<ChronoCollectionValues.Entry> result = new List<ChronoCollectionValues.Entry>();
    Integer last = sorted.size() - 1;
    while (last >= 0) {
      Integer first = last;
      while (
        first > 0 &&
        ChronoCollectionValues.compareValue(sorted[first - 1], sorted[last]) ==
        0
      ) {
        first--;
      }
      for (Integer i = first; i <= last; i++) {
        result.add(sorted[i]);
      }
      last = first - 1;
    }
    return result;
  }
  private static List<ChronoCollectionValues.Entry> distinct(
    List<ChronoCollectionValues.Entry> entries
  ) {
    Set<String> seen = new Set<String>();
    List<ChronoCollectionValues.Entry> result = new List<ChronoCollectionValues.Entry>();
    for (ChronoCollectionValues.Entry item : entries) {
      if (!seen.contains(ChronoCollectionValues.key(item))) {
        seen.add(ChronoCollectionValues.key(item));
        result.add(item);
      }
    }
    return result;
  }
  private static List<ChronoCollectionValues.Entry> filterEntries(
    List<ChronoCollectionValues.Entry> entries,
    ChronoCollectionToolsInput input
  ) {
    ChronoConvertInput context = ChronoCollectionValues.source(input);
    String lowerIso = ChronoAuxiliaryValue.read(input, 'lower', context);
    String upperIso = ChronoAuxiliaryValue.read(input, 'upper', context);
    ChronoCollectionValues.Entry lower = String.isBlank(lowerIso)
      ? null
      : ChronoCollectionValues.point(lowerIso, input);
    ChronoCollectionValues.Entry upper = String.isBlank(upperIso)
      ? null
      : ChronoCollectionValues.point(upperIso, input);
    validateFilter(lower, upper);
    List<ChronoCollectionValues.Entry> result = new List<ChronoCollectionValues.Entry>();
    for (ChronoCollectionValues.Entry item : entries) {
      if (inBounds(item, lower, upper)) {
        result.add(item);
      }
    }
    return result;
  }
  private static void validateFilter(
    ChronoCollectionValues.Entry lower,
    ChronoCollectionValues.Entry upper
  ) {
    if (lower == null && upper == null) {
      throw new ChronoException('Supply at least one filter boundary.');
    }
    if (
      lower != null &&
      upper != null &&
      ChronoCollectionValues.compareValue(lower, upper) > 0
    ) {
      throw new ChronoException('Filter boundaries are reversed.');
    }
  }
  private static Boolean inBounds(
    ChronoCollectionValues.Entry item,
    ChronoCollectionValues.Entry lower,
    ChronoCollectionValues.Entry upper
  ) {
    return (lower == null ||
      ChronoCollectionValues.compareValue(item, lower) >= 0) &&
      (upper == null ||
      ChronoCollectionValues.compareValue(item, upper) < 0);
  }
  private static List<ChronoCollectionValues.Entry> nearest(
    List<ChronoCollectionValues.Entry> entries,
    ChronoCollectionToolsInput input
  ) {
    ChronoCollectionValues.Entry target = ChronoCollectionValues.point(
        ChronoAuxiliaryValue.read(
          input,
          'point',
          ChronoCollectionValues.source(input)
        ),
        input
      ),
      chosen;
    Decimal best;
    for (ChronoCollectionValues.Entry item : entries) {
      Decimal distance = ChronoCollectionValues.distance(item, target);
      if (best == null || distance < best) {
        best = distance;
        chosen = item;
      }
    }
    if (chosen == null) {
      return new List<ChronoCollectionValues.Entry>();
    }
    return new List<ChronoCollectionValues.Entry>{ chosen };
  }
  private static String groupKey(
    ChronoCollectionValues.Entry item,
    ChronoCollectionToolsInput input
  ) {
    ChronoSupport.choice(
      input.period,
      new Set<String>{ 'day', 'week', 'month', 'quarter', 'year' },
      'group period'
    );
    if (item.value.isExact() && String.isBlank(input.timeZoneId)) {
      throw new ChronoException(
        'Exact calendar groups require one calculation timezone.'
      );
    }
    Date day = item.value.wallClock().dateGmt();
    return ChronoIso.dateText(
      ChronoFlowPeriod.periodStart(day, input.period, input.weekStartsOn)
    );
  }
  private static ChronoValuesResult sumDurations(
    List<ChronoConvertInput> sources,
    ChronoValuesResult result
  ) {
    Integer months = 0;
    Integer days = 0;
    Long milliseconds = 0;
    for (ChronoConvertInput source : sources) {
      if (source.valueType != 'Duration') {
        throw new ChronoException('Duration sums require duration values.');
      }
      ChronoDuration value = (ChronoDuration) ChronoFlowValue.read(source)
        .value;
      months += ChronoDurationService.getMonths(value);
      days += ChronoDurationService.getDays(value);
      milliseconds += ChronoDurationService.getMilliseconds(value);
    }
    result.duration = ChronoDurationService.toIsoString(
      ChronoDurationService.create(months, days, milliseconds)
    );
    return result;
  }
  /** @description Executes a concrete request through the internal operation contract. */
  public Object evaluate(Object input) {
    return ChronoCollectionTools.execute((ChronoCollectionToolsInput) input);
  }
  /** @description Supplies the concrete result used to isolate batched results. */
  public Type resultType() {
    return ChronoValuesResult.class;
  }
}
