// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal bulk operations and concrete result adaptation. */
public with sharing class ChronoDurationCalculationOperations {
  public static List<ChronoDurationResult> calculate(
    List<ChronoDurationToolsInput> requests
  ) {
    List<ChronoDurationResult> results = new List<ChronoDurationResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoDurationToolsInput item : requests) {
      inputs.add(item);
    }
    for (Object item : new ChronoCatalogueBatch('DurationTools').run(inputs)) {
      results.add((ChronoDurationResult) item);
    }
    return results;
  }
}
