// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Validates allocation input and compiles recurring block clocks once. */
public with sharing class ChronoAllocationRules {
  public String zoneId;
  public String mode;
  public String basis;
  public String unitName;
  public Long unit;
  public Integer maximum;
  public ChronoIntervals.Span bounds;
  public Date firstDay;
  public Date lastDay;
  public List<ChronoAllocationBlocks.Block> blocks;
  public List<Holiday> holidays;
  public ChronoAllocationRules(ChronoTimeAllocationRequest input) {
    ChronoSupport.requireValue(input, 'Allocation request');
    ChronoDates.validateInstant(input.startInstant);
    ChronoDates.validateInstant(input.endInstant);
    ChronoIntervals.span(
      input.startInstant.getTime(),
      input.endInstant.getTime()
    );
    zoneId = ChronoSupport.zone(input.timeZoneId).getID();
    configure(input);
    setBounds(input);
    blocks = ChronoAllocationBlocks.compile(input.blocks);
    holidays = input.holidays == null ? new List<Holiday>() : input.holidays;
    if (holidays.size() > 1000) {
      throw new ChronoException('Supply at most 1000 holidays per request.');
    }
    ChronoHolidays.validate(holidays);
  }
  private void configure(ChronoTimeAllocationRequest input) {
    mode = option(input.overlapMode, 'overlap mode');
    basis = option(input.timeBasis, 'time basis');
    unitName = option(input.allocationUnit, 'allocation unit');
    unit = new Map<String, Long>{
        'millisecond' => 1L,
        'second' => 1000L,
        'minute' => 60000L
      }
      .get(unitName);
    maximum = input.maximumSegments == null ? 1000 : input.maximumSegments;
    if (maximum < 1 || maximum > 5000) {
      throw new ChronoException('Maximum segment rows must be 1–5000.');
    }
  }
  private void setBounds(ChronoTimeAllocationRequest input) {
    Datetime start = ChronoSupport.localValue(input.startInstant, zoneId);
    Datetime finish = ChronoSupport.localValue(input.endInstant, zoneId);
    if (basis == 'clock' && finish < start) {
      throw new ChronoException(
        'Clock-time end precedes its start after a clock change. Use elapsed time for this interval.'
      );
    }
    bounds = ChronoIntervals.span(
      basis == 'clock' ? start.getTime() : input.startInstant.getTime(),
      basis == 'clock' ? finish.getTime() : input.endInstant.getTime()
    );
    firstDay = start.dateGmt();
    lastDay = finish.dateGmt();
    if (bounds.finish - bounds.start > 366L * 86400000L) {
      throw new ChronoException(
        'Time allocation is limited to 366 days per request.'
      );
    }
    expandElapsedDays(input);
  }
  private void expandElapsedDays(ChronoTimeAllocationRequest input) {
    if (basis == 'elapsed') {
      firstDay = input.startInstant.dateGmt();
      lastDay = input.endInstant.dateGmt();
      if (firstDay > Date.newInstance(1, 1, 1)) {
        firstDay = firstDay.addDays(-1);
      }
      if (lastDay < Date.newInstance(9999, 12, 31)) {
        lastDay = lastDay.addDays(1);
      }
    }
  }
  private static String option(String value, String label) {
    List<String> options = new Map<String, List<String>>{
        'overlap mode' => new List<String>{
          'strict',
          'lax',
          'duplicate',
          'split'
        },
        'time basis' => new List<String>{ 'elapsed', 'clock' },
        'allocation unit' => new List<String>{
          'millisecond',
          'second',
          'minute'
        }
      }
      .get(label);
    String result = String.isBlank(value) ? options[0] : value;
    ChronoSupport.choice(result, new Set<String>(options), label);
    return result;
  }
}
