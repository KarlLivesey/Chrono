// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoPickerTest {
  @IsTest
  static void initialIsoValuesUseValidatingParsers() {
    ChronoFlowResult local = ChronoPickerController.readInitialValue(
      '2026-10-25T01:30:00.000123'
    );
    Assert.areEqual(Date.newInstance(2026, 10, 25), local.dateValue);
    Assert.areEqual('01:30:00.000', local.timeValue);
    Assert.isNull(local.instantValue, 'An overlap still requires a choice.');
    Assert.areEqual(
      'PlainDate',
      ChronoPickerController.readInitialValue('2026-10-25').valueType
    );
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 10, 25, 0, 30, 0),
      ChronoPickerController.readInitialValue('2026-10-25T00:30:00Z')
        .instantValue
    );
    Assert.areEqual(
      '2026-10-25T01:30:00.000+01:00[Europe/London]',
      ChronoPickerController.readInitialValue(
          '2026-10-25T01:30:00+01:00[Europe/London]'
        )
        .value
    );
  }
  @IsTest
  static void initialIsoRejectsIncompleteAndInvalidValues() {
    for (
      String text : new List<String>{
        null,
        '',
        '{}',
        'PT1H',
        '01:30',
        '2026-10',
        '--10-25',
        '2026-02-30',
        '2026-10-25T25:00',
        '2026-10-25T01:30Z[Invalid/Zone]',
        '2026-07-01T12:00Z[Europe/London]'
      }
    ) {
      try {
        ChronoPickerController.readInitialValue(text);
        Assert.fail('Invalid initial value accepted: ' + text);
      } catch (ChronoException expected) {
        Assert.isNotNull(expected.getMessage());
      }
    }
  }

  @IsTest
  static void zoneSearchUsesRequestedDatesAndBothOccurrences() {
    Map<String, List<ChronoPickerOption>> march = ChronoPickerController.describeZones(
      '2026-03-15',
      '10:00',
      new List<String>{ 'Europe/London', 'America/New_York' }
    );
    Assert.areEqual(0, march.get('Europe/London')[0].offsetSeconds);
    Assert.areEqual(-14400, march.get('America/New_York')[0].offsetSeconds);
    Map<String, List<ChronoPickerOption>> autumn = ChronoPickerController.describeZones(
      '2026-10-25',
      '01:30',
      new List<String>{ 'Europe/London' }
    );
    Assert.areEqual(2, autumn.get('Europe/London').size());
    Assert.areEqual(3600, autumn.get('Europe/London')[0].offsetSeconds);
    Assert.areEqual(0, autumn.get('Europe/London')[1].offsetSeconds);
    try {
      ChronoPickerController.describeZones('2026-10-25', '01:30', null);
      Assert.fail('A missing page must be rejected.');
    } catch (ChronoException expected) {
      Assert.isTrue(expected.getMessage().contains('twelve'));
    }
  }
  @IsTest
  static void repeatedAndNormalTimes() {
    List<ChronoPickerOption> options = ChronoPickerController.resolveLocal(
      '2026-10-25',
      '01:30',
      'Europe/London'
    );
    Assert.areEqual(2, options.size());
    Assert.areEqual('earlier', options[0].choice);
    Assert.areEqual('later', options[1].choice);
    Assert.areEqual(
      3600000L,
      options[1].instantValue.getTime() - options[0].instantValue.getTime()
    );
    Assert.areEqual(3600, options[0].offsetSeconds);
    Assert.areEqual(0, options[1].offsetSeconds);
    ChronoPickerOption normal = ChronoPickerController.resolveLocal(
      '2026-09-06',
      '12:34:56.789',
      'Asia/Kathmandu'
    )[0];
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 9, 6, 6, 49, 56).getTime() + 789,
      normal.instantValue.getTime()
    );
    Assert.areEqual(
      normal.localValue,
      ChronoPickerController.projectInstant(
          normal.instantValue,
          'Asia/Kathmandu'
        )
        .localValue
    );
    Assert.isTrue(
      ChronoPickerController.getTimeZones().contains('Europe/London')
    );
  }
  @IsTest
  static void gapBoundariesMatchTemporalPrecision() {
    Assert.areEqual(
      0,
      ChronoZoneResolver.resolve(
          Date.newInstance(2026, 3, 29),
          Time.newInstance(1, 30, 0, 0),
          'Europe/London'
        )
        .size(),
      'Core resolution still rejects the gap'
    );
    boundary(
      '2026-03-29',
      '01:30',
      'Europe/London',
      '2026-03-29T00:59:59.999',
      '2026-03-29T02:00:00.000'
    );
    boundary(
      '2026-10-04',
      '02:15',
      'Australia/Lord_Howe',
      '2026-10-04T01:59:59.999',
      '2026-10-04T02:30:00.000'
    );
    boundary(
      '2011-12-30',
      '12:00',
      'Pacific/Apia',
      '2011-12-29T23:59:59.999',
      '2011-12-31T00:00:00.000'
    );
  }
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Input triple and two independently specified expected boundaries.
  private static void boundary(
    String day,
    String clockValue,
    String zone,
    String before,
    String after
  ) {
    List<ChronoPickerOption> values = ChronoPickerController.resolveLocal(
      day,
      clockValue,
      zone
    );
    Assert.areEqual(before, values[0].localValue);
    Assert.areEqual(after, values[1].localValue);
    Assert.areEqual('backward', values[0].choice);
    Assert.areEqual('forward', values[1].choice);
    Assert.areEqual(
      1L,
      values[1].instantValue.getTime() - values[0].instantValue.getTime()
    );
  }
  @IsTest
  static void invalidInputCannotNormalise() {
    for (String day : new List<String>{ '2026-02-29', '2026-13-01' }) {
      try {
        ChronoPickerController.resolveLocal(day, '12:00', 'UTC');
        Assert.fail('Invalid calendar date');
      } catch (Exception expected) {
        Assert.isNotNull(expected.getMessage());
      }
    }
    try {
      ChronoPickerController.resolveLocal(
        '2026-09-06',
        '12:00',
        'Imaginary/Zone'
      );
      Assert.fail('Unknown zone');
    } catch (ChronoException expected) {
      Assert.isTrue(expected.getMessage().contains('Unknown'));
    }
  }
  @IsTest
  static void nativeRecordsNeedNeitherIdsNorQueries() {
    OperatingHours hours = new OperatingHours(
      Name = 'Unsaved support',
      TimeZone = 'Europe/London'
    );
    List<TimeSlot> slots = weekdays();
    List<Holiday> holidays = bankHoliday();
    Datetime friday = Datetime.newInstanceGmt(2026, 8, 28, 15, 30, 0);
    Datetime tuesday = Datetime.newInstanceGmt(2026, 9, 1, 8, 30, 0);
    Integer queries = Limits.getQueries();
    Integer dml = Limits.getDmlStatements();
    ChronoZonedDateTime source = ChronoZonedDateTimeService.create(
      friday,
      'Europe/London'
    );
    Assert.areEqual(
      tuesday,
      ChronoZonedDateTimeService.toDatetime(
        ChronoZonedDateTimeService.addHours(source, 1, hours, slots, holidays)
      )
    );
    Assert.areEqual(
      tuesday,
      ChronoZonedDateTimeService.toDatetime(
        ChronoZonedDateTimeService.addHours(source, 1, hours, slots, holidays)
      )
    );
    Assert.areEqual(
      tuesday,
      ChronoZonedDateTimeService.toDatetime(
        ChronoZonedDateTimeService.addHours(
          friday,
          'Europe/London',
          1,
          hours,
          slots,
          holidays
        )
      )
    );
    Assert.areEqual(
      tuesday,
      ChronoZonedDateTimeService.toDatetime(
        ChronoZonedDateTimeService.addMinutes(
          source,
          60,
          hours,
          slots,
          holidays
        )
      )
    );
    Assert.areEqual(
      tuesday,
      ChronoZonedDateTimeService.toDatetime(
        ChronoZonedDateTimeService.addMinutes(
          source,
          60,
          hours,
          slots,
          holidays
        )
      )
    );
    Assert.areEqual(
      tuesday,
      ChronoZonedDateTimeService.toDatetime(
        ChronoZonedDateTimeService.addMinutes(
          friday,
          'Europe/London',
          60,
          hours,
          slots,
          holidays
        )
      )
    );
    Assert.areEqual(queries, Limits.getQueries());
    Assert.areEqual(dml, Limits.getDmlStatements());
    Assert.isNull(hours.Id);
  }
  @IsTest
  static void closedHoursSuggestNearestOpenAndRespectDisplayZone() {
    ChronoPickerAvailability result = ChronoPickerSchedules.checkSupplied(
      new OperatingHours(Name = 'Support', TimeZone = 'Europe/London'),
      weekdays(),
      bankHoliday(),
      null,
      Datetime.newInstanceGmt(2026, 8, 31, 12, 0, 0),
      'America/New_York'
    );
    Assert.isFalse(result.isOpen);
    Assert.areEqual('Europe/London', result.timeZoneId);
    Assert.areEqual('2026-08-28T11:59:59.999', result.choices[0].localValue);
    Assert.areEqual('2026-09-01T04:00:00.000', result.choices[1].localValue);
    Assert.areEqual('previousOpen', result.choices[0].choice);
    Assert.areEqual('nextOpen', result.choices[1].choice);
    ChronoPickerAvailability dateResult = ChronoPickerSchedules.checkSupplied(
      new OperatingHours(TimeZone = 'Europe/London'),
      weekdays(),
      bankHoliday(),
      Date.newInstance(2026, 8, 31),
      null,
      'UTC'
    );
    Assert.areEqual(Date.newInstance(2026, 8, 28), dateResult.previousDate);
    Assert.areEqual(Date.newInstance(2026, 9, 1), dateResult.nextDate);
  }
  @IsTest
  static void openingInclusiveClosingExclusiveAndPartialHoliday() {
    OperatingHours hours = new OperatingHours(TimeZone = 'UTC');
    List<Holiday> holidays = new List<Holiday>{
      new Holiday(
        ActivityDate = Date.newInstance(2026, 9, 7),
        IsAllDay = false,
        StartTimeInMinutes = 720,
        EndTimeInMinutes = 780
      )
    };
    Assert.isTrue(
      ChronoPickerSchedules.checkSupplied(
          hours,
          weekdays(),
          holidays,
          null,
          Datetime.newInstanceGmt(2026, 9, 7, 9, 0, 0),
          'UTC'
        )
        .isOpen
    );
    ChronoPickerAvailability lunch = ChronoPickerSchedules.checkSupplied(
      hours,
      weekdays(),
      holidays,
      null,
      Datetime.newInstanceGmt(2026, 9, 7, 12, 30, 0),
      'UTC'
    );
    Assert.isFalse(lunch.isOpen);
    Assert.areEqual('2026-09-07T11:59:59.999', lunch.choices[0].localValue);
    Assert.areEqual('2026-09-07T13:00:00.000', lunch.choices[1].localValue);
    Assert.isFalse(
      ChronoPickerSchedules.checkSupplied(
          hours,
          weekdays(),
          holidays,
          null,
          Datetime.newInstanceGmt(2026, 9, 7, 17, 0, 0),
          'UTC'
        )
        .isOpen
    );
  }
  @IsTest
  static void overlappingSuppliedSlotsDoNotDoubleCount() {
    List<TimeSlot> slots = weekdays();
    slots.add(
      new TimeSlot(
        DayOfWeek = 'Monday',
        StartTime = Time.newInstance(12, 0, 0, 0),
        EndTime = Time.newInstance(16, 0, 0, 0)
      )
    );
    Datetime start = Datetime.newInstanceGmt(2026, 9, 7, 9, 0, 0);
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 9, 8, 10, 0, 0),
      ChronoZonedDateTimeService.toDatetime(
        ChronoZonedDateTimeService.addHours(
          start,
          'UTC',
          9,
          new OperatingHours(TimeZone = 'UTC'),
          slots,
          new List<Holiday>()
        )
      )
    );
  }
  @IsTest
  static void nativeTimeSlotTransportPreservesTime() {
    TimeSlot transported = (TimeSlot) JSON.deserialize(
      '{"DayOfWeek":"Monday","StartTime":32400000,"EndTime":61200000}',
      TimeSlot.class
    );
    Assert.areEqual(
      Time.newInstance(9, 0, 0, 0),
      transported.StartTime,
      'The LWC bridge uses native Time field JSON format'
    );
  }
  @IsTest
  static void savedScheduleSelectionUsesAllowlistAndBoundFilters() {
    OperatingHours london = new OperatingHours(
      Name = 'Support',
      TimeZone = 'Europe/London'
    );
    OperatingHours other = new OperatingHours(Name = 'Other', TimeZone = 'GMT');
    insert new List<OperatingHours>{ london, other };
    List<TimeSlot> slots = weekdays();
    for (TimeSlot slot : slots) {
      slot.OperatingHoursId = london.Id;
    }
    insert slots;
    String filter = '{"criteria":[{"fieldPath":"TimeZone","operator":"eq","value":"Europe/London"}]}';
    Assert.areEqual(
      2,
      ChronoPickerSchedules.searchHours(null, new List<Id>(), null, false)
        .size(),
      'Explicit unrestricted search survives null-list transport'
    );
    Assert.areEqual(
      0,
      ChronoPickerSchedules.searchHours(null, null, null, true).size(),
      'Missing restricted IDs deny all'
    );
    Assert.areEqual(
      0,
      ChronoPickerSchedules.searchHours(null, null, null, null).size(),
      'Missing mode never broadens access'
    );
    Assert.areEqual(
      1,
      ChronoPickerSchedules.searchHours(null, null, filter, false).size()
    );
    Assert.areEqual(
      0,
      ChronoPickerSchedules.searchHours(null, new List<Id>(), null, true).size()
    );
    Assert.areEqual(
      0,
      ChronoPickerSchedules.searchHours('\' OR Name != \'', null, null, false)
        .size()
    );
    Assert.isTrue(
      ChronoPickerSchedules.checkHours(
          london.Id,
          Date.newInstance(2026, 9, 7),
          null,
          'UTC',
          new List<Id>{ london.Id },
          filter,
          true
        )
        .isOpen
    );
    try {
      ChronoPickerSchedules.checkHours(
        other.Id,
        Date.newInstance(2026, 9, 7),
        null,
        'UTC',
        new List<Id>{ london.Id },
        null,
        true
      );
      Assert.fail('Allowlist enforced');
    } catch (ChronoException expected) {
      Assert.isTrue(expected.getMessage().contains('outside'));
    }
  }
  private static List<TimeSlot> weekdays() {
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
          StartTime = Time.newInstance(9, 0, 0, 0),
          EndTime = Time.newInstance(17, 0, 0, 0),
          Type = 'Normal'
        )
      );
    }
    return result;
  }
  @IsTest
  static void savedSchedulesEnforceReadPermissions() {
    Profile minimal = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Minimum Access - Salesforce'
      LIMIT 1
    ];
    User restricted = new User(
      Alias = 'cpicker',
      Email = 'picker@example.invalid',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Picker',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      TimeZoneSidKey = 'Europe/London',
      ProfileId = minimal.Id,
      Username = 'chrono-picker-' +
        UserInfo.getOrganizationId() +
        '@example.invalid'
    );
    System.runAs(restricted) {
      try {
        ChronoPickerSchedules.searchHours(null, null, null, false);
        Assert.fail('Saved-schedule reads require object and field access');
      } catch (QueryException expected) {
        Assert.isNotNull(expected.getMessage());
      }
      Integer queries = Limits.getQueries();
      ChronoPickerAvailability supplied = ChronoPickerSchedules.checkSupplied(
        new OperatingHours(TimeZone = 'Europe/London'),
        weekdays(),
        null,
        Date.newInstance(2026, 9, 7),
        null,
        'UTC'
      );
      Assert.isTrue(
        supplied.isOpen,
        'Unsaved native values need no schedule-read permission'
      );
      Assert.areEqual(queries, Limits.getQueries());
    }
  }
  private static List<Holiday> bankHoliday() {
    return new List<Holiday>{
      new Holiday(
        ActivityDate = Date.newInstance(2026, 8, 31),
        IsAllDay = true,
        IsRecurrence = false
      )
    };
  }
}
