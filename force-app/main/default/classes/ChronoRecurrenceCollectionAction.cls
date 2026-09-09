// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoRecurrenceCollectionAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests for this interview.'
    )
    global List<ChronoRecurrenceInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Generate recurring dates (collection)'
    description='Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.'
    category='Chrono: Recurrence'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-recurrence-collection-editor'
  )
  global static List<ChronoRecurrenceCollectionResult> run(
    List<Request> requests
  ) {
    List<ChronoRecurrenceCollectionResult> results = new List<ChronoRecurrenceCollectionResult>();
    if (requests == null) {
      return results;
    }
    List<ChronoRecurrenceInput> flat = new List<ChronoRecurrenceInput>();
    List<Integer> sizes = new List<Integer>();
    for (Request request : requests) {
      if (request == null || request.items == null) {
        sizes.add(-1);
        continue;
      }
      sizes.add(request.items.size());
      for (ChronoRecurrenceInput item : request.items) {
        flat.add(item);
      }
    }
    List<Object> values = new List<Object>();
    for (ChronoRecurrenceResult item : ChronoRecurrenceService.generate(flat)) {
      values.add(item);
    }
    Integer cursor = 0;
    for (Integer size : sizes) {
      results.add(group(values, cursor, size));
      cursor += Math.max(size, 0);
    }
    return results;
  }
  private static ChronoRecurrenceCollectionResult group(
    List<Object> values,
    Integer cursor,
    Integer size
  ) {
    ChronoRecurrenceCollectionResult grouped = new ChronoRecurrenceCollectionResult();
    grouped.success = size >= 0;
    if (size < 0) {
      grouped.errorMessage = 'Provide an input collection; empty collections are allowed.';
    }
    for (Integer i = 0; i < size; i++) {
      ChronoRecurrenceResult value = (ChronoRecurrenceResult) values[
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
