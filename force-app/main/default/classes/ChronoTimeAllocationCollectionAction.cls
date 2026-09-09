// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoTimeAllocationCollectionAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests for this interview.'
    )
    global List<ChronoTimeAllocationInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Allocate time to blocks (collection)'
    description='Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.'
    category='Chrono: Time allocation'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-time-allocation-collection-editor'
  )
  global static List<ChronoTimeAllocationCollectionResult> run(
    List<Request> requests
  ) {
    List<ChronoTimeAllocationCollectionResult> results = new List<ChronoTimeAllocationCollectionResult>();
    if (requests == null) {
      return results;
    }
    List<ChronoTimeAllocationInput> flat = new List<ChronoTimeAllocationInput>();
    List<Integer> sizes = new List<Integer>();
    for (Request request : requests) {
      if (request == null || request.items == null) {
        sizes.add(-1);
        continue;
      }
      sizes.add(request.items.size());
      for (ChronoTimeAllocationInput item : request.items) {
        flat.add(item);
      }
    }
    List<Object> values = new List<Object>();
    for (
      ChronoTimeAllocationResult item : ChronoFlowAllocation.allocate(flat)
    ) {
      values.add(item);
    }
    Integer cursor = 0;
    for (Integer size : sizes) {
      results.add(group(values, cursor, size));
      cursor += Math.max(size, 0);
    }
    return results;
  }
  private static ChronoTimeAllocationCollectionResult group(
    List<Object> values,
    Integer cursor,
    Integer size
  ) {
    ChronoTimeAllocationCollectionResult grouped = new ChronoTimeAllocationCollectionResult();
    grouped.success = size >= 0;
    if (size < 0) {
      grouped.errorMessage = 'Provide an input collection; empty collections are allowed.';
    }
    for (Integer i = 0; i < size; i++) {
      ChronoTimeAllocationResult value = (ChronoTimeAllocationResult) values[
        cursor + i
      ];
      grouped.results.add(value);
      if (!value.success) {
        grouped.success = false;
        grouped.errorMessage = 'One or more items failed. Inspect the item results.';
      }
    }
    return grouped;
  }
}
