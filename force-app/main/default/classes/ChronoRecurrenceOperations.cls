// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal bulk operations and concrete result adaptation. */
public with sharing class ChronoRecurrenceOperations {
  public static List<ChronoRecurrenceResult> generate(
    List<ChronoRecurrenceInput> requests
  ) {
    List<ChronoRecurrenceResult> results = new List<ChronoRecurrenceResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoRecurrenceInput item : requests) {
      inputs.add(item);
    }
    for (Object item : new ChronoCatalogueBatch('Recurrence').run(inputs)) {
      results.add((ChronoRecurrenceResult) item);
    }
    return results;
  }
}
