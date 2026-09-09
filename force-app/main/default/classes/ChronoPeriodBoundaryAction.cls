// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Find a calendar period boundary in an explicit timezone where applicable. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Required managed Flow entry point.
global with sharing class ChronoPeriodBoundaryAction {
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
    /** @description day, week, month or year. */
    @InvocableVariable(label='Period' description='day, week, month or year.')
    global String unit;
    /** @description start or end. End is the final millisecond, or final date, in the period. */
    @InvocableVariable(
      label='Boundary'
      description='start or end. End is the final millisecond, or final date, in the period.'
    )
    global String boundary;
    /** @description ISO weekday: 1 Monday through 7 Sunday. Defaults to Monday. */
    @InvocableVariable(
      label='Week starts on'
      description='ISO weekday: 1 Monday through 7 Sunday. Defaults to Monday.'
    )
    global Integer weekStartsOn;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }

  /** @description Find a calendar period boundary in an explicit timezone where applicable.
   * @param requests One request per interview.
   * @return Independent ordered results, including per-item errors.
   */
  @InvocableMethod(
    label='Chrono: Start or end of period'
    description='Find a calendar period boundary in an explicit timezone where applicable.'
    category='Chrono: Calculations'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-period-boundary-editor'
  )
  global static List<ChronoFlowResult> run(List<Request> requests) {
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    List<ChronoPeriodBoundaryInput> inputs = new List<ChronoPeriodBoundaryInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (ChronoValueResult item : ChronoCalculationService.boundary(inputs)) {
      results.add(ChronoFlowServiceResults.value(item));
    }
    return results;
  }
  private static ChronoPeriodBoundaryInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoPeriodBoundaryInput item = new ChronoPeriodBoundaryInput();
    item.valueType = request.valueType;
    item.value = request.value;
    item.instantValue = request.instantValue;
    item.dateValue = request.dateValue;
    item.timeValue = request.timeValue;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    item.unit = request.unit;
    item.boundary = request.boundary;
    item.weekStartsOn = request.weekStartsOn;
    return item;
  }
}
