// Requires the London and New York schedules from the Chrono example setup.
// Read-only subscriber check: 200 calculations, independent nested values and one invalid item.
List<OperatingHours> schedules = [
  SELECT Id, Name, TimeZone
  FROM OperatingHours
  WHERE
    Name IN ('Chrono demo - London weekdays', 'Chrono demo - New York weekdays')
  ORDER BY Name
];
Assert.areEqual(2, schedules.size());
List<skel.ChronoWorkingTimeInput> requests = new List<skel.ChronoWorkingTimeInput>();
for (Integer i = 0; i < 200; i++) {
  skel.ChronoWorkingTimeInput request = new skel.ChronoWorkingTimeInput();
  request.startValue =
    '2026-09-08T09:00:00.000' +
    (Math.mod(i, 2) == 0
      ? '+01:00[Europe/London]'
      : '-04:00[America/New_York]');
  request.timeZoneId = schedules[Math.mod(i, 2)].TimeZone;
  request.scheduleType = 'OperatingHours';
  request.scheduleId = schedules[Math.mod(i, 2)].Id;
  request.amount = Math.mod(i, 30);
  request.unit = 'minutes';
  if (Math.mod(i, 2) == 0) {
    request.startValue = null;
    request.startInstant = Datetime.newInstanceGmt(2026, 9, 8, 8, 0, 0);
  }
  requests.add(request);
}
requests.add(null);
Assert.areEqual(0, skel.ChronoWorkingTimeService.add(null).size());
Assert.areEqual(
  0,
  skel.ChronoWorkingTimeService.add(new List<skel.ChronoWorkingTimeInput>())
    .size()
);
List<skel.ChronoWorkingTimeResult> results = skel.ChronoWorkingTimeService.add(
  requests
);
Assert.areEqual(201, results.size());
for (Integer i = 0; i < 200; i++) {
  Assert.areEqual(Math.mod(i, 30), requests[i].amount);
  Assert.areEqual('minutes', requests[i].unit);
  Assert.areEqual('OperatingHours', requests[i].scheduleType);
  Assert.areEqual(
    String.valueOf(schedules[Math.mod(i, 2)].Id),
    requests[i].scheduleId
  );
  Assert.areEqual(schedules[Math.mod(i, 2)].TimeZone, requests[i].timeZoneId);
  if (Math.mod(i, 2) == 0) {
    Assert.isNull(requests[i].startValue);
    Assert.areEqual(
      Datetime.newInstanceGmt(2026, 9, 8, 8, 0, 0),
      requests[i].startInstant
    );
  } else {
    Assert.isNull(requests[i].startInstant);
    Assert.areEqual(
      '2026-09-08T09:00:00.000-04:00[America/New_York]',
      requests[i].startValue
    );
  }
  Assert.isTrue(
    results[i].success,
    'Item ' + i + ': ' + results[i].errorMessage
  );
  Datetime start = Math.mod(i, 2) == 0
    ? Datetime.newInstanceGmt(2026, 9, 8, 8, 0, 0)
    : Datetime.newInstanceGmt(2026, 9, 8, 13, 0, 0);
  Assert.areEqual(start.addMinutes(Math.mod(i, 30)), results[i].value.instant);
  Assert.areEqual(
    schedules[Math.mod(i, 2)].TimeZone,
    results[i].value.timeZoneId
  );
}
Assert.isFalse(results[200].success);
Assert.isNull(results[200].value);
Assert.isNotNull(results[200].errorMessage);
Datetime duplicateInstant = results[30].value.instant;
results[0].value.instant = duplicateInstant.addDays(1);
results[0].value.timeZoneId = 'Pacific/Auckland';
results[0].success = false;
Assert.areEqual(duplicateInstant, results[30].value.instant);
Assert.areEqual('Europe/London', results[30].value.timeZoneId);
Assert.isTrue(results[30].success);
System.debug(
  'PASS: 200 inputs, two schedules/zones, ordered results, isolated invalid input, independent duplicate results.'
);
