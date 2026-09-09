// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Count whole calendar months/days from the start, followed by remaining clock or elapsed time. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Required managed Flow entry point.
global with sharing class ChronoCalendarDifferenceAction {
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
    /** @description Defaults to the source type; exact types can be compared together. */
    @InvocableVariable(
      label='End value type'
      description='Defaults to the source type; exact types can be compared together.'
    )
    global String endValueType;
    /** @description ISO end value; alternatively use native end fields. */
    @InvocableVariable(
      label='End ISO value'
      description='ISO end value; alternatively use native end fields.'
    )
    global String endValue;
    /** @description Native exact end instant. */
    @InvocableVariable(
      label='End native datetime'
      description='Native exact end instant.'
    )
    global Datetime endInstant;
    /** @description Native local end date. */
    @InvocableVariable(
      label='End native date'
      description='Native local end date.'
    )
    global Date endDate;
    /** @description ISO local time for a native end date/time. */
    @InvocableVariable(
      label='End local time'
      description='ISO local time for a native end date/time.'
    )
    global String endTime;
    /** @description day, month or year. Defaults to day; years are represented by total calendar months. */
    @InvocableVariable(
      label='Largest unit'
      description='day, month or year. Defaults to day; years are represented by total calendar months.'
    )
    global String largestUnit;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }

  /** @description Count whole calendar months/days from the start, followed by remaining clock or elapsed time.
   * @param requests One request per interview.
   * @return Independent ordered results, including per-item errors.
   */
  @InvocableMethod(
    label='Chrono: Calendar difference'
    description='Count whole calendar months/days from the start, followed by remaining clock or elapsed time.'
    category='Chrono: Calculations'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-calendar-difference-editor'
  )
  global static List<ChronoFlowResult> run(List<Request> requests) {
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    List<ChronoCalendarDifferenceInput> inputs = new List<ChronoCalendarDifferenceInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (
      ChronoDurationCalculationResult item : ChronoCalculationService.calendarDifference(
        inputs
      )
    ) {
      results.add(ChronoFlowServiceResults.duration(item));
    }
    return results;
  }
  private static ChronoCalendarDifferenceInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoCalendarDifferenceInput item = new ChronoCalendarDifferenceInput();
    item.valueType = request.valueType;
    item.value = request.value;
    item.instantValue = request.instantValue;
    item.dateValue = request.dateValue;
    item.timeValue = request.timeValue;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    item.endValueType = request.endValueType;
    item.endValue = request.endValue;
    item.endInstant = request.endInstant;
    item.endDate = request.endDate;
    item.endTime = request.endTime;
    item.largestUnit = request.largestUnit;
    return item;
  }
}
