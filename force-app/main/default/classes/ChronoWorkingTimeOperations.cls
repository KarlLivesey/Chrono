// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Invocation-local working-time batching, error isolation and independent result copies. */
public with sharing class ChronoWorkingTimeOperations {
  public static List<ChronoWorkingTimeResult> add(
    List<ChronoWorkingTimeInput> requests
  ) {
    List<ChronoWorkingTimeResult> results = new List<ChronoWorkingTimeResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    ChronoWorkingTimeContext context = new ChronoWorkingTimeContext(requests);
    Map<String, ChronoWorkingTimeResult> cache = new Map<String, ChronoWorkingTimeResult>();
    for (ChronoWorkingTimeInput input : requests) {
      String key = JSON.serialize(input);
      if (!cache.containsKey(key)) {
        cache.put(key, calculate(context, input));
      }
      results.add(copy(cache.get(key)));
    }
    return results;
  }
  private static ChronoWorkingTimeResult calculate(
    ChronoWorkingTimeContext context,
    ChronoWorkingTimeInput input
  ) {
    ChronoWorkingTimeResult result = new ChronoWorkingTimeResult();
    try {
      result.value = context.execute(input);
      result.success = true;
    } catch (Exception ex) {
      // Batch callers receive ordinary per-item failures without losing valid items.
      result.success = false;
      result.errorMessage = ex.getMessage();
    }
    return result;
  }
  private static ChronoWorkingTimeResult copy(ChronoWorkingTimeResult source) {
    ChronoWorkingTimeResult result = new ChronoWorkingTimeResult();
    result.success = source.success;
    result.errorMessage = source.errorMessage;
    if (source.value != null) {
      result.value = new ChronoZonedDateTime();
      result.value.instant = source.value.instant;
      result.value.timeZoneId = source.value.timeZoneId;
    }
    return result;
  }
}
