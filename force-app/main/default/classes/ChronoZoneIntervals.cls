// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Intersects local clock intervals with constant-offset UTC segments, preserving gaps and repeated opening windows. */
public with sharing class ChronoZoneIntervals {
  private static final Long SIX_HOURS = 21600000L;
  private final TimeZone zone;
  private final List<Segment> segments = new List<Segment>();
  public ChronoZoneIntervals(Date day, String zoneId) {
    zone = ChronoSupport.zone(zoneId);
    Long cursor =
      Datetime.newInstanceGmt(day, Time.newInstance(0, 0, 0, 0)).getTime() -
      86400000L;
    Long endTime = cursor + 259200000L;
    while (cursor < endTime) {
      Integer offset = zone.getOffset(Datetime.newInstance(cursor));
      Long next = Math.min(cursor + SIX_HOURS, endTime);
      if (zone.getOffset(Datetime.newInstance(next - 1)) != offset) {
        next = transition(cursor, next - 1, offset);
      }
      append(cursor, next, offset);
      cursor = next;
    }
  }
  public List<ChronoScheduleDay.Span> between(
    Datetime localStart,
    Datetime localEnd
  ) {
    List<ChronoScheduleDay.Span> result = new List<ChronoScheduleDay.Span>();
    for (Segment segment : segments) {
      Long startTime = Math.max(
        segment.startTime,
        localStart.getTime() - segment.offset
      );
      Long endTime = Math.min(
        segment.endTime,
        localEnd.getTime() - segment.offset
      );
      if (startTime < endTime) {
        result.add(ChronoScheduleDay.span(startTime, endTime));
      }
    }
    return result;
  }
  private void append(Long startTime, Long endTime, Integer offset) {
    if (!segments.isEmpty() && segments[segments.size() - 1].offset == offset) {
      segments[segments.size() - 1].endTime = endTime;
    } else {
      segments.add(new Segment(startTime, endTime, offset));
    }
  }
  private Long transition(Long lower, Long upper, Integer oldOffset) {
    while (upper - lower > 1) {
      Long middle = lower + (upper - lower) / 2;
      if (zone.getOffset(Datetime.newInstance(middle)) == oldOffset) {
        lower = middle;
      } else {
        upper = middle;
      }
    }
    return upper;
  }
  private class Segment {
    private final Long startTime;
    private Long endTime;
    private final Integer offset;
    private Segment(Long startTime, Long endTime, Integer offset) {
      this.startTime = startTime;
      this.endTime = endTime;
      this.offset = offset;
    }
  }
}
