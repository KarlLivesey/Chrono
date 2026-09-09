// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Expands named block windows without merging different block identities. */
public with sharing class ChronoAllocationWindows {
  private final ChronoAllocationRules rules;
  private Integer windows = 0;
  public ChronoAllocationWindows(ChronoAllocationRules rules) {
    this.rules = rules;
  }
  public List<Window> build() {
    List<Window> result = new List<Window>();
    if (rules.bounds.start == rules.bounds.finish) {
      return result;
    }
    Date day = rules.firstDay;
    while (day <= rules.lastDay) {
      result.addAll(dayWindows(day));
      if (day == rules.lastDay) {
        break;
      }
      day = ChronoDates.addDays(day, 1);
    }
    return result;
  }
  private List<Window> dayWindows(Date day) {
    Long midnight = Datetime.newInstanceGmt(day, Time.newInstance(0, 0, 0, 0))
      .getTime();
    ChronoZoneIntervals zones = rules.basis == 'elapsed'
      ? new ChronoZoneIntervals(day, rules.zoneId)
      : null;
    List<ChronoIntervals.Span> holiday = holidayWindows(day, midnight, zones);
    List<Window> result = new List<Window>();
    for (Integer index = 0; index < rules.blocks.size(); index++) {
      List<ChronoIntervals.Span> candidates = blockWindows(index, day, zones);
      candidates = rules.blocks[index].holiday
        ? ChronoIntervals.intersect(candidates, holiday)
        : ChronoIntervals.subtract(candidates, holiday);
      candidates = ChronoIntervals.intersect(
        candidates,
        new List<ChronoIntervals.Span>{ rules.bounds }
      );
      for (ChronoIntervals.Span span : candidates) {
        if (++windows > 10000) {
          throw new ChronoException(
            'Too many block windows. Narrow the worked interval or reduce the number of blocks.'
          );
        }
        Window window = new Window();
        window.block = index;
        window.span = span;
        result.add(window);
      }
    }
    return result;
  }
  private List<ChronoIntervals.Span> blockWindows(
    Integer index,
    Date day,
    ChronoZoneIntervals zones
  ) {
    Long midnight = Datetime.newInstanceGmt(day, Time.newInstance(0, 0, 0, 0))
      .getTime();
    ChronoAllocationBlocks.Block block = rules.blocks[index];
    List<ChronoIntervals.Span> result = new List<ChronoIntervals.Span>();
    // Weekday selection belongs to the block start date. Holiday classification
    // belongs to each actual calendar day, including the tail of overnight blocks.
    for (
      Integer previous = 0;
      previous <= (block.finish > 86400000L ? 1 : 0);
      previous++
    ) {
      if (previous == 1 && day == Date.newInstance(1, 1, 1)) {
        continue;
      }
      Date anchor = previous == 0 ? day : day.addDays(-1);
      Integer weekday = Math.mod(ChronoHolidays.weekday(anchor) + 6, 7) + 1;
      if (!block.days.contains(weekday)) {
        continue;
      }
      Long start = Math.max(
        midnight,
        midnight - previous * 86400000L + block.start
      );
      Long finish = Math.min(
        midnight + 86400000L,
        midnight - previous * 86400000L + block.finish
      );
      result.addAll(project(start, finish, zones));
    }
    return result;
  }
  private List<ChronoIntervals.Span> holidayWindows(
    Date day,
    Long midnight,
    ChronoZoneIntervals zones
  ) {
    List<ChronoIntervals.Span> result = new List<ChronoIntervals.Span>();
    for (Holiday holiday : rules.holidays) {
      if (!ChronoHolidays.occurs(holiday, day)) {
        continue;
      }
      Long start = holiday.IsAllDay == true
        ? 0L
        : ((Long) holiday.StartTimeInMinutes) * 60000L;
      Long finish = holiday.IsAllDay == true
        ? 86400000L
        : ((Long) holiday.EndTimeInMinutes) * 60000L;
      result.addAll(project(midnight + start, midnight + finish, zones));
    }
    return ChronoIntervals.unionSpans(result);
  }
  private static List<ChronoIntervals.Span> project(
    Long start,
    Long finish,
    ChronoZoneIntervals zones
  ) {
    List<ChronoIntervals.Span> result = new List<ChronoIntervals.Span>();
    if (finish <= start) {
      return result;
    }
    if (zones == null) {
      result.add(ChronoIntervals.span(start, finish));
    } else {
      for (
        ChronoScheduleDay.Span span : zones.between(
          Datetime.newInstance(start),
          Datetime.newInstance(finish)
        )
      ) {
        result.add(ChronoIntervals.span(span.startTime, span.endTime));
      }
    }
    return result;
  }
  public class Window {
    public Integer block;
    public ChronoIntervals.Span span;
  }
}
