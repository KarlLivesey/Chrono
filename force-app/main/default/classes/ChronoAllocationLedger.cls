// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Credits each atomic overlap segment and accounts explicitly for duplication and rounding. */
public with sharing class ChronoAllocationLedger {
  private final ChronoAllocationRules rules;
  public final ChronoTimeAllocationResult result;
  private Integer laxWinner;
  private Long laxLength = 0;
  private List<ChronoTimeAllocationRow> laxRows = new List<ChronoTimeAllocationRow>();
  public ChronoAllocationLedger(ChronoAllocationRules rules) {
    this.rules = rules;
    result = new ChronoTimeAllocationResult();
    result.success = true;
    result.timeZoneId = rules.zoneId;
    result.timeBasis = rules.basis;
    result.overlapMode = rules.mode;
    result.allocationUnit = rules.unitName;
    result.inputMilliseconds = rules.bounds.finish - rules.bounds.start;
    result.allocatedMilliseconds = 0;
    result.unallocatedMilliseconds = 0;
    result.duplicateMilliseconds = 0;
    result.roundingMilliseconds = 0;
    result.totals = new List<ChronoTimeAllocationRow>();
    result.segments = new List<ChronoTimeAllocationRow>();
    for (ChronoAllocationBlocks.Block block : rules.blocks) {
      ChronoTimeAllocationRow row = new ChronoTimeAllocationRow();
      row.blockKey = block.key;
      row.label = block.label;
      row.matchedMilliseconds = 0;
      row.allocatedMilliseconds = 0;
      row.allocatedDuration = 'PT0S';
      result.totals.add(row);
    }
  }
  public void credit(Long start, Long finish, List<Integer> matches) {
    if (finish <= start) {
      return;
    }
    Long length = finish - start;
    beginLaxRegion(matches.isEmpty() ? null : matches[0]);
    ChronoIntervals.Span bounds = ChronoIntervals.span(start, finish);
    if (matches.isEmpty()) {
      result.unallocatedMilliseconds += length;
      addSegment(null, bounds, 0L);
      return;
    }
    if (rules.mode == 'strict' && matches.size() > 1) {
      throw new ChronoException(
        'Worked time matches overlapping blocks: ' +
          rules.blocks[matches[0]].key +
          ' and ' +
          rules.blocks[matches[1]].key +
          '. Change the blocks or overlap mode.'
      );
    }
    creditMatches(bounds, matches);
  }
  private void creditMatches(
    ChronoIntervals.Span bounds,
    List<Integer> matches
  ) {
    Long length = bounds.finish - bounds.start;
    // Lax mode rounds a continuous winning interval, not incidental boundaries
    // from blocks receiving no credit. Keep its diagnostic rows at millisecond precision.
    Long quantum = rules.mode == 'lax' ? 1L : rules.unit;
    Long units = length / quantum;
    Long remainder = length - units * quantum;
    Integer copies = rules.mode == 'duplicate' ? matches.size() : 1;
    result.duplicateMilliseconds += length * (copies - 1);
    result.roundingMilliseconds += remainder * copies;
    for (Integer rank = 0; rank < matches.size(); rank++) {
      Integer index = matches[rank];
      Long share = shareUnits(units, rank, matches.size());
      Long amount = share * quantum;
      ChronoTimeAllocationRow total = result.totals[index];
      total.matchedMilliseconds += length;
      total.allocatedMilliseconds += amount;
      total.allocatedDuration = duration(total.allocatedMilliseconds);
      result.allocatedMilliseconds += amount;
      ChronoTimeAllocationRow segment = addSegment(index, bounds, amount);
      if (rules.mode == 'lax' && rank == 0) {
        laxLength += length;
        laxRows.add(segment);
      }
    }
  }
  public ChronoTimeAllocationResult complete() {
    settleLaxRegion();
    return result;
  }
  private void beginLaxRegion(Integer winner) {
    if (rules.mode == 'lax' && winner != laxWinner) {
      settleLaxRegion();
      laxWinner = winner;
    }
  }
  private void settleLaxRegion() {
    if (laxWinner == null || laxLength == 0) {
      return;
    }
    Long remainder = laxLength - (laxLength / rules.unit) * rules.unit;
    result.roundingMilliseconds += remainder;
    result.allocatedMilliseconds -= remainder;
    ChronoTimeAllocationRow total = result.totals[laxWinner];
    total.allocatedMilliseconds -= remainder;
    total.allocatedDuration = duration(total.allocatedMilliseconds);
    // Attribute discarded trailing milliseconds to their actual segments.
    // The row totals still reconcile with the block total after rounding.
    for (Integer i = laxRows.size() - 1; i >= 0 && remainder > 0; i--) {
      ChronoTimeAllocationRow row = laxRows[i];
      Long discarded = Math.min(remainder, row.allocatedMilliseconds);
      row.allocatedMilliseconds -= discarded;
      row.allocatedDuration = duration(row.allocatedMilliseconds);
      remainder -= discarded;
    }
    laxLength = 0;
    laxRows.clear();
  }
  private Long shareUnits(Long units, Integer rank, Integer count) {
    if (rules.mode == 'split') {
      Long equalShare = units / count;
      Long extra = units - equalShare * count;
      return equalShare + (rank < extra ? 1L : 0L);
    }
    return rules.mode == 'duplicate' || rank == 0 ? units : 0L;
  }
  private ChronoTimeAllocationRow addSegment(
    Integer index,
    ChronoIntervals.Span bounds,
    Long allocated
  ) {
    if (result.segments.size() == rules.maximum) {
      throw new ChronoException(
        'Allocation segment limit exceeded. Narrow the interval or increase maximum segment rows.'
      );
    }
    ChronoTimeAllocationRow row = new ChronoTimeAllocationRow();
    row.blockKey = index == null ? null : rules.blocks[index].key;
    row.label = index == null ? 'Unallocated' : rules.blocks[index].label;
    row.startValue = text(bounds.start);
    row.endValue = text(bounds.finish);
    row.matchedMilliseconds = bounds.finish - bounds.start;
    row.allocatedMilliseconds = allocated;
    row.allocatedDuration = duration(allocated);
    result.segments.add(row);
    return row;
  }
  private String text(Long ticks) {
    Datetime value = Datetime.newInstance(ticks);
    if (rules.basis == 'elapsed') {
      return ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.create(value, rules.zoneId)
      );
    }
    return ChronoIso.dateText(value.dateGmt()) +
      'T' +
      ChronoIso.timeText(value.timeGmt());
  }
  private static String duration(Long milliseconds) {
    return ChronoDurationService.toIsoString(
      ChronoDurationService.create(0, 0, milliseconds)
    );
  }
}
