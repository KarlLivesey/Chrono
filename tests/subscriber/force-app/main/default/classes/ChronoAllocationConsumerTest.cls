// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoAllocationConsumerTest {
  private static String blocks() {
    return '[{"key":"one","startTime":"08:00","endTime":"10:00"},{"key":"two","startTime":"10:00","endTime":"11:00"},{"key":"three","startTime":"11:00","endTime":"15:00"}]';
  }
  private static Map<String, Object> inputs() {
    return new Map<String, Object>{
      'valueType' => 'ZonedDateTime',
      'value' => '2026-09-07T08:00:00.000+01:00[Europe/London]',
      'endValue' => '2026-09-07T12:00:00.000+01:00[Europe/London]',
      'timeZoneId' => 'Europe/London',
      'blocksText' => blocks()
    };
  }
  private static skel.ChronoTimeAllocationInput allocationInput() {
    skel.ChronoTimeAllocationInput input = new skel.ChronoTimeAllocationInput();
    input.valueType = 'ZonedDateTime';
    input.value = '2026-09-07T08:00:00.000+01:00[Europe/London]';
    input.endValue = '2026-09-07T12:00:00.000+01:00[Europe/London]';
    input.timeZoneId = 'Europe/London';
    input.blocksText = blocks();
    return input;
  }
  private static skel.ChronoTimeBlock block(
    String key,
    String startTime,
    String endTime
  ) {
    skel.ChronoTimeBlock value = new skel.ChronoTimeBlock();
    value.key = key;
    value.startTime = startTime;
    value.endTime = endTime;
    return value;
  }
  @IsTest
  static void nativeServiceAndScalarFlowExposeUsefulRows() {
    skel.ChronoTimeAllocationRequest request = new skel.ChronoTimeAllocationRequest();
    request.startInstant = Datetime.newInstanceGmt(2026, 9, 7, 7, 0, 0);
    request.endInstant = Datetime.newInstanceGmt(2026, 9, 7, 11, 0, 0);
    request.timeZoneId = 'Europe/London';
    request.blocks = new List<skel.ChronoTimeBlock>{
      block('one', '08:00', '10:00'),
      block('two', '10:00', '11:00'),
      block('three', '11:00', '15:00')
    };
    skel.ChronoTimeAllocationResult result = skel.ChronoTimeAllocationService.allocate(
      request
    );
    Assert.areEqual(
      7200000L,
      result.totals[0].allocatedMilliseconds,
      'Global service result'
    );
    Flow.Interview interview = Flow.Interview.createInterview(
      'ChronoTimeAllocationHarness',
      inputs()
    );
    interview.start();
    Assert.areEqual(true, interview.getVariableValue('output_success'));
    List<skel.ChronoTimeAllocationRow> totals = (List<skel.ChronoTimeAllocationRow>) interview.getVariableValue(
      'output_totals'
    );
    Assert.areEqual(3, totals.size());
    Assert.areEqual('one', totals[0].blockKey);
    Assert.areEqual(7200000L, totals[0].allocatedMilliseconds);
    Assert.areEqual(3600000L, totals[2].allocatedMilliseconds);
    List<skel.ChronoTimeAllocationRow> segments = (List<skel.ChronoTimeAllocationRow>) interview.getVariableValue(
      'output_segments'
    );
    Assert.areEqual(
      '2026-09-07T08:00:00.000+01:00[Europe/London]',
      segments[0].startValue
    );
    Assert.areEqual(
      14400000L,
      interview.getVariableValue('output_allocatedMilliseconds')
    );
  }
  @IsTest
  static void collectionFlowKeepsNestedRowsAndFailuresIndependent() {
    skel.ChronoTimeAllocationInput input = allocationInput();
    Flow.Interview interview = Flow.Interview.createInterview(
      'ChronoTimeAllocationCollectionHarness',
      new Map<String, Object>{
        'items' => new List<skel.ChronoTimeAllocationInput>{ input, input }
      }
    );
    interview.start();
    Assert.areEqual(true, interview.getVariableValue('output_success'));
    List<skel.ChronoTimeAllocationResult> rows = (List<skel.ChronoTimeAllocationResult>) interview.getVariableValue(
      'output_results'
    );
    Assert.areEqual(2, rows.size());
    Assert.areEqual(7200000L, rows[1].totals[0].allocatedMilliseconds);
    rows[0].totals[0].allocatedMilliseconds = 0;
    Assert.areEqual(7200000L, rows[1].totals[0].allocatedMilliseconds);
  }
  @IsTest
  static void flowLoopReadsPrimitiveFields() {
    Flow.Interview interview = Flow.Interview.createInterview(
      'ChronoAllocationLoopHarness',
      inputs()
    );
    interview.start();
    Assert.areEqual(
      14400000,
      interview.getVariableValue('loopMilliseconds'),
      'Flow loops can access each total field'
    );
  }
  @IsTest
  static void nativeHolidayRecordsAndDateFieldsCrossFlow() {
    Map<String, Object> values = new Map<String, Object>{
      'valueType' => 'PlainDateTime',
      'dateValue' => Date.newInstance(2026, 9, 8),
      'timeValue' => '08:00',
      'endDate' => Date.newInstance(2026, 9, 8),
      'endTime' => '12:00',
      'timeZoneId' => 'Europe/London',
      'holidays' => new List<Holiday>{
        new Holiday(
          ActivityDate = Date.newInstance(2026, 9, 8),
          IsAllDay = true
        )
      },
      'blocksText' => '[{"key":"normal","startTime":"08:00","endTime":"12:00"},{"key":"holiday","dayType":"holiday","startTime":"08:00","endTime":"12:00"}]'
    };
    Flow.Interview interview = Flow.Interview.createInterview(
      'ChronoTimeAllocationHarness',
      values
    );
    interview.start();
    Assert.areEqual(true, interview.getVariableValue('output_success'));
    List<skel.ChronoTimeAllocationRow> rows = (List<skel.ChronoTimeAllocationRow>) interview.getVariableValue(
      'output_totals'
    );
    Assert.areEqual(
      0L,
      rows[0].allocatedMilliseconds,
      'Holiday replaces normal blocks'
    );
    Assert.areEqual(
      14400000L,
      rows[1].allocatedMilliseconds,
      'Unsaved Holiday record survives Flow transport'
    );
  }
  @IsTest
  static void strictErrorsReturnNoPartialAllocationThroughFlow() {
    Map<String, Object> values = inputs();
    values.put(
      'blocksText',
      '[{"key":"one","startTime":"08:00","endTime":"12:00"},{"key":"two","startTime":"09:00","endTime":"12:00"}]'
    );
    Flow.Interview interview = Flow.Interview.createInterview(
      'ChronoTimeAllocationHarness',
      values
    );
    interview.start();
    Assert.areEqual(false, interview.getVariableValue('output_success'));
    Assert.isTrue(
      String.valueOf(interview.getVariableValue('output_errorMessage'))
        .contains('overlapping')
    );
    Assert.isNull(
      interview.getVariableValue('output_totals'),
      'Failed allocations must not expose partial totals'
    );
  }
  @IsTest
  static void nestedFlowLoopsReadCollectionTotals() {
    skel.ChronoTimeAllocationInput input = allocationInput();
    Flow.Interview interview = Flow.Interview.createInterview(
      'ChronoAllocationNestedLoopHarness',
      new Map<String, Object>{
        'items' => new List<skel.ChronoTimeAllocationInput>{ input, input }
      }
    );
    interview.start();
    Assert.areEqual(
      28800000,
      interview.getVariableValue('loopMilliseconds'),
      'Nested Flow loops can read both intervals and all their block totals'
    );
  }
}
