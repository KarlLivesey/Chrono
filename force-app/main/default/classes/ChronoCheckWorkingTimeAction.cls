// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Check whether a date has opening hours or an instant is inside OperatingHours. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Required managed Flow entry point.
global with sharing class ChronoCheckWorkingTimeAction {
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

  /** @description Check whether a date has opening hours or an instant is inside OperatingHours.
   * @param requests One request per interview.
   * @return Independent ordered results, including per-item errors.
   */
  @InvocableMethod(
    label='Chrono: Check working time'
    description='Check whether a date has opening hours or an instant is inside OperatingHours.'
    category='Chrono: Working Hours'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-check-working-time-editor'
  )
  global static List<ChronoFlowResult> run(List<Request> requests) {
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    List<ChronoCheckWorkingTimeInput> inputs = new List<ChronoCheckWorkingTimeInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (
      ChronoWorkingTimeCheckResult item : ChronoWorkingTimeService.check(inputs)
    ) {
      results.add(ChronoFlowServiceResults.check(item));
    }
    return results;
  }
  private static ChronoCheckWorkingTimeInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoCheckWorkingTimeInput item = new ChronoCheckWorkingTimeInput();
    item.valueType = request.valueType;
    item.value = request.value;
    item.instantValue = request.instantValue;
    item.dateValue = request.dateValue;
    item.timeValue = request.timeValue;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    item.operatingHoursId = request.operatingHoursId;
    item.operatingHours = request.operatingHours;
    item.timeSlots = request.timeSlots;
    item.holidays = request.holidays;
    return item;
  }
}
