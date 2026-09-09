// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoTimeAllocationTest {
  private static ChronoTimeBlock block(
    String key,
    String start,
    String finish
  ) {
    ChronoTimeBlock value = new ChronoTimeBlock();
    value.key = key;
    value.label = key;
    value.startTime = start;
    value.endTime = finish;
    return value;
  }
  private static ChronoTimeAllocationRequest request(
    String start,
    String finish
  ) {
    ChronoTimeAllocationRequest input = new ChronoTimeAllocationRequest();
    input.startInstant = ChronoIso.parseInstant(start);
    input.endInstant = ChronoIso.parseInstant(finish);
    input.timeZoneId = 'Europe/London';
    input.blocks = new List<ChronoTimeBlock>{
      block('one', '08:00', '10:00'),
      block('two', '10:00', '11:00'),
      block('three', '11:00', '15:00')
    };
    return input;
  }
  private static void reconciles(ChronoTimeAllocationResult result) {
    Assert.areEqual(
      result.inputMilliseconds + result.duplicateMilliseconds,
      result.allocatedMilliseconds +
        result.unallocatedMilliseconds +
        result.roundingMilliseconds,
      'All time must be accounted for'
    );
    Long total = 0;
    for (ChronoTimeAllocationRow row : result.totals) {
      total += row.allocatedMilliseconds;
    }
    Assert.areEqual(
      total,
      result.allocatedMilliseconds,
      'Block totals reconcile'
    );
  }
  @IsTest
  static void allocatesAdjacentBlocksWithoutDoubleCounting() {
    ChronoTimeAllocationRequest input = request(
      '2026-09-07T08:00+01:00',
      '2026-09-07T12:00+01:00'
    );
    Integer queries = Limits.getQueries();
    Integer dml = Limits.getDmlStatements();
    ChronoTimeAllocationResult result = ChronoTimeAllocationService.allocate(
      input
    );
    Assert.areEqual(7200000L, result.totals[0].allocatedMilliseconds);
    Assert.areEqual(3600000L, result.totals[1].allocatedMilliseconds);
    Assert.areEqual(3600000L, result.totals[2].allocatedMilliseconds);
    Assert.areEqual(3, result.segments.size());
    Assert.areEqual(0L, result.unallocatedMilliseconds);
    Assert.areEqual(queries, Limits.getQueries());
    Assert.areEqual(dml, Limits.getDmlStatements());
    Assert.isNull(input.overlapMode, 'Defaults do not mutate request');
    reconciles(result);
  }
  @IsTest
  static void holidaysReplaceNormalBlocksOnTheirActualDates() {
    ChronoTimeAllocationRequest input = request(
      '2026-09-07T08:00+01:00',
      '2026-09-08T12:00+01:00'
    );
    ChronoTimeBlock holiday = block('holiday', '08:00', '12:00');
    holiday.dayType = 'holiday';
    input.blocks.add(holiday);
    input.holidays = new List<Holiday>{
      new Holiday(ActivityDate = Date.newInstance(2026, 9, 8), IsAllDay = true)
    };
    ChronoTimeAllocationResult result = ChronoTimeAllocationService.allocate(
      input
    );
    Assert.areEqual(7200000L, result.totals[0].allocatedMilliseconds);
    Assert.areEqual(3600000L, result.totals[1].allocatedMilliseconds);
    Assert.areEqual(
      14400000L,
      result.totals[2].allocatedMilliseconds,
      'Monday 11–15'
    );
    Assert.areEqual(
      14400000L,
      result.totals[3].allocatedMilliseconds,
      'Tuesday holiday'
    );
    reconciles(result);
  }
  @IsTest
  static void partialAndRecurringHolidaysUseNativeRecords() {
    ChronoTimeAllocationRequest input = request(
      '2026-09-07T08:00+01:00',
      '2026-09-07T12:00+01:00'
    );
    input.blocks = new List<ChronoTimeBlock>{
      block('normal', '08:00', '12:00'),
      block('holiday', '00:00', '24:00')
    };
    input.blocks[1].dayType = 'holiday';
    Holiday holiday = new Holiday(
      IsRecurrence = true,
      RecurrenceType = 'RecursWeekly',
      RecurrenceStartDate = Date.newInstance(2026, 9, 1),
      RecurrenceDayOfWeekMask = 2,
      RecurrenceInterval = 1,
      IsAllDay = false,
      StartTimeInMinutes = 570,
      EndTimeInMinutes = 630
    );
    input.holidays = new List<Holiday>{ holiday, holiday };
    ChronoTimeAllocationResult result = ChronoTimeAllocationService.allocate(
      input
    );
    Assert.areEqual(10800000L, result.totals[0].allocatedMilliseconds);
    Assert.areEqual(3600000L, result.totals[1].allocatedMilliseconds);
    reconciles(result);
  }
  @IsTest
  static void overnightWeekdaysSplitAtHolidayMidnight() {
    ChronoTimeAllocationRequest input = request(
      '2026-09-07T22:00+01:00',
      '2026-09-08T06:00+01:00'
    );
    input.blocks = new List<ChronoTimeBlock>{
      block('night', '22:00', '06:00'),
      block('holiday', '00:00', '24:00')
    };
    input.blocks[0].weekdays = '1';
    input.blocks[1].dayType = 'holiday';
    input.holidays = new List<Holiday>{
      new Holiday(ActivityDate = Date.newInstance(2026, 9, 8), IsAllDay = true)
    };
    ChronoTimeAllocationResult result = ChronoTimeAllocationService.allocate(
      input
    );
    Assert.areEqual(7200000L, result.totals[0].allocatedMilliseconds);
    Assert.areEqual(21600000L, result.totals[1].allocatedMilliseconds);
    reconciles(result);
  }
  @IsTest
  static void modesHandleOverlapAndPriorityExplicitly() {
    ChronoTimeAllocationRequest input = request(
      '2026-09-07T08:00+01:00',
      '2026-09-07T08:10+01:00'
    );
    input.blocks = new List<ChronoTimeBlock>{
      block('one', '08:00', '09:00'),
      block('two', '08:00', '09:00'),
      block('three', '08:00', '09:00')
    };
    assertFailure(input, 'overlapping');
    input.overlapMode = 'lax';
    ChronoTimeAllocationResult result = ChronoTimeAllocationService.allocate(
      input
    );
    Assert.areEqual(600000L, result.totals[0].allocatedMilliseconds);
    Assert.areEqual(0L, result.totals[1].allocatedMilliseconds);
    reconciles(result);
    input.overlapMode = 'duplicate';
    result = ChronoTimeAllocationService.allocate(input);
    Assert.areEqual(1800000L, result.allocatedMilliseconds);
    Assert.areEqual(1200000L, result.duplicateMilliseconds);
    reconciles(result);
    input.overlapMode = 'split';
    result = ChronoTimeAllocationService.allocate(input);
    for (ChronoTimeAllocationRow row : result.totals) {
      Assert.areEqual(200000L, row.allocatedMilliseconds);
    }
    reconciles(result);
    input.allocationUnit = 'minute';
    result = ChronoTimeAllocationService.allocate(input);
    Assert.areEqual(240000L, result.totals[0].allocatedMilliseconds);
    Assert.areEqual(180000L, result.totals[1].allocatedMilliseconds);
    Assert.areEqual(180000L, result.totals[2].allocatedMilliseconds);
    reconciles(result);
  }
  @IsTest
  static void splitChangesWithTheMatchingSetAndPreservesRemainders() {
    ChronoTimeAllocationRequest input = request(
      '2026-09-07T08:00+01:00',
      '2026-09-07T08:20:00.001+01:00'
    );
    input.blocks = new List<ChronoTimeBlock>{
      block('one', '08:00', '09:00'),
      block('two', '08:00', '09:00'),
      block('three', '08:10', '09:00')
    };
    input.overlapMode = 'split';
    input.allocationUnit = 'minute';
    ChronoTimeAllocationResult result = ChronoTimeAllocationService.allocate(
      input
    );
    Assert.areEqual(540000L, result.totals[0].allocatedMilliseconds);
    Assert.areEqual(480000L, result.totals[1].allocatedMilliseconds);
    Assert.areEqual(180000L, result.totals[2].allocatedMilliseconds);
    Assert.areEqual(1L, result.roundingMilliseconds);
    reconciles(result);
    input.endInstant = Datetime.newInstance(input.startInstant.getTime() + 1);
    input.allocationUnit = 'millisecond';
    result = ChronoTimeAllocationService.allocate(input);
    Assert.areEqual(1L, result.totals[0].allocatedMilliseconds);
    Assert.areEqual(0L, result.totals[1].allocatedMilliseconds);
    reconciles(result);
  }
  @IsTest
  static void elapsedAndClockTreatDstDifferently() {
    for (
      String start : new List<String>{
        '2026-03-29T00:00Z',
        '2026-10-25T00:00+01:00'
      }
    ) {
      Boolean spring = start.startsWith('2026-03');
      ChronoTimeAllocationRequest input = request(
        start,
        spring ? '2026-03-29T03:00+01:00' : '2026-10-25T03:00Z'
      );
      input.blocks = new List<ChronoTimeBlock>{
        block('all', '00:00', '24:00')
      };
      ChronoTimeAllocationResult result = ChronoTimeAllocationService.allocate(
        input
      );
      Assert.areEqual(
        spring ? 7200000L : 14400000L,
        result.allocatedMilliseconds
      );
      reconciles(result);
      input.timeBasis = 'clock';
      result = ChronoTimeAllocationService.allocate(input);
      Assert.areEqual(10800000L, result.allocatedMilliseconds);
      Assert.isFalse(result.segments[0].startValue.contains('['));
      reconciles(result);
    }
    ChronoTimeAllocationRequest reversed = request(
      '2026-10-25T01:30+01:00',
      '2026-10-25T01:15Z'
    );
    reversed.timeBasis = 'clock';
    assertFailure(reversed, 'precedes');
  }
  @IsTest
  static void unmatchedTimeAndLimitsAreExplicit() {
    ChronoTimeAllocationRequest input = request(
      '2026-09-07T07:00+01:00',
      '2026-09-07T16:00+01:00'
    );
    ChronoTimeAllocationResult result = ChronoTimeAllocationService.allocate(
      input
    );
    Assert.areEqual(7200000L, result.unallocatedMilliseconds);
    Assert.isNull(result.segments[0].blockKey);
    reconciles(result);
    input.maximumSegments = 1;
    assertFailure(input, 'limit');
    input.maximumSegments = null;
    input.blocks[1].key = 'one';
    assertFailure(input, 'unique');
    input.blocks[1].key = 'two';
    input.blocks[0].weekdays = '0,8';
    assertFailure(input, 'weekdays');
    input.blocks[0].weekdays = '1';
    input.allocationUnit = 'hour';
    assertFailure(input, 'allocation unit');
  }
  @IsTest
  static void collectionsAndTwoHundredInterviewsAreIndependent() {
    ChronoTimeAllocationInput item = flowInput();
    List<ChronoTimeAllocationAction.Request> interviews = new List<ChronoTimeAllocationAction.Request>();
    for (Integer i = 0; i < 200; i++) {
      ChronoTimeAllocationAction.Request value = (ChronoTimeAllocationAction.Request) JSON.deserialize(
        JSON.serialize(item),
        ChronoTimeAllocationAction.Request.class
      );
      interviews.add(value);
    }
    interviews[5].overlapMode = 'invalid';
    List<ChronoTimeAllocationResult> rows = ChronoTimeAllocationAction.run(
      interviews
    );
    Assert.areEqual(200, rows.size());
    Assert.isFalse(rows[5].success);
    Assert.isTrue(rows[6].success);
    rows[0].totals[0].allocatedMilliseconds = 0;
    Assert.areEqual(7200000L, rows[1].totals[0].allocatedMilliseconds);
    ChronoTimeAllocationCollectionAction.Request first = new ChronoTimeAllocationCollectionAction.Request();
    first.items = new List<ChronoTimeAllocationInput>{ item, null, item };
    ChronoTimeAllocationCollectionAction.Request empty = new ChronoTimeAllocationCollectionAction.Request();
    empty.items = new List<ChronoTimeAllocationInput>();
    List<ChronoTimeAllocationCollectionResult> grouped = ChronoTimeAllocationCollectionAction.run(
      new List<ChronoTimeAllocationCollectionAction.Request>{
        first,
        empty,
        null
      }
    );
    Assert.areEqual(3, grouped.size());
    Assert.isFalse(grouped[0].success);
    Assert.isTrue(grouped[0].results[0].success);
    Assert.isFalse(grouped[0].results[1].success);
    Assert.isTrue(grouped[1].success);
    Assert.isFalse(grouped[2].success);
    grouped[0].results[0].segments[0].label = 'Changed';
    Assert.areEqual('one', grouped[0].results[2].segments[0].label);
  }
  @IsTest
  static void flowSupportsNativeAndIsoEndpoints() {
    ChronoTimeAllocationInput input = flowInput();
    ChronoTimeAllocation engine = new ChronoTimeAllocation();
    Assert.areEqual(
      14400000L,
      ((ChronoTimeAllocationResult) engine.evaluate(input))
        .allocatedMilliseconds
    );
    input.valueType = 'PlainDateTime';
    input.value = '2026-09-07T08:00';
    input.endValue = '2026-09-07T12:00';
    input.instantValue = null;
    input.endInstant = null;
    Assert.areEqual(
      14400000L,
      ((ChronoTimeAllocationResult) engine.evaluate(input))
        .allocatedMilliseconds
    );
    input.value = null;
    input.endValue = null;
    input.dateValue = Date.newInstance(2026, 9, 7);
    input.endDate = input.dateValue;
    input.timeValue = '08:00';
    input.endTime = '12:00';
    Assert.areEqual(
      14400000L,
      ((ChronoTimeAllocationResult) engine.evaluate(input))
        .allocatedMilliseconds
    );
    input.valueType = 'PlainDate';
    input.timeValue = null;
    input.endTime = null;
    input.endDate = input.dateValue.addDays(1);
    Assert.areEqual(
      25200000L,
      ((ChronoTimeAllocationResult) engine.evaluate(input))
        .allocatedMilliseconds
    );
  }
  private static ChronoTimeAllocationInput flowInput() {
    ChronoTimeAllocationRequest native = request(
      '2026-09-07T08:00+01:00',
      '2026-09-07T12:00+01:00'
    );
    ChronoTimeAllocationInput item = new ChronoTimeAllocationInput();
    item.valueType = 'Instant';
    item.instantValue = native.startInstant;
    item.endInstant = native.endInstant;
    item.timeZoneId = native.timeZoneId;
    item.blocksText = JSON.serialize(native.blocks);
    return item;
  }
  private static void assertFailure(
    ChronoTimeAllocationRequest input,
    String message
  ) {
    try {
      ChronoTimeAllocationService.allocate(input);
      Assert.fail('Expected allocation failure');
    } catch (ChronoException expected) {
      Assert.isTrue(
        expected.getMessage().contains(message),
        expected.getMessage()
      );
    }
  }
  @IsTest
  static void losingBlocksCannotReduceLaxCredit() {
    ChronoTimeAllocationRequest input = request(
      '2026-09-07T08:00:00Z',
      '2026-09-07T08:01:01Z'
    );
    input.timeZoneId = 'UTC';
    input.overlapMode = 'lax';
    input.allocationUnit = 'minute';
    input.blocks = new List<ChronoTimeBlock>{
      block('winner', '08:00', '09:00')
    };
    ChronoTimeAllocationResult before = ChronoTimeAllocationService.allocate(
      input
    );
    input.blocks.add(block('loser', '08:00:30', '09:00'));
    ChronoTimeAllocationResult after = ChronoTimeAllocationService.allocate(
      input
    );
    Assert.areEqual(60000L, before.allocatedMilliseconds);
    Assert.areEqual(before.allocatedMilliseconds, after.allocatedMilliseconds);
    Assert.areEqual(1000L, after.roundingMilliseconds);
    Assert.areEqual(0L, after.totals[1].allocatedMilliseconds);
    Assert.areEqual(
      31000L,
      after.totals[1].matchedMilliseconds,
      'Keep losing-block diagnostics'
    );
    Long segments = 0;
    for (ChronoTimeAllocationRow row : after.segments) {
      segments += row.allocatedMilliseconds;
    }
    Assert.areEqual(after.allocatedMilliseconds, segments);
    reconciles(after);
    input.allocationUnit = null;
    input.endInstant = Datetime.newInstance(input.endInstant.getTime() + 1);
    after = ChronoTimeAllocationService.allocate(input);
    Assert.areEqual('millisecond', after.allocationUnit);
    Assert.areEqual(61001L, after.allocatedMilliseconds);
    Assert.areEqual(0L, after.roundingMilliseconds);
  }
  @IsTest
  static void laxRoundingEndsWhenTheWinnerChangesOrWorkIsUnallocated() {
    ChronoTimeAllocationRequest input = request(
      '2026-09-07T08:00:00Z',
      '2026-09-07T08:01:30Z'
    );
    input.timeZoneId = 'UTC';
    input.overlapMode = 'lax';
    input.allocationUnit = 'minute';
    input.blocks = new List<ChronoTimeBlock>{
      block('priority', '08:00:30', '08:01'),
      block('base', '08:00', '09:00')
    };
    ChronoTimeAllocationResult result = ChronoTimeAllocationService.allocate(
      input
    );
    Assert.areEqual(
      0L,
      result.allocatedMilliseconds,
      'Three distinct 30-second winning regions'
    );
    Assert.areEqual(90000L, result.roundingMilliseconds);
    reconciles(result);
    input.blocks = new List<ChronoTimeBlock>{
      block('base', '08:00', '08:00:30')
    };
    result = ChronoTimeAllocationService.allocate(input);
    Assert.areEqual(30000L, result.roundingMilliseconds);
    Assert.areEqual(60000L, result.unallocatedMilliseconds);
    reconciles(result);
  }

  @IsTest
  static void nativeBulkAllocationCopiesNestedResultsAndIsolatesFailures() {
    ChronoTimeAllocationRequest input = request(
      '2026-09-07T08:00+01:00',
      '2026-09-07T12:00+01:00'
    );
    List<ChronoTimeAllocationRequest> inputs = new List<ChronoTimeAllocationRequest>();
    for (Integer i = 0; i < 200; i++) {
      inputs.add(input);
    }
    inputs.add(null);
    Test.startTest();
    List<ChronoTimeAllocationResult> results = ChronoTimeAllocationService.allocateAll(
      inputs
    );
    Assert.areEqual(0, Limits.getQueries());
    Assert.areEqual(0, Limits.getDmlStatements());
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
    Assert.areEqual(0, ChronoTimeAllocationService.allocateAll(null).size());
    try {
      ChronoTimeAllocationService.allocate(null);
      Assert.fail('Single invalid input still throws');
    } catch (ChronoException expected) {
      Assert.isNotNull(expected.getMessage());
    }
  }
}
