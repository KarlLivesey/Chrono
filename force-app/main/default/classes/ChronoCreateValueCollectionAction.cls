// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Construct a validated value from individual calendar and clock components. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoCreateValueCollectionAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests for this interview.'
    )
    global List<ChronoCreateValueInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Construct a validated value from individual calendar and clock components.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Create date/time from components (collection)'
    description='Construct a validated value from individual calendar and clock components.'
    category='Chrono: Values'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-create-value-collection-editor'
  )
  global static List<ChronoFlowCollectionResult> run(List<Request> requests) {
    List<ChronoCreateValueInput> inputs = new List<ChronoCreateValueInput>();
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
    for (ChronoValueResult item : ChronoValueService.create(inputs)) {
      results.add(ChronoFlowServiceResults.value(item));
    }
    return ChronoFlowBatch.regroup(results, sizes);
  }
  private static ChronoFlowCollectionResult group(
    List<Object> values,
    Integer cursor,
    Integer size
  ) {
    ChronoFlowCollectionResult grouped = new ChronoFlowCollectionResult();
    grouped.success = size >= 0;
    if (size < 0) {
      grouped.errorMessage = 'Provide an input collection; empty collections are allowed.';
    }
    for (Integer i = 0; i < size; i++) {
      ChronoFlowResult value = (ChronoFlowResult) values[cursor + i];
      grouped.results.add(value);
      if (!value.success) {
        grouped.success = false;
        grouped.errorMessage = 'One or more items failed. Inspect the item results.';
      }
    }
    return grouped;
  }
}
