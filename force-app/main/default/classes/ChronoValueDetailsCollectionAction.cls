// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Inspect calendar and clock components with an explicit timezone for instants. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoValueDetailsCollectionAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests for this interview.'
    )
    global List<ChronoValueDetailsInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Inspect calendar and clock components with an explicit timezone for instants.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Get date/time details (collection)'
    description='Inspect calendar and clock components with an explicit timezone for instants.'
    category='Chrono: Values'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-value-details-collection-editor'
  )
  global static List<ChronoDetailsCollectionResult> run(
    List<Request> requests
  ) {
    List<ChronoDetailsCollectionResult> results = new List<ChronoDetailsCollectionResult>();
    if (requests == null) {
      return results;
    }
    List<ChronoValueDetailsInput> flat = new List<ChronoValueDetailsInput>();
    List<Integer> sizes = new List<Integer>();
    for (Request request : requests) {
      if (request == null || request.items == null) {
        sizes.add(-1);
        continue;
      }
      sizes.add(request.items.size());
      for (ChronoValueDetailsInput item : request.items) {
        flat.add(item);
      }
    }
    List<Object> values = new List<Object>();
    for (ChronoDetailsResult item : ChronoValueService.details(flat)) {
      values.add(item);
    }
    Integer cursor = 0;
    for (Integer size : sizes) {
      results.add(group(values, cursor, size));
      cursor += Math.max(size, 0);
    }
    return results;
  }
  private static ChronoDetailsCollectionResult group(
    List<Object> values,
    Integer cursor,
    Integer size
  ) {
    ChronoDetailsCollectionResult grouped = new ChronoDetailsCollectionResult();
    grouped.success = size >= 0;
    if (size < 0) {
      grouped.errorMessage = 'Provide an input collection; empty collections are allowed.';
    }
    for (Integer i = 0; i < size; i++) {
      ChronoDetailsResult value = (ChronoDetailsResult) values[cursor + i];
      grouped.results.add(value);
      if (!value.success) {
        grouped.success = false;
        grouped.errorMessage = 'One or more items failed. Inspect the item results.';
      }
    }
    return grouped;
  }
}
