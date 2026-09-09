// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Computes picker eligibility and nearest open boundaries from native schedule values. */
public with sharing class ChronoPickerCalendar {
  private final OperatingHours hours;
  private final ChronoScheduleDay schedule;
  public ChronoPickerCalendar(
    OperatingHours supplied,
    List<TimeSlot> slots,
    List<Holiday> holidays
  ) {
    new ChronoWorkingTime(supplied, slots, holidays);
    hours = supplied;
    List<Holiday> closures = holidays == null ? new List<Holiday>() : holidays;
    for (Holiday closure : closures) {
      if (closure == null) {
        throw new ChronoException('Holiday entries cannot be null.');
      }
    }
    schedule = new ChronoScheduleDay(hours.TimeZone, slots, closures);
  }
  /** @description Tests membership without searching for other openings. */
  public Boolean contains(Date day, Datetime instant) {
    return isOpen(instant == null ? day : localDate(instant), instant);
  }
  /** @description Finds an opening in one direction; the caller handles already-open values. */
  public Datetime nearest(Date day, Datetime instant, Integer direction) {
    return nearestOpen(
      instant == null ? day : localDate(instant),
      instant,
      direction
    );
  }
  public Date localDate(Datetime instant) {
    return ChronoSupport.localValue(instant, hours.TimeZone).dateGmt();
  }
  public ChronoPickerAvailability check(
    Date dateValue,
    Datetime instantValue,
    String displayZone
  ) {
    Date day = instantValue == null
      ? dateValue
      : ChronoSupport.localValue(instantValue, hours.TimeZone).dateGmt();
    ChronoSupport.requireValue(day, 'Date');
    ChronoPickerAvailability result = new ChronoPickerAvailability();
    result.timeZoneId = hours.TimeZone;
    result.scheduleName = hours.Name;
    result.isOpen = false;
    result.choices = new List<ChronoPickerOption>();
    result.isOpen = isOpen(day, instantValue);
    if (result.isOpen) {
      return result;
    }
    for (Integer direction : new List<Integer>{ -1, 1 }) {
      Datetime nearest = nearestOpen(day, instantValue, direction);
      if (instantValue == null) {
        Date openDay = ChronoSupport.localValue(nearest, hours.TimeZone)
          .dateGmt();
        if (direction < 0) {
          result.previousDate = openDay;
        } else {
          result.nextDate = openDay;
        }
      } else {
        result.choices.add(
          ChronoPickerOptions.create(
            nearest,
            displayZone,
            direction < 0 ? 'previousOpen' : 'nextOpen'
          )
        );
      }
    }
    return result;
  }
  private Datetime nearestOpen(
    Date startDay,
    Datetime instant,
    Integer direction
  ) {
    Date day = startDay;
    for (Integer searched = 0; searched < 3660; searched++) {
      Long best = nearestInDay(day, instant, direction);
      if (best != null) {
        return Datetime.newInstance(best);
      }
      day = day.addDays(direction);
    }
    throw new ChronoException(
      'No open time found within the 3660-day search limit.'
    );
  }
  private Boolean isOpen(Date day, Datetime instant) {
    for (ChronoScheduleDay.Span span : schedule.spansFor(day)) {
      if (
        instant == null ||
        (span.startTime <= instant.getTime() &&
        instant.getTime() < span.endTime)
      ) {
        return true;
      }
    }
    return false;
  }
  private Long nearestInDay(Date day, Datetime instant, Integer direction) {
    Long best;
    for (ChronoScheduleDay.Span span : schedule.spansFor(day)) {
      Long candidate = direction < 0 ? span.endTime - 1 : span.startTime;
      if (!isInDirection(candidate, instant, direction)) {
        continue;
      }
      if (
        best == null || (direction < 0 ? candidate > best : candidate < best)
      ) {
        best = candidate;
      }
    }
    return best;
  }
  private Boolean isInDirection(
    Long candidate,
    Datetime instant,
    Integer direction
  ) {
    if (instant == null) {
      return true;
    }
    return direction < 0
      ? candidate < instant.getTime()
      : candidate > instant.getTime();
  }
}
