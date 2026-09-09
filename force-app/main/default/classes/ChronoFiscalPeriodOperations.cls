// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal bulk operations and concrete result adaptation. */
public with sharing class ChronoFiscalPeriodOperations {
  public static List<ChronoFiscalResult> resolve(
    List<ChronoFiscalPeriodInput> requests
  ) {
    List<ChronoFiscalResult> results = new List<ChronoFiscalResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoFiscalPeriodInput item : requests) {
      inputs.add(item);
    }
    for (Object item : new ChronoCatalogueBatch('FiscalPeriod').run(inputs)) {
      results.add((ChronoFiscalResult) item);
    }
    return results;
  }
}
