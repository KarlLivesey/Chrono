// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Validate and manipulate half-open ranges: start is included and end is excluded. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoRangeToolsCollectionAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests for this interview.'
    )
    global List<ChronoRangeToolsInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Validate and manipulate half-open ranges: start is included and end is excluded.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Work with date/time ranges (collection)'
    description='Validate and manipulate half-open ranges: start is included and end is excluded.'
    category='Chrono: Ranges'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-range-tools-collection-editor'
  )
  global static List<ChronoRangeCollectionResult> run(List<Request> requests) {
    List<ChronoRangeCollectionResult> results = new List<ChronoRangeCollectionResult>();
    if (requests == null) {
      return results;
    }
    List<ChronoRangeToolsInput> flat = new List<ChronoRangeToolsInput>();
    List<Integer> sizes = new List<Integer>();
    for (Request request : requests) {
      if (request == null || request.items == null) {
        sizes.add(-1);
        continue;
      }
      sizes.add(request.items.size());
      for (ChronoRangeToolsInput item : request.items) {
        flat.add(item);
      }
    }
    List<Object> values = new List<Object>();
    for (ChronoRangeResult item : ChronoRangeService.calculate(flat)) {
      values.add(item);
    }
    Integer cursor = 0;
    for (Integer size : sizes) {
      results.add(group(values, cursor, size));
      cursor += Math.max(size, 0);
    }
    return results;
  }
  private static ChronoRangeCollectionResult group(
    List<Object> values,
    Integer cursor,
    Integer size
  ) {
    ChronoRangeCollectionResult grouped = new ChronoRangeCollectionResult();
    grouped.success = size >= 0;
    if (size < 0) {
      grouped.errorMessage = 'Provide an input collection; empty collections are allowed.';
    }
    for (Integer i = 0; i < size; i++) {
      ChronoRangeResult value = (ChronoRangeResult) values[cursor + i];
      grouped.results.add(value);
      if (!value.success) {
        grouped.success = false;
        grouped.errorMessage = 'One or more items failed. Inspect the item results.';
      }
    }
    return grouped;
  }
}
