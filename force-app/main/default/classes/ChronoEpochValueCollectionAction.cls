// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Convert an exact value to or from Unix seconds or milliseconds. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoEpochValueCollectionAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests for this interview.'
    )
    global List<ChronoEpochValueInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Convert an exact value to or from Unix seconds or milliseconds.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Convert Unix timestamp (collection)'
    description='Convert an exact value to or from Unix seconds or milliseconds.'
    category='Chrono: Values'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-epoch-value-collection-editor'
  )
  global static List<ChronoEpochCollectionResult> run(List<Request> requests) {
    List<ChronoEpochCollectionResult> results = new List<ChronoEpochCollectionResult>();
    if (requests == null) {
      return results;
    }
    List<ChronoEpochValueInput> flat = new List<ChronoEpochValueInput>();
    List<Integer> sizes = new List<Integer>();
    for (Request request : requests) {
      if (request == null || request.items == null) {
        sizes.add(-1);
        continue;
      }
      sizes.add(request.items.size());
      for (ChronoEpochValueInput item : request.items) {
        flat.add(item);
      }
    }
    List<Object> values = new List<Object>();
    for (ChronoEpochResult item : ChronoValueService.convertEpoch(flat)) {
      values.add(item);
    }
    Integer cursor = 0;
    for (Integer size : sizes) {
      results.add(group(values, cursor, size));
      cursor += Math.max(size, 0);
    }
    return results;
  }
  private static ChronoEpochCollectionResult group(
    List<Object> values,
    Integer cursor,
    Integer size
  ) {
    ChronoEpochCollectionResult grouped = new ChronoEpochCollectionResult();
    grouped.success = size >= 0;
    if (size < 0) {
      grouped.errorMessage = 'Provide an input collection; empty collections are allowed.';
    }
    for (Integer i = 0; i < size; i++) {
      ChronoEpochResult value = (ChronoEpochResult) values[cursor + i];
      grouped.results.add(value);
      if (!value.success) {
        grouped.success = false;
        grouped.errorMessage = 'One or more items failed. Inspect the item results.';
      }
    }
    return grouped;
  }
}
