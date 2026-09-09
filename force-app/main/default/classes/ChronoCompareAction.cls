// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Compare compatible values and return before, equal or after. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier, PMD.TooManyFields'
) // Required managed Flow entry point.
global with sharing class ChronoCompareAction {
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
    /** @description Required when comparing durations containing calendar units. */
    @InvocableVariable(
      label='Duration reference date'
      description='Required when comparing durations containing calendar units.'
    )
    global Date referenceDate;
    /** @description Optional non-negative tolerance for complete date, clock, exact or duration values. */
    @InvocableVariable(
      label='Tolerance in milliseconds'
      description='Optional non-negative tolerance for complete date, clock, exact or duration values.'
    )
    global Long toleranceMilliseconds;
    /** @description Optional day, week, month, quarter or year. Exact values require a common calculation timezone. */
    @InvocableVariable(
      label='Compare local period'
      description='Optional day, week, month, quarter or year. Exact values require a common calculation timezone.'
    )
    global String comparisonPeriod;
    /** @description 1 is Monday through 7 Sunday. Defaults to Monday. */
    @InvocableVariable(
      label='Week starts on'
      description='1 is Monday through 7 Sunday. Defaults to Monday.'
    )
    global Integer weekStartsOn;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }

  /** @description Compare compatible values and return before, equal or after.
   * @param requests One request per interview.
   * @return Independent ordered results, including per-item errors.
   */
  @InvocableMethod(
    label='Chrono: Compare date/time values'
    description='Compare compatible values and return before, equal or after.'
    category='Chrono: Calculations'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-compare-editor'
  )
  global static List<ChronoFlowResult> run(List<Request> requests) {
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    List<ChronoCompareInput> inputs = new List<ChronoCompareInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (
      ChronoComparisonResult item : ChronoCalculationService.compare(inputs)
    ) {
      results.add(ChronoFlowServiceResults.comparison(item));
    }
    return results;
  }
  private static ChronoCompareInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoCompareInput item = new ChronoCompareInput();
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
    item.referenceDate = request.referenceDate;
    item.toleranceMilliseconds = request.toleranceMilliseconds;
    item.comparisonPeriod = request.comparisonPeriod;
    item.weekStartsOn = request.weekStartsOn;
    return item;
  }
}
