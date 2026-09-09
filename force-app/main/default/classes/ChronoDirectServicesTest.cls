// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoDirectServicesTest {
  @IsTest
  static void createValueDirectApex() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"valueType":"PlainDate","year":2026,"month":9,"day":7}'
    );
    Object expected = JSON.deserializeUntyped('"2026-09-07"');
    ChronoCreateValueInput item = new ChronoCreateValueInput();
    item.valueType = (String) inputs.get('valueType');
    item.year = Integer.valueOf(String.valueOf(inputs.get('year')));
    item.month = Integer.valueOf(String.valueOf(inputs.get('month')));
    item.day = Integer.valueOf(String.valueOf(inputs.get('day')));

    Test.startTest();
    Integer queries = Limits.getQueries();
    List<ChronoValueResult> rows = ChronoValueService.create(
      new List<ChronoCreateValueInput>{ item, item, null }
    );
    Assert.areEqual(
      queries,
      Limits.getQueries(),
      'This supplied-data calculation does not query'
    );
    Test.stopTest();
    Assert.areEqual(3, rows.size());
    for (Integer i = 0; i < 2; i++) {
      Assert.isTrue(rows[i].success, 'Item ' + i + ': ' + rows[i].errorMessage);
      Assert.areEqual(
        expected,
        JSON.deserializeUntyped(
          JSON.serialize(
            ChronoPlainDateService.toIsoString(rows[i].value.plainDate)
          )
        )
      );
    }
    Assert.isFalse(rows[2].success);
    Assert.isNotNull(rows[2].errorMessage);
    rows[0].success = false;
    Assert.isTrue(rows[1].success, 'Duplicate outcomes are independent');
  }
  @IsTest
  static void replaceValueDirectApex() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"valueType":"PlainDate","value":"2026-01-31","month":2,"overflow":"constrain"}'
    );
    Object expected = JSON.deserializeUntyped('"2026-02-28"');
    ChronoReplaceValueInput item = new ChronoReplaceValueInput();
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    item.month = Integer.valueOf(String.valueOf(inputs.get('month')));
    item.overflow = (String) inputs.get('overflow');

    Test.startTest();
    Integer queries = Limits.getQueries();
    List<ChronoValueResult> rows = ChronoValueService.replace(
      new List<ChronoReplaceValueInput>{ item, item, null }
    );
    Assert.areEqual(
      queries,
      Limits.getQueries(),
      'This supplied-data calculation does not query'
    );
    Test.stopTest();
    Assert.areEqual(3, rows.size());
    for (Integer i = 0; i < 2; i++) {
      Assert.isTrue(rows[i].success, 'Item ' + i + ': ' + rows[i].errorMessage);
      Assert.areEqual(
        expected,
        JSON.deserializeUntyped(
          JSON.serialize(
            ChronoPlainDateService.toIsoString(rows[i].value.plainDate)
          )
        )
      );
    }
    Assert.isFalse(rows[2].success);
    Assert.isNotNull(rows[2].errorMessage);
    rows[0].success = false;
    Assert.isTrue(rows[1].success, 'Duplicate outcomes are independent');
  }
  @IsTest
  static void validateValueDirectApex() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"valueType":"PlainDate","value":"2026-02-30"}'
    );
    Object expected = JSON.deserializeUntyped('false');
    ChronoValidateValueInput item = new ChronoValidateValueInput();
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');

    Test.startTest();
    Integer queries = Limits.getQueries();
    List<ChronoValidationResult> rows = ChronoValueService.validate(
      new List<ChronoValidateValueInput>{ item, item, null }
    );
    Assert.areEqual(
      queries,
      Limits.getQueries(),
      'This supplied-data calculation does not query'
    );
    Test.stopTest();
    Assert.areEqual(3, rows.size());
    for (Integer i = 0; i < 2; i++) {
      Assert.isTrue(rows[i].success, 'Item ' + i + ': ' + rows[i].errorMessage);
      Assert.areEqual(
        expected,
        JSON.deserializeUntyped(JSON.serialize(rows[i].isValid))
      );
    }
    Assert.isFalse(rows[2].success);
    Assert.isNotNull(rows[2].errorMessage);
    rows[0].success = false;
    Assert.isTrue(rows[1].success, 'Duplicate outcomes are independent');
  }
  @IsTest
  static void parseValueDirectApex() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"valueType":"PlainDate","text":"03/04/2026","pattern":"dd/MM/yyyy"}'
    );
    Object expected = JSON.deserializeUntyped('"2026-04-03"');
    ChronoParseValueInput item = new ChronoParseValueInput();
    item.valueType = (String) inputs.get('valueType');
    item.text = (String) inputs.get('text');
    item.pattern = (String) inputs.get('pattern');

    Test.startTest();
    Integer queries = Limits.getQueries();
    List<ChronoValueResult> rows = ChronoValueService.parse(
      new List<ChronoParseValueInput>{ item, item, null }
    );
    Assert.areEqual(
      queries,
      Limits.getQueries(),
      'This supplied-data calculation does not query'
    );
    Test.stopTest();
    Assert.areEqual(3, rows.size());
    for (Integer i = 0; i < 2; i++) {
      Assert.isTrue(rows[i].success, 'Item ' + i + ': ' + rows[i].errorMessage);
      Assert.areEqual(
        expected,
        JSON.deserializeUntyped(
          JSON.serialize(
            ChronoPlainDateService.toIsoString(rows[i].value.plainDate)
          )
        )
      );
    }
    Assert.isFalse(rows[2].success);
    Assert.isNotNull(rows[2].errorMessage);
    rows[0].success = false;
    Assert.isTrue(rows[1].success, 'Duplicate outcomes are independent');
  }
  @IsTest
  static void epochValueDirectApex() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"operation":"fromEpoch","epochValue":0,"epochUnit":"millisecond"}'
    );
    Object expected = JSON.deserializeUntyped('"1970-01-01T00:00:00.000Z"');
    ChronoEpochValueInput item = new ChronoEpochValueInput();
    item.operation = (String) inputs.get('operation');
    item.epochValue = Decimal.valueOf(String.valueOf(inputs.get('epochValue')));
    item.epochUnit = (String) inputs.get('epochUnit');

    Test.startTest();
    Integer queries = Limits.getQueries();
    List<ChronoEpochResult> rows = ChronoValueService.convertEpoch(
      new List<ChronoEpochValueInput>{ item, item, null }
    );
    Assert.areEqual(
      queries,
      Limits.getQueries(),
      'This supplied-data calculation does not query'
    );
    Test.stopTest();
    Assert.areEqual(3, rows.size());
    for (Integer i = 0; i < 2; i++) {
      Assert.isTrue(rows[i].success, 'Item ' + i + ': ' + rows[i].errorMessage);
      Assert.areEqual(
        expected,
        JSON.deserializeUntyped(JSON.serialize(rows[i].value))
      );
    }
    Assert.isFalse(rows[2].success);
    Assert.isNotNull(rows[2].errorMessage);
    rows[0].success = false;
    Assert.isTrue(rows[1].success, 'Duplicate outcomes are independent');
  }
  @IsTest
  static void valueDetailsDirectApex() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"valueType":"PlainDate","value":"2026-09-07"}'
    );
    Object expected = JSON.deserializeUntyped('1');
    ChronoValueDetailsInput item = new ChronoValueDetailsInput();
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');

    Test.startTest();
    Integer queries = Limits.getQueries();
    List<ChronoDetailsResult> rows = ChronoValueService.details(
      new List<ChronoValueDetailsInput>{ item, item, null }
    );
    Assert.areEqual(
      queries,
      Limits.getQueries(),
      'This supplied-data calculation does not query'
    );
    Test.stopTest();
    Assert.areEqual(3, rows.size());
    for (Integer i = 0; i < 2; i++) {
      Assert.isTrue(rows[i].success, 'Item ' + i + ': ' + rows[i].errorMessage);
      Assert.areEqual(
        expected,
        JSON.deserializeUntyped(JSON.serialize(rows[i].dayOfWeek))
      );
    }
    Assert.isFalse(rows[2].success);
    Assert.isNotNull(rows[2].errorMessage);
    rows[0].success = false;
    Assert.isTrue(rows[1].success, 'Duplicate outcomes are independent');
  }
  @IsTest
  static void durationToolsDirectApex() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"operation":"total","value":"PT90M","unit":"minute"}'
    );
    Object expected = JSON.deserializeUntyped('90');
    ChronoDurationToolsInput item = new ChronoDurationToolsInput();
    item.operation = (String) inputs.get('operation');
    item.value = (String) inputs.get('value');
    item.unit = (String) inputs.get('unit');

    Test.startTest();
    Integer queries = Limits.getQueries();
    List<ChronoDurationResult> rows = ChronoDurationCalculationService.calculate(
      new List<ChronoDurationToolsInput>{ item, item, null }
    );
    Assert.areEqual(
      queries,
      Limits.getQueries(),
      'This supplied-data calculation does not query'
    );
    Test.stopTest();
    Assert.areEqual(3, rows.size());
    for (Integer i = 0; i < 2; i++) {
      Assert.isTrue(rows[i].success, 'Item ' + i + ': ' + rows[i].errorMessage);
      Assert.areEqual(
        expected,
        JSON.deserializeUntyped(JSON.serialize(rows[i].total))
      );
    }
    Assert.isFalse(rows[2].success);
    Assert.isNotNull(rows[2].errorMessage);
    rows[0].success = false;
    Assert.isTrue(rows[1].success, 'Duplicate outcomes are independent');
  }
  @IsTest
  static void zoneToolsDirectApex() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"operation":"details","valueType":"ZonedDateTime","value":"2026-09-07T09:00+01:00[Europe/London]"}'
    );
    Object expected = JSON.deserializeUntyped('3600');
    ChronoZoneToolsInput item = new ChronoZoneToolsInput();
    item.operation = (String) inputs.get('operation');
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');

    Test.startTest();
    Integer queries = Limits.getQueries();
    List<ChronoZoneResult> rows = ChronoTimeZoneService.calculate(
      new List<ChronoZoneToolsInput>{ item, item, null }
    );
    Assert.areEqual(
      queries,
      Limits.getQueries(),
      'This supplied-data calculation does not query'
    );
    Test.stopTest();
    Assert.areEqual(3, rows.size());
    for (Integer i = 0; i < 2; i++) {
      Assert.isTrue(rows[i].success, 'Item ' + i + ': ' + rows[i].errorMessage);
      Assert.areEqual(
        expected,
        JSON.deserializeUntyped(JSON.serialize(rows[i].offsetSeconds))
      );
    }
    Assert.isFalse(rows[2].success);
    Assert.isNotNull(rows[2].errorMessage);
    rows[0].success = false;
    Assert.isTrue(rows[1].success, 'Duplicate outcomes are independent');
  }
  @IsTest
  static void rangeToolsDirectApex() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"operation":"subtract","valueType":"PlainDate","value":"2026-01-01","endValue":"2026-01-05","rangesText":"2026-01-02/2026-01-03"}'
    );
    Object expected = JSON.deserializeUntyped(
      '["2026-01-01/2026-01-02","2026-01-03/2026-01-05"]'
    );
    ChronoRangeToolsInput item = new ChronoRangeToolsInput();
    item.operation = (String) inputs.get('operation');
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    item.endValue = (String) inputs.get('endValue');
    item.rangesText = (String) inputs.get('rangesText');

    Test.startTest();
    Integer queries = Limits.getQueries();
    List<ChronoRangeResult> rows = ChronoRangeService.calculate(
      new List<ChronoRangeToolsInput>{ item, item, null }
    );
    Assert.areEqual(
      queries,
      Limits.getQueries(),
      'This supplied-data calculation does not query'
    );
    Test.stopTest();
    Assert.areEqual(3, rows.size());
    for (Integer i = 0; i < 2; i++) {
      Assert.isTrue(rows[i].success, 'Item ' + i + ': ' + rows[i].errorMessage);
      Assert.areEqual(
        expected,
        JSON.deserializeUntyped(JSON.serialize(rows[i].ranges))
      );
    }
    Assert.isFalse(rows[2].success);
    Assert.isNotNull(rows[2].errorMessage);
    rows[0].success = false;
    Assert.isTrue(rows[1].success, 'Duplicate outcomes are independent');
  }
  @IsTest
  static void availabilityDirectApex() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"operation":"windows","valueType":"ZonedDateTime","value":"2026-09-07T09:00+01:00[Europe/London]","endValue":"2026-09-07T10:00+01:00[Europe/London]"}'
    );
    Object expected = JSON.deserializeUntyped('3600000');
    ChronoAvailabilityInput item = new ChronoAvailabilityInput();
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

    Test.startTest();
    Integer queries = Limits.getQueries();
    List<ChronoAvailabilityResult> rows = ChronoAvailabilityService.evaluate(
      new List<ChronoAvailabilityInput>{ item, item, null }
    );
    Assert.areEqual(
      queries,
      Limits.getQueries(),
      'This supplied-data calculation does not query'
    );
    Test.stopTest();
    Assert.areEqual(3, rows.size());
    for (Integer i = 0; i < 2; i++) {
      Assert.isTrue(rows[i].success, 'Item ' + i + ': ' + rows[i].errorMessage);
      Assert.areEqual(
        expected,
        JSON.deserializeUntyped(JSON.serialize(rows[i].milliseconds))
      );
    }
    Assert.isFalse(rows[2].success);
    Assert.isNotNull(rows[2].errorMessage);
    rows[0].success = false;
    Assert.isTrue(rows[1].success, 'Duplicate outcomes are independent');
  }
  @IsTest
  static void collectionToolsDirectApex() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"operation":"sort","valueType":"PlainDate","valuesText":"2026-01-02\\n2026-01-01"}'
    );
    Object expected = JSON.deserializeUntyped('["2026-01-01","2026-01-02"]');
    ChronoCollectionToolsInput item = new ChronoCollectionToolsInput();
    item.operation = (String) inputs.get('operation');
    item.valueType = (String) inputs.get('valueType');
    item.valuesText = (String) inputs.get('valuesText');

    Test.startTest();
    Integer queries = Limits.getQueries();
    List<ChronoValuesResult> rows = ChronoCollectionService.calculate(
      new List<ChronoCollectionToolsInput>{ item, item, null }
    );
    Assert.areEqual(
      queries,
      Limits.getQueries(),
      'This supplied-data calculation does not query'
    );
    Test.stopTest();
    Assert.areEqual(3, rows.size());
    for (Integer i = 0; i < 2; i++) {
      Assert.isTrue(rows[i].success, 'Item ' + i + ': ' + rows[i].errorMessage);
      Assert.areEqual(
        expected,
        JSON.deserializeUntyped(JSON.serialize(rows[i].values))
      );
    }
    Assert.isFalse(rows[2].success);
    Assert.isNotNull(rows[2].errorMessage);
    rows[0].success = false;
    Assert.isTrue(rows[1].success, 'Duplicate outcomes are independent');
  }
  @IsTest
  static void recurrenceDirectApex() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"operation":"weekday","valueType":"PlainDate","value":"2026-09-07","weekday":2}'
    );
    Object expected = JSON.deserializeUntyped('"2026-09-08"');
    ChronoRecurrenceInput item = new ChronoRecurrenceInput();
    item.operation = (String) inputs.get('operation');
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    item.weekday = Integer.valueOf(String.valueOf(inputs.get('weekday')));

    Test.startTest();
    Integer queries = Limits.getQueries();
    List<ChronoRecurrenceResult> rows = ChronoRecurrenceService.generate(
      new List<ChronoRecurrenceInput>{ item, item, null }
    );
    Assert.areEqual(
      queries,
      Limits.getQueries(),
      'This supplied-data calculation does not query'
    );
    Test.stopTest();
    Assert.areEqual(3, rows.size());
    for (Integer i = 0; i < 2; i++) {
      Assert.isTrue(rows[i].success, 'Item ' + i + ': ' + rows[i].errorMessage);
      Assert.areEqual(
        expected,
        JSON.deserializeUntyped(JSON.serialize(rows[i].value))
      );
    }
    Assert.isFalse(rows[2].success);
    Assert.isNotNull(rows[2].errorMessage);
    rows[0].success = false;
    Assert.isTrue(rows[1].success, 'Duplicate outcomes are independent');
  }
  @IsTest
  static void formatValueDirectApex() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"operation":"value","valueType":"PlainDate","value":"2026-09-07","pattern":"yyyy-MM-dd"}'
    );
    Object expected = JSON.deserializeUntyped('"2026-09-07"');
    ChronoFormatValueInput item = new ChronoFormatValueInput();
    item.operation = (String) inputs.get('operation');
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    item.pattern = (String) inputs.get('pattern');

    Test.startTest();
    Integer queries = Limits.getQueries();
    List<ChronoFormatResult> rows = ChronoFormattingService.format(
      new List<ChronoFormatValueInput>{ item, item, null }
    );
    Assert.areEqual(
      queries,
      Limits.getQueries(),
      'This supplied-data calculation does not query'
    );
    Test.stopTest();
    Assert.areEqual(3, rows.size());
    for (Integer i = 0; i < 2; i++) {
      Assert.isTrue(rows[i].success, 'Item ' + i + ': ' + rows[i].errorMessage);
      Assert.areEqual(
        expected,
        JSON.deserializeUntyped(JSON.serialize(rows[i].text))
      );
    }
    Assert.isFalse(rows[2].success);
    Assert.isNotNull(rows[2].errorMessage);
    rows[0].success = false;
    Assert.isTrue(rows[1].success, 'Duplicate outcomes are independent');
  }

  @IsTest
  static void fiscalPeriodsBatchOrganisationAndMonthBasedRequests() {
    ChronoFiscalPeriodInput configured = new ChronoFiscalPeriodInput();
    configured.calendarSource = 'organisation';
    configured.valueType = 'PlainDate';
    configured.dateValue = Date.today();
    configured.period = 'month';
    ChronoFiscalPeriodInput explicit = new ChronoFiscalPeriodInput();
    explicit.calendarSource = 'monthBased';
    explicit.startMonth = 4;
    explicit.period = 'quarter';
    explicit.valueType = 'PlainDate';
    explicit.value = '2026-02-02';
    List<ChronoFiscalPeriodInput> inputs = new List<ChronoFiscalPeriodInput>();
    for (Integer i = 0; i < 200; i++) {
      inputs.add(Math.mod(i, 2) == 0 ? configured : explicit);
    }
    inputs.add(null);
    Test.startTest();
    List<ChronoFiscalResult> rows = ChronoFiscalPeriodService.resolve(inputs);
    Assert.areEqual(1, Limits.getQueries(), 'Organisation periods loaded once');
    List<ChronoFiscalResult> supplied = ChronoFiscalPeriodService.resolve(
      new List<ChronoFiscalPeriodInput>{ explicit }
    );
    Assert.areEqual(
      1,
      Limits.getQueries(),
      'Explicit fiscal calendar requires no query'
    );
    Test.stopTest();
    for (Integer i = 1; i < 200; i += 2) {
      Assert.isTrue(
        rows[i].success,
        'Expected success: ' + rows[i].errorMessage
      );
      Assert.areEqual(4, rows[i].periodNumber);
      Assert.areEqual(Date.newInstance(2026, 4, 1), rows[i].endExclusiveDate);
    }
    // Tests do not assume the org has configured fiscal Period rows visible in isolated test data.
    Assert.areEqual(rows[0].success, rows[2].success);
    Assert.areEqual(rows[0].periodId, rows[2].periodId);
    Assert.isTrue(
      supplied[0].success,
      'Expected success: ' + supplied[0].errorMessage
    );
    Assert.isFalse(rows[200].success);
  }
}
