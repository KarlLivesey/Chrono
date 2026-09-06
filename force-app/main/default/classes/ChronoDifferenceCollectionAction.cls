// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Calculate signed elapsed time between two instants. Collection inputs are also bulkified across Flow interviews. */
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
  /** @description Calculate signed elapsed time between two instants. Flattens all interviews into one invocation-local batch.
   * @param requests One collection wrapper per interview.
   * @return One response per interview, with one result per item.
   */
  @InvocableMethod(
    label='Chrono: Elapsed difference (collection)'
    description='Calculate signed elapsed time between two instants. Handles collections and batched interviews.'
    category='Chrono'
    iconName='slds:standard:event'
  )
  global static List<ChronoFlowCollectionResult> run(List<Request> requests) {
    List<Object> flat = new List<Object>();
    List<Integer> sizes = new List<Integer>();
    if (requests != null) {
      for (Request request : requests) {
        if (request == null || request.items == null) {
          sizes.add(-1);
          continue;
        }
        sizes.add(request.items.size());
        for (ChronoDifferenceInput item : request.items) {
          flat.add(item);
        }
      }
    }
    return ChronoFlowBatch.regroup(
      new ChronoFlowBatch('Difference').run(flat),
      sizes
    );
  }
}
