// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
@SuppressWarnings(
  'PMD.ApexUnitTestClassShouldHaveAsserts'
) // Every test uses the centralised Flow output assertions below.
private class ChronoCatalogueConsumerTest {
  private static Flow.Interview invoke(
    String name,
    Map<String, Object> inputs
  ) {
    Flow.Interview interview = Flow.Interview.createInterview(name, inputs);
    interview.start();
    Assert.areEqual(
      true,
      interview.getVariableValue('output_success'),
      name +
        ' action error: ' +
        String.valueOf(interview.getVariableValue('output_errorMessage'))
    );
    return interview;
  }
  private static void check(
    Flow.Interview interview,
    String field,
    Object expected
  ) {
    Object actual = JSON.deserializeUntyped(
      JSON.serialize(interview.getVariableValue('output_' + field))
    );
    Assert.areEqual(expected, actual, 'Subscriber Flow output ' + field);
  }
  private static Object collection(String family, Object items) {
    return invoke(
        'Chrono' + family + 'CollectionHarness',
        new Map<String, Object>{ 'items' => items }
      )
      .getVariableValue('output_results');
  }
  private static void checkCollectionValue(
    Boolean success,
    Object actual,
    Object expected
  ) {
    Assert.isTrue(success, 'Collection item should succeed');
    Assert.areEqual(
      expected,
      JSON.deserializeUntyped(JSON.serialize(actual)),
      'Collection primitive output'
    );
  }
  @IsTest
  static void createValueFlowContracts() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"valueType":"PlainDate","year":2026,"month":9,"day":7}'
    );
    Object expected = JSON.deserializeUntyped('"2026-09-07"');
    skel.ChronoCreateValueInput item = new skel.ChronoCreateValueInput();
    item.valueType = (String) inputs.get('valueType');
    item.year = Integer.valueOf(String.valueOf(inputs.get('year')));
    item.month = Integer.valueOf(String.valueOf(inputs.get('month')));
    item.day = Integer.valueOf(String.valueOf(inputs.get('day')));
    check(invoke('ChronoCreateValueHarness', inputs), 'value', expected);
    List<skel.ChronoFlowResult> rows = (List<skel.ChronoFlowResult>) collection(
      'CreateValue',
      new List<skel.ChronoCreateValueInput>{ item, item }
    );
    Assert.areEqual(2, rows.size(), 'Both collection entries cross Flow');
    for (skel.ChronoFlowResult row : rows) {
      checkCollectionValue(row.success, row.value, expected);
    }
  }
  @IsTest
  static void replaceValueFlowContracts() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"valueType":"PlainDate","value":"2026-01-31","month":2,"overflow":"constrain"}'
    );
    Object expected = JSON.deserializeUntyped('"2026-02-28"');
    skel.ChronoReplaceValueInput item = new skel.ChronoReplaceValueInput();
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    item.month = Integer.valueOf(String.valueOf(inputs.get('month')));
    item.overflow = (String) inputs.get('overflow');
    check(invoke('ChronoReplaceValueHarness', inputs), 'value', expected);
    List<skel.ChronoFlowResult> rows = (List<skel.ChronoFlowResult>) collection(
      'ReplaceValue',
      new List<skel.ChronoReplaceValueInput>{ item, item }
    );
    Assert.areEqual(2, rows.size(), 'Both collection entries cross Flow');
    for (skel.ChronoFlowResult row : rows) {
      checkCollectionValue(row.success, row.value, expected);
    }
  }
  @IsTest
  static void validateValueFlowContracts() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"valueType":"PlainDate","value":"2026-02-30"}'
    );
    Object expected = JSON.deserializeUntyped('false');
    skel.ChronoValidateValueInput item = new skel.ChronoValidateValueInput();
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    check(invoke('ChronoValidateValueHarness', inputs), 'isValid', expected);
    List<skel.ChronoValidationResult> rows = (List<skel.ChronoValidationResult>) collection(
      'ValidateValue',
      new List<skel.ChronoValidateValueInput>{ item, item }
    );
    Assert.areEqual(2, rows.size(), 'Both collection entries cross Flow');
    for (skel.ChronoValidationResult row : rows) {
      checkCollectionValue(row.success, row.isValid, expected);
    }
  }
  @IsTest
  static void parseValueFlowContracts() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"valueType":"PlainDate","text":"03/04/2026","pattern":"dd/MM/yyyy"}'
    );
    Object expected = JSON.deserializeUntyped('"2026-04-03"');
    skel.ChronoParseValueInput item = new skel.ChronoParseValueInput();
    item.valueType = (String) inputs.get('valueType');
    item.text = (String) inputs.get('text');
    item.pattern = (String) inputs.get('pattern');
    check(invoke('ChronoParseValueHarness', inputs), 'value', expected);
    List<skel.ChronoFlowResult> rows = (List<skel.ChronoFlowResult>) collection(
      'ParseValue',
      new List<skel.ChronoParseValueInput>{ item, item }
    );
    Assert.areEqual(2, rows.size(), 'Both collection entries cross Flow');
    for (skel.ChronoFlowResult row : rows) {
      checkCollectionValue(row.success, row.value, expected);
    }
  }
  @IsTest
  static void epochValueFlowContracts() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"operation":"fromEpoch","epochValue":0,"epochUnit":"millisecond"}'
    );
    Object expected = JSON.deserializeUntyped('"1970-01-01T00:00:00.000Z"');
    skel.ChronoEpochValueInput item = new skel.ChronoEpochValueInput();
    item.operation = (String) inputs.get('operation');
    item.epochValue = Decimal.valueOf(String.valueOf(inputs.get('epochValue')));
    item.epochUnit = (String) inputs.get('epochUnit');
    check(invoke('ChronoEpochValueHarness', inputs), 'value', expected);
    List<skel.ChronoEpochResult> rows = (List<skel.ChronoEpochResult>) collection(
      'EpochValue',
      new List<skel.ChronoEpochValueInput>{ item, item }
    );
    Assert.areEqual(2, rows.size(), 'Both collection entries cross Flow');
    for (skel.ChronoEpochResult row : rows) {
      checkCollectionValue(row.success, row.value, expected);
    }
  }
  @IsTest
  static void valueDetailsFlowContracts() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"valueType":"PlainDate","value":"2026-09-07"}'
    );
    Object expected = JSON.deserializeUntyped('1');
    skel.ChronoValueDetailsInput item = new skel.ChronoValueDetailsInput();
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    check(invoke('ChronoValueDetailsHarness', inputs), 'dayOfWeek', expected);
    List<skel.ChronoDetailsResult> rows = (List<skel.ChronoDetailsResult>) collection(
      'ValueDetails',
      new List<skel.ChronoValueDetailsInput>{ item, item }
    );
    Assert.areEqual(2, rows.size(), 'Both collection entries cross Flow');
    for (skel.ChronoDetailsResult row : rows) {
      checkCollectionValue(row.success, row.dayOfWeek, expected);
    }
  }
  @IsTest
  static void durationToolsFlowContracts() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"operation":"total","value":"PT90M","unit":"minute"}'
    );
    Object expected = JSON.deserializeUntyped('90');
    skel.ChronoDurationToolsInput item = new skel.ChronoDurationToolsInput();
    item.operation = (String) inputs.get('operation');
    item.value = (String) inputs.get('value');
    item.unit = (String) inputs.get('unit');
    check(invoke('ChronoDurationToolsHarness', inputs), 'total', expected);
    List<skel.ChronoDurationResult> rows = (List<skel.ChronoDurationResult>) collection(
      'DurationTools',
      new List<skel.ChronoDurationToolsInput>{ item, item }
    );
    Assert.areEqual(2, rows.size(), 'Both collection entries cross Flow');
    for (skel.ChronoDurationResult row : rows) {
      checkCollectionValue(row.success, row.total, expected);
    }
  }
  @IsTest
  static void zoneToolsFlowContracts() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"operation":"details","valueType":"ZonedDateTime","value":"2026-09-07T09:00+01:00[Europe/London]"}'
    );
    Object expected = JSON.deserializeUntyped('3600');
    skel.ChronoZoneToolsInput item = new skel.ChronoZoneToolsInput();
    item.operation = (String) inputs.get('operation');
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    check(invoke('ChronoZoneToolsHarness', inputs), 'offsetSeconds', expected);
    List<skel.ChronoZoneResult> rows = (List<skel.ChronoZoneResult>) collection(
      'ZoneTools',
      new List<skel.ChronoZoneToolsInput>{ item, item }
    );
    Assert.areEqual(2, rows.size(), 'Both collection entries cross Flow');
    for (skel.ChronoZoneResult row : rows) {
      checkCollectionValue(row.success, row.offsetSeconds, expected);
    }
  }
  @IsTest
  static void rangeToolsFlowContracts() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"operation":"subtract","valueType":"PlainDate","value":"2026-01-01","endValue":"2026-01-05","rangesText":"2026-01-02/2026-01-03"}'
    );
    Object expected = JSON.deserializeUntyped(
      '["2026-01-01/2026-01-02","2026-01-03/2026-01-05"]'
    );
    skel.ChronoRangeToolsInput item = new skel.ChronoRangeToolsInput();
    item.operation = (String) inputs.get('operation');
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    item.endValue = (String) inputs.get('endValue');
    item.rangesText = (String) inputs.get('rangesText');
    check(invoke('ChronoRangeToolsHarness', inputs), 'ranges', expected);
    List<skel.ChronoRangeResult> rows = (List<skel.ChronoRangeResult>) collection(
      'RangeTools',
      new List<skel.ChronoRangeToolsInput>{ item, item }
    );
    Assert.areEqual(2, rows.size(), 'Both collection entries cross Flow');
    for (skel.ChronoRangeResult row : rows) {
      checkCollectionValue(row.success, row.ranges, expected);
    }
  }
  @IsTest
  static void availabilityFlowContracts() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"operation":"windows","valueType":"ZonedDateTime","value":"2026-09-07T09:00+01:00[Europe/London]","endValue":"2026-09-07T10:00+01:00[Europe/London]"}'
    );
    Object expected = JSON.deserializeUntyped('3600000');
    skel.ChronoAvailabilityInput item = new skel.ChronoAvailabilityInput();
    item.operation = (String) inputs.get('operation');
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    item.endValue = (String) inputs.get('endValue');
    item.operatingHours = new OperatingHours(TimeZone = 'Europe/London');
    item.timeSlots = new List<TimeSlot>{
      new TimeSlot(
        DayOfWeek = 'Monday',
        StartTime = Time.newInstance(9, 0, 0, 0),
        EndTime = Time.newInstance(17, 0, 0, 0)
      )
    };
    inputs.put('operatingHours', item.operatingHours);
    inputs.put('timeSlots', item.timeSlots);
    check(
      invoke('ChronoAvailabilityHarness', inputs),
      'milliseconds',
      expected
    );
    List<skel.ChronoAvailabilityResult> rows = (List<skel.ChronoAvailabilityResult>) collection(
      'Availability',
      new List<skel.ChronoAvailabilityInput>{ item, item }
    );
    Assert.areEqual(2, rows.size(), 'Both collection entries cross Flow');
    for (skel.ChronoAvailabilityResult row : rows) {
      checkCollectionValue(row.success, row.milliseconds, expected);
    }
  }
  @IsTest
  static void collectionToolsFlowContracts() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"operation":"sort","valueType":"PlainDate","valuesText":"2026-01-02\\n2026-01-01"}'
    );
    Object expected = JSON.deserializeUntyped('["2026-01-01","2026-01-02"]');
    skel.ChronoCollectionToolsInput item = new skel.ChronoCollectionToolsInput();
    item.operation = (String) inputs.get('operation');
    item.valueType = (String) inputs.get('valueType');
    item.valuesText = (String) inputs.get('valuesText');
    check(invoke('ChronoCollectionToolsHarness', inputs), 'values', expected);
    List<skel.ChronoValuesResult> rows = (List<skel.ChronoValuesResult>) collection(
      'CollectionTools',
      new List<skel.ChronoCollectionToolsInput>{ item, item }
    );
    Assert.areEqual(2, rows.size(), 'Both collection entries cross Flow');
    for (skel.ChronoValuesResult row : rows) {
      checkCollectionValue(row.success, row.values, expected);
    }
  }
  @IsTest
  static void fiscalPeriodFlowContracts() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"calendarSource":"monthBased","period":"quarter","startMonth":4,"valueType":"PlainDate","value":"2026-02-02"}'
    );
    Object expected = JSON.deserializeUntyped('4');
    skel.ChronoFiscalPeriodInput item = new skel.ChronoFiscalPeriodInput();
    item.calendarSource = (String) inputs.get('calendarSource');
    item.period = (String) inputs.get('period');
    item.startMonth = Integer.valueOf(String.valueOf(inputs.get('startMonth')));
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    Flow.Interview fiscal = invoke('ChronoFiscalPeriodHarness', inputs);
    check(fiscal, 'periodNumber', expected);
    // Flow.Interview serialises native Date outputs as UTC midnight.
    check(fiscal, 'lastDate', '2026-03-31T00:00:00.000Z');
    check(fiscal, 'endExclusiveDate', '2026-04-01T00:00:00.000Z');
    check(fiscal, 'endExclusiveValue', '2026-04-01');
    List<skel.ChronoFiscalResult> rows = (List<skel.ChronoFiscalResult>) collection(
      'FiscalPeriod',
      new List<skel.ChronoFiscalPeriodInput>{ item, item }
    );
    Assert.areEqual(2, rows.size(), 'Both collection entries cross Flow');
    for (skel.ChronoFiscalResult row : rows) {
      checkCollectionValue(row.success, row.periodNumber, expected);
      Assert.areEqual(Date.newInstance(2026, 3, 31), row.lastDate);
      Assert.areEqual(Date.newInstance(2026, 4, 1), row.endExclusiveDate);
      Assert.areEqual('2026-04-01', row.endExclusiveValue);
    }
  }
  @IsTest
  static void recurrenceFlowContracts() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"operation":"weekday","valueType":"PlainDate","value":"2026-09-07","weekday":2}'
    );
    Object expected = JSON.deserializeUntyped('"2026-09-08"');
    skel.ChronoRecurrenceInput item = new skel.ChronoRecurrenceInput();
    item.operation = (String) inputs.get('operation');
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    item.weekday = Integer.valueOf(String.valueOf(inputs.get('weekday')));
    check(invoke('ChronoRecurrenceHarness', inputs), 'value', expected);
    List<skel.ChronoRecurrenceResult> rows = (List<skel.ChronoRecurrenceResult>) collection(
      'Recurrence',
      new List<skel.ChronoRecurrenceInput>{ item, item }
    );
    Assert.areEqual(2, rows.size(), 'Both collection entries cross Flow');
    for (skel.ChronoRecurrenceResult row : rows) {
      checkCollectionValue(row.success, row.value, expected);
    }
  }
  @IsTest
  static void formatValueFlowContracts() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"operation":"value","valueType":"PlainDate","value":"2026-09-07","pattern":"yyyy-MM-dd"}'
    );
    Object expected = JSON.deserializeUntyped('"2026-09-07"');
    skel.ChronoFormatValueInput item = new skel.ChronoFormatValueInput();
    item.operation = (String) inputs.get('operation');
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    item.pattern = (String) inputs.get('pattern');
    check(invoke('ChronoFormatValueHarness', inputs), 'text', expected);
    List<skel.ChronoFormatResult> rows = (List<skel.ChronoFormatResult>) collection(
      'FormatValue',
      new List<skel.ChronoFormatValueInput>{ item, item }
    );
    Assert.areEqual(2, rows.size(), 'Both collection entries cross Flow');
    for (skel.ChronoFormatResult row : rows) {
      checkCollectionValue(row.success, row.text, expected);
    }
  }
  @IsTest
  static void nativeAuxiliaryResourcesCrossFlow() {
    check(
      invoke(
        'ChronoRangeToolsHarness',
        new Map<String, Object>{
          'operation' => 'contains',
          'valueType' => 'PlainDate',
          'dateValue' => Date.newInstance(2026, 1, 1),
          'endDate' => Date.newInstance(2026, 2, 1),
          'pointDate' => Date.newInstance(2026, 1, 15)
        }
      ),
      'containsValue',
      true
    );
    check(
      invoke(
        'ChronoFormatValueHarness',
        new Map<String, Object>{
          'operation' => 'relative',
          'valueType' => 'ZonedDateTime',
          'value' => '2026-03-29T12:00+01:00[Europe/London]',
          'referenceInstant' => Datetime.newInstanceGmt(2026, 3, 29, 10, 0, 0)
        }
      ),
      'text',
      'in 1 hour'
    );
    check(
      invoke(
        'ChronoCollectionToolsHarness',
        new Map<String, Object>{
          'operation' => 'filter',
          'valueType' => 'PlainDate',
          'dates' => new List<Date>{
            Date.newInstance(2026, 1, 1),
            Date.newInstance(2026, 1, 15)
          },
          'lowerDate' => Date.newInstance(2026, 1, 10)
        }
      ),
      'values',
      new List<Object>{ '2026-01-15' }
    );
  }
}
