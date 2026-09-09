// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Find an open value on or after/before the source, including holidays. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Required managed Flow entry point.
global with sharing class ChronoFindWorkingTimeAction {
  /** @description Scalar Flow inputs. */
  global class Request {
    /** @description Chrono type of the source. */
    @InvocableVariable(
      label='Value type'
      description='Chrono type of the source.'
    )
    global String valueType;
    /** @description ISO source; alternatively supply native fields. */
    @InvocableVariable(
      label='ISO value'
      description='ISO source; alternatively supply native fields.'
    )
    global String value;
    /** @description Exact source instant; mutually exclusive with ISO value. */
    @InvocableVariable(
      label='Native datetime'
      description='Exact source instant; mutually exclusive with ISO value.'
    )
    global Datetime instantValue;
    /** @description Local source date; mutually exclusive with ISO value. */
    @InvocableVariable(
      label='Native date'
      description='Local source date; mutually exclusive with ISO value.'
    )
    global Date dateValue;
    /** @description ISO local time for native date/time input. */
    @InvocableVariable(
      label='Local time'
      description='ISO local time for native date/time input.'
    )
    global String timeValue;
    /** @description Explicit zone for local resolution or calendar calculations. */
    @InvocableVariable(
      label='Calculation timezone'
      description='Explicit zone for local resolution or calendar calculations.'
    )
    global String timeZoneId;
    /** @description reject, earlier or later; skipped local times are rejected unless explicitly corrected. */
    @InvocableVariable(
      label='Repeated-time policy'
      description='reject, earlier or later; skipped local times are rejected unless explicitly corrected.'
    )
    global String disambiguation;
    /** @description Saved accessible OperatingHours record ID. */
    @InvocableVariable(
      label='OperatingHours ID'
      description='Saved accessible OperatingHours record ID.'
    )
    global String operatingHoursId;
    /** @description next or previous. An already-open value is returned unchanged. */
    @InvocableVariable(
      label='Direction'
      description='next or previous. An already-open value is returned unchanged.'
    )
    global String direction;
    /** @description Supplied native schedule, including unsaved records. Use instead of a saved schedule ID. */
    @InvocableVariable(
      label='OperatingHours record'
      description='Supplied native schedule, including unsaved records. Use instead of a saved schedule ID.'
    )
    global OperatingHours operatingHours;
    /** @description Normal time slots for the supplied OperatingHours record. No queries or DML. */
    @InvocableVariable(
      label='Time slots'
      description='Normal time slots for the supplied OperatingHours record. No queries or DML.'
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

  /** @description Find an open value on or after/before the source, including holidays.
   * @param requests One request per interview.
   * @return Independent ordered results, including per-item errors.
   */
  @InvocableMethod(
    label='Chrono: Find next or previous working time'
    description='Find an open value on or after/before the source, including holidays.'
    category='Chrono: Working Hours'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-find-working-time-editor'
  )
  global static List<ChronoFlowResult> run(List<Request> requests) {
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    List<ChronoFindWorkingTimeInput> inputs = new List<ChronoFindWorkingTimeInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (ChronoValueResult item : ChronoWorkingTimeService.find(inputs)) {
      results.add(ChronoFlowServiceResults.value(item));
    }
    return results;
  }
  private static ChronoFindWorkingTimeInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoFindWorkingTimeInput item = new ChronoFindWorkingTimeInput();
    item.valueType = request.valueType;
    item.value = request.value;
    item.instantValue = request.instantValue;
    item.dateValue = request.dateValue;
    item.timeValue = request.timeValue;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    item.operatingHoursId = request.operatingHoursId;
    item.direction = request.direction;
    item.operatingHours = request.operatingHours;
    item.timeSlots = request.timeSlots;
    item.holidays = request.holidays;
    return item;
  }
}
