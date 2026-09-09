// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Round to a clock increment or a calendar-day boundary. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Required managed Flow entry point.
global with sharing class ChronoRoundAction {
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
    /** @description day, hour, minute, second or millisecond. */
    @InvocableVariable(
      label='Unit'
      description='day, hour, minute, second or millisecond.'
    )
    global String unit;
    /** @description Positive increment dividing its parent unit; defaults to 1. */
    @InvocableVariable(
      label='Increment'
      description='Positive increment dividing its parent unit; defaults to 1.'
    )
    global Integer increment;
    /** @description floor, ceil or halfExpand (nearest, ties away from zero). Defaults to halfExpand. */
    @InvocableVariable(
      label='Rounding mode'
      description='floor, ceil or halfExpand (nearest, ties away from zero). Defaults to halfExpand.'
    )
    global String roundingMode;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }

  /** @description Round to a clock increment or a calendar-day boundary.
   * @param requests One request per interview.
   * @return Independent ordered results, including per-item errors.
   */
  @InvocableMethod(
    label='Chrono: Round date/time'
    description='Round to a clock increment or a calendar-day boundary.'
    category='Chrono: Calculations'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-round-editor'
  )
  global static List<ChronoFlowResult> run(List<Request> requests) {
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    List<ChronoRoundInput> inputs = new List<ChronoRoundInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (ChronoValueResult item : ChronoCalculationService.round(inputs)) {
      results.add(ChronoFlowServiceResults.value(item));
    }
    return results;
  }
  private static ChronoRoundInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoRoundInput item = new ChronoRoundInput();
    item.valueType = request.valueType;
    item.value = request.value;
    item.instantValue = request.instantValue;
    item.dateValue = request.dateValue;
    item.timeValue = request.timeValue;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    item.unit = request.unit;
    item.increment = request.increment;
    item.roundingMode = request.roundingMode;
    return item;
  }
}
