// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoAvailabilityAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    /** @description Operation. */
    @InvocableVariable(label='Operation' description='Operation.')
    global String operation;
    /** @description Value type. */
    @InvocableVariable(label='Value type' description='Value type.')
    global String valueType;
    /** @description ISO value. */
    @InvocableVariable(label='ISO value' description='ISO value.')
    global String value;
    /** @description Native date. */
    @InvocableVariable(label='Native date' description='Native date.')
    global Date dateValue;
    /** @description Native datetime. */
    @InvocableVariable(label='Native datetime' description='Native datetime.')
    global Datetime instantValue;
    /** @description ISO time for a native date and time input. */
    @InvocableVariable(
      label='Local time'
      description='ISO time for a native date and time input.'
    )
    global String timeValue;
    /** @description Required when resolving local time or inspecting an instant. */
    @InvocableVariable(
      label='Timezone'
      description='Required when resolving local time or inspecting an instant.'
    )
    global String timeZoneId;
    /** @description Repeated-time policy. */
    @InvocableVariable(
      label='Repeated-time policy'
      description='Repeated-time policy.'
    )
    global String disambiguation;
    /** @description End ISO value. */
    @InvocableVariable(label='End ISO value' description='End ISO value.')
    global String endValue;
    /** @description End native date. */
    @InvocableVariable(label='End native date' description='End native date.')
    global Date endDate;
    /** @description End native datetime. */
    @InvocableVariable(
      label='End native datetime'
      description='End native datetime.'
    )
    global Datetime endInstant;
    /** @description Optional clock with a native end date. */
    @InvocableVariable(
      label='End local time'
      description='Optional clock with a native end date.'
    )
    global String endTime;
    /** @description Use one saved ID or a supplied OperatingHours record. */
    @InvocableVariable(
      label='OperatingHours ID'
      description='Use one saved ID or a supplied OperatingHours record.'
    )
    global String operatingHoursId;
    /** @description A supplied record can be unsaved. Also supply its TimeSlot and Holiday collections. */
    @InvocableVariable(
      label='OperatingHours record'
      description='A supplied record can be unsaved. Also supply its TimeSlot and Holiday collections.'
    )
    global OperatingHours operatingHours;
    /** @description Normal slots for the supplied schedule; no DML is performed. */
    @InvocableVariable(
      label='Time slots'
      description='Normal slots for the supplied schedule; no DML is performed.'
    )
    global List<TimeSlot> timeSlots;
    /** @description Holiday records for the supplied schedule, including recurring holidays. */
    @InvocableVariable(
      label='Holidays'
      description='Holiday records for the supplied schedule, including recurring holidays.'
    )
    global List<Holiday> holidays;
    /** @description Saved schedule IDs to intersect or unite with the primary schedule. */
    @InvocableVariable(
      label='Additional schedule IDs'
      description='Saved schedule IDs to intersect or unite with the primary schedule.'
    )
    global List<String> otherOperatingHoursIds;
    /** @description Combine schedules. */
    @InvocableVariable(
      label='Combine schedules'
      description='Combine schedules.'
    )
    global String scheduleCombination;
    /** @description ISO exact start/end intervals to exclude from availability. */
    @InvocableVariable(
      label='Busy intervals'
      description='ISO exact start/end intervals to exclude from availability.'
    )
    global List<String> busyRanges;
    /** @description One exact ISO start/end interval per line. */
    @InvocableVariable(
      label='Fixed busy intervals'
      description='One exact ISO start/end interval per line.'
    )
    global String busyRangesText;
    /** @description Positive elapsed ISO duration, for example PT30M. Calendar units are not appointment lengths. */
    @InvocableVariable(
      label='Continuous duration'
      description='Positive elapsed ISO duration, for example PT30M. Calendar units are not appointment lengths.'
    )
    global String duration;
    /** @description Positive elapsed ISO duration. Defaults to the appointment duration. Starts are anchored to each open window. */
    @InvocableVariable(
      label='Appointment start interval'
      description='Positive elapsed ISO duration. Defaults to the appointment duration. Starts are anchored to each open window.'
    )
    global String stepDuration;
    /** @description 1–1000, default 100. Exceeding it returns an error. */
    @InvocableVariable(
      label='Maximum results'
      description='1–1000, default 100. Exceeding it returns an error.'
    )
    global Integer maximumResults;
    /** @description Required when notice or booking horizon is set; use a Flow datetime such as the current datetime. */
    @InvocableVariable(
      label='Reference datetime'
      description='Required when notice or booking horizon is set; use a Flow datetime such as the current datetime.'
    )
    global Datetime referenceInstant;
    /** @description Non-negative elapsed ISO duration from the reference datetime, for example PT2H. */
    @InvocableVariable(
      label='Minimum notice'
      description='Non-negative elapsed ISO duration from the reference datetime, for example PT2H.'
    )
    global String minimumNotice;
    /** @description Positive elapsed ISO duration from the reference datetime; the complete appointment must fit before this limit. */
    @InvocableVariable(
      label='Booking horizon'
      description='Positive elapsed ISO duration from the reference datetime; the complete appointment must fit before this limit.'
    )
    global String bookingHorizon;
    /** @description Non-negative elapsed duration kept free before each appointment within operating hours. */
    @InvocableVariable(
      label='Buffer before'
      description='Non-negative elapsed duration kept free before each appointment within operating hours.'
    )
    global String bufferBefore;
    /** @description Non-negative elapsed duration kept free after each appointment within operating hours. */
    @InvocableVariable(
      label='Buffer after'
      description='Non-negative elapsed duration kept free after each appointment within operating hours.'
    )
    global String bufferAfter;
    /** @description Optional exact datetime anchoring appointment starts across all windows and busy breaks. Without it each free window anchors its own grid. */
    @InvocableVariable(
      label='Appointment grid anchor'
      description='Optional exact datetime anchoring appointment starts across all windows and busy breaks. Without it each free window anchors its own grid.'
    )
    global Datetime gridAnchor;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Find working-hour availability'
    description='Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays.'
    category='Chrono: Working Hours'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-availability-editor'
  )
  global static List<ChronoAvailabilityResult> run(List<Request> requests) {
    List<ChronoAvailabilityResult> results = new List<ChronoAvailabilityResult>();
    List<ChronoAvailabilityInput> inputs = new List<ChronoAvailabilityInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (
      ChronoAvailabilityResult item : ChronoAvailabilityService.evaluate(inputs)
    ) {
      results.add(item);
    }
    return results;
  }
  private static ChronoAvailabilityInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoAvailabilityInput item = new ChronoAvailabilityInput();
    item.operation = request.operation;
    item.valueType = request.valueType;
    item.value = request.value;
    item.dateValue = request.dateValue;
    item.instantValue = request.instantValue;
    item.timeValue = request.timeValue;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    item.endValue = request.endValue;
    item.endDate = request.endDate;
    item.endInstant = request.endInstant;
    item.endTime = request.endTime;
    item.operatingHoursId = request.operatingHoursId;
    item.operatingHours = request.operatingHours;
    item.timeSlots = request.timeSlots;
    item.holidays = request.holidays;
    item.otherOperatingHoursIds = request.otherOperatingHoursIds;
    item.scheduleCombination = request.scheduleCombination;
    item.busyRanges = request.busyRanges;
    item.busyRangesText = request.busyRangesText;
    item.duration = request.duration;
    item.stepDuration = request.stepDuration;
    item.maximumResults = request.maximumResults;
    item.referenceInstant = request.referenceInstant;
    item.minimumNotice = request.minimumNotice;
    item.bookingHorizon = request.bookingHorizon;
    item.bufferBefore = request.bufferBefore;
    item.bufferAfter = request.bufferAfter;
    item.gridAnchor = request.gridAnchor;
    return item;
  }
}
