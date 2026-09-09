// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal bulk operations and concrete result adaptation. */
public with sharing class ChronoCollectionOperations {
  public static List<ChronoValuesResult> calculate(
    List<ChronoCollectionToolsInput> requests
  ) {
    List<ChronoValuesResult> results = new List<ChronoValuesResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoCollectionToolsInput item : requests) {
      inputs.add(item);
    }
    for (
      Object item : new ChronoCatalogueBatch('CollectionTools').run(inputs)
    ) {
      results.add((ChronoValuesResult) item);
    }
    return results;
  }
}
