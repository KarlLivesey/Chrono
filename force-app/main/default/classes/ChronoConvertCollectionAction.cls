// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Convert or normalise all eight Chrono value types. Collection inputs are also bulkified across Flow interviews. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Subscriber Flow action and invocable wrapper.
global with sharing class ChronoConvertCollectionAction {
  /** @description One collection submitted by a Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Values to convert'
      description='Collection of ChronoConvertInput values. Results retain this order.'
      required=true
    )
    global List<ChronoConvertInput> items;
    /** @description Global no-argument constructor for subscriber Flow. */
    @SuppressWarnings(
      'PMD.EmptyStatementBlock'
    ) // Required global no-argument Flow constructor.
    global Request() {
    }
  }
  /** @description Convert or normalise all eight Chrono value types. Flattens all interviews into one invocation-local batch.
   * @param requests One collection wrapper per interview.
   * @return One response per interview, with one result per item.
   */
  @InvocableMethod(
    label='Chrono: Convert date/time (collection)'
    description='Convert or normalise all eight Chrono value types. Handles collections and batched interviews.'
    configurationEditor='skel-chrono-convert-collection-editor'
    category='Chrono: Values'
    iconName='slds:standard:event'
  )
  global static List<ChronoFlowCollectionResult> run(List<Request> requests) {
    List<ChronoConvertInput> inputs = new List<ChronoConvertInput>();
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
    for (ChronoValueResult item : ChronoValueService.convert(inputs)) {
      results.add(ChronoFlowServiceResults.value(item));
    }
    return ChronoFlowBatch.regroup(results, sizes);
  }
}
