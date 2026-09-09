// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Compare compatible values and return before, equal or after. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Required managed Flow entry point.
global with sharing class ChronoCompareCollectionAction {
  /** @description One explicit collection per interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests; an empty collection is allowed.'
    )
    global List<ChronoCompareInput> items;
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
    label='Chrono: Compare date/time values (collection)'
    description='Compare compatible values and return before, equal or after.'
    category='Chrono: Calculations'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-compare-collection-editor'
  )
  global static List<ChronoFlowCollectionResult> run(List<Request> requests) {
    List<ChronoCompareInput> inputs = new List<ChronoCompareInput>();
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
    for (
      ChronoComparisonResult item : ChronoCalculationService.compare(inputs)
    ) {
      results.add(ChronoFlowServiceResults.comparison(item));
    }
    return ChronoFlowBatch.regroup(results, sizes);
  }
}
