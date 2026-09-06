// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Add time inside Salesforce OperatingHours or BusinessHours, skipping closures and holidays. Collection inputs are also bulkified across Flow interviews. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Subscriber Flow action and invocable wrapper.
global with sharing class ChronoWorkingTimeCollectionAction {
  /** @description One collection submitted by a Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Working-time requests'
      description='Collection of ChronoWorkingTimeInput values. Results retain this order.'
      required=true
    )
    global List<ChronoWorkingTimeInput> items;
    /** @description Global no-argument constructor for subscriber Flow. */
    @SuppressWarnings(
      'PMD.EmptyStatementBlock'
    ) // Required global no-argument Flow constructor.
    global Request() {
    }
  }
  /** @description Add time inside Salesforce OperatingHours or BusinessHours, skipping closures and holidays. Flattens all interviews into one invocation-local batch.
   * @param requests One collection wrapper per interview.
   * @return One response per interview, with one result per item.
   */
  @InvocableMethod(
    label='Chrono: Add or subtract working time (collection)'
    description='Add time inside Salesforce OperatingHours or BusinessHours, skipping closures and holidays. Handles collections and batched interviews.'
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
        for (ChronoWorkingTimeInput item : request.items) {
          flat.add(item);
        }
      }
    }
    return ChronoFlowBatch.regroup(
      new ChronoFlowBatch('WorkingTime').run(flat),
      sizes
    );
  }
}
