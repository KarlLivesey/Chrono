// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Typed adapters into the existing native schedule catalogue. */
public with sharing class ChronoScheduleInputs {
  public static ChronoAvailabilityInput fromWorking(
    ChronoWorkingTimeInput input
  ) {
    ChronoAvailabilityInput schedule = new ChronoAvailabilityInput();
    schedule.operatingHoursId = input.scheduleId;
    schedule.operatingHours = input.operatingHours;
    schedule.timeSlots = input.timeSlots;
    schedule.holidays = input.holidays;
    return schedule;
  }
  public static ChronoAvailabilityInput fromOperation(
    ChronoOperationInput input
  ) {
    ChronoAvailabilityInput schedule = new ChronoAvailabilityInput();
    schedule.operatingHoursId = input.operatingHoursId;
    schedule.operatingHours = input.operatingHours;
    schedule.timeSlots = input.timeSlots;
    schedule.holidays = input.holidays;
    return schedule;
  }
  public static ChronoWorkingTimeInput fromDifference(
    ChronoDifferenceInput input
  ) {
    ChronoWorkingTimeInput schedule = new ChronoWorkingTimeInput();
    schedule.scheduleType = 'OperatingHours';
    schedule.scheduleId = input.operatingHoursId;
    schedule.operatingHours = input.operatingHours;
    schedule.timeSlots = input.timeSlots;
    schedule.holidays = input.holidays;
    return schedule;
  }
  public static Boolean supplied(ChronoAvailabilityInput input) {
    return input.operatingHours != null ||
      input.timeSlots != null ||
      input.holidays != null;
  }
  public static Boolean restricted(ChronoDifferenceInput input) {
    return !String.isBlank(input.operatingHoursId) ||
      input.operatingHours != null ||
      input.timeSlots != null ||
      input.holidays != null;
  }
}
