// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoFlowConsumerTest {
  @TestSetup
  static void holiday() {
    insert new Holiday(
      Name = 'Chrono consumer bank holiday',
      ActivityDate = Date.newInstance(2026, 8, 31),
      IsAllDay = true
    );
  }
  private static Flow.Interview start(
    String flowName,
    Map<String, Object> inputs
  ) {
    String orgNamespace = [SELECT NamespacePrefix FROM Organization LIMIT 1]
    .NamespacePrefix;
    Flow.Interview interview = Flow.Interview.createInterview(
      orgNamespace,
      flowName,
      inputs
    );
    interview.start();
    return interview;
  }
  private static void assertSuccess(Flow.Interview interview) {
    Assert.areEqual(
      true,
      interview.getVariableValue('success'),
      'Flow item error: ' + interview.getVariableValue('errorMessage')
    );
  }
  @IsTest
  static void scalarFlowsExecuteAcrossPackageBoundary() {
    Test.startTest();
    Flow.Interview conversion = start(
      'ChronoConvertHarness',
      new Map<String, Object>{
        'valueType' => 'PlainDateTime',
        'value' => '2026-09-01T09:30',
        'targetType' => 'ZonedDateTime',
        'timeZoneId' => 'Europe/London'
      }
    );
    assertSuccess(conversion);
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 9, 1, 8, 30, 0),
      conversion.getVariableValue('datetimeResult'),
      'Real Flow returns native datetime'
    );
    Flow.Interview adjustment = start(
      'ChronoAdjustHarness',
      new Map<String, Object>{
        'valueType' => 'PlainDate',
        'value' => '2026-01-31',
        'amount' => 1,
        'unit' => 'months'
      }
    );
    assertSuccess(adjustment);
    Assert.areEqual(
      '2026-02-28',
      adjustment.getVariableValue('valueResult'),
      'Real Flow arithmetic'
    );
    Flow.Interview difference = start(
      'ChronoDifferenceHarness',
      new Map<String, Object>{
        'startValue' => '2026-09-01T08:30Z',
        'endValue' => '2026-09-01T09:30Z'
      }
    );
    assertSuccess(difference);
    Assert.areEqual(
      3600000,
      difference.getVariableValue('milliseconds'),
      'Real Flow duration output'
    );
    Test.stopTest();
  }
  @IsTest
  static void typedCollectionsRoundTripThroughFlow() {
    skel.ChronoTimeZonePicklist picker = new skel.ChronoTimeZonePicklist();
    Assert.isTrue(
      picker.getValues().size() > 100,
      'Global configuration helper works from subscriber Apex'
    );
    Assert.areEqual(
      '',
      picker.getDefaultValue().getValue(),
      'Zone choice is explicit'
    );
    skel.ChronoConvertInput dateInput = new skel.ChronoConvertInput();
    dateInput.valueType = 'PlainDate';
    dateInput.value = '2026-09-01';
    skel.ChronoConvertInput durationInput = new skel.ChronoConvertInput();
    durationInput.valueType = 'Duration';
    durationInput.value = 'PT720H';
    Test.startTest();
    Flow.Interview conversion = start(
      'ChronoConvertCollectionHarness',
      new Map<String, Object>{
        'items' => new List<skel.ChronoConvertInput>{ dateInput, durationInput }
      }
    );
    assertSuccess(conversion);
    List<skel.ChronoFlowResult> converted = (List<skel.ChronoFlowResult>) conversion.getVariableValue(
      'results'
    );
    Assert.areEqual(2, converted.size(), 'Flow collection cardinality');
    Assert.areEqual('PlainDate', converted[0].valueType, 'First type');
    Assert.areEqual(
      2592000000L,
      converted[1].milliseconds,
      'Long field survives Apex-defined transport'
    );
    skel.ChronoAdjustInput adjustmentInput = new skel.ChronoAdjustInput();
    adjustmentInput.valueType = 'PlainTime';
    adjustmentInput.value = '23:30';
    adjustmentInput.amount = 1;
    adjustmentInput.unit = 'hours';
    Flow.Interview adjustment = start(
      'ChronoAdjustCollectionHarness',
      new Map<String, Object>{
        'items' => new List<skel.ChronoAdjustInput>{ adjustmentInput }
      }
    );
    assertSuccess(adjustment);
    Assert.areEqual(
      '00:30:00.000',
      ((List<skel.ChronoFlowResult>) adjustment.getVariableValue('results'))[0]
        .value,
      'Typed adjustment collection'
    );
    skel.ChronoDifferenceInput differenceInput = new skel.ChronoDifferenceInput();
    differenceInput.startValue = '2026-09-01T09:30Z';
    differenceInput.endValue = '2026-09-01T08:30Z';
    Flow.Interview difference = start(
      'ChronoDifferenceCollectionHarness',
      new Map<String, Object>{
        'items' => new List<skel.ChronoDifferenceInput>{ differenceInput }
      }
    );
    assertSuccess(difference);
    Assert.areEqual(
      -3600000L,
      ((List<skel.ChronoFlowResult>) difference.getVariableValue('results'))[0]
        .milliseconds,
      'Typed negative difference'
    );
    Test.stopTest();
  }
  @IsTest
  static void operatingHoursFlowsSkipWeekendAndBankHoliday() {
    OperatingHours hours = new OperatingHours(
      Name = 'Chrono consumer weekdays',
      TimeZone = 'Europe/London'
    );
    insert hours;
    List<TimeSlot> slots = new List<TimeSlot>();
    for (
      String day : new List<String>{
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday'
      }
    ) {
      slots.add(
        new TimeSlot(
          OperatingHoursId = hours.Id,
          DayOfWeek = day,
          Type = 'Normal',
          StartTime = Time.newInstance(9, 0, 0, 0),
          EndTime = Time.newInstance(17, 0, 0, 0)
        )
      );
    }
    insert slots;
    Holiday bank = [
      SELECT Id
      FROM Holiday
      WHERE Name = 'Chrono consumer bank holiday'
    ];
    insert new OperatingHoursHoliday(
      OperatingHoursId = hours.Id,
      HolidayId = bank.Id
    );
    Map<String, Object> inputs = new Map<String, Object>{
      'startValue' => '2026-08-28T16:30+01:00[Europe/London]',
      'timeZoneId' => 'Europe/London',
      'amount' => 1,
      'unit' => 'hours',
      'scheduleType' => 'OperatingHours',
      'scheduleId' => String.valueOf(hours.Id)
    };
    Test.startTest();
    Flow.Interview scalar = start('ChronoWorkingTimeHarness', inputs);
    assertSuccess(scalar);
    Assert.areEqual(
      '2026-09-01T09:30:00.000+01:00[Europe/London]',
      scalar.getVariableValue('valueResult'),
      'Actual Flow acceptance example'
    );
    skel.ChronoWorkingTimeInput item = new skel.ChronoWorkingTimeInput();
    item.startValue = (String) inputs.get('startValue');
    item.timeZoneId = (String) inputs.get('timeZoneId');
    item.amount = 1;
    item.unit = 'hours';
    item.scheduleType = 'OperatingHours';
    item.scheduleId = String.valueOf(hours.Id);
    Flow.Interview collection = start(
      'ChronoWorkingTimeCollectionHarness',
      new Map<String, Object>{
        'items' => new List<skel.ChronoWorkingTimeInput>{ item, item }
      }
    );
    assertSuccess(collection);
    List<skel.ChronoFlowResult> results = (List<skel.ChronoFlowResult>) collection.getVariableValue(
      'results'
    );
    Assert.areEqual(2, results.size(), 'Working collection output');
    Assert.areEqual(
      scalar.getVariableValue('datetimeResult'),
      results[1].instantValue,
      'Scalar and collection agree'
    );
    Test.stopTest();
  }
  @IsTest
  static void flowRuntimeBatchesTwoHundredInterviews() {
    String orgNamespace = [SELECT NamespacePrefix FROM Organization LIMIT 1]
    .NamespacePrefix;
    Invocable.Action action = Invocable.Action.createCustomAction(
      'flow',
      orgNamespace,
      'ChronoConvertHarness'
    );
    List<Map<String, Object>> inputs = new List<Map<String, Object>>();
    for (Integer i = 0; i < 200; i++) {
      inputs.add(
        new Map<String, Object>{
          'valueType' => 'PlainDate',
          'value' => Math.mod(i, 2) == 0 ? '2026-09-01' : '2026-09-02'
        }
      );
    }
    action.setInvocations(inputs);
    Test.startTest();
    List<Invocable.Action.Result> results = action.invoke();
    Test.stopTest();
    Assert.areEqual(200, results.size(), 'Platform invocation cardinality');
    for (Integer i = 0; i < results.size(); i++) {
      Assert.isTrue(
        results[i].isSuccess(),
        'Platform action errors: ' + JSON.serialize(results[i].getErrors())
      );
      Assert.areEqual(
        true,
        results[i].getOutputParameters().get('success'),
        'Item succeeded'
      );
      Assert.areEqual(
        inputs[i].get('value'),
        results[i].getOutputParameters().get('valueResult'),
        'Interview order preserved'
      );
    }
  }
  @IsTest
  static void invalidCollectionItemDoesNotLoseSiblings() {
    skel.ChronoConvertInput good = new skel.ChronoConvertInput();
    good.valueType = 'PlainDate';
    good.value = '2026-09-01';
    skel.ChronoConvertInput bad = new skel.ChronoConvertInput();
    bad.valueType = 'PlainDate';
    bad.value = '2026-02-30';
    Test.startTest();
    Flow.Interview interview = start(
      'ChronoConvertCollectionHarness',
      new Map<String, Object>{
        'items' => new List<skel.ChronoConvertInput>{ good, bad, good }
      }
    );
    Test.stopTest();
    Assert.areEqual(
      false,
      interview.getVariableValue('success'),
      'Collection reports item failure'
    );
    List<skel.ChronoFlowResult> results = (List<skel.ChronoFlowResult>) interview.getVariableValue(
      'results'
    );
    Assert.areEqual(3, results.size(), 'Failed item retains position');
    Assert.isTrue(results[0].success, 'First succeeds');
    Assert.isFalse(results[1].success, 'Invalid calendar date rejected');
    Assert.isTrue(results[2].success, 'Last succeeds');
  }
}
