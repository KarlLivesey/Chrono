// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoWorkingDaysCollectionAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests for this interview.'
    )
    global List<ChronoWorkingDaysInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Add working calendar days (collection)'
    description='Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays.'
    category='Chrono: Working Hours'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-working-days-collection-editor'
  )
  global static List<ChronoFlowCollectionResult> run(List<Request> requests) {
    List<ChronoWorkingDaysInput> inputs = new List<ChronoWorkingDaysInput>();
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
    for (ChronoValueResult item : ChronoWorkingTimeService.addDays(inputs)) {
      results.add(ChronoFlowServiceResults.value(item));
    }
    return ChronoFlowBatch.regroup(results, sizes);
  }
}
