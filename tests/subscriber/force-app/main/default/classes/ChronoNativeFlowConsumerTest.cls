// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoNativeFlowConsumerTest {
  private static OperatingHours hours() {
    return new OperatingHours(
      Name = 'London weekdays',
      TimeZone = 'Europe/London'
    );
  }
  private static List<TimeSlot> slots() {
    List<TimeSlot> result = new List<TimeSlot>();
    for (
      String day : new List<String>{
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday'
      }
    ) {
      result.add(
        new TimeSlot(
          DayOfWeek = day,
          Type = 'Normal',
          StartTime = Time.newInstance(9, 0, 0, 0),
          EndTime = Time.newInstance(17, 0, 0, 0)
        )
      );
    }
    return result;
  }
  private static List<Holiday> holidays() {
    return new List<Holiday>{
      new Holiday(
        Name = 'Bank holiday',
        ActivityDate = Date.newInstance(2026, 8, 31),
        IsAllDay = true
      )
    };
  }
  private static skel.ChronoWorkingTimeInput addInput() {
    skel.ChronoWorkingTimeInput input = new skel.ChronoWorkingTimeInput();
    input.startValue = '2026-08-28T16:30';
    input.timeZoneId = 'Europe/London';
    input.scheduleType = 'OperatingHours';
    input.operatingHours = hours();
    input.timeSlots = slots();
    input.holidays = holidays();
    input.amount = 1;
    input.unit = 'hours';
    return input;
  }
  private static skel.ChronoDifferenceInput difference(
    String start,
    String finish
  ) {
    skel.ChronoDifferenceInput input = new skel.ChronoDifferenceInput();
    input.startValue = start;
    input.endValue = finish;
    input.timeZoneId = 'Europe/London';
    return input;
  }
  @IsTest
  static void nativeRecordsCrossActualFlowActionBoundary() {
    for (
      String family : new List<String>{
        'WorkingTime',
        'Difference',
        'CheckWorkingTime',
        'FindWorkingTime'
      }
    ) {
      Map<String, Object> inputs = flowInputs(family);
      Flow.Interview interview = Flow.Interview.createInterview(
        'ChronoNative' + family + 'Harness',
        inputs
      );
      interview.start();
      Assert.areEqual(
        true,
        interview.getVariableValue('success'),
        'Flow ' + family + ': ' + interview.getVariableValue('errorMessage')
      );
      verifyFlow(family, interview);
    }
  }
  private static Map<String, Object> flowInputs(String family) {
    Map<String, Object> inputs = new Map<String, Object>{
      'operatingHours' => hours(),
      'timeSlots' => slots(),
      'holidays' => holidays()
    };
    if (family == 'WorkingTime' || family == 'Difference') {
      inputs.put('startDate', Date.newInstance(2026, 8, 28));
      inputs.put('startTime', '16:30');
      inputs.put('timeZoneId', 'Europe/London');
      if (family == 'Difference') {
        inputs.put('endDate', Date.newInstance(2026, 9, 1));
        inputs.put('endTime', '09:30');
      }
    } else {
      inputs.put('dateValue', Date.newInstance(2026, 8, 31));
    }
    return inputs;
  }
  private static void verifyFlow(String family, Flow.Interview interview) {
    if (family == 'WorkingTime') {
      Assert.areEqual(
        Datetime.newInstanceGmt(2026, 9, 1, 8, 30, 0),
        interview.getVariableValue('instantValue')
      );
    }
    if (family == 'Difference') {
      Assert.areEqual(3600000, interview.getVariableValue('milliseconds'));
    }
    if (family == 'CheckWorkingTime') {
      Assert.areEqual(false, interview.getVariableValue('isOpen'));
    }
    if (family == 'FindWorkingTime') {
      Assert.areEqual(
        Date.newInstance(2026, 9, 1),
        interview.getVariableValue('dateResult')
      );
    }
  }

  private static List<skel.ChronoFlowResult> collectionFlow(
    String family,
    Object items
  ) {
    Flow.Interview flow = Flow.Interview.createInterview(
      'Chrono' + family + 'CollectionHarness',
      new Map<String, Object>{ 'items' => items }
    );
    flow.start();
    String resultName = (family == 'WorkingTime' ||
      family == 'Difference')
      ? 'results'
      : 'output_results';
    List<skel.ChronoFlowResult> rows = (List<skel.ChronoFlowResult>) flow.getVariableValue(
      resultName
    );
    Assert.areEqual(2, rows.size());
    for (skel.ChronoFlowResult row : rows) {
      Assert.isTrue(row.success, 'Flow ' + family + ': ' + row.errorMessage);
    }
    return rows;
  }
  @IsTest
  static void collectionFlowsCarryNativeSchedulesAndDates() {
    List<skel.ChronoFlowResult> added = collectionFlow(
      'WorkingTime',
      new List<skel.ChronoWorkingTimeInput>{ addInput(), addInput() }
    );
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 9, 1, 8, 30, 0),
      added[1].instantValue
    );
    skel.ChronoDifferenceInput input = difference(null, null);
    input.startDate = Date.newInstance(2026, 8, 28);
    input.startTime = '16:30';
    input.endDate = Date.newInstance(2026, 9, 1);
    input.endTime = '09:30';
    input.operatingHours = hours();
    input.timeSlots = slots();
    input.holidays = holidays();
    List<skel.ChronoFlowResult> elapsed = collectionFlow(
      'Difference',
      new List<skel.ChronoDifferenceInput>{ input, input }
    );
    Assert.areEqual(3600000L, elapsed[1].milliseconds);
    elapsed[0].milliseconds = 0;
    Assert.areEqual(3600000L, elapsed[1].milliseconds);
  }
  @IsTest
  static void collectionCheckAndFindUseNativeRecords() {
    skel.ChronoCheckWorkingTimeInput check = new skel.ChronoCheckWorkingTimeInput();
    check.valueType = 'PlainDate';
    check.value = '2026-08-31';
    check.operatingHours = hours();
    check.timeSlots = slots();
    check.holidays = holidays();
    List<skel.ChronoFlowResult> checked = collectionFlow(
      'CheckWorkingTime',
      new List<skel.ChronoCheckWorkingTimeInput>{ check, check }
    );
    Assert.isFalse(checked[1].isOpen);
    skel.ChronoFindWorkingTimeInput find = new skel.ChronoFindWorkingTimeInput();
    find.valueType = check.valueType;
    find.value = check.value;
    find.direction = 'next';
    find.operatingHours = hours();
    find.timeSlots = slots();
    find.holidays = holidays();
    List<skel.ChronoFlowResult> found = collectionFlow(
      'FindWorkingTime',
      new List<skel.ChronoFindWorkingTimeInput>{ find, find }
    );
    Assert.areEqual(Date.newInstance(2026, 9, 1), found[1].dateValue);
  }
  @IsTest
  static void flowDifferenceUsesSeparateEndZoneAndOccurrence() {
    Map<String, Object> inputs = flowInputs('Difference');
    inputs.put('startDate', Date.newInstance(2026, 9, 7));
    inputs.put('endDate', Date.newInstance(2026, 9, 7));
    inputs.put('startTime', '09:00');
    inputs.put('endTime', '09:00');
    inputs.put('endTimeZoneId', 'America/New_York');
    Flow.Interview zones = Flow.Interview.createInterview(
      'ChronoNativeDifferenceHarness',
      inputs
    );
    zones.start();
    Assert.areEqual(
      true,
      zones.getVariableValue('success'),
      'Separate zones: ' + zones.getVariableValue('errorMessage')
    );
    Assert.areEqual(5 * 3600000, zones.getVariableValue('milliseconds'));
    inputs.put('startDate', Date.newInstance(2026, 10, 25));
    inputs.put('endDate', Date.newInstance(2026, 10, 25));
    inputs.put('startTime', '01:30');
    inputs.put('endTime', '01:30');
    inputs.put('endTimeZoneId', 'Europe/London');
    inputs.put('disambiguation', 'earlier');
    inputs.put('endDisambiguation', 'later');
    inputs.put(
      'timeSlots',
      new List<TimeSlot>{
        new TimeSlot(
          DayOfWeek = 'Sunday',
          Type = 'Normal',
          StartTime = Time.newInstance(0, 0, 0, 0),
          EndTime = Time.newInstance(4, 0, 0, 0)
        )
      }
    );
    Flow.Interview repeated = Flow.Interview.createInterview(
      'ChronoNativeDifferenceHarness',
      inputs
    );
    repeated.start();
    Assert.areEqual(
      true,
      repeated.getVariableValue('success'),
      'Repeated hour: ' + repeated.getVariableValue('errorMessage')
    );
    Assert.areEqual(3600000, repeated.getVariableValue('milliseconds'));
  }
}
