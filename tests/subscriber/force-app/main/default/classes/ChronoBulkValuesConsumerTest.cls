// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
// Exact package query budgets are asserted by the corresponding in-package tests.
// Subscriber Limits counters do not include the skel namespace.
@IsTest
private class ChronoBulkValuesConsumerTest {
  @IsTest
  static void createValueDirectApex() {
    Map<String, Object> inputs = (Map<String, Object>) JSON.deserializeUntyped(
      '{"valueType":"PlainDate","year":2026,"month":9,"day":7}'
    );
    Object expected = JSON.deserializeUntyped('"2026-09-07"');
    skel.ChronoCreateValueInput item = new skel.ChronoCreateValueInput();
    item.valueType = (String) inputs.get('valueType');
    item.year = Integer.valueOf(String.valueOf(inputs.get('year')));
    item.month = Integer.valueOf(String.valueOf(inputs.get('month')));
    item.day = Integer.valueOf(String.valueOf(inputs.get('day')));

    Test.startTest();
    List<skel.ChronoValueResult> rows = skel.ChronoValueService.create(
      new List<skel.ChronoCreateValueInput>{ item, item, null }
    );
    Test.stopTest();
    Assert.areEqual(3, rows.size());
    for (Integer i = 0; i < 2; i++) {
      Assert.isTrue(rows[i].success, 'Item ' + i + ': ' + rows[i].errorMessage);
      Assert.areEqual(
        expected,
        JSON.deserializeUntyped(
          JSON.serialize(
            skel.ChronoPlainDateService.toIsoString(rows[i].value.plainDate)
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
    skel.ChronoReplaceValueInput item = new skel.ChronoReplaceValueInput();
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    item.month = Integer.valueOf(String.valueOf(inputs.get('month')));
    item.overflow = (String) inputs.get('overflow');

    Test.startTest();
    List<skel.ChronoValueResult> rows = skel.ChronoValueService.replace(
      new List<skel.ChronoReplaceValueInput>{ item, item, null }
    );
    Test.stopTest();
    Assert.areEqual(3, rows.size());
    for (Integer i = 0; i < 2; i++) {
      Assert.isTrue(rows[i].success, 'Item ' + i + ': ' + rows[i].errorMessage);
      Assert.areEqual(
        expected,
        JSON.deserializeUntyped(
          JSON.serialize(
            skel.ChronoPlainDateService.toIsoString(rows[i].value.plainDate)
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
    skel.ChronoValidateValueInput item = new skel.ChronoValidateValueInput();
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');

    Test.startTest();
    List<skel.ChronoValidationResult> rows = skel.ChronoValueService.validate(
      new List<skel.ChronoValidateValueInput>{ item, item, null }
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
    skel.ChronoParseValueInput item = new skel.ChronoParseValueInput();
    item.valueType = (String) inputs.get('valueType');
    item.text = (String) inputs.get('text');
    item.pattern = (String) inputs.get('pattern');

    Test.startTest();
    List<skel.ChronoValueResult> rows = skel.ChronoValueService.parse(
      new List<skel.ChronoParseValueInput>{ item, item, null }
    );
    Test.stopTest();
    Assert.areEqual(3, rows.size());
    for (Integer i = 0; i < 2; i++) {
      Assert.isTrue(rows[i].success, 'Item ' + i + ': ' + rows[i].errorMessage);
      Assert.areEqual(
        expected,
        JSON.deserializeUntyped(
          JSON.serialize(
            skel.ChronoPlainDateService.toIsoString(rows[i].value.plainDate)
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
    skel.ChronoEpochValueInput item = new skel.ChronoEpochValueInput();
    item.operation = (String) inputs.get('operation');
    item.epochValue = Decimal.valueOf(String.valueOf(inputs.get('epochValue')));
    item.epochUnit = (String) inputs.get('epochUnit');

    Test.startTest();
    List<skel.ChronoEpochResult> rows = skel.ChronoValueService.convertEpoch(
      new List<skel.ChronoEpochValueInput>{ item, item, null }
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
    skel.ChronoValueDetailsInput item = new skel.ChronoValueDetailsInput();
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');

    Test.startTest();
    List<skel.ChronoDetailsResult> rows = skel.ChronoValueService.details(
      new List<skel.ChronoValueDetailsInput>{ item, item, null }
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
    skel.ChronoDurationToolsInput item = new skel.ChronoDurationToolsInput();
    item.operation = (String) inputs.get('operation');
    item.value = (String) inputs.get('value');
    item.unit = (String) inputs.get('unit');

    Test.startTest();
    List<skel.ChronoDurationResult> rows = skel.ChronoDurationCalculationService.calculate(
      new List<skel.ChronoDurationToolsInput>{ item, item, null }
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
    skel.ChronoZoneToolsInput item = new skel.ChronoZoneToolsInput();
    item.operation = (String) inputs.get('operation');
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');

    Test.startTest();
    List<skel.ChronoZoneResult> rows = skel.ChronoTimeZoneService.calculate(
      new List<skel.ChronoZoneToolsInput>{ item, item, null }
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
    skel.ChronoRangeToolsInput item = new skel.ChronoRangeToolsInput();
    item.operation = (String) inputs.get('operation');
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    item.endValue = (String) inputs.get('endValue');
    item.rangesText = (String) inputs.get('rangesText');

    Test.startTest();
    List<skel.ChronoRangeResult> rows = skel.ChronoRangeService.calculate(
      new List<skel.ChronoRangeToolsInput>{ item, item, null }
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

    Test.startTest();
    List<skel.ChronoAvailabilityResult> rows = skel.ChronoAvailabilityService.evaluate(
      new List<skel.ChronoAvailabilityInput>{ item, item, null }
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
    skel.ChronoCollectionToolsInput item = new skel.ChronoCollectionToolsInput();
    item.operation = (String) inputs.get('operation');
    item.valueType = (String) inputs.get('valueType');
    item.valuesText = (String) inputs.get('valuesText');

    Test.startTest();
    List<skel.ChronoValuesResult> rows = skel.ChronoCollectionService.calculate(
      new List<skel.ChronoCollectionToolsInput>{ item, item, null }
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
    skel.ChronoRecurrenceInput item = new skel.ChronoRecurrenceInput();
    item.operation = (String) inputs.get('operation');
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    item.weekday = Integer.valueOf(String.valueOf(inputs.get('weekday')));

    Test.startTest();
    List<skel.ChronoRecurrenceResult> rows = skel.ChronoRecurrenceService.generate(
      new List<skel.ChronoRecurrenceInput>{ item, item, null }
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
    skel.ChronoFormatValueInput item = new skel.ChronoFormatValueInput();
    item.operation = (String) inputs.get('operation');
    item.valueType = (String) inputs.get('valueType');
    item.value = (String) inputs.get('value');
    item.pattern = (String) inputs.get('pattern');

    Test.startTest();
    List<skel.ChronoFormatResult> rows = skel.ChronoFormattingService.format(
      new List<skel.ChronoFormatValueInput>{ item, item, null }
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
    skel.ChronoFiscalPeriodInput configured = new skel.ChronoFiscalPeriodInput();
    configured.calendarSource = 'organisation';
    configured.valueType = 'PlainDate';
    configured.dateValue = Date.today();
    configured.period = 'month';
    skel.ChronoFiscalPeriodInput explicit = new skel.ChronoFiscalPeriodInput();
    explicit.calendarSource = 'monthBased';
    explicit.startMonth = 4;
    explicit.period = 'quarter';
    explicit.valueType = 'PlainDate';
    explicit.value = '2026-02-02';
    List<skel.ChronoFiscalPeriodInput> inputs = new List<skel.ChronoFiscalPeriodInput>();
    for (Integer i = 0; i < 200; i++) {
      inputs.add(Math.mod(i, 2) == 0 ? configured : explicit);
    }
    inputs.add(null);
    Test.startTest();
    List<skel.ChronoFiscalResult> rows = skel.ChronoFiscalPeriodService.resolve(
      inputs
    );
    List<skel.ChronoFiscalResult> supplied = skel.ChronoFiscalPeriodService.resolve(
      new List<skel.ChronoFiscalPeriodInput>{ explicit }
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
