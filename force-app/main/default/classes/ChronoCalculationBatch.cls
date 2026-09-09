// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Ordered invocation-local execution and deduplication shared by Apex services and their adapters. */
public with sharing class ChronoCalculationBatch { // NOPMD -- Aggregate includes independent batching and operation dispatch paths.
  private final String family;
  public Integer computationCount = 0;
  public ChronoCalculationBatch(String family) {
    this.family = family;
  }
  public List<ChronoOperationResult> run(List<Object> requests) {
    List<ChronoOperationResult> results = new List<ChronoOperationResult>();
    Map<String, ChronoOperationResult> cache = new Map<String, ChronoOperationResult>();
    ChronoWorkingTimeContext working = (family == 'Difference')
      ? new ChronoWorkingTimeContext(differenceInputs(requests))
      : null;
    ChronoFlowScheduleOps schedules = (family == 'CheckWorkingTime' ||
      family == 'FindWorkingTime')
      ? new ChronoFlowScheduleOps(requests)
      : null;
    for (Object input : requests) {
      String key = JSON.serialize(input);
      if (!cache.containsKey(key)) {
        computationCount++;
        try {
          cache.put(key, execute(input, working, schedules));
        } catch (Exception ex) {
          // A failed request must not prevent independent requests from completing.
          cache.put(key, ChronoOperationResults.failure(ex.getMessage()));
        }
      }
      results.add(ChronoOperationResults.copy(cache.get(key)));
    }
    return results;
  }
  // Flat family dispatch; operation algorithms are tested in their own classes.
  @SuppressWarnings('PMD.CognitiveComplexity')
  private ChronoOperationResult execute(
    Object input,
    ChronoWorkingTimeContext working,
    ChronoFlowScheduleOps schedules
  ) {
    ChronoSupport.requireValue(input, 'Input');
    switch on family {
      when 'Convert' {
        return new ChronoFlowConvert((ChronoConvertInput) input).execute();
      }
      when 'Adjust' {
        return ChronoFlowAdjust.execute((ChronoAdjustInput) input);
      }
      when 'Difference' {
        return difference((ChronoDifferenceInput) input, working);
      }
      when else {
        return ChronoFlowOperations.execute(
          family,
          (ChronoOperationInput) input,
          schedules
        );
      }
    }
  }
  private static ChronoOperationResult difference(
    ChronoDifferenceInput request,
    ChronoWorkingTimeContext working
  ) {
    Datetime start = ChronoDatedInput.start(request);
    Datetime finish = ChronoDatedInput.finish(request);
    return new ChronoFlowValue(
        'Duration',
        ChronoDurationService.create(
          0,
          0,
          !ChronoScheduleInputs.restricted(request)
            ? finish.getTime() - start.getTime()
            : working.differenceMilliseconds(request, start, finish)
        )
      )
      .result();
  }
  private static List<ChronoWorkingTimeInput> differenceInputs(
    List<Object> requests
  ) {
    List<ChronoWorkingTimeInput> inputs = new List<ChronoWorkingTimeInput>();
    for (Object raw : requests) {
      if (raw != null) {
        inputs.add(
          ChronoScheduleInputs.fromDifference((ChronoDifferenceInput) raw)
        );
      }
    }
    return inputs;
  }
}
