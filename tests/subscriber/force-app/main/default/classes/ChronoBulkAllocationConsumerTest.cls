// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
// Exact package query budgets are asserted by the corresponding in-package tests.
// Subscriber Limits counters do not include the skel namespace.
@IsTest
private class ChronoBulkAllocationConsumerTest {
  private static skel.ChronoTimeBlock block(
    String key,
    String start,
    String finish
  ) {
    skel.ChronoTimeBlock value = new skel.ChronoTimeBlock();
    value.key = key;
    value.label = key;
    value.startTime = start;
    value.endTime = finish;
    return value;
  }
  private static skel.ChronoTimeAllocationRequest request(
    String start,
    String finish
  ) {
    skel.ChronoTimeAllocationRequest input = new skel.ChronoTimeAllocationRequest();
    input.startInstant = skel.ChronoInstantService.parseIso(start).value;
    input.endInstant = skel.ChronoInstantService.parseIso(finish).value;
    input.timeZoneId = 'Europe/London';
    input.blocks = new List<skel.ChronoTimeBlock>{
      block('one', '08:00', '10:00'),
      block('two', '10:00', '11:00'),
      block('three', '11:00', '15:00')
    };
    return input;
  }
  private static void reconciles(skel.ChronoTimeAllocationResult result) {
    Assert.areEqual(
      result.inputMilliseconds + result.duplicateMilliseconds,
      result.allocatedMilliseconds +
        result.unallocatedMilliseconds +
        result.roundingMilliseconds,
      'All time must be accounted for'
    );
    Long total = 0;
    for (skel.ChronoTimeAllocationRow row : result.totals) {
      total += row.allocatedMilliseconds;
    }
    Assert.areEqual(
      total,
      result.allocatedMilliseconds,
      'Block totals reconcile'
    );
  }
  @IsTest
  static void nativeBulkAllocationCopiesNestedResultsAndIsolatesFailures() {
    skel.ChronoTimeAllocationRequest input = request(
      '2026-09-07T08:00+01:00',
      '2026-09-07T12:00+01:00'
    );
    List<skel.ChronoTimeAllocationRequest> inputs = new List<skel.ChronoTimeAllocationRequest>();
    for (Integer i = 0; i < 200; i++) {
      inputs.add(input);
    }
    inputs.add(null);
    Test.startTest();
    List<skel.ChronoTimeAllocationResult> results = skel.ChronoTimeAllocationService.allocateAll(
      inputs
    );
    Test.stopTest();
    Assert.areEqual(201, results.size());
    for (Integer i = 0; i < 200; i++) {
      Assert.isTrue(
        results[i].success,
        'Expected success: ' + results[i].errorMessage
      );
      Assert.areEqual(14400000L, results[i].allocatedMilliseconds);
      reconciles(results[i]);
    }
    Assert.isFalse(results[200].success);
    results[0].totals[0].allocatedMilliseconds = 0;
    results[0].segments.clear();
    Assert.areEqual(7200000L, results[1].totals[0].allocatedMilliseconds);
    Assert.areEqual(3, results[1].segments.size());
    Assert.isNull(input.overlapMode);
    Assert.areEqual(
      0,
      skel.ChronoTimeAllocationService.allocateAll(null).size()
    );
    try {
      skel.ChronoTimeAllocationService.allocate(null);
      Assert.fail('Single invalid input still throws');
    } catch (skel.ChronoException expected) {
      Assert.isNotNull(expected.getMessage());
    }
  }
}
