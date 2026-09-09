// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Converts one operating-schedule day to open UTC intervals. */
public with sharing class ChronoScheduleDay {
  private static final List<String> WEEKDAYS = new List<String>{
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  };
  private static final Time MIDNIGHT = Time.newInstance(0, 0, 0, 0);
  private final String zoneId;
  private final List<TimeSlot> slots;
  private final List<Holiday> holidays;
  public ChronoScheduleDay(
    String zoneId,
    List<TimeSlot> slots,
    List<Holiday> holidays
  ) {
    this.zoneId = zoneId;
    this.slots = slots;
    this.holidays = holidays;
  }
  public List<Span> spansFor(Date day) {
    List<Span> result = new List<Span>();
    ChronoZoneIntervals intervals = new ChronoZoneIntervals(day, zoneId);
    for (TimeSlot slot : slots) {
      if (slot.DayOfWeek == WEEKDAYS[ChronoHolidays.weekday(day)]) {
        result.addAll(
          intervals.between(
            Datetime.newInstanceGmt(day, slot.StartTime),
            Datetime.newInstanceGmt(day, slot.EndTime)
          )
        );
      }
    }
    result.sort(new SpanComparator());
    List<Span> merged = new List<Span>();
    for (Span opening : result) {
      if (
        !merged.isEmpty() &&
        opening.startTime <= merged[merged.size() - 1].endTime
      ) {
        Span previous = merged[merged.size() - 1];
        previous.endTime = Math.max(previous.endTime, opening.endTime);
      } else {
        merged.add(opening);
      }
    }
    result = merged;
    for (Holiday holiday : holidays) {
      if (ChronoHolidays.occurs(holiday, day)) {
        for (Span closed : holidaySpans(holiday, day, intervals)) {
          result = subtract(result, closed);
        }
      }
    }
    return result;
  }
  private List<Span> holidaySpans(
    Holiday holiday,
    Date day,
    ChronoZoneIntervals intervals
  ) {
    Datetime midnight = Datetime.newInstanceGmt(day, MIDNIGHT);
    if (holiday.IsAllDay) {
      return intervals.between(midnight, midnight.addDays(1));
    }
    Integer startMinutes = holiday.StartTimeInMinutes;
    Integer endMinutes = holiday.EndTimeInMinutes;
    if (
      startMinutes == null ||
      endMinutes == null ||
      startMinutes < 0 ||
      endMinutes > 1440 ||
      endMinutes <= startMinutes
    ) {
      throw new ChronoException('Invalid partial-day holiday hours.');
    }
    return intervals.between(
      midnight.addMinutes(startMinutes),
      midnight.addMinutes(endMinutes)
    );
  }
  private List<Span> subtract(List<Span> openings, Span closed) {
    List<Span> result = new List<Span>();
    for (Span opening : openings) {
      if (
        closed.endTime <= opening.startTime ||
        closed.startTime >= opening.endTime
      ) {
        result.add(opening);
      } else {
        if (closed.startTime > opening.startTime) {
          result.add(span(opening.startTime, closed.startTime));
        }
        if (closed.endTime < opening.endTime) {
          result.add(span(closed.endTime, opening.endTime));
        }
      }
    }
    return result;
  }
  public class Span {
    public Long startTime;
    public Long endTime;
  }
  public static Span span(Long startTime, Long endTime) {
    Span result = new Span();
    result.startTime = startTime;
    result.endTime = endTime;
    return result;
  }
  private class SpanComparator implements Comparator<Span> {
    public Integer compare(Span left, Span right) {
      ChronoSupport.requireValue(left, 'Schedule interval');
      ChronoSupport.requireValue(right, 'Schedule interval');
      return ChronoFlowCompare.compareLong(left.startTime, right.startTime);
    }
  }
}
