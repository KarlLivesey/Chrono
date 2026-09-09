// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal bulk operations and concrete result adaptation. */
public with sharing class ChronoCalculationOperations {
  public static List<ChronoValueResult> adjust(
    List<ChronoAdjustInput> requests
  ) {
    List<ChronoValueResult> results = new List<ChronoValueResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoAdjustInput item : requests) {
      inputs.add(item);
    }
    for (
      ChronoOperationResult item : new ChronoCalculationBatch('Adjust')
        .run(inputs)
    ) {
      results.add(ChronoServiceResults.value((ChronoOperationResult) item));
    }
    return results;
  }
  public static List<ChronoDurationCalculationResult> difference(
    List<ChronoDifferenceInput> requests
  ) {
    List<ChronoDurationCalculationResult> results = new List<ChronoDurationCalculationResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoDifferenceInput item : requests) {
      inputs.add(item);
    }
    for (
      ChronoOperationResult item : new ChronoCalculationBatch('Difference')
        .run(inputs)
    ) {
      results.add(ChronoServiceResults.duration((ChronoOperationResult) item));
    }
    return results;
  }
  public static List<ChronoDurationCalculationResult> calendarDifference(
    List<ChronoCalendarDifferenceInput> requests
  ) {
    List<ChronoDurationCalculationResult> results = new List<ChronoDurationCalculationResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoCalendarDifferenceInput item : requests) {
      inputs.add(item == null ? null : ChronoOperationInputs.adapt(item));
    }
    for (
      ChronoOperationResult item : new ChronoCalculationBatch(
          'CalendarDifference'
        )
        .run(inputs)
    ) {
      results.add(ChronoServiceResults.duration((ChronoOperationResult) item));
    }
    return results;
  }
  public static List<ChronoComparisonResult> compare(
    List<ChronoCompareInput> requests
  ) {
    List<ChronoComparisonResult> results = new List<ChronoComparisonResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoCompareInput item : requests) {
      inputs.add(item == null ? null : ChronoOperationInputs.adapt(item));
    }
    for (
      ChronoOperationResult item : new ChronoCalculationBatch('Compare')
        .run(inputs)
    ) {
      results.add(
        ChronoServiceResults.comparison((ChronoOperationResult) item)
      );
    }
    return results;
  }
  public static List<ChronoValueResult> boundary(
    List<ChronoPeriodBoundaryInput> requests
  ) {
    List<ChronoValueResult> results = new List<ChronoValueResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoPeriodBoundaryInput item : requests) {
      inputs.add(item == null ? null : ChronoOperationInputs.adapt(item));
    }
    for (
      ChronoOperationResult item : new ChronoCalculationBatch('PeriodBoundary')
        .run(inputs)
    ) {
      results.add(ChronoServiceResults.value((ChronoOperationResult) item));
    }
    return results;
  }
  public static List<ChronoValueResult> round(List<ChronoRoundInput> requests) {
    List<ChronoValueResult> results = new List<ChronoValueResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoRoundInput item : requests) {
      inputs.add(item == null ? null : ChronoOperationInputs.adapt(item));
    }
    for (
      ChronoOperationResult item : new ChronoCalculationBatch('Round')
        .run(inputs)
    ) {
      results.add(ChronoServiceResults.value((ChronoOperationResult) item));
    }
    return results;
  }
}
