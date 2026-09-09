// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal bulk operations and concrete result adaptation. */
public with sharing class ChronoRangeOperations {
  public static List<ChronoRangeResult> calculate(
    List<ChronoRangeToolsInput> requests
  ) {
    List<ChronoRangeResult> results = new List<ChronoRangeResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoRangeToolsInput item : requests) {
      inputs.add(item);
    }
    for (Object item : new ChronoCatalogueBatch('RangeTools').run(inputs)) {
      results.add((ChronoRangeResult) item);
    }
    return results;
  }
}
