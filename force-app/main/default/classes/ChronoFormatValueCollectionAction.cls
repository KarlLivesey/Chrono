// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoFormatValueCollectionAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests for this interview.'
    )
    global List<ChronoFormatValueInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Format date/time for display (collection)'
    description='Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output.'
    category='Chrono: Formatting'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-format-value-collection-editor'
  )
  global static List<ChronoFormatCollectionResult> run(List<Request> requests) {
    List<ChronoFormatCollectionResult> results = new List<ChronoFormatCollectionResult>();
    if (requests == null) {
      return results;
    }
    List<ChronoFormatValueInput> flat = new List<ChronoFormatValueInput>();
    List<Integer> sizes = new List<Integer>();
    for (Request request : requests) {
      if (request == null || request.items == null) {
        sizes.add(-1);
        continue;
      }
      sizes.add(request.items.size());
      for (ChronoFormatValueInput item : request.items) {
        flat.add(item);
      }
    }
    List<Object> values = new List<Object>();
    for (ChronoFormatResult item : ChronoFormattingService.format(flat)) {
      values.add(item);
    }
    Integer cursor = 0;
    for (Integer size : sizes) {
      results.add(group(values, cursor, size));
      cursor += Math.max(size, 0);
    }
    return results;
  }
  private static ChronoFormatCollectionResult group(
    List<Object> values,
    Integer cursor,
    Integer size
  ) {
    ChronoFormatCollectionResult grouped = new ChronoFormatCollectionResult();
    grouped.success = size >= 0;
    if (size < 0) {
      grouped.errorMessage = 'Provide an input collection; empty collections are allowed.';
    }
    for (Integer i = 0; i < size; i++) {
      ChronoFormatResult value = (ChronoFormatResult) values[cursor + i];
      grouped.results.add(value);
      if (!value.success) {
        grouped.success = false;
        grouped.errorMessage = 'One or more items failed. Inspect the item results.';
      }
    }
    return grouped;
  }
}
