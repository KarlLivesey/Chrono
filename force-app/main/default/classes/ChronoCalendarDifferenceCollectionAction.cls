// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Count whole calendar months/days from the start, followed by remaining clock or elapsed time. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Required managed Flow entry point.
global with sharing class ChronoCalendarDifferenceCollectionAction {
  /** @description One explicit collection per interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests; an empty collection is allowed.'
    )
    global List<ChronoCalendarDifferenceInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }

  /** @description Count whole calendar months/days from the start, followed by remaining clock or elapsed time.
   * @param requests One request per interview.
   * @return Independent ordered results, including per-item errors.
   */
  @InvocableMethod(
    label='Chrono: Calendar difference (collection)'
    description='Count whole calendar months/days from the start, followed by remaining clock or elapsed time.'
    category='Chrono: Calculations'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-calendar-difference-collection-editor'
  )
  global static List<ChronoFlowCollectionResult> run(List<Request> requests) {
    List<ChronoCalendarDifferenceInput> inputs = new List<ChronoCalendarDifferenceInput>();
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
      ChronoDurationCalculationResult item : ChronoCalculationService.calendarDifference(
        inputs
      )
    ) {
      results.add(ChronoFlowServiceResults.duration(item));
    }
    return ChronoFlowBatch.regroup(results, sizes);
  }
}
