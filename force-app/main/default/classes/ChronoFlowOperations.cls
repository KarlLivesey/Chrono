// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Routes additional operations after the shared batch has handled caching and item errors. */
public with sharing class ChronoFlowOperations {
  // Flat operation dispatch; each branch delegates without additional algorithmic state.
  @SuppressWarnings('PMD.CognitiveComplexity')
  public static ChronoOperationResult execute(
    String family,
    ChronoOperationInput input,
    ChronoFlowScheduleOps schedules
  ) {
    if (family == 'CheckWorkingTime' || family == 'FindWorkingTime') {
      return schedules.execute(family, input);
    }
    if (family == 'Compare') {
      return ChronoFlowCompare.execute(input);
    }
    if (family == 'PeriodBoundary') {
      return ChronoFlowPeriod.execute(input);
    }
    if (family == 'Round') {
      return ChronoFlowRound.execute(input);
    }
    if (family == 'ResolveLocal') {
      return ChronoFlowResolve.execute(input);
    }
    if (family == 'CalendarDifference') {
      return new ChronoFlowCalendarDiff(input).execute(input.largestUnit);
    }
    throw new ChronoException('Unknown action family.');
  }
}
