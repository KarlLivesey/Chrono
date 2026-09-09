// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Subscriber proof of data-only field assignment and validated service operations. */
@IsTest
private class ChronoServiceConsumerTest {
  @IsTest
  static void assignCoreDataAcrossNamespace() {
    skel.ChronoPlainDateTime local = new skel.ChronoPlainDateTime();
    local.localDate = Date.newInstance(2026, 3, 28);
    local.localTime = Time.newInstance(12, 0, 0, 0);
    skel.ChronoZonedDateTime zoned = skel.ChronoPlainDateTimeService.toZonedDateTime(
      local,
      'Europe/London'
    );
    Assert.areEqual('Europe/London', zoned.timeZoneId);
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 3, 28, 12, 0, 0),
      zoned.instant
    );
    skel.ChronoZonedDateTime shifted = skel.ChronoZonedDateTimeService.addDays(
      zoned,
      1
    );
    Assert.areEqual(
      '2026-03-29T12:00:00.000+01:00[Europe/London]',
      skel.ChronoZonedDateTimeService.toIsoString(shifted)
    );
    shifted.timeZoneId = 'UTC';
    Assert.areEqual('Europe/London', zoned.timeZoneId);
  }
  @IsTest
  static void alteredDataCannotEnterArithmetic() {
    skel.ChronoDuration duration = skel.ChronoDurationService.parseIso(
      'P1DT1H'
    );
    duration.days = -1;
    try {
      skel.ChronoDurationService.toIsoString(duration);
      Assert.fail('Mixed signs must be rejected across the package boundary.');
    } catch (skel.ChronoException ex) {
      Assert.isTrue(ex.getMessage().contains('same sign'));
    }
    skel.ChronoZonedDateTime value = new skel.ChronoZonedDateTime();
    value.instant = Datetime.now();
    value.timeZoneId = 'Not/AZone';
    try {
      skel.ChronoZonedDateTimeService.addHours(value, 1);
      Assert.fail('Invalid zone must be rejected.');
    } catch (skel.ChronoException ex) {
      Assert.isTrue(ex.getMessage().contains('zone'));
    }
  }
  @IsTest
  static void workingDatesExecuteThroughScalarAndCollectionFlows() {
    OperatingHours hours = new OperatingHours(TimeZone = 'UTC');
    List<TimeSlot> slots = new List<TimeSlot>{
      new TimeSlot(
        DayOfWeek = 'Friday',
        StartTime = Time.newInstance(9, 0, 0, 0),
        EndTime = Time.newInstance(17, 0, 0, 0)
      ),
      new TimeSlot(
        DayOfWeek = 'Monday',
        StartTime = Time.newInstance(9, 0, 0, 0),
        EndTime = Time.newInstance(17, 0, 0, 0)
      ),
      new TimeSlot(
        DayOfWeek = 'Tuesday',
        StartTime = Time.newInstance(9, 0, 0, 0),
        EndTime = Time.newInstance(17, 0, 0, 0)
      )
    };
    List<Holiday> holidays = new List<Holiday>{
      new Holiday(ActivityDate = Date.newInstance(2026, 8, 31), IsAllDay = true)
    };
    Flow.Interview scalar = Flow.Interview.createInterview(
      'ChronoWorkingDaysHarness',
      new Map<String, Object>{
        'valueType' => 'PlainDate',
        'dateValue' => Date.newInstance(2026, 8, 28),
        'amount' => 1,
        'operatingHours' => hours,
        'timeSlots' => slots,
        'holidays' => holidays
      }
    );
    scalar.start();
    Assert.areEqual(
      true,
      scalar.getVariableValue('output_success'),
      String.valueOf(scalar.getVariableValue('output_errorMessage')) ??
        'Expected successful working-date arithmetic.'
    );
    Assert.areEqual(
      Date.newInstance(2026, 9, 1),
      scalar.getVariableValue('output_dateValue')
    );
    skel.ChronoWorkingDaysInput input = new skel.ChronoWorkingDaysInput();
    input.valueType = 'PlainDate';
    input.dateValue = Date.newInstance(2026, 8, 28);
    input.amount = 1;
    input.operatingHours = hours;
    input.timeSlots = slots;
    input.holidays = holidays;
    Flow.Interview collection = Flow.Interview.createInterview(
      'ChronoWorkingDaysCollectionHarness',
      new Map<String, Object>{
        'items' => new List<skel.ChronoWorkingDaysInput>{ input, input }
      }
    );
    collection.start();
    List<skel.ChronoFlowResult> results = (List<skel.ChronoFlowResult>) collection.getVariableValue(
      'output_results'
    );
    Assert.areEqual(2, results.size());
    Assert.areEqual('2026-09-01', results[1].value);
    results[0].value = 'changed';
    Assert.areEqual('2026-09-01', results[1].value);
  }
  @IsTest
  static void appointmentLimitsCrossFlowNativeInputs() {
    Flow.Interview flow = Flow.Interview.createInterview(
      'ChronoAvailabilityHarness',
      new Map<String, Object>{
        'operation' => 'appointments',
        'valueType' => 'Instant',
        'instantValue' => Datetime.newInstanceGmt(2026, 9, 8, 9, 0, 0),
        'endInstant' => Datetime.newInstanceGmt(2026, 9, 8, 12, 0, 0),
        'timeZoneId' => 'UTC',
        'operatingHours' => new OperatingHours(TimeZone = 'UTC'),
        'timeSlots' => new List<TimeSlot>{
          new TimeSlot(
            DayOfWeek = 'Tuesday',
            StartTime = Time.newInstance(9, 0, 0, 0),
            EndTime = Time.newInstance(17, 0, 0, 0)
          )
        },
        'duration' => 'PT30M',
        'stepDuration' => 'PT30M',
        'bufferBefore' => 'PT10M',
        'bufferAfter' => 'PT10M',
        'referenceInstant' => Datetime.newInstanceGmt(2026, 9, 8, 9, 0, 0),
        'minimumNotice' => 'PT40M',
        'bookingHorizon' => 'PT2H',
        'gridAnchor' => Datetime.newInstanceGmt(2026, 9, 8, 9, 0, 0)
      }
    );
    flow.start();
    Assert.areEqual(
      true,
      flow.getVariableValue('output_success'),
      String.valueOf(flow.getVariableValue('output_errorMessage')) ??
        'Expected available appointments.'
    );
    Assert.areEqual(
      new List<String>{
        '2026-09-08T10:00:00.000+00:00[UTC]',
        '2026-09-08T10:30:00.000+00:00[UTC]'
      },
      (List<String>) flow.getVariableValue('output_openingValues')
    );
  }
}
