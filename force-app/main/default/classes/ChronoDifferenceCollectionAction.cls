// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Calculate signed elapsed time between two instants, optionally counting only OperatingHours. Collection inputs are also bulkified across Flow interviews. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Subscriber Flow action and invocable wrapper.
global with sharing class ChronoDifferenceCollectionAction {
  /** @description One collection submitted by a Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Pairs of instants'
      description='Collection of ChronoDifferenceInput values. Results retain this order.'
      required=true
    )
    global List<ChronoDifferenceInput> items;
    /** @description Global no-argument constructor for subscriber Flow. */
    @SuppressWarnings(
      'PMD.EmptyStatementBlock'
    ) // Required global no-argument Flow constructor.
    global Request() {
    }
  }
  /** @description Calculate signed elapsed time between two instants, optionally counting only OperatingHours. Flattens all interviews into one invocation-local batch.
   * @param requests One collection wrapper per interview.
   * @return One response per interview, with one result per item.
   */
  @InvocableMethod(
    label='Chrono: Elapsed difference (collection)'
    description='Calculate signed elapsed time between two instants, optionally counting only OperatingHours. Handles collections and batched interviews.'
    configurationEditor='skel-chrono-difference-collection-editor'
    category='Chrono: Calculations'
    iconName='slds:standard:event'
  )
  global static List<ChronoFlowCollectionResult> run(List<Request> requests) {
    List<ChronoDifferenceInput> inputs = new List<ChronoDifferenceInput>();
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
      ChronoDurationCalculationResult item : ChronoCalculationService.difference(
        inputs
      )
    ) {
      results.add(ChronoFlowServiceResults.duration(item));
    }
    return ChronoFlowBatch.regroup(results, sizes);
  }
}
