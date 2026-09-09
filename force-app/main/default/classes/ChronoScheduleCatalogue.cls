// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Bulk loads native schedule records once per action invocation and caches day windows. */
public with sharing class ChronoScheduleCatalogue {
  private ChronoOperatingSchedules loaded;
  private String loadError;
  private Map<String, String> invalidIds = new Map<String, String>();
  private Map<String, Schedule> cache = new Map<String, Schedule>();
  public ChronoScheduleCatalogue(List<Object> requests) {
    Set<Id> ids = new Set<Id>();
    for (Object request : requests) {
      if (request == null) {
        continue;
      }
      ChronoAvailabilityInput input = (ChronoAvailabilityInput) request;
      collect(ids, input.operatingHoursId);
      if (input.otherOperatingHoursIds != null) {
        for (String value : input.otherOperatingHoursIds) {
          collect(ids, value);
        }
      }
    }
    if (!ids.isEmpty()) {
      try {
        loaded = new ChronoOperatingSchedules(ids);
      } catch (Exception ex) {
        loadError =
          'Cannot read operating-hour configuration: ' + ex.getMessage();
      }
    }
  }
  private void collect(Set<Id> ids, String value) {
    if (String.isBlank(value)) {
      return;
    }
    try {
      Id recordId = Id.valueOf(value);
      if (recordId.getSObjectType() == OperatingHours.SObjectType) {
        ids.add(recordId);
      }
    } catch (StringException ex) {
      invalidIds.put(value, ex.getMessage());
    }
  }
  public Schedule primary(ChronoAvailabilityInput input) {
    if (input.operatingHours != null) {
      if (!String.isBlank(input.operatingHoursId)) {
        throw new ChronoException(
          'Use an OperatingHours ID or supplied records, not both.'
        );
      }
      String key = JSON.serialize(
        new List<Object>{
          input.operatingHours,
          input.timeSlots,
          input.holidays
        }
      );
      if (!cache.containsKey(key)) {
        cache.put(
          key,
          new Schedule(input.operatingHours, input.timeSlots, input.holidays)
        );
      }
      return cache.get(key);
    }
    if (input.timeSlots != null || input.holidays != null) {
      throw new ChronoException(
        'Supplied slots and holidays require a supplied OperatingHours record.'
      );
    }
    return saved(input.operatingHoursId);
  }
  public Schedule saved(String value) {
    if (invalidIds.containsKey(value)) {
      throw new ChronoException(invalidIds.get(value));
    }
    Id recordId = checkedId(value);
    if (loadError != null) {
      throw new ChronoException(loadError);
    }
    if (loaded == null || !loaded.operating.containsKey(recordId)) {
      throw new ChronoException(
        'OperatingHours was not found or is not accessible.'
      );
    }
    if (!cache.containsKey(value)) {
      cache.put(
        value,
        new Schedule(
          loaded.operating.get(recordId),
          loaded.slots.get(recordId),
          loaded.holidays.get(recordId)
        )
      );
    }
    return cache.get(value);
  }
  private static Id checkedId(String value) {
    if (String.isBlank(value)) {
      throw new ChronoException('Supply an OperatingHours ID or record.');
    }
    Id recordId = Id.valueOf(value);
    if (recordId.getSObjectType() != OperatingHours.SObjectType) {
      throw new ChronoException('The ID must identify OperatingHours.');
    }
    return recordId;
  }
  public class Schedule {
    public final String zoneId;
    public final ChronoPickerCalendar picker;
    public final List<Holiday> holidays;
    private final ChronoScheduleDay calculator;
    private ChronoWorkingTime workingTime;
    private final OperatingHours hours;
    private final List<TimeSlot> slots;
    private Map<Date, List<ChronoIntervals.Span>> days = new Map<Date, List<ChronoIntervals.Span>>();
    public Schedule(
      OperatingHours hours,
      List<TimeSlot> slots,
      List<Holiday> holidays
    ) {
      this.hours = hours;
      this.slots = slots;
      // Reuse the core validation contract rather than a second schedule engine.
      picker = new ChronoPickerCalendar(hours, slots, holidays);
      zoneId = hours.TimeZone;
      this.holidays = holidays == null ? new List<Holiday>() : holidays;
      calculator = new ChronoScheduleDay(zoneId, slots, this.holidays);
      validateHolidays();
    }
    public ChronoWorkingTime working() {
      if (workingTime == null) {
        workingTime = new ChronoWorkingTime(hours, slots, holidays);
      }
      return workingTime;
    }
    private void validateHolidays() {
      ChronoHolidays.validate(holidays);
    }
    public List<ChronoIntervals.Span> day(Date day) {
      if (!days.containsKey(day)) {
        List<ChronoIntervals.Span> result = new List<ChronoIntervals.Span>();
        for (ChronoScheduleDay.Span span : calculator.spansFor(day)) {
          result.add(ChronoIntervals.span(span.startTime, span.endTime));
        }
        days.put(day, result);
      }
      return days.get(day);
    }
    public List<ChronoIntervals.Span> windows(ChronoIntervals.Span bounds) {
      Date first = Datetime.newInstance(bounds.start).dateGmt().addDays(-1);
      Date last = Datetime.newInstance(bounds.finish).dateGmt().addDays(1);
      if (first.daysBetween(last) > 368) {
        throw new ChronoException(
          'Availability searches are limited to 366 days.'
        );
      }
      List<ChronoIntervals.Span> spans = new List<ChronoIntervals.Span>();
      for (
        Date current = first; current <= last; current = current.addDays(1)
      ) {
        spans.addAll(day(current));
      }
      return ChronoIntervals.intersect(
        spans,
        new List<ChronoIntervals.Span>{ bounds }
      );
    }
  }
}
