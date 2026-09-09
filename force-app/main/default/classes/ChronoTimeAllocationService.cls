// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Allocates worked time into named blocks. Inputs are not mutated; results are independent. No queries or DML. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoTimeAllocationService {
  /** @description Applies weekday/holiday, overlap, time-basis and rounding rules. Throws ChronoException for invalid input, strict overlaps or exceeded limits.
   * @param input Native worked endpoints, required block timezone, ordered blocks and optional native holidays. Calendar units are not used for billed durations.
   * @return Totals and contributing segments, including explicit unallocated and sub-unit remainder amounts.
   */
  global static ChronoTimeAllocationResult allocate(
    ChronoTimeAllocationRequest input
  ) {
    return ChronoTimeAllocationOperations.allocate(input);
  }
  /** @description Allocates an ordered native request batch without queries or DML. Identical requests share work within this call. Null/empty lists return empty results. Ordinary failures are isolated per item; governor limits still apply.
   * @param requests Complete ordered batch; records are not mutated.
   * @return Independent totals and segment graphs per request. Check each success flag.
   */
  global static List<ChronoTimeAllocationResult> allocateAll(
    List<ChronoTimeAllocationRequest> requests
  ) {
    return ChronoTimeAllocationOperations.allocateAll(requests);
  }
}
