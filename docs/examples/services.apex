// Chrono 0.1.0.19 subscriber examples. No queries or DML.
// Run: sf apex run --target-org your-org --file services.apex
skel.ChronoPlainDate january = skel.ChronoPlainDateService.parseIso(
  '2026-01-31'
);
skel.ChronoPlainDate february = skel.ChronoPlainDateService.addMonths(
  january,
  1
);
Assert.areEqual(Date.newInstance(2026, 2, 28), february.value);
Assert.areEqual(Date.newInstance(2026, 1, 31), january.value);

skel.ChronoZonedDateTime beforeClockChange = skel.ChronoZonedDateTimeService.parseIso(
  '2026-03-28T12:00:00.000+00:00[Europe/London]'
);
skel.ChronoZonedDateTime calendarDay = skel.ChronoZonedDateTimeService.addDays(
  beforeClockChange,
  1
);
skel.ChronoZonedDateTime elapsedDay = skel.ChronoZonedDateTimeService.addHours(
  beforeClockChange,
  24
);
Assert.areEqual(
  '2026-03-29T12:00:00.000+01:00[Europe/London]',
  skel.ChronoZonedDateTimeService.toIsoString(calendarDay)
);
Assert.areEqual(
  '2026-03-29T13:00:00.000+01:00[Europe/London]',
  skel.ChronoZonedDateTimeService.toIsoString(elapsedDay)
);
Assert.areEqual(
  23 * 3600000L,
  skel.ChronoZonedDateTimeService.elapsedDifference(
      beforeClockChange,
      calendarDay
    )
    .milliseconds
);

skel.ChronoPlainDateTime repeated = skel.ChronoPlainDateTimeService.parseIso(
  '2026-10-25T01:30'
);
skel.ChronoZonedDateTime first = skel.ChronoPlainDateTimeService.toZonedDateTime(
  repeated,
  'Europe/London',
  'earlier'
);
skel.ChronoZonedDateTime second = skel.ChronoPlainDateTimeService.toZonedDateTime(
  repeated,
  'Europe/London',
  'later'
);
Assert.areEqual(3600000L, second.instant.getTime() - first.instant.getTime());
Assert.areEqual(
  Datetime.newInstanceGmt(2026, 10, 25, 1, 30, 0),
  second.instant
);
Boolean gapRejected = false;
try {
  skel.ChronoPlainDateTimeService.toZonedDateTime(
    skel.ChronoPlainDateTimeService.parseIso('2026-03-29T01:30'),
    'Europe/London'
  );
} catch (skel.ChronoException ex) {
  gapRejected = true;
}
Assert.isTrue(
  gapRejected,
  'A nonexistent local time must not produce an instant.'
);

skel.ChronoDuration precise = skel.ChronoDurationService.parseIso(
  'PT7.987654321S'
);
Assert.areEqual(7987L, skel.ChronoDurationService.toMilliseconds(precise));
Assert.areEqual(
  0L,
  skel.ChronoDurationService.toMilliseconds(
    skel.ChronoDurationService.parseIso('-PT0.0009S')
  )
);

OperatingHours hours = new OperatingHours(TimeZone = 'Europe/London');
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
      DayOfWeek = day,
      Type = 'Normal',
      StartTime = Time.newInstance(9, 0, 0, 0),
      EndTime = Time.newInstance(17, 0, 0, 0)
    )
  );
}
List<Holiday> holidays = new List<Holiday>{
  new Holiday(ActivityDate = Date.newInstance(2026, 8, 31), IsAllDay = true)
};
skel.ChronoZonedDateTime friday = skel.ChronoZonedDateTimeService.parseIso(
  '2026-08-28T16:30:00.000+01:00[Europe/London]'
);
Integer queriesBefore = Limits.getQueries();
skel.ChronoZonedDateTime tuesday = skel.ChronoZonedDateTimeService.addHours(
  friday,
  1,
  hours,
  slots,
  holidays
);
Assert.areEqual(queriesBefore, Limits.getQueries());
Assert.areEqual(
  '2026-09-01T09:30:00.000+01:00[Europe/London]',
  skel.ChronoZonedDateTimeService.toIsoString(tuesday)
);

skel.ChronoTimeAllocationRequest request = new skel.ChronoTimeAllocationRequest();
request.startInstant = Datetime.newInstanceGmt(2026, 9, 7, 7, 0, 0);
request.endInstant = Datetime.newInstanceGmt(2026, 9, 7, 11, 0, 0);
request.timeZoneId = 'Europe/London';
request.blocks = new List<skel.ChronoTimeBlock>();
List<String> starts = new List<String>{ '08:00', '10:00', '11:00' };
List<String> ends = new List<String>{ '10:00', '11:00', '15:00' };
for (Integer i = 0; i < 3; i++) {
  skel.ChronoTimeBlock block = new skel.ChronoTimeBlock();
  block.key = 'block' + i;
  block.startTime = starts[i];
  block.endTime = ends[i];
  request.blocks.add(block);
}
skel.ChronoTimeAllocationResult allocation = skel.ChronoTimeAllocationService.allocate(
  request
);
Assert.areEqual(7200000L, allocation.totals[0].allocatedMilliseconds);
Assert.areEqual(3600000L, allocation.totals[1].allocatedMilliseconds);
Assert.areEqual(3600000L, allocation.totals[2].allocatedMilliseconds);
Assert.areEqual(
  allocation.inputMilliseconds + allocation.duplicateMilliseconds,
  allocation.allocatedMilliseconds +
    allocation.unallocatedMilliseconds +
    allocation.roundingMilliseconds
);
Assert.areEqual(0, Limits.getDmlStatements());
System.debug('Chrono documentation examples passed.');
