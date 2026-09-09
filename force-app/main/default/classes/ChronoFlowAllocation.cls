// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Converts Flow ranges/block definitions once, then invokes the native bulk allocation service. */
public with sharing class ChronoFlowAllocation {
  private final Map<String, ChronoTimeAllocationRequest> cache = new Map<String, ChronoTimeAllocationRequest>();
  private final Map<String, String> errors = new Map<String, String>();
  public static List<ChronoTimeAllocationResult> allocate(
    List<ChronoTimeAllocationInput> inputs
  ) {
    return new ChronoFlowAllocation().run(inputs);
  }
  private List<ChronoTimeAllocationResult> run(
    List<ChronoTimeAllocationInput> inputs
  ) {
    List<ChronoTimeAllocationResult> results = new List<ChronoTimeAllocationResult>();
    List<ChronoTimeAllocationRequest> requests = new List<ChronoTimeAllocationRequest>();
    List<Integer> positions = new List<Integer>();
    for (ChronoTimeAllocationInput input : inputs) {
      Integer index = results.size();
      results.add(null);
      String key = JSON.serialize(input);
      prepare(input, key);
      if (errors.containsKey(key)) {
        ChronoTimeAllocationResult failed = new ChronoTimeAllocationResult();
        failed.success = false;
        failed.errorMessage = errors.get(key);
        results[index] = failed;
      } else {
        positions.add(index);
        requests.add(cache.get(key));
      }
    }
    List<ChronoTimeAllocationResult> calculated = ChronoTimeAllocationService.allocateAll(
      requests
    );
    for (Integer i = 0; i < calculated.size(); i++) {
      results[positions[i]] = calculated[i];
    }
    return results;
  }
  private void prepare(ChronoTimeAllocationInput input, String key) {
    if (cache.containsKey(key) || errors.containsKey(key)) {
      return;
    }
    try {
      cache.put(key, ChronoTimeAllocation.request(input));
    } catch (Exception ex) {
      errors.put(key, ex.getMessage());
    }
  }
}
