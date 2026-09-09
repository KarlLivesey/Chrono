// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Construct, inspect, total, balance or scale durations with explicit calendar context. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoDurationToolsCollectionAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests for this interview.'
    )
    global List<ChronoDurationToolsInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Construct, inspect, total, balance or scale durations with explicit calendar context.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Calculate duration (collection)'
    description='Construct, inspect, total, balance or scale durations with explicit calendar context.'
    category='Chrono: Durations'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-duration-tools-collection-editor'
  )
  global static List<ChronoDurationCollectionResult> run(
    List<Request> requests
  ) {
    List<ChronoDurationCollectionResult> results = new List<ChronoDurationCollectionResult>();
    if (requests == null) {
      return results;
    }
    List<ChronoDurationToolsInput> flat = new List<ChronoDurationToolsInput>();
    List<Integer> sizes = new List<Integer>();
    for (Request request : requests) {
      if (request == null || request.items == null) {
        sizes.add(-1);
        continue;
      }
      sizes.add(request.items.size());
      for (ChronoDurationToolsInput item : request.items) {
        flat.add(item);
      }
    }
    List<Object> values = new List<Object>();
    for (
      ChronoDurationResult item : ChronoDurationCalculationService.calculate(
        flat
      )
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
  private static ChronoDurationCollectionResult group(
    List<Object> values,
    Integer cursor,
    Integer size
  ) {
    ChronoDurationCollectionResult grouped = new ChronoDurationCollectionResult();
    grouped.success = size >= 0;
    if (size < 0) {
      grouped.errorMessage = 'Provide an input collection; empty collections are allowed.';
    }
    for (Integer i = 0; i < size; i++) {
      ChronoDurationResult value = (ChronoDurationResult) values[cursor + i];
      grouped.results.add(value);
      if (!value.success) {
        grouped.success = false;
        grouped.errorMessage = 'One or more items failed. Inspect the item results.';
      }
    }
    return grouped;
  }
}
