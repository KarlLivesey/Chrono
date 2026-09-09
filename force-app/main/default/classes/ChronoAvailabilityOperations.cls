// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal bulk operations and concrete result adaptation. */
public with sharing class ChronoAvailabilityOperations {
  public static List<ChronoAvailabilityResult> evaluate(
    List<ChronoAvailabilityInput> requests
  ) {
    List<ChronoAvailabilityResult> results = new List<ChronoAvailabilityResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoAvailabilityInput item : requests) {
      inputs.add(item);
    }
    for (Object item : new ChronoCatalogueBatch('Availability').run(inputs)) {
      results.add((ChronoAvailabilityResult) item);
    }
    return results;
  }
}
