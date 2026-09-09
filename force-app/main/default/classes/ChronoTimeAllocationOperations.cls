// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Shared native allocation implementation and invocation-local bulk calculation. */
public with sharing class ChronoTimeAllocationOperations {
  public static ChronoTimeAllocationResult allocate(
    ChronoTimeAllocationRequest input
  ) {
    return new ChronoAllocationSweep()
      .allocate(new ChronoAllocationRules(input));
  }
  public static List<ChronoTimeAllocationResult> allocateAll(
    List<ChronoTimeAllocationRequest> requests
  ) {
    List<ChronoTimeAllocationResult> results = new List<ChronoTimeAllocationResult>();
    if (requests == null) {
      return results;
    }
    Map<String, String> cache = new Map<String, String>();
    for (ChronoTimeAllocationRequest request : requests) {
      String key = JSON.serialize(request);
      if (!cache.containsKey(key)) {
        cache.put(key, JSON.serialize(calculate(request)));
      }
      results.add(
        (ChronoTimeAllocationResult) JSON.deserialize(
          cache.get(key),
          ChronoTimeAllocationResult.class
        )
      );
    }
    return results;
  }
  private static ChronoTimeAllocationResult calculate(
    ChronoTimeAllocationRequest request
  ) {
    try {
      return allocate(request);
    } catch (Exception ex) {
      ChronoTimeAllocationResult result = new ChronoTimeAllocationResult();
      result.success = false;
      result.errorMessage = ex.getMessage();
      return result;
    }
  }
}
