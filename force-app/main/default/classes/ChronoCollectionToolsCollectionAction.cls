// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoCollectionToolsCollectionAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests for this interview.'
    )
    global List<ChronoCollectionToolsInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Work with date/time collections (collection)'
    description='Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow.'
    category='Chrono: Collections'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-collection-tools-collection-editor'
  )
  global static List<ChronoValuesCollectionResult> run(List<Request> requests) {
    List<ChronoValuesCollectionResult> results = new List<ChronoValuesCollectionResult>();
    if (requests == null) {
      return results;
    }
    List<ChronoCollectionToolsInput> flat = new List<ChronoCollectionToolsInput>();
    List<Integer> sizes = new List<Integer>();
    for (Request request : requests) {
      if (request == null || request.items == null) {
        sizes.add(-1);
        continue;
      }
      sizes.add(request.items.size());
      for (ChronoCollectionToolsInput item : request.items) {
        flat.add(item);
      }
    }
    List<Object> values = new List<Object>();
    for (ChronoValuesResult item : ChronoCollectionService.calculate(flat)) {
      values.add(item);
    }
    Integer cursor = 0;
    for (Integer size : sizes) {
      results.add(group(values, cursor, size));
      cursor += Math.max(size, 0);
    }
    return results;
  }
  private static ChronoValuesCollectionResult group(
    List<Object> values,
    Integer cursor,
    Integer size
  ) {
    ChronoValuesCollectionResult grouped = new ChronoValuesCollectionResult();
    grouped.success = size >= 0;
    if (size < 0) {
      grouped.errorMessage = 'Provide an input collection; empty collections are allowed.';
    }
    for (Integer i = 0; i < size; i++) {
      ChronoValuesResult value = (ChronoValuesResult) values[cursor + i];
      grouped.results.add(value);
      if (!value.success) {
        grouped.success = false;
        grouped.errorMessage = 'One or more items failed. Inspect the item results.';
      }
    }
    return grouped;
  }
}
