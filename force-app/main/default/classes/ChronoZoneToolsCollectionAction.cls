// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Convert zones, inspect date-specific offsets and search bounded timezone transitions. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoZoneToolsCollectionAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests for this interview.'
    )
    global List<ChronoZoneToolsInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Convert zones, inspect date-specific offsets and search bounded timezone transitions.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Work with timezones (collection)'
    description='Convert zones, inspect date-specific offsets and search bounded timezone transitions.'
    category='Chrono: Time Zones'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-zone-tools-collection-editor'
  )
  global static List<ChronoZoneCollectionResult> run(List<Request> requests) {
    List<ChronoZoneCollectionResult> results = new List<ChronoZoneCollectionResult>();
    if (requests == null) {
      return results;
    }
    List<ChronoZoneToolsInput> flat = new List<ChronoZoneToolsInput>();
    List<Integer> sizes = new List<Integer>();
    for (Request request : requests) {
      if (request == null || request.items == null) {
        sizes.add(-1);
        continue;
      }
      sizes.add(request.items.size());
      for (ChronoZoneToolsInput item : request.items) {
        flat.add(item);
      }
    }
    List<Object> values = new List<Object>();
    for (ChronoZoneResult item : ChronoTimeZoneService.calculate(flat)) {
      values.add(item);
    }
    Integer cursor = 0;
    for (Integer size : sizes) {
      results.add(group(values, cursor, size));
      cursor += Math.max(size, 0);
    }
    return results;
  }
  private static ChronoZoneCollectionResult group(
    List<Object> values,
    Integer cursor,
    Integer size
  ) {
    ChronoZoneCollectionResult grouped = new ChronoZoneCollectionResult();
    grouped.success = size >= 0;
    if (size < 0) {
      grouped.errorMessage = 'Provide an input collection; empty collections are allowed.';
    }
    for (Integer i = 0; i < size; i++) {
      ChronoZoneResult value = (ChronoZoneResult) values[cursor + i];
      grouped.results.add(value);
      if (!value.success) {
        grouped.success = false;
        grouped.errorMessage = 'One or more items failed. Inspect the item results.';
      }
    }
    return grouped;
  }
}
