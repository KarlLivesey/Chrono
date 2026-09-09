// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal bulk operations and concrete result adaptation. */
public with sharing class ChronoTimeZoneOperations {
  public static List<ChronoLocalResolutionResult> resolveLocal(
    List<ChronoResolveLocalInput> requests
  ) {
    List<ChronoLocalResolutionResult> results = new List<ChronoLocalResolutionResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoResolveLocalInput item : requests) {
      inputs.add(item == null ? null : ChronoOperationInputs.adapt(item));
    }
    for (
      ChronoOperationResult item : new ChronoCalculationBatch('ResolveLocal')
        .run(inputs)
    ) {
      results.add(
        ChronoServiceResults.resolution((ChronoOperationResult) item)
      );
    }
    return results;
  }
  public static List<ChronoZoneResult> calculate(
    List<ChronoZoneToolsInput> requests
  ) {
    List<ChronoZoneResult> results = new List<ChronoZoneResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoZoneToolsInput item : requests) {
      inputs.add(item);
    }
    for (Object item : new ChronoCatalogueBatch('ZoneTools').run(inputs)) {
      results.add((ChronoZoneResult) item);
    }
    return results;
  }
}
