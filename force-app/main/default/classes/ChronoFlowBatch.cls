// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Ordered invocation-local execution and deduplication shared by all Flow entry points. */
public with sharing class ChronoFlowBatch { // NOPMD -- Aggregate includes independent batching, dispatch and regrouping paths.
  private final String family;
  @TestVisible
  private Integer computationCount = 0;
  public ChronoFlowBatch(String family) {
    this.family = family;
  }
  public List<ChronoFlowResult> run(List<Object> requests) {
    ChronoCalculationBatch batch = new ChronoCalculationBatch(family);
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    for (ChronoOperationResult item : batch.run(requests)) {
      results.add(ChronoFlowResults.fromOperation(item));
    }
    computationCount = batch.computationCount;
    return results;
  }
  public static List<ChronoFlowCollectionResult> regroup(
    List<ChronoFlowResult> flat,
    List<Integer> sizes
  ) {
    List<ChronoFlowCollectionResult> results = new List<ChronoFlowCollectionResult>();
    Integer offset = 0;
    for (Integer size : sizes) {
      ChronoFlowCollectionResult result = new ChronoFlowCollectionResult();
      if (size < 0) {
        result.success = false;
        result.errorMessage = 'Provide an items collection; an empty collection is allowed.';
      }
      for (Integer index = 0; index < size; index++) {
        ChronoFlowResult item = flat[offset++];
        result.results.add(item);
        if (!item.success) {
          result.success = false;
          result.errorMessage = 'One or more items failed. Inspect the item results.';
        }
      }
      results.add(result);
    }
    return results;
  }
}
