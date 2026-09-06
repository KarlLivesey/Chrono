// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal working-time arithmetic over Salesforce operating hours. Reads configuration in user mode; never writes it. */
public with sharing class ChronoWorkingTime {
  private static final Integer MAX_SEARCH_DAYS = 3660;
  private final String zoneId;
  private final List<TimeSlot> slots;
  private final List<Holiday> holidays;
  public ChronoWorkingTime(OperatingHours hours) {
    ChronoSupport.requireValue(hours, 'OperatingHours');
    ChronoSupport.requireValue(hours.Id, 'Saved OperatingHours ID');
    OperatingHours stored = [
      SELECT TimeZone
      FROM OperatingHours
      WHERE Id = :hours.Id
      WITH USER_MODE
    ];
    zoneId = stored.TimeZone;
    ChronoSupport.zone(zoneId);
    slots = [
      SELECT DayOfWeek, StartTime, EndTime, Type, RecordsetFilterCriteriaId
      FROM TimeSlot
      WHERE OperatingHoursId = :hours.Id AND Type = 'Normal'
      WITH USER_MODE
      ORDER BY StartTime
    ];
    if (slots.isEmpty()) {
      throw new ChronoException('OperatingHours has no normal time slots.');
    }
    for (TimeSlot slot : slots) {
      if (slot.RecordsetFilterCriteriaId != null) {
        throw new ChronoException(
          'Conditional operating-hour slots require appointment context and cannot be used for generic working-time arithmetic.'
        );
      }
    }
    holidays = new List<Holiday>();
    for (OperatingHoursHoliday link : [
      SELECT
        Holiday.IsAllDay,
        Holiday.ActivityDate,
        Holiday.StartTimeInMinutes,
        Holiday.EndTimeInMinutes,
        Holiday.IsRecurrence,
        Holiday.RecurrenceStartDate,
        Holiday.RecurrenceEndDateOnly,
        Holiday.RecurrenceType,
        Holiday.RecurrenceInterval,
        Holiday.RecurrenceDayOfWeekMask,
        Holiday.RecurrenceDayOfMonth,
        Holiday.RecurrenceInstance,
        Holiday.RecurrenceMonthOfYear
      FROM OperatingHoursHoliday
      WHERE OperatingHoursId = :hours.Id
      WITH USER_MODE
    ]) {
      holidays.add(link.Holiday);
    }
  }

  public Datetime addMilliseconds(Datetime instant, Long amount) {
    ChronoSupport.requireValue(instant, 'Datetime');
    ChronoSupport.requireValue(amount, 'Working milliseconds');
    if (amount == 0) {
      return instant;
    }
    Progress progress = new Progress(instant, amount);
    Date day = ChronoSupport.localValue(instant, zoneId).dateGmt();
    ChronoScheduleDay schedule = new ChronoScheduleDay(zoneId, slots, holidays);
    for (Integer searched = 0; searched < MAX_SEARCH_DAYS; searched++) {
      Datetime result = progress.consume(schedule.spansFor(day));
      if (result != null) {
        return result;
      }
      day = day.addDays(progress.direction);
    }
    throw new ChronoException(
      'Working-time calculation exceeded the 3660-day search limit.'
    );
  }
  private class Progress {
    private final Long initialTime;
    private final Integer direction;
    private Long remaining;
    private Progress(Datetime instant, Long amount) {
      initialTime = instant.getTime();
      direction = amount > 0 ? 1 : -1;
      remaining = Math.abs(amount);
    }
    private Datetime consume(List<ChronoScheduleDay.Span> spans) {
      for (Integer index = 0; index < spans.size(); index++) {
        ChronoScheduleDay.Span span = spans[
          direction > 0 ? index : spans.size() - 1 - index
        ];
        Long cursor = direction > 0
          ? Math.max(initialTime, span.startTime)
          : Math.min(initialTime, span.endTime);
        Long available = direction > 0
          ? span.endTime - cursor
          : cursor - span.startTime;
        if (available <= 0) {
          continue;
        }
        if (remaining <= available) {
          return Datetime.newInstance(cursor + direction * remaining);
        }
        remaining -= available;
      }
      return null;
    }
  }
}
