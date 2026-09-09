// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Validate a native or ISO value without failing other interviews. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoValidateValueCollectionAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests for this interview.'
    )
    global List<ChronoValidateValueInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Validate a native or ISO value without failing other interviews.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Validate date/time value (collection)'
    description='Validate a native or ISO value without failing other interviews.'
    category='Chrono: Values'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-validate-value-collection-editor'
  )
  global static List<ChronoValidationCollectionResult> run(
    List<Request> requests
  ) {
    List<ChronoValidationCollectionResult> results = new List<ChronoValidationCollectionResult>();
    if (requests == null) {
      return results;
    }
    List<ChronoValidateValueInput> flat = new List<ChronoValidateValueInput>();
    List<Integer> sizes = new List<Integer>();
    for (Request request : requests) {
      if (request == null || request.items == null) {
        sizes.add(-1);
        continue;
      }
      sizes.add(request.items.size());
      for (ChronoValidateValueInput item : request.items) {
        flat.add(item);
      }
    }
    List<Object> values = new List<Object>();
    for (ChronoValidationResult item : ChronoValueService.validate(flat)) {
      values.add(item);
    }
    Integer cursor = 0;
    for (Integer size : sizes) {
      results.add(group(values, cursor, size));
      cursor += Math.max(size, 0);
    }
    return results;
  }
  private static ChronoValidationCollectionResult group(
    List<Object> values,
    Integer cursor,
    Integer size
  ) {
    ChronoValidationCollectionResult grouped = new ChronoValidationCollectionResult();
    grouped.success = size >= 0;
    if (size < 0) {
      grouped.errorMessage = 'Provide an input collection; empty collections are allowed.';
    }
    for (Integer i = 0; i < size; i++) {
      ChronoValidationResult value = (ChronoValidationResult) values[
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
