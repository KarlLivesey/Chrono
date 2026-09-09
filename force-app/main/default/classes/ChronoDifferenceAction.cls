// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Calculate signed elapsed time between two instants, optionally counting only OperatingHours. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier, PMD.TooManyFields'
) // Flow actions in managed packages require global methods.
global with sharing class ChronoDifferenceAction {
  /** @description Scalar invocable wrapper targeted by Flow Builder extension metadata. */
  @SuppressWarnings(
    'PMD.TooManyFields'
  ) // Flat invocable inputs are required by Flow.
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
    /** @description Native ending instant; alternatively use endValue. */
    @InvocableVariable(
      label='End datetime'
      description='Native ending instant; alternatively use endValue.'
    )
    global Datetime endInstant;
    /** @description ISO date, local date/time, instant or zoned date/time. Local values require an explicit timezone. */
    @InvocableVariable(
      label='End ISO value'
      description='ISO date, local date/time, instant or zoned date/time. Local values require an explicit timezone.'
    )
    global String endValue;
    /** @description Optional saved OperatingHours ID; omit to count all elapsed time. */
    @InvocableVariable(
      label='OperatingHours ID (optional)'
      description='Count only open time in this schedule’s timezone, excluding associated holidays. Leave blank for all elapsed time.'
    )
    global String operatingHoursId;
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
    /** @description Native local date; midnight unless endTime is supplied. Requires an explicit timezone. */
    @InvocableVariable(
      label='End date'
      description='Native local date; midnight unless endTime is supplied. Requires an explicit timezone.'
    )
    global Date endDate;
    /** @description Optional ISO clock time with endDate. Omit for local midnight. */
    @InvocableVariable(
      label='End local time'
      description='Optional ISO clock time with endDate. Omit for local midnight.'
    )
    global String endTime;
    /** @description Explicit timezone for local dates and date/times. Exact inputs retain their instant. */
    @InvocableVariable(
      label='Local input timezone'
      description='Explicit timezone for local dates and date/times. Exact inputs retain their instant.'
    )
    global String timeZoneId;
    /** @description reject (default), earlier or later. Nonexistent times are rejected. */
    @InvocableVariable(
      label='Repeated-time policy'
      description='reject (default), earlier or later. Nonexistent times are rejected.'
    )
    global String disambiguation;
    /** @description Optional separate timezone for the end value. Defaults to timeZoneId. */
    @InvocableVariable(
      label='End local input timezone'
      description='Optional separate timezone for the end value. Defaults to timeZoneId.'
    )
    global String endTimeZoneId;
    /** @description Optional end policy. Defaults to disambiguation; reject, earlier or later. */
    @InvocableVariable(
      label='End repeated-time policy'
      description='Optional end policy. Defaults to disambiguation; reject, earlier or later.'
    )
    global String endDisambiguation;
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

  /** @description Calculate signed elapsed time between two instants, optionally counting only OperatingHours. Bulkified across Flow interviews.
   * @param requests One request per interview.
   * @return One independent result per request, in the same order.
   */
  @InvocableMethod(
    label='Chrono: Elapsed difference'
    description='Calculate signed elapsed time between two instants, optionally counting only OperatingHours.'
    configurationEditor='skel-chrono-difference-editor'
    category='Chrono: Calculations'
    iconName='slds:standard:event'
  )
  global static List<ChronoFlowResult> run(List<Request> requests) {
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    List<ChronoDifferenceInput> inputs = new List<ChronoDifferenceInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (
      ChronoDurationCalculationResult item : ChronoCalculationService.difference(
        inputs
      )
    ) {
      results.add(ChronoFlowServiceResults.duration(item));
    }
    return results;
  }
  private static ChronoDifferenceInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    return ChronoOperationInputs.adapt(request);
  }
}
