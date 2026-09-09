// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Inspect unique/repeated/skipped local times and explicitly select an occurrence or nearest gap boundary. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Required managed Flow entry point.
global with sharing class ChronoResolveLocalCollectionAction {
  /** @description One explicit collection per interview. */
  global class Request {
    @InvocableVariable(
      label='Input collection'
      description='Ordered requests; an empty collection is allowed.'
    )
    global List<ChronoResolveLocalInput> items;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }

  /** @description Inspect unique/repeated/skipped local times and explicitly select an occurrence or nearest gap boundary.
   * @param requests One request per interview.
   * @return Independent ordered results, including per-item errors.
   */
  @InvocableMethod(
    label='Chrono: Inspect or resolve local time (collection)'
    description='Inspect unique/repeated/skipped local times and explicitly select an occurrence or nearest gap boundary.'
    category='Chrono: Time Zones'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-resolve-local-collection-editor'
  )
  global static List<ChronoFlowCollectionResult> run(List<Request> requests) {
    List<ChronoResolveLocalInput> inputs = new List<ChronoResolveLocalInput>();
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
      ChronoLocalResolutionResult item : ChronoTimeZoneService.resolveLocal(
        inputs
      )
    ) {
      results.add(ChronoFlowServiceResults.resolution(item));
    }
    return ChronoFlowBatch.regroup(results, sizes);
  }
}
