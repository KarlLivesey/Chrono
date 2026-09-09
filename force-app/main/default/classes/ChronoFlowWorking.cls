// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Adapts bulk working-time service results to the Flow output contract. */
public with sharing class ChronoFlowWorking {
  public static List<ChronoFlowResult> add(
    List<ChronoWorkingTimeInput> requests
  ) {
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    for (
      ChronoWorkingTimeResult item : ChronoWorkingTimeService.add(requests)
    ) {
      results.add(toFlowResult(item));
    }
    return results;
  }
  private static ChronoFlowResult toFlowResult(ChronoWorkingTimeResult item) {
    if (!item.success) {
      return ChronoFlowResults.failure(item.errorMessage);
    }
    try {
      return ChronoFlowResults.fromOperation(
        new ChronoFlowValue('ZonedDateTime', item.value).result()
      );
    } catch (Exception ex) {
      // Flow requires canonical ISO output even when a typed Apex value is valid.
      return ChronoFlowResults.failure(ex.getMessage());
    }
  }
}
