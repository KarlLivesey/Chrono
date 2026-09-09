// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Round to a clock increment or a calendar-day boundary. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Required managed Flow entry point.
global with sharing class ChronoRoundCollectionAction {
  /** @description One explicit collection per interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests; an empty collection is allowed.'
    )
    global List<ChronoRoundInput> items;
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
    label='Chrono: Round date/time (collection)'
    description='Round to a clock increment or a calendar-day boundary.'
    category='Chrono: Calculations'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-round-collection-editor'
  )
  global static List<ChronoFlowCollectionResult> run(List<Request> requests) {
    List<ChronoRoundInput> inputs = new List<ChronoRoundInput>();
    List<Integer> sizes = new List<Integer>();
    if (requests != null) {
      for (Request request : requests) {
        if (request == null || request.items == null) {
          sizes.add(-1);
          continue;
        }
        sizes.add(request.items.size());
        inputs.addAll(request.items);
      }
    }
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    for (ChronoValueResult item : ChronoCalculationService.round(inputs)) {
      results.add(ChronoFlowServiceResults.value(item));
    }
    return ChronoFlowBatch.regroup(results, sizes);
  }
}
