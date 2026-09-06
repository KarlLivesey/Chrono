// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Ordered invocation-local execution and deduplication shared by all Flow entry points. */
public with sharing class ChronoFlowBatch {
  private final String family;
  @TestVisible
  private Integer computationCount = 0;
  public ChronoFlowBatch(String family) {
    this.family = family;
  }
  public List<ChronoFlowResult> run(List<Object> requests) {
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    Map<String, ChronoFlowResult> cache = new Map<String, ChronoFlowResult>();
    ChronoFlowWorking working = family == 'WorkingTime'
      ? new ChronoFlowWorking(requests)
      : null;
    for (Object input : requests) {
      String key = JSON.serialize(input);
      if (!cache.containsKey(key)) {
        computationCount++;
        try {
          cache.put(key, execute(input, working));
        } catch (Exception ex) {
          // The Flow contract reports a failed item while preserving other interviews.
          cache.put(key, ChronoFlowResult.failure(ex.getMessage()));
        }
      }
      results.add(cache.get(key).copyResult());
    }
    return results;
  }
  private ChronoFlowResult execute(Object input, ChronoFlowWorking working) {
    ChronoSupport.requireValue(input, 'Input');
    switch on family {
      when 'Convert' {
        return new ChronoFlowConvert((ChronoConvertInput) input).execute();
      }
      when 'Adjust' {
        return ChronoFlowAdjust.execute((ChronoAdjustInput) input);
      }
      when 'Difference' {
        ChronoDifferenceInput request = (ChronoDifferenceInput) input;
        Datetime start = ChronoFlowValue.exact(
          request.startInstant,
          request.startValue
        );
        Datetime finish = ChronoFlowValue.exact(
          request.endInstant,
          request.endValue
        );
        return new ChronoFlowValue(
            'Duration',
            new ChronoInstant(start).until(new ChronoInstant(finish))
          )
          .result();
      }
      when 'WorkingTime' {
        return working.execute((ChronoWorkingTimeInput) input);
      }
      when else {
        throw new ChronoException('Unknown action family.');
      }
    }
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
