// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Behavioural coverage of new value contracts, native inputs and ordered batching. */
@IsTest
private class ChronoCatalogueValuesTest {
  @IsTest
  static void createsDatesAndRepeatedZonedTimes() {
    ChronoCreateValueAction.Request day = new ChronoCreateValueAction.Request();
    day.valueType = 'PlainDate';
    day.year = 2026;
    day.month = 2;
    day.day = 30;
    ChronoCreateValueAction.Request zoned = new ChronoCreateValueAction.Request();
    zoned.valueType = 'ZonedDateTime';
    zoned.year = 2026;
    zoned.month = 10;
    zoned.day = 25;
    zoned.hour = 1;
    zoned.minute = 30;
    zoned.timeZoneId = 'Europe/London';
    zoned.disambiguation = 'later';
    List<ChronoFlowResult> values = ChronoCreateValueAction.run(
      new List<ChronoCreateValueAction.Request>{ day, zoned }
    );
    Assert.isFalse(values[0].success);
    Assert.areEqual(
      '2026-10-25T01:30:00.000+00:00[Europe/London]',
      values[1].value
    );
    zoned.millisecond = 1000;
    Assert.isFalse(
      ChronoCreateValueAction.run(
          new List<ChronoCreateValueAction.Request>{ zoned }
        )[0]
        .success
    );
  }
  @IsTest
  static void replacementPreservesNativeClockAndRejectsOverflow() {
    ChronoReplaceValueAction.Request value = new ChronoReplaceValueAction.Request();
    value.valueType = 'PlainDateTime';
    value.dateValue = Date.newInstance(2026, 1, 31);
    value.timeValue = '09:42:13.250';
    value.month = 2;
    Assert.isFalse(
      ChronoReplaceValueAction.run(
          new List<ChronoReplaceValueAction.Request>{ value }
        )[0]
        .success
    );
    value.overflow = 'constrain';
    Assert.areEqual(
      '2026-02-28T09:42:13.250',
      ChronoReplaceValueAction.run(
          new List<ChronoReplaceValueAction.Request>{ value }
        )[0]
        .value
    );
  }
  @IsTest
  static void parsesExplicitPatternWithoutDateGuessing() {
    ChronoParseValueAction.Request value = new ChronoParseValueAction.Request();
    value.valueType = 'PlainDateTime';
    value.text = '07/09/2026 at 13:04';
    value.pattern = 'dd/MM/yyyy \'at\' HH:mm';
    Assert.areEqual(
      '2026-09-07T13:04:00.000',
      ChronoParseValueAction.run(
          new List<ChronoParseValueAction.Request>{ value }
        )[0]
        .value
    );
    value.pattern = 'MM/dd/yyyy \'at\' HH:mm';
    Assert.areEqual(
      '2026-07-09T13:04:00.000',
      ChronoParseValueAction.run(
          new List<ChronoParseValueAction.Request>{ value }
        )[0]
        .value
    );
    value.pattern = 'MM/dd/yyyy at HH:mm';
    Assert.isFalse(
      ChronoParseValueAction.run(
          new List<ChronoParseValueAction.Request>{ value }
        )[0]
        .success
    );
  }
  @IsTest
  static void collectionValueActionsRetainInterviewAndItemOrder() {
    ChronoCreateValueInput createItem = new ChronoCreateValueInput();
    createItem.valueType = 'PlainDate';
    createItem.year = 2026;
    createItem.month = 9;
    createItem.day = 7;
    ChronoCreateValueCollectionAction.Request createRequest = new ChronoCreateValueCollectionAction.Request();
    createRequest.items = new List<ChronoCreateValueInput>{ createItem, null };
    ChronoCreateValueCollectionAction.Request emptyCreate = new ChronoCreateValueCollectionAction.Request();
    emptyCreate.items = new List<ChronoCreateValueInput>();
    List<ChronoFlowCollectionResult> created = ChronoCreateValueCollectionAction.run(
      new List<ChronoCreateValueCollectionAction.Request>{
        createRequest,
        emptyCreate,
        null
      }
    );
    Assert.isFalse(created[0].success);
    Assert.areEqual(2, created[0].results.size());
    Assert.areEqual('2026-09-07', created[0].results[0].value);
    Assert.isFalse(created[0].results[1].success);
    Assert.isTrue(created[1].success);
    Assert.isFalse(created[2].success);

    ChronoParseValueInput parseItem = new ChronoParseValueInput();
    parseItem.valueType = 'PlainDate';
    parseItem.text = '2026-09-07';
    parseItem.pattern = 'yyyy-MM-dd';
    ChronoParseValueCollectionAction.Request parseRequest = new ChronoParseValueCollectionAction.Request();
    parseRequest.items = new List<ChronoParseValueInput>{ parseItem };
    List<ChronoFlowCollectionResult> parsed = ChronoParseValueCollectionAction.run(
      new List<ChronoParseValueCollectionAction.Request>{ parseRequest }
    );
    Assert.isTrue(parsed[0].success);
    Assert.areEqual('2026-09-07', parsed[0].results[0].value);

    ChronoReplaceValueInput replaceItem = new ChronoReplaceValueInput();
    replaceItem.valueType = 'PlainDate';
    replaceItem.value = '2026-09-07';
    replaceItem.day = 8;
    ChronoReplaceValueCollectionAction.Request replaceRequest = new ChronoReplaceValueCollectionAction.Request();
    replaceRequest.items = new List<ChronoReplaceValueInput>{ replaceItem };
    List<ChronoFlowCollectionResult> replaced = ChronoReplaceValueCollectionAction.run(
      new List<ChronoReplaceValueCollectionAction.Request>{ replaceRequest }
    );
    Assert.isTrue(replaced[0].success);
    Assert.areEqual('2026-09-08', replaced[0].results[0].value);
  }
  @IsTest
  static void detailsUseDateSpecificZoneAndIsoWeekYear() {
    ChronoValueDetailsAction.Request value = new ChronoValueDetailsAction.Request();
    value.valueType = 'Instant';
    value.instantValue = Datetime.newInstanceGmt(2021, 1, 1, 0, 30, 0);
    value.timeZoneId = 'America/New_York';
    ChronoDetailsResult result = ChronoValueDetailsAction.run(
      new List<ChronoValueDetailsAction.Request>{ value }
    )[0];
    Assert.areEqual(Date.newInstance(2020, 12, 31), result.dateValue);
    Assert.areEqual(2020, result.yearOfWeek);
    Assert.areEqual(53, result.weekOfYear);
    Assert.areEqual(19, result.hour);
    Assert.areEqual(-18000, result.offsetSeconds);
    Assert.areEqual(true, result.isLeapYear);
    value.instantValue = Datetime.newInstanceGmt(2026, 7, 1, 12, 0, 0);
    Assert.areEqual(
      -14400,
      ChronoValueDetailsAction.run(
          new List<ChronoValueDetailsAction.Request>{ value }
        )[0]
        .offsetSeconds
    );
  }
  @IsTest
  static void detailsDoNotInventPartialDateFields() {
    ChronoValueDetailsAction.Request value = new ChronoValueDetailsAction.Request();
    value.valueType = 'PlainMonthDay';
    value.value = '--02-29';
    ChronoDetailsResult result = ChronoValueDetailsAction.run(
      new List<ChronoValueDetailsAction.Request>{ value }
    )[0];
    Assert.areEqual(null, result.year);
    Assert.areEqual(2, result.month);
    Assert.areEqual(29, result.day);
    Assert.areEqual(null, result.dateValue);
  }
  @IsTest
  static void unixConversionTruncatesNegativeSubMilliseconds() {
    ChronoEpochValueAction.Request value = new ChronoEpochValueAction.Request();
    value.operation = 'fromEpoch';
    value.epochUnit = 'second';
    value.epochValue = -0.0019;
    ChronoEpochResult result = ChronoEpochValueAction.run(
      new List<ChronoEpochValueAction.Request>{ value }
    )[0];
    Assert.areEqual('1969-12-31T23:59:59.999Z', result.value);
    Assert.areEqual(-0.001, result.epochValue);
    value.operation = 'toEpoch';
    value.valueType = 'Instant';
    value.instantValue = result.instantValue;
    value.epochValue = null;
    Assert.areEqual(
      -0.001,
      ChronoEpochValueAction.run(
          new List<ChronoEpochValueAction.Request>{ value }
        )[0]
        .epochValue
    );
  }
  @IsTest
  static void validationReportsInvalidRatherThanThrowing() {
    ChronoValidateValueAction.Request value = new ChronoValidateValueAction.Request();
    value.valueType = 'PlainDate';
    value.value = '2026-02-30';
    ChronoValidationResult result = ChronoValidateValueAction.run(
      new List<ChronoValidateValueAction.Request>{ value }
    )[0];
    Assert.isTrue(result.success);
    Assert.isFalse(result.isValid);
    Assert.isNotNull(result.validationMessage);
  }
  @IsTest
  static void explicitCollectionsPreserveTwoHundredInterviewsAndCopies() {
    ChronoValueDetailsInput value = new ChronoValueDetailsInput();
    value.valueType = 'PlainDate';
    value.dateValue = Date.newInstance(2026, 9, 7);
    List<ChronoValueDetailsCollectionAction.Request> requests = new List<ChronoValueDetailsCollectionAction.Request>();
    for (Integer i = 0; i < 200; i++) {
      ChronoValueDetailsCollectionAction.Request request = new ChronoValueDetailsCollectionAction.Request();
      request.items = new List<ChronoValueDetailsInput>{ value, null, value };
      requests.add(request);
    }
    Test.startTest();
    Integer before = Limits.getQueries();
    List<ChronoDetailsCollectionResult> results = ChronoValueDetailsCollectionAction.run(
      requests
    );
    Assert.areEqual(0, Limits.getQueries() - before);
    Test.stopTest();
    Assert.areEqual(200, results.size());
    Assert.areEqual(3, results[0].results.size());
    Assert.isFalse(results[0].results[1].success);
    Assert.areEqual(1, results[0].results[2].dayOfWeek);
    results[0].results[0].year = 2000;
    Assert.areEqual(2026, results[0].results[2].year);
    Assert.areEqual(2026, results[1].results[0].year);
  }
}
