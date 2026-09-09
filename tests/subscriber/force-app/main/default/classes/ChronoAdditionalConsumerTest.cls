// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoAdditionalConsumerTest {
  private static OperatingHours schedule() {
    OperatingHours hours = new OperatingHours(
      Name = 'Subscriber action test',
      TimeZone = 'Europe/London'
    );
    insert hours;
    insert new TimeSlot(
      OperatingHoursId = hours.Id,
      DayOfWeek = 'Monday',
      Type = 'Normal',
      StartTime = Time.newInstance(9, 0, 0, 0),
      EndTime = Time.newInstance(17, 0, 0, 0)
    );
    return hours;
  }
  private static Flow.Interview invoke(
    String name,
    Map<String, Object> inputs
  ) {
    Flow.Interview interview = Flow.Interview.createInterview(name, inputs);
    interview.start();
    Assert.areEqual(
      true,
      interview.getVariableValue('output_success'),
      String.valueOf(interview.getVariableValue('output_errorMessage')) +
      ' action should succeed'
    );
    return interview;
  }
  @IsTest
  static void checkWorkingTimeFlowContracts() {
    OperatingHours hours = schedule();
    Map<String, Object> inputs = new Map<String, Object>{
      'valueType' => 'PlainDate'
    };
    skel.ChronoCheckWorkingTimeInput item = new skel.ChronoCheckWorkingTimeInput();
    item.valueType = 'PlainDate';
    inputs.put('dateValue', Date.newInstance(2026, 9, 7));
    item.dateValue = Date.newInstance(2026, 9, 7);
    inputs.put('operatingHoursId', hours.Id);
    item.operatingHoursId = hours.Id;
    Flow.Interview scalar = invoke('ChronoCheckWorkingTimeHarness', inputs);
    Assert.areEqual(true, scalar.getVariableValue('output_isOpen'));
    Flow.Interview collection = invoke(
      'ChronoCheckWorkingTimeCollectionHarness',
      new Map<String, Object>{
        'items' => new List<skel.ChronoCheckWorkingTimeInput>{ item, item }
      }
    );
    List<skel.ChronoFlowResult> results = (List<skel.ChronoFlowResult>) collection.getVariableValue(
      'output_results'
    );
    Assert.areEqual(2, results.size());
    Assert.areEqual(true, results[1].isOpen);
  }
  @IsTest
  static void findWorkingTimeFlowContracts() {
    OperatingHours hours = schedule();
    Map<String, Object> inputs = new Map<String, Object>{
      'valueType' => 'PlainDate'
    };
    skel.ChronoFindWorkingTimeInput item = new skel.ChronoFindWorkingTimeInput();
    item.valueType = 'PlainDate';
    inputs.put('value', '2026-09-06');
    item.value = '2026-09-06';
    inputs.put('operatingHoursId', hours.Id);
    item.operatingHoursId = hours.Id;
    inputs.put('direction', 'next');
    item.direction = 'next';
    Flow.Interview scalar = invoke('ChronoFindWorkingTimeHarness', inputs);
    Assert.areEqual('2026-09-07', scalar.getVariableValue('output_value'));
    Flow.Interview collection = invoke(
      'ChronoFindWorkingTimeCollectionHarness',
      new Map<String, Object>{
        'items' => new List<skel.ChronoFindWorkingTimeInput>{ item, item }
      }
    );
    List<skel.ChronoFlowResult> results = (List<skel.ChronoFlowResult>) collection.getVariableValue(
      'output_results'
    );
    Assert.areEqual(2, results.size());
    Assert.areEqual('2026-09-07', results[1].value);
  }
  @IsTest
  static void compareFlowContracts() {
    Map<String, Object> inputs = new Map<String, Object>{
      'valueType' => 'Instant'
    };
    skel.ChronoCompareInput item = new skel.ChronoCompareInput();
    item.valueType = 'Instant';
    inputs.put('instantValue', Datetime.newInstanceGmt(2026, 9, 7, 10, 0, 0));
    item.instantValue = Datetime.newInstanceGmt(2026, 9, 7, 10, 0, 0);
    inputs.put('endInstant', Datetime.newInstanceGmt(2026, 9, 7, 11, 0, 0));
    item.endInstant = Datetime.newInstanceGmt(2026, 9, 7, 11, 0, 0);
    Flow.Interview scalar = invoke('ChronoCompareHarness', inputs);
    Assert.areEqual(-1, scalar.getVariableValue('output_comparison'));
    Flow.Interview collection = invoke(
      'ChronoCompareCollectionHarness',
      new Map<String, Object>{
        'items' => new List<skel.ChronoCompareInput>{ item, item }
      }
    );
    List<skel.ChronoFlowResult> results = (List<skel.ChronoFlowResult>) collection.getVariableValue(
      'output_results'
    );
    Assert.areEqual(2, results.size());
    Assert.areEqual(-1, results[1].comparison);
  }
  @IsTest
  static void periodBoundaryFlowContracts() {
    Map<String, Object> inputs = new Map<String, Object>{
      'valueType' => 'PlainDate'
    };
    skel.ChronoPeriodBoundaryInput item = new skel.ChronoPeriodBoundaryInput();
    item.valueType = 'PlainDate';
    inputs.put('dateValue', Date.newInstance(2026, 9, 7));
    item.dateValue = Date.newInstance(2026, 9, 7);
    inputs.put('unit', 'month');
    item.unit = 'month';
    inputs.put('boundary', 'end');
    item.boundary = 'end';
    Flow.Interview scalar = invoke('ChronoPeriodBoundaryHarness', inputs);
    Assert.areEqual('2026-09-30', scalar.getVariableValue('output_value'));
    Flow.Interview collection = invoke(
      'ChronoPeriodBoundaryCollectionHarness',
      new Map<String, Object>{
        'items' => new List<skel.ChronoPeriodBoundaryInput>{ item, item }
      }
    );
    List<skel.ChronoFlowResult> results = (List<skel.ChronoFlowResult>) collection.getVariableValue(
      'output_results'
    );
    Assert.areEqual(2, results.size());
    Assert.areEqual('2026-09-30', results[1].value);
  }
  @IsTest
  static void roundFlowContracts() {
    Map<String, Object> inputs = new Map<String, Object>{
      'valueType' => 'PlainTime'
    };
    skel.ChronoRoundInput item = new skel.ChronoRoundInput();
    item.valueType = 'PlainTime';
    inputs.put('value', '12:37');
    item.value = '12:37';
    inputs.put('unit', 'minute');
    item.unit = 'minute';
    inputs.put('increment', 15);
    item.increment = 15;
    Flow.Interview scalar = invoke('ChronoRoundHarness', inputs);
    Assert.areEqual('12:30:00.000', scalar.getVariableValue('output_value'));
    Flow.Interview collection = invoke(
      'ChronoRoundCollectionHarness',
      new Map<String, Object>{
        'items' => new List<skel.ChronoRoundInput>{ item, item }
      }
    );
    List<skel.ChronoFlowResult> results = (List<skel.ChronoFlowResult>) collection.getVariableValue(
      'output_results'
    );
    Assert.areEqual(2, results.size());
    Assert.areEqual('12:30:00.000', results[1].value);
  }
  @IsTest
  static void resolveLocalFlowContracts() {
    Map<String, Object> inputs = new Map<String, Object>{
      'valueType' => 'PlainDateTime'
    };
    skel.ChronoResolveLocalInput item = new skel.ChronoResolveLocalInput();
    item.valueType = 'PlainDateTime';
    inputs.put('dateValue', Date.newInstance(2026, 10, 25));
    item.dateValue = Date.newInstance(2026, 10, 25);
    inputs.put('timeValue', '01:30');
    item.timeValue = '01:30';
    inputs.put('timeZoneId', 'Europe/London');
    item.timeZoneId = 'Europe/London';
    inputs.put('resolution', 'later');
    item.resolution = 'later';
    Flow.Interview scalar = invoke('ChronoResolveLocalHarness', inputs);
    Assert.areEqual(
      'repeated',
      scalar.getVariableValue('output_resolutionStatus')
    );
    Flow.Interview collection = invoke(
      'ChronoResolveLocalCollectionHarness',
      new Map<String, Object>{
        'items' => new List<skel.ChronoResolveLocalInput>{ item, item }
      }
    );
    List<skel.ChronoFlowResult> results = (List<skel.ChronoFlowResult>) collection.getVariableValue(
      'output_results'
    );
    Assert.areEqual(2, results.size());
    Assert.areEqual('repeated', results[1].resolutionStatus);
  }
  @IsTest
  static void calendarDifferenceFlowContracts() {
    Map<String, Object> inputs = new Map<String, Object>{
      'valueType' => 'PlainDate'
    };
    skel.ChronoCalendarDifferenceInput item = new skel.ChronoCalendarDifferenceInput();
    item.valueType = 'PlainDate';
    inputs.put('dateValue', Date.newInstance(2026, 9, 7));
    item.dateValue = Date.newInstance(2026, 9, 7);
    inputs.put('endDate', Date.newInstance(2026, 9, 8));
    item.endDate = Date.newInstance(2026, 9, 8);
    Flow.Interview scalar = invoke('ChronoCalendarDifferenceHarness', inputs);
    Assert.areEqual(1, scalar.getVariableValue('output_days'));
    Flow.Interview collection = invoke(
      'ChronoCalendarDifferenceCollectionHarness',
      new Map<String, Object>{
        'items' => new List<skel.ChronoCalendarDifferenceInput>{ item, item }
      }
    );
    List<skel.ChronoFlowResult> results = (List<skel.ChronoFlowResult>) collection.getVariableValue(
      'output_results'
    );
    Assert.areEqual(2, results.size());
    Assert.areEqual(1, results[1].days);
  }
  @IsTest
  static void platformBatchesTwoHundredInterviews() {
    OperatingHours hours = schedule();
    List<Map<String, Object>> inputs = new List<Map<String, Object>>();
    for (Integer i = 0; i < 200; i++) {
      inputs.add(
        new Map<String, Object>{
          'valueType' => 'PlainDate',
          'dateValue' => Date.newInstance(2026, 9, 7),
          'operatingHoursId' => String.valueOf(hours.Id)
        }
      );
    }
    String orgNamespace = [SELECT NamespacePrefix FROM Organization LIMIT 1]
    .NamespacePrefix;
    Invocable.Action action = Invocable.Action.createCustomAction(
      'flow',
      orgNamespace,
      'ChronoCheckWorkingTimeHarness'
    );
    action.setInvocations(inputs);
    Test.startTest();
    Integer before = Limits.getQueries();
    List<Invocable.Action.Result> results = action.invoke();
    Integer used = Limits.getQueries() - before;
    Test.stopTest();
    Assert.areEqual(200, results.size());
    for (Invocable.Action.Result result : results) {
      Assert.isTrue(
        result.isSuccess(),
        'Platform errors: ' + JSON.serialize(result.getErrors())
      );
      Assert.areEqual(true, result.getOutputParameters().get('output_isOpen'));
    }
    // The subscriber caller's counter does not expose skel's queries. The
    // package tests assert the exact three-query load inside that namespace.
    if (orgNamespace == 'skel') {
      Assert.areEqual(
        3,
        used,
        'All Flow interviews share one user-mode schedule load'
      );
    } else {
      Assert.isTrue(
        used <= 3,
        'Batch does not add per-interview subscriber queries'
      );
    }
  }
}
