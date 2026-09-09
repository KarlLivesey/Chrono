// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoCatalogueAdvancedTest {
  @IsTest
  static void collectionOrderingDedupAndNearestUseInstants() {
    ChronoCollectionToolsInput input = new ChronoCollectionToolsInput();
    input.valueType = 'ZonedDateTime';
    input.operation = 'sort';
    input.direction = 'descending';
    input.values = new List<String>{
      '2026-10-25T01:30+01:00[Europe/London]',
      '2026-10-24T20:30-04:00[America/New_York]',
      '2026-10-25T01:30+00:00[Europe/London]'
    };
    ChronoValuesResult result = ChronoCollectionTools.execute(input);
    Assert.areEqual(
      new List<Integer>{ 2, 0, 1 },
      result.indexes,
      'Stable equal-value order'
    );
    Assert.areEqual(2, result.uniqueCount);
    input.operation = 'deduplicate';
    Assert.areEqual(
      new List<Integer>{ 0, 2 },
      ChronoCollectionTools.execute(input).indexes
    );
    input.operation = 'nearest';
    input.pointValue = '2026-10-25T01:15+00:00[Europe/London]';
    Assert.areEqual(
      new List<Integer>{ 2 },
      ChronoCollectionTools.execute(input).indexes
    );
  }
  @IsTest
  static void collectionNativeDatesGroupsFiltersAndDurationSum() {
    ChronoCollectionToolsInput input = new ChronoCollectionToolsInput();
    input.operation = 'group';
    input.valueType = 'PlainDate';
    input.dates = new List<Date>{
      Date.newInstance(2026, 3, 31),
      Date.newInstance(2026, 4, 1)
    };
    input.period = 'quarter';
    Assert.areEqual(
      new List<String>{ '2026-01-01', '2026-04-01' },
      ChronoCollectionTools.execute(input).groupKeys
    );
    input.operation = 'filter';
    input.lowerValue = '2026-04-01';
    input.upperValue = '2026-04-02';
    Assert.areEqual(
      new List<Integer>{ 1 },
      ChronoCollectionTools.execute(input).indexes
    );
    input.operation = 'sumDurations';
    input.dates = null;
    input.valueType = 'Duration';
    input.valuesText = 'P1M\nP2D\nPT90M';
    Assert.areEqual(
      'P1M2DT5400.000S',
      ChronoCollectionTools.execute(input).duration
    );
    input.operation = 'summary';
    input.valuesText = null;
    input.values = new List<String>();
    Assert.areEqual(0, ChronoCollectionTools.execute(input).count);
  }
  @IsTest
  static void recurringClockSkipsGapWithoutSpendingCount() {
    ChronoRecurrenceInput input = new ChronoRecurrenceInput();
    input.operation = 'rrule';
    input.valueType = 'ZonedDateTime';
    input.value = '2026-03-22T01:30+00:00[Europe/London]';
    input.rule = 'FREQ=WEEKLY;COUNT=3;BYDAY=SU';
    input.untilDate = Date.newInstance(2026, 4, 20);
    ChronoRecurrenceResult result = (ChronoRecurrenceResult) new ChronoCatalogueBatch(
        'Recurrence'
      )
      .run(new List<Object>{ input })[0];
    Assert.isTrue(
      result.success,
      result.errorMessage == null ? 'Expected success' : result.errorMessage
    );
    Assert.areEqual(
      new List<String>{
        '2026-03-22T01:30:00.000+00:00[Europe/London]',
        '2026-04-05T01:30:00.000+01:00[Europe/London]',
        '2026-04-12T01:30:00.000+01:00[Europe/London]'
      },
      result.values
    );
    input.operation = 'generate';
    input.frequency = 'weekly';
    input.count = 2;
    input.gapPolicy = 'forward';
    result = (ChronoRecurrenceResult) new ChronoCatalogueBatch('Recurrence')
      .run(new List<Object>{ input })[0];
    Assert.areEqual(
      '2026-03-29T02:00:00.000+01:00[Europe/London]',
      result.values[1]
    );
  }
  @IsTest
  static void recurringMonthEndsAndUnsupportedRulesAreExplicit() {
    ChronoRecurrenceInput input = new ChronoRecurrenceInput();
    input.operation = 'rrule';
    input.valueType = 'PlainDate';
    input.value = '2026-01-31';
    input.rule = 'FREQ=MONTHLY;COUNT=3';
    input.untilDate = Date.newInstance(2026, 6, 1);
    ChronoRecurrenceResult result = (ChronoRecurrenceResult) new ChronoCatalogueBatch(
        'Recurrence'
      )
      .run(new List<Object>{ input })[0];
    Assert.areEqual(
      new List<String>{ '2026-01-31', '2026-03-31', '2026-05-31' },
      result.values
    );
    input.rule = 'FREQ=MONTHLY;BYSETPOS=1';
    result = (ChronoRecurrenceResult) new ChronoCatalogueBatch('Recurrence')
      .run(new List<Object>{ input })[0];
    Assert.isFalse(result.success);
    Assert.isTrue(result.errorMessage.contains('BYSETPOS'));
    input.rule = 'FREQ=DAILY;COUNT=2;UNTIL=20260201';
    result = (ChronoRecurrenceResult) new ChronoCatalogueBatch('Recurrence')
      .run(new List<Object>{ input })[0];
    Assert.isFalse(result.success);
  }
  @IsTest
  static void weekdayAnnualAndWorkingOrdinal() {
    ChronoRecurrenceInput input = new ChronoRecurrenceInput();
    input.operation = 'nthWeekday';
    input.valueType = 'PlainDate';
    input.value = '2026-02-01';
    input.weekday = 5;
    input.ordinal = -1;
    Assert.areEqual(
      '2026-02-27',
      ((ChronoRecurrenceResult) new ChronoCatalogueBatch('Recurrence')
          .run(new List<Object>{ input })[0])
        .value
    );
    input.operation = 'annual';
    input.value = '2025-03-01';
    input.month = 2;
    input.day = 29;
    Assert.areEqual(
      '2028-02-29',
      ((ChronoRecurrenceResult) new ChronoCatalogueBatch('Recurrence')
          .run(new List<Object>{ input })[0])
        .value
    );
    input.operation = 'nthWorkingDay';
    input.value = '2026-05-01';
    input.ordinal = 1;
    input.operatingHours = new OperatingHours(TimeZone = 'Europe/London');
    input.timeSlots = new List<TimeSlot>();
    for (
      String day : new List<String>{
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday'
      }
    ) {
      input.timeSlots.add(
        new TimeSlot(
          DayOfWeek = day,
          StartTime = Time.newInstance(9, 0, 0, 0),
          EndTime = Time.newInstance(17, 0, 0, 0)
        )
      );
    }
    input.holidays = new List<Holiday>{
      new Holiday(ActivityDate = Date.newInstance(2026, 5, 1), IsAllDay = true)
    };
    Assert.areEqual(
      '2026-05-04',
      ((ChronoRecurrenceResult) new ChronoCatalogueBatch('Recurrence')
          .run(new List<Object>{ input })[0])
        .value
    );
  }
  @IsTest
  static void fiscalMonthAndConfiguredIrregularPeriods() {
    ChronoFiscalPeriodInput input = new ChronoFiscalPeriodInput();
    input.valueType = 'PlainDate';
    input.value = '2026-02-02';
    input.calendarSource = 'monthBased';
    input.startMonth = 4;
    input.period = 'quarter';
    ChronoFiscalPeriods fiscal = new ChronoFiscalPeriods(
      new List<Object>{ input }
    );
    ChronoFiscalResult result = fiscal.execute(input);
    Assert.areEqual(Date.newInstance(2026, 1, 1), result.startDate);
    Assert.areEqual(Date.newInstance(2026, 3, 31), result.lastDate);
    Assert.areEqual(4, result.periodNumber);
    input.calendarSource = 'organisation';
    fiscal.rows = (List<Period>) JSON.deserialize(
      '[{"Type":"Quarter","StartDate":"2026-01-04","EndDate":"2026-04-04","Number":1,"FullyQualifiedLabel":"FY26 Q1","FiscalYearSettings":{"Name":"FY26"}}]',
      List<Period>.class
    );
    result = fiscal.execute(input);
    Assert.areEqual(Date.newInstance(2026, 1, 4), result.startDate);
    Assert.areEqual('FY26 Q1', result.label);
  }
  private static User localeUser(String locale) {
    return new User(
      Username = 'chrono.' +
        locale +
        '.' +
        Datetime.now().getTime() +
        '@example.invalid',
      Email = 'chrono@example.invalid',
      LastName = 'Chrono formatting',
      Alias = 'chrono',
      TimeZoneSidKey = 'Europe/London',
      LocaleSidKey = locale,
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US',
      ProfileId = UserInfo.getProfileId()
    );
  }
  @IsTest
  static void formattingUsesLocaleStyleAndRealOffset() {
    ChronoFormatValueInput input = new ChronoFormatValueInput();
    input.operation = 'value';
    input.valueType = 'ZonedDateTime';
    input.value = '2026-09-07T13:05+01:00[Europe/London]';
    input.style = 'short';
    input.includeZone = true;
    System.runAs(localeUser('en_GB')) {
      ChronoFormatResult result = ChronoFormatting.execute(input);
      Assert.isTrue(result.text.startsWith('07/09/2026'), result.text);
      Assert.isTrue(result.text.contains('13:05'), result.text);
      Assert.isTrue(
        result.text.endsWith('+01:00 [Europe/London]'),
        result.text
      );
    }
    System.runAs(localeUser('en_US')) {
      ChronoFormatResult result = ChronoFormatting.execute(input);
      Assert.isTrue(result.text.startsWith('9/7/2026'), result.text);
      Assert.isTrue(result.text.contains('1:05'), result.text);
    }
  }
  @IsTest
  static void partialFormattingDoesNotInventComponents() {
    ChronoFormatValueInput input = new ChronoFormatValueInput();
    input.operation = 'value';
    input.valueType = 'PlainMonthDay';
    input.value = '--02-29';
    input.style = 'short';
    System.runAs(localeUser('en_GB')) {
      Assert.areEqual('29/02', ChronoFormatting.execute(input).text);
      input.pattern = 'yyyy-MM-dd';
      ChronoFormatResult invalid = (ChronoFormatResult) new ChronoCatalogueBatch(
          'FormatValue'
        )
        .run(new List<Object>{ input })[0];
      Assert.isFalse(invalid.success);
      input.pattern = null;
      input.valueType = 'PlainYearMonth';
      input.value = '2026-09';
      Assert.areEqual('09/2026', ChronoFormatting.execute(input).text);
    }
  }
  @IsTest
  static void readableDurationsRelativeAndRanges() {
    ChronoFormatValueInput input = new ChronoFormatValueInput();
    input.operation = 'duration';
    input.valueType = 'Duration';
    input.value = 'P1Y2M3DT4H5M6.0079S';
    input.durationStyle = 'compact';
    Assert.areEqual(
      '1y 2mo 3d 4h 5min 6.007s',
      ChronoFormatting.execute(input).text
    );
    input.operation = 'relative';
    input.valueType = 'ZonedDateTime';
    input.value = '2026-03-29T12:00+01:00[Europe/London]';
    input.referenceValue = '2026-03-29T10:00Z';
    Assert.areEqual('in 1 hour', ChronoFormatting.execute(input).text);
    input.operation = 'range';
    input.pattern = 'HH:mm';
    input.endValue = '2026-03-29T12:00Z';
    input.timeZoneId = 'Europe/London';
    Assert.areEqual('12:00 – 13:00', ChronoFormatting.execute(input).text);
  }
  @IsTest
  static void advancedCollectionsReturnIndependentLists() {
    ChronoRecurrenceCollectionAction.Request request = new ChronoRecurrenceCollectionAction.Request();
    ChronoRecurrenceInput input = new ChronoRecurrenceInput();
    input.valueType = 'PlainDate';
    input.value = '2026-09-07';
    input.operation = 'weekday';
    input.weekday = 2;
    request.items = new List<ChronoRecurrenceInput>{ input, null, input };
    ChronoRecurrenceCollectionResult result = ChronoRecurrenceCollectionAction.run(
      new List<ChronoRecurrenceCollectionAction.Request>{ request }
    )[0];
    Assert.isFalse(result.success);
    result.results[0].values.clear();
    Assert.areEqual(1, result.results[2].values.size());
    ChronoCollectionToolsAction.Request values = new ChronoCollectionToolsAction.Request();
    values.valueType = 'Instant';
    values.operation = 'summary';
    values.datetimes = new List<Datetime>{
      Datetime.newInstanceGmt(2026, 1, 1, 0, 0, 0)
    };
    List<ChronoValuesResult> summaries = ChronoCollectionToolsAction.run(
      new List<ChronoCollectionToolsAction.Request>{ values, values }
    );
    summaries[0].values.clear();
    Assert.areEqual(1, summaries[1].values.size());
  }
  @IsTest
  static void nativeAuxiliaryDatesAndTimestamps() {
    ChronoRangeToolsInput range = new ChronoRangeToolsInput();
    range.operation = 'contains';
    range.valueType = 'PlainDate';
    range.dateValue = Date.newInstance(2026, 1, 1);
    range.endDate = Date.newInstance(2026, 2, 1);
    range.pointDate = Date.newInstance(2026, 1, 15);
    Assert.isTrue(ChronoRangeTools.execute(range).containsValue);
    range.operation = 'intersection';
    range.otherStartDate = Date.newInstance(2026, 1, 20);
    range.otherEndDate = Date.newInstance(2026, 2, 20);
    Assert.areEqual(
      new List<String>{ '2026-01-20/2026-02-01' },
      ChronoRangeTools.execute(range).ranges
    );
    ChronoCollectionToolsInput listInput = new ChronoCollectionToolsInput();
    listInput.valueType = 'PlainDate';
    listInput.operation = 'filter';
    listInput.dates = new List<Date>();
    listInput.lowerDate = range.pointDate;
    Assert.areEqual(0, ChronoCollectionTools.execute(listInput).count);
    listInput.dates.add(range.dateValue);
    listInput.dates.add(range.pointDate);
    Assert.areEqual(
      new List<Integer>{ 1 },
      ChronoCollectionTools.execute(listInput).indexes
    );
    ChronoFormatValueInput format = new ChronoFormatValueInput();
    format.operation = 'relative';
    format.valueType = 'ZonedDateTime';
    format.value = '2026-03-29T12:00+01:00[Europe/London]';
    format.referenceInstant = Datetime.newInstanceGmt(2026, 3, 29, 10, 0, 0);
    Assert.areEqual('in 1 hour', ChronoFormatting.execute(format).text);
    format.operation = 'range';
    format.pattern = 'HH:mm';
    format.endInstant = Datetime.newInstanceGmt(2026, 3, 29, 12, 0, 0);
    Assert.areEqual('12:00 – 13:00', ChronoFormatting.execute(format).text);
  }
  @IsTest
  static void nativeAuxiliaryLocalMidnightAndSourceConflict() {
    ChronoRangeToolsInput input = new ChronoRangeToolsInput();
    input.valueType = 'PlainDateTime';
    input.operation = 'contains';
    input.value = '2026-01-01T00:00';
    input.endValue = '2026-01-02T00:00';
    input.pointDate = Date.newInstance(2026, 1, 1);
    Assert.isTrue(ChronoRangeTools.execute(input).containsValue);
    input.pointTime = '23:59';
    Assert.isTrue(ChronoRangeTools.execute(input).containsValue);
    input.pointValue = '2026-01-01T12:00';
    ChronoRangeResult invalid = (ChronoRangeResult) new ChronoCatalogueBatch(
        'RangeTools'
      )
      .run(new List<Object>{ input })[0];
    Assert.isFalse(
      invalid.success,
      'Conflicting native and ISO sources must be rejected'
    );
  }
  @IsTest
  static void previousTransitionIncludesSearchLowerBoundary() {
    ChronoZoneToolsInput input = new ChronoZoneToolsInput();
    input.operation = 'previousTransition';
    input.valueType = 'Instant';
    input.instantValue = Datetime.newInstanceGmt(2026, 3, 30, 1, 0, 0);
    input.timeZoneId = 'Europe/London';
    input.searchDays = 1;
    ChronoZoneResult result = ChronoZoneTools.execute(input);
    Assert.isTrue(result.found);
    Assert.areEqual(
      '2026-03-29T02:00:00.000+01:00[Europe/London]',
      result.transitionValues[0]
    );
  }
}
