// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoAvailabilityCollectionAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests for this interview.'
    )
    global List<ChronoAvailabilityInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Find working-hour availability (collection)'
    description='Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays.'
    category='Chrono: Working Hours'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-availability-collection-editor'
  )
  global static List<ChronoAvailabilityCollectionResult> run(
    List<Request> requests
  ) {
    List<ChronoAvailabilityCollectionResult> results = new List<ChronoAvailabilityCollectionResult>();
    if (requests == null) {
      return results;
    }
    List<ChronoAvailabilityInput> flat = new List<ChronoAvailabilityInput>();
    List<Integer> sizes = new List<Integer>();
    for (Request request : requests) {
      if (request == null || request.items == null) {
        sizes.add(-1);
        continue;
      }
      sizes.add(request.items.size());
      for (ChronoAvailabilityInput item : request.items) {
        flat.add(item);
      }
    }
    List<Object> values = new List<Object>();
    for (
      ChronoAvailabilityResult item : ChronoAvailabilityService.evaluate(flat)
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
  private static ChronoAvailabilityCollectionResult group(
    List<Object> values,
    Integer cursor,
    Integer size
  ) {
    ChronoAvailabilityCollectionResult grouped = new ChronoAvailabilityCollectionResult();
    grouped.success = size >= 0;
    if (size < 0) {
      grouped.errorMessage = 'Provide an input collection; empty collections are allowed.';
    }
    for (Integer i = 0; i < size; i++) {
      ChronoAvailabilityResult value = (ChronoAvailabilityResult) values[
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
