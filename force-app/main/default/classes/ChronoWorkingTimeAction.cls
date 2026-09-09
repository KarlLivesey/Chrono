// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Add time inside Salesforce OperatingHours or BusinessHours, skipping closures and holidays. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Flow actions in managed packages require global methods.
global with sharing class ChronoWorkingTimeAction {
  /** @description Scalar invocable wrapper targeted by Flow Builder extension metadata. */
  global class Request {
    /** @description Native starting instant; alternatively use startValue. */
    @InvocableVariable(
      label='Start datetime'
      description='Native starting instant; alternatively use startValue.'
    )
    global Datetime startInstant;
    /** @description ISO date, local date/time, instant or zoned date/time. Local values require an explicit timezone. */
    @InvocableVariable(
      label='Start ISO value'
      description='ISO date, local date/time, instant or zoned date/time. Local values require an explicit timezone.'
    )
    global String startValue;
    /** @description Explicit zone for the result; availability follows the schedule zone. */
    @InvocableVariable(
      label='Result time zone'
      description='Explicit zone for the result; availability follows the schedule zone.'
      required=true
    )
    global String timeZoneId;
    /** @description Signed whole working units; negative values subtract. */
    @InvocableVariable(
      label='Amount'
      description='Signed whole working units; negative values subtract.'
      required=true
    )
    global Integer amount;
    /** @description hours or minutes. */
    @InvocableVariable(
      label='Unit'
      description='hours or minutes.'
      required=true
    )
    global String unit;
    /** @description OperatingHours or BusinessHours. */
    @InvocableVariable(
      label='Schedule type'
      description='OperatingHours or BusinessHours.'
      required=true
    )
    global String scheduleType;
    /** @description Saved Salesforce schedule record ID. */
    @InvocableVariable(
      label='Schedule record ID'
      description='Saved Salesforce schedule record ID; omit when supplying native OperatingHours records.'
    )
    global String scheduleId;
    /** @description Native local date; midnight unless startTime is supplied. Requires an explicit timezone. */
    @InvocableVariable(
      label='Start date'
      description='Native local date; midnight unless startTime is supplied. Requires an explicit timezone.'
    )
    global Date startDate;
    /** @description Optional ISO clock time with startDate. Omit for local midnight. */
    @InvocableVariable(
      label='Start local time'
      description='Optional ISO clock time with startDate. Omit for local midnight.'
    )
    global String startTime;
    /** @description reject (default), earlier or later. Nonexistent times are rejected. */
    @InvocableVariable(
      label='Repeated-time policy'
      description='reject (default), earlier or later. Nonexistent times are rejected.'
    )
    global String disambiguation;
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
    /** @description Global constructor for subscriber Flow. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }

  /** @description Add time inside Salesforce OperatingHours or BusinessHours, skipping closures and holidays. Bulkified across Flow interviews.
   * @param requests One request per interview.
   * @return One independent result per request, in the same order.
   */
  @InvocableMethod(
    label='Chrono: Add or subtract working time'
    description='Add time inside Salesforce OperatingHours or BusinessHours, skipping closures and holidays.'
    configurationEditor='skel-chrono-working-time-editor'
    category='Chrono: Working Hours'
    iconName='slds:standard:event'
  )
  global static List<ChronoFlowResult> run(List<Request> requests) {
    List<ChronoWorkingTimeInput> items = new List<ChronoWorkingTimeInput>();
    if (requests != null) {
      for (Request request : requests) {
        items.add(
          request == null
            ? null
            : (ChronoWorkingTimeInput) ChronoOperationInputs.adapt(request)
        );
      }
    }
    return ChronoFlowWorking.add(items);
  }
}
