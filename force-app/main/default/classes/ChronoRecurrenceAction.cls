// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoRecurrenceAction {
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
    /** @description Direction. */
    @InvocableVariable(label='Direction' description='Direction.')
    global String direction;
    /** @description Include the starting date. */
    @InvocableVariable(
      label='Include the starting date'
      description='Include the starting date.'
    )
    global Boolean inclusive;
    /** @description 1 Monday through 7 Sunday. */
    @InvocableVariable(label='Weekday' description='1 Monday through 7 Sunday.')
    global Integer weekday;
    /** @description Positive from the start; negative from the end. For example -1 is last. */
    @InvocableVariable(
      label='Occurrence'
      description='Positive from the start; negative from the end. For example -1 is last.'
    )
    global Integer ordinal;
    /** @description 1–12. */
    @InvocableVariable(label='Annual month' description='1–12.')
    global Integer month;
    /** @description Invalid dates such as 29 February in a common year are skipped. */
    @InvocableVariable(
      label='Annual day'
      description='Invalid dates such as 29 February in a common year are skipped.'
    )
    global Integer day;
    /** @description Repeat every. */
    @InvocableVariable(label='Repeat every' description='Repeat every.')
    global String frequency;
    /** @description Positive frequency interval; defaults to 1. */
    @InvocableVariable(
      label='Interval'
      description='Positive frequency interval; defaults to 1.'
    )
    global Integer interval;
    /** @description Comma-separated MO,TU,WE,TH,FR,SA,SU. Weekly rules only. */
    @InvocableVariable(
      label='Weekdays'
      description='Comma-separated MO,TU,WE,TH,FR,SA,SU. Weekly rules only.'
    )
    global String weekdays;
    /** @description Supported: FREQ DAILY/WEEKLY/MONTHLY/YEARLY, INTERVAL, COUNT, UNTIL, BYDAY (plain weekday codes), BYMONTHDAY, BYMONTH and WKST. Unsupported parts are rejected. */
    @InvocableVariable(
      label='iCalendar RRULE'
      description='Supported: FREQ DAILY/WEEKLY/MONTHLY/YEARLY, INTERVAL, COUNT, UNTIL, BYDAY (plain weekday codes), BYMONTHDAY, BYMONTH and WKST. Unsupported parts are rejected.'
    )
    global String rule;
    /** @description Inclusive date boundary, at most 3660 days from the start. */
    @InvocableVariable(
      label='Search through date'
      description='Inclusive date boundary, at most 3660 days from the start.'
    )
    global Date untilDate;
    /** @description Optional deliberate stop count. Distinct from the safety result limit. */
    @InvocableVariable(
      label='Occurrence count'
      description='Optional deliberate stop count. Distinct from the safety result limit.'
    )
    global Integer count;
    /** @description Skipped local times. */
    @InvocableVariable(
      label='Skipped local times'
      description='Skipped local times.'
    )
    global String gapPolicy;
    /** @description Closed schedule dates. */
    @InvocableVariable(
      label='Closed schedule dates'
      description='Closed schedule dates.'
    )
    global String closedPolicy;
    /** @description 1–1000, default 100. Larger output fails rather than being silently truncated. */
    @InvocableVariable(
      label='Maximum results'
      description='1–1000, default 100. Larger output fails rather than being silently truncated.'
    )
    global Integer maximumResults;
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
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Generate recurring dates'
    description='Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.'
    category='Chrono: Recurrence'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-recurrence-editor'
  )
  global static List<ChronoRecurrenceResult> run(List<Request> requests) {
    List<ChronoRecurrenceResult> results = new List<ChronoRecurrenceResult>();
    List<ChronoRecurrenceInput> inputs = new List<ChronoRecurrenceInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (
      ChronoRecurrenceResult item : ChronoRecurrenceService.generate(inputs)
    ) {
      results.add(item);
    }
    return results;
  }
  private static ChronoRecurrenceInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoRecurrenceInput item = new ChronoRecurrenceInput();
    item.operation = request.operation;
    item.valueType = request.valueType;
    item.value = request.value;
    item.dateValue = request.dateValue;
    item.instantValue = request.instantValue;
    item.timeValue = request.timeValue;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    item.direction = request.direction;
    item.inclusive = request.inclusive;
    item.weekday = request.weekday;
    item.ordinal = request.ordinal;
    item.month = request.month;
    item.day = request.day;
    item.frequency = request.frequency;
    item.interval = request.interval;
    item.weekdays = request.weekdays;
    item.rule = request.rule;
    item.untilDate = request.untilDate;
    item.count = request.count;
    item.gapPolicy = request.gapPolicy;
    item.closedPolicy = request.closedPolicy;
    item.maximumResults = request.maximumResults;
    item.operatingHoursId = request.operatingHoursId;
    item.operatingHours = request.operatingHours;
    item.timeSlots = request.timeSlots;
    item.holidays = request.holidays;
    return item;
  }
}
