// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
@IsTest
private class ChronoAvailabilityTest {
  private static ChronoAvailabilityInput input() {
    ChronoAvailabilityInput value = new ChronoAvailabilityInput();
    value.operation = 'windows';
    value.valueType = 'ZonedDateTime';
    value.value = '2026-08-28T16:30+01:00[Europe/London]';
    value.endValue = '2026-09-01T10:00+01:00[Europe/London]';
    value.operatingHours = new OperatingHours(
      Name = 'London',
      TimeZone = 'Europe/London'
    );
    value.timeSlots = new List<TimeSlot>();
    for (
      String day : new List<String>{
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday'
      }
    ) {
      value.timeSlots.add(
        new TimeSlot(
          DayOfWeek = day,
          StartTime = Time.newInstance(9, 0, 0, 0),
          EndTime = Time.newInstance(17, 0, 0, 0)
        )
      );
    }
    value.holidays = new List<Holiday>{
      new Holiday(
        Name = 'Bank holiday',
        ActivityDate = Date.newInstance(2026, 8, 31),
        IsAllDay = true
      )
    };
    return value;
  }
  private static ChronoAvailabilityResult run(ChronoAvailabilityInput input) {
    ChronoAvailabilityResult result = (ChronoAvailabilityResult) new ChronoCatalogueBatch(
        'Availability'
      )
      .run(new List<Object>{ input })[0];
    Assert.isTrue(
      result.success,
      result.errorMessage == null ? 'Expected success' : result.errorMessage
    );
    return result;
  }
  @IsTest
  static void unsavedWindowsHolidayAndContinuousTime() {
    ChronoAvailabilityInput value = input();
    Test.startTest();
    Integer queries = Limits.getQueries();
    ChronoAvailabilityResult result = run(value);
    Assert.areEqual(
      queries,
      Limits.getQueries(),
      'Supplied records need no queries'
    );
    Test.stopTest();
    Assert.areEqual(2, result.ranges.size());
    Assert.areEqual(90 * 60000L, result.milliseconds);
    Assert.isFalse(result.containsRange);
    value.operation = 'continuous';
    value.duration = 'PT1H';
    result = run(value);
    Assert.areEqual(
      '2026-09-01T09:00:00.000+01:00[Europe/London]',
      result.openingValues[0]
    );
    value.operation = 'holidays';
    result = run(value);
    Assert.areEqual(
      new List<Date>{ Date.newInstance(2026, 8, 31) },
      result.holidayDates
    );
    Assert.areEqual('Bank holiday', result.holidayRecords[0].Name);
  }
  @IsTest
  static void appointmentChoicesExcludeBusyTimesAndUseScheduleZone() {
    ChronoAvailabilityInput value = input();
    value.value = '2026-09-01T03:00-04:00[America/New_York]';
    value.endValue = '2026-09-01T06:00-04:00[America/New_York]';
    value.operation = 'appointments';
    value.duration = 'PT30M';
    value.stepDuration = 'PT30M';
    value.busyRangesText = '2026-09-01T08:30Z/2026-09-01T09:00Z';
    ChronoAvailabilityResult result = run(value);
    Assert.areEqual(3, result.ranges.size());
    Assert.areEqual(
      '2026-09-01T04:00:00.000-04:00[America/New_York]',
      result.openingValues[0]
    );
    Assert.areEqual(
      '2026-09-01T05:00:00.000-04:00[America/New_York]',
      result.openingValues[1]
    );
    value.operation = 'containsRange';
    value.value = '2026-09-01T04:00-04:00[America/New_York]';
    value.endValue = '2026-09-01T04:30-04:00[America/New_York]';
    value.busyRangesText = null;
    Assert.isTrue(run(value).containsRange);
  }
  @IsTest
  static void allAndAnySchedulesAreBulkLoadedAcrossInterviews() {
    List<OperatingHours> hours = new List<OperatingHours>{
      new OperatingHours(Name = 'London', TimeZone = 'Europe/London'),
      new OperatingHours(Name = 'New York', TimeZone = 'America/New_York')
    };
    insert hours;
    List<TimeSlot> slots = new List<TimeSlot>();
    for (OperatingHours schedule : hours) {
      slots.add(
        new TimeSlot(
          OperatingHoursId = schedule.Id,
          DayOfWeek = 'Tuesday',
          StartTime = Time.newInstance(9, 0, 0, 0),
          EndTime = Time.newInstance(17, 0, 0, 0)
        )
      );
    }
    insert slots;
    ChronoAvailabilityInput value = new ChronoAvailabilityInput();
    value.operation = 'shared';
    value.valueType = 'ZonedDateTime';
    value.value = '2026-09-01T00:00+01:00[Europe/London]';
    value.endValue = '2026-09-02T00:00+01:00[Europe/London]';
    value.operatingHoursId = hours[0].Id;
    value.otherOperatingHoursIds = new List<String>{ hours[1].Id };
    List<Object> requests = new List<Object>();
    for (Integer i = 0; i < 200; i++) {
      requests.add(value);
    }
    Test.startTest();
    Integer queries = Limits.getQueries();
    List<Object> results = new ChronoCatalogueBatch('Availability')
      .run(requests);
    Assert.areEqual(3, Limits.getQueries() - queries);
    Test.stopTest();
    ChronoAvailabilityResult first = (ChronoAvailabilityResult) results[0];
    Assert.isTrue(
      first.success,
      first.errorMessage == null ? 'Expected success' : first.errorMessage
    );
    Assert.areEqual(3 * 3600000L, first.milliseconds);
    first.ranges.clear();
    Assert.areEqual(1, ((ChronoAvailabilityResult) results[199]).ranges.size());
    value.operation = 'anySchedule';
    Assert.areEqual(13 * 3600000L, run(value).milliseconds);
  }
  @IsTest
  static void collectionsKeepFailuresAndValidationReportsInvalidSlots() {
    ChronoAvailabilityInput value = input();
    value.operation = 'validateSchedule';
    value.timeSlots[0].EndTime = value.timeSlots[0].StartTime;
    Assert.isFalse(run(value).isValid);
    ChronoAvailabilityCollectionAction.Request request = new ChronoAvailabilityCollectionAction.Request();
    request.items = new List<ChronoAvailabilityInput>{ input(), null, input() };
    ChronoAvailabilityCollectionResult result = ChronoAvailabilityCollectionAction.run(
      new List<ChronoAvailabilityCollectionAction.Request>{ request }
    )[0];
    Assert.isFalse(result.success);
    Assert.areEqual(3, result.results.size());
    result.results[0].openingValues.clear();
    Assert.areEqual(2, result.results[2].openingValues.size());
  }
  @IsTest
  static void bookingConstraintsRespectBusyBuffersNoticeAndOneGrid() {
    ChronoAvailabilityInput value = input();
    value.value = '2026-09-01T09:00+01:00[Europe/London]';
    value.endValue = '2026-09-01T17:00+01:00[Europe/London]';
    value.operation = 'appointments';
    value.duration = 'PT30M';
    value.stepDuration = 'PT30M';
    value.referenceInstant = Datetime.newInstanceGmt(2026, 9, 1, 8, 0, 0);
    value.minimumNotice = 'PT40M';
    value.bookingHorizon = 'PT4H';
    value.bufferBefore = 'PT10M';
    value.bufferAfter = 'PT15M';
    value.gridAnchor = value.referenceInstant;
    value.busyRangesText = '2026-09-01T09:00Z/2026-09-01T09:30Z';
    ChronoAvailabilityResult result = run(value);
    Assert.areEqual(
      new List<String>{
        '2026-09-01T11:00:00.000+01:00[Europe/London]',
        '2026-09-01T11:30:00.000+01:00[Europe/London]',
        '2026-09-01T12:00:00.000+01:00[Europe/London]',
        '2026-09-01T12:30:00.000+01:00[Europe/London]'
      },
      result.openingValues
    );
    value.referenceInstant = null;
    ChronoAvailabilityResult invalid = (ChronoAvailabilityResult) new ChronoCatalogueBatch(
        'Availability'
      )
      .run(new List<Object>{ value })[0];
    Assert.isFalse(invalid.success);
    Assert.isTrue(invalid.errorMessage.contains('Reference datetime'));
  }
  @IsTest
  static void gridWorksBeforeItsAnchorAndRejectsCalendarBuffers() {
    Assert.areEqual(
      1500L,
      ChronoBookingLimits.firstStart(1100L, 500L, Datetime.newInstance(2000L))
    );
    ChronoAvailabilityInput value = input();
    value.bufferBefore = 'P1D';
    ChronoAvailabilityResult invalid = (ChronoAvailabilityResult) new ChronoCatalogueBatch(
        'Availability'
      )
      .run(new List<Object>{ value })[0];
    Assert.isFalse(invalid.success);
  }
}
