// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Inspect unique/repeated/skipped local times and explicitly select an occurrence or nearest gap boundary. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Required managed Flow entry point.
global with sharing class ChronoResolveLocalAction {
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
    /** @description inspect, earlier, later, backward or forward. Defaults to inspect. */
    @InvocableVariable(
      label='Resolution'
      description='inspect, earlier, later, backward or forward. Defaults to inspect.'
    )
    global String resolution;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }

  /** @description Inspect unique/repeated/skipped local times and explicitly select an occurrence or nearest gap boundary.
   * @param requests One request per interview.
   * @return Independent ordered results, including per-item errors.
   */
  @InvocableMethod(
    label='Chrono: Inspect or resolve local time'
    description='Inspect unique/repeated/skipped local times and explicitly select an occurrence or nearest gap boundary.'
    category='Chrono: Time Zones'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-resolve-local-editor'
  )
  global static List<ChronoFlowResult> run(List<Request> requests) {
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    List<ChronoResolveLocalInput> inputs = new List<ChronoResolveLocalInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (
      ChronoLocalResolutionResult item : ChronoTimeZoneService.resolveLocal(
        inputs
      )
    ) {
      results.add(ChronoFlowServiceResults.resolution(item));
    }
    return results;
  }
  private static ChronoResolveLocalInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoResolveLocalInput item = new ChronoResolveLocalInput();
    item.valueType = request.valueType;
    item.value = request.value;
    item.instantValue = request.instantValue;
    item.dateValue = request.dateValue;
    item.timeValue = request.timeValue;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    item.resolution = request.resolution;
    return item;
  }
}
