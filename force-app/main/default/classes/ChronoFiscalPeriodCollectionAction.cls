// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoFiscalPeriodCollectionAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests for this interview.'
    )
    global List<ChronoFiscalPeriodInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Get fiscal period (collection)'
    description='Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.'
    category='Chrono: Calculations'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-fiscal-period-collection-editor'
  )
  global static List<ChronoFiscalCollectionResult> run(List<Request> requests) {
    List<ChronoFiscalCollectionResult> results = new List<ChronoFiscalCollectionResult>();
    if (requests == null) {
      return results;
    }
    List<ChronoFiscalPeriodInput> flat = new List<ChronoFiscalPeriodInput>();
    List<Integer> sizes = new List<Integer>();
    for (Request request : requests) {
      if (request == null || request.items == null) {
        sizes.add(-1);
        continue;
      }
      sizes.add(request.items.size());
      for (ChronoFiscalPeriodInput item : request.items) {
        flat.add(item);
      }
    }
    List<Object> values = new List<Object>();
    for (ChronoFiscalResult item : ChronoFiscalPeriodService.resolve(flat)) {
      values.add(item);
    }
    Integer cursor = 0;
    for (Integer size : sizes) {
      results.add(group(values, cursor, size));
      cursor += Math.max(size, 0);
    }
    return results;
  }
  private static ChronoFiscalCollectionResult group(
    List<Object> values,
    Integer cursor,
    Integer size
  ) {
    ChronoFiscalCollectionResult grouped = new ChronoFiscalCollectionResult();
    grouped.success = size >= 0;
    if (size < 0) {
      grouped.errorMessage = 'Provide an input collection; empty collections are allowed.';
    }
    for (Integer i = 0; i < size; i++) {
      ChronoFiscalResult value = (ChronoFiscalResult) values[cursor + i];
      grouped.results.add(value);
      if (!value.success) {
        grouped.success = false;
        grouped.errorMessage = 'One or more items failed. Inspect the item results.';
      }
    }
    return grouped;
  }
}
