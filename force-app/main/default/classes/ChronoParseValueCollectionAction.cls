// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Parse an explicitly specified numeric date and time pattern without guessing. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoParseValueCollectionAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests for this interview.'
    )
    global List<ChronoParseValueInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Parse an explicitly specified numeric date and time pattern without guessing.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Parse formatted date/time (collection)'
    description='Parse an explicitly specified numeric date and time pattern without guessing.'
    category='Chrono: Values'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-parse-value-collection-editor'
  )
  global static List<ChronoFlowCollectionResult> run(List<Request> requests) {
    List<ChronoParseValueInput> inputs = new List<ChronoParseValueInput>();
    List<Integer> sizes = new List<Integer>();
    if (requests != null) {
      for (Request request : requests) {
        if (request == null || request.items == null) {
          sizes.add(-1);
          continue;
        }
        sizes.add(request.items.size());
        inputs.addAll(request.items);
      }
    }
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    for (ChronoValueResult item : ChronoValueService.parse(inputs)) {
      results.add(ChronoFlowServiceResults.value(item));
    }
    return ChronoFlowBatch.regroup(results, sizes);
  }
}
