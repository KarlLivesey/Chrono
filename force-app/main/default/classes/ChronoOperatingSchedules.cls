// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Loads all requested operating schedules with three user-mode queries; no per-item database access. */
public with sharing class ChronoOperatingSchedules {
  public final Map<Id, OperatingHours> operating;
  public final Map<Id, List<TimeSlot>> slots = new Map<Id, List<TimeSlot>>();
  public final Map<Id, List<Holiday>> holidays = new Map<Id, List<Holiday>>();
  public ChronoOperatingSchedules(Set<Id> ids) {
    operating = new Map<Id, OperatingHours>(
      [
        SELECT Id, Name, TimeZone
        FROM OperatingHours
        WHERE Id IN :ids
        WITH USER_MODE
      ]
    );
    for (TimeSlot slot : [
      SELECT
        OperatingHoursId,
        DayOfWeek,
        StartTime,
        EndTime,
        Type,
        RecordsetFilterCriteriaId
      FROM TimeSlot
      WHERE OperatingHoursId IN :ids AND Type = 'Normal'
      WITH USER_MODE
      ORDER BY StartTime
    ]) {
      if (!slots.containsKey(slot.OperatingHoursId)) {
        slots.put(slot.OperatingHoursId, new List<TimeSlot>());
      }
      slots.get(slot.OperatingHoursId).add(slot);
    }
    for (OperatingHoursHoliday link : [
      SELECT
        OperatingHoursId,
        Holiday.Id,
        Holiday.Name,
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
      WHERE OperatingHoursId IN :ids
      WITH USER_MODE
    ]) {
      if (!holidays.containsKey(link.OperatingHoursId)) {
        holidays.put(link.OperatingHoursId, new List<Holiday>());
      }
      holidays.get(link.OperatingHoursId).add(link.Holiday);
    }
  }
  public ChronoWorkingTime getSchedule(Id scheduleId) {
    return new ChronoWorkingTime(
      operating.get(scheduleId),
      slots.get(scheduleId),
      holidays.get(scheduleId)
    );
  }
}
