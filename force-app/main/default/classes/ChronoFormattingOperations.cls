// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal bulk operations and concrete result adaptation. */
public with sharing class ChronoFormattingOperations {
  public static List<ChronoFormatResult> format(
    List<ChronoFormatValueInput> requests
  ) {
    List<ChronoFormatResult> results = new List<ChronoFormatResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoFormatValueInput item : requests) {
      inputs.add(item);
    }
    for (Object item : new ChronoCatalogueBatch('FormatValue').run(inputs)) {
      results.add((ChronoFormatResult) item);
    }
    return results;
  }
}
