// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Check whether a date has opening hours or an instant is inside OperatingHours. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Required managed Flow entry point.
global with sharing class ChronoCheckWorkingTimeCollectionAction {
  /** @description One explicit collection per interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests; an empty collection is allowed.'
    )
    global List<ChronoCheckWorkingTimeInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }

  /** @description Check whether a date has opening hours or an instant is inside OperatingHours.
   * @param requests One request per interview.
   * @return Independent ordered results, including per-item errors.
   */
  @InvocableMethod(
    label='Chrono: Check working time (collection)'
    description='Check whether a date has opening hours or an instant is inside OperatingHours.'
    category='Chrono: Working Hours'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-check-working-time-collection-editor'
  )
  global static List<ChronoFlowCollectionResult> run(List<Request> requests) {
    List<ChronoCheckWorkingTimeInput> inputs = new List<ChronoCheckWorkingTimeInput>();
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
    for (
      ChronoWorkingTimeCheckResult item : ChronoWorkingTimeService.check(inputs)
    ) {
      results.add(ChronoFlowServiceResults.check(item));
    }
    return ChronoFlowBatch.regroup(results, sizes);
  }
}
