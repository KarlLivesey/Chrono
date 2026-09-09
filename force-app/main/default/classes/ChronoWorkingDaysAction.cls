// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoWorkingDaysAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
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
    /** @description Signed whole working dates to add; the starting date is excluded. Maximum search is 3660 calendar days. */
    @InvocableVariable(
      label='Working calendar days'
      description='Signed whole working dates to add; the starting date is excluded. Maximum search is 3660 calendar days.'
    )
    global Integer amount;
    /** @description Keep rejects neither closed clocks nor missing hours; reject requires open hours; next and previous move to the nearest open boundary. Dates only require a working date. */
    @InvocableVariable(
      label='If the resulting clock is closed'
      description='Keep rejects neither closed clocks nor missing hours; reject requires open hours; next and previous move to the nearest open boundary. Dates only require a working date.'
    )
    global String closedTimePolicy;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Add working calendar days'
    description='Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays.'
    category='Chrono: Working Hours'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-working-days-editor'
  )
  global static List<ChronoFlowResult> run(List<Request> requests) {
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    List<ChronoWorkingDaysInput> inputs = new List<ChronoWorkingDaysInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (ChronoValueResult item : ChronoWorkingTimeService.addDays(inputs)) {
      results.add(ChronoFlowServiceResults.value(item));
    }
    return results;
  }
  private static ChronoWorkingDaysInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoWorkingDaysInput item = new ChronoWorkingDaysInput();
    item.valueType = request.valueType;
    item.value = request.value;
    item.dateValue = request.dateValue;
    item.instantValue = request.instantValue;
    item.timeValue = request.timeValue;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    item.operatingHoursId = request.operatingHoursId;
    item.operatingHours = request.operatingHours;
    item.timeSlots = request.timeSlots;
    item.holidays = request.holidays;
    item.amount = request.amount;
    item.closedTimePolicy = request.closedTimePolicy;
    return item;
  }
}
