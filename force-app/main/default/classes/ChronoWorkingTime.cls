// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal working-time arithmetic over Salesforce operating hours. Reads configuration in user mode; never writes it. */
public with sharing class ChronoWorkingTime {
  private static final Integer MAX_SEARCH_DAYS = 3660;
  private String zoneId;
  private List<TimeSlot> slots;
  private List<Holiday> holidays;
  public ChronoWorkingTime(OperatingHours hours) {
    ChronoSupport.requireValue(hours, 'OperatingHours');
    ChronoSupport.requireValue(hours.Id, 'Saved OperatingHours ID');
    ChronoOperatingSchedules loaded = new ChronoOperatingSchedules(
      new Set<Id>{ hours.Id }
    );
    initialise(
      loaded.operating.get(hours.Id),
      loaded.slots.get(hours.Id),
      loaded.holidays.get(hours.Id)
    );
  }
  public ChronoWorkingTime(
    OperatingHours hours,
    List<TimeSlot> slots,
    List<Holiday> holidays
  ) {
    initialise(hours, slots, holidays);
  }
  private void initialise(
    OperatingHours hours,
    List<TimeSlot> loadedSlots,
    List<Holiday> loadedHolidays
  ) {
    ChronoSupport.requireValue(hours, 'Accessible OperatingHours');
    zoneId = hours.TimeZone;
    ChronoSupport.zone(zoneId);
    slots = loadedSlots == null ? new List<TimeSlot>() : loadedSlots;
    holidays = loadedHolidays == null ? new List<Holiday>() : loadedHolidays;
    if (slots.isEmpty()) {
      throw new ChronoException('OperatingHours has no normal time slots.');
    }
    for (TimeSlot slot : slots) {
      validateSlot(slot);
      if (slot.RecordsetFilterCriteriaId != null) {
        throw new ChronoException(
          'Conditional operating-hour slots require appointment context and cannot be used for generic working-time arithmetic.'
        );
      }
    }
  }

  private static void validateSlot(TimeSlot slot) {
    ChronoSupport.requireValue(slot, 'Time slot');
    ChronoSupport.requireValue(slot.StartTime, 'Slot start time');
    ChronoSupport.requireValue(slot.EndTime, 'Slot end time');
    Set<String> weekdays = new Set<String>{
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    };
    if (
      !weekdays.contains(slot.DayOfWeek) ||
      slot.StartTime >= slot.EndTime ||
      (slot.Type != null &&
      slot.Type != 'Normal')
    ) {
      throw new ChronoException(
        'Provide normal same-day slots with a weekday and start time before end time.'
      );
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
  /** @description Signed elapsed milliseconds spent inside open schedule intervals, excluding the end instant. Ranges exceeding 3660 UTC dates are rejected.
   * @param start Starting instant.
   * @param finish Ending instant.
   * @return Signed elapsed open milliseconds; zero for equal instants or closed intervals.
   */
  public Long differenceMilliseconds(Datetime start, Datetime finish) {
    ChronoSupport.requireValue(start, 'Start datetime');
    ChronoSupport.requireValue(finish, 'End datetime');
    if (start == finish) {
      return 0L;
    }
    Long lower = Math.min(start.getTime(), finish.getTime());
    Long upper = Math.max(start.getTime(), finish.getTime());
    Date firstUtcDay = Datetime.newInstance(lower).dateGmt();
    Date lastUtcDay = Datetime.newInstance(upper - 1).dateGmt();
    Integer dayCount = firstUtcDay.daysBetween(lastUtcDay) + 1;
    if (dayCount > MAX_SEARCH_DAYS) {
      throw new ChronoException(
        'Working-time calculation exceeded the 3660-day search limit.'
      );
    }
    // Include neighbouring local dates: a midnight rollback can visit a date
    // absent from both endpoint wall dates. Actual UTC intersections clip padding.
    Date firstDay = firstUtcDay.addDays(-1);
    dayCount += 2;
    ChronoScheduleDay schedule = new ChronoScheduleDay(zoneId, slots, holidays);
    Long total = 0L;
    for (Integer index = 0; index < dayCount; index++) {
      for (
        ChronoScheduleDay.Span span : schedule.spansFor(firstDay.addDays(index))
      ) {
        total += Math.max(
          0L,
          Math.min(upper, span.endTime) - Math.max(lower, span.startTime)
        );
      }
    }
    return finish > start ? total : -total;
  }
  private class Progress {
    private final Long initialTime;
    private final Integer direction;
    private Long remaining;
    private Progress(Datetime instant, Long amount) {
      initialTime = instant.getTime();
      direction = amount > 0 ? 1 : -1;
      remaining = ChronoNumbers.milliseconds(((Decimal) amount).abs());
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
