// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal bulk operations and concrete result adaptation. */
public with sharing class ChronoWorkingCalendarOperations {
  public static List<ChronoWorkingTimeCheckResult> check(
    List<ChronoCheckWorkingTimeInput> requests
  ) {
    List<ChronoWorkingTimeCheckResult> results = new List<ChronoWorkingTimeCheckResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoCheckWorkingTimeInput item : requests) {
      inputs.add(item == null ? null : ChronoOperationInputs.adapt(item));
    }
    for (
      ChronoOperationResult item : new ChronoCalculationBatch(
          'CheckWorkingTime'
        )
        .run(inputs)
    ) {
      results.add(ChronoServiceResults.check((ChronoOperationResult) item));
    }
    return results;
  }
  public static List<ChronoValueResult> find(
    List<ChronoFindWorkingTimeInput> requests
  ) {
    List<ChronoValueResult> results = new List<ChronoValueResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoFindWorkingTimeInput item : requests) {
      inputs.add(item == null ? null : ChronoOperationInputs.adapt(item));
    }
    for (
      ChronoOperationResult item : new ChronoCalculationBatch('FindWorkingTime')
        .run(inputs)
    ) {
      results.add(ChronoServiceResults.value((ChronoOperationResult) item));
    }
    return results;
  }
  public static List<ChronoValueResult> addDays(
    List<ChronoWorkingDaysInput> requests
  ) {
    List<ChronoValueResult> results = new List<ChronoValueResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoWorkingDaysInput item : requests) {
      inputs.add(item);
    }
    for (Object item : new ChronoCatalogueBatch('WorkingDays').run(inputs)) {
      results.add(ChronoServiceResults.value((ChronoOperationResult) item));
    }
    return results;
  }
}
