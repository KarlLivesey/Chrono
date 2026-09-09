// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
// Uses actual subscriber fiscal periods and requires Chrono 0.2 bulk Apex services.
List<Period> periods = [
  SELECT Id, Type, StartDate, EndDate, FullyQualifiedLabel
  FROM Period
  WHERE StartDate <= TODAY AND EndDate >= TODAY
];
Assert.areEqual(
  3,
  periods.size(),
  'Configure the current fiscal year, quarter and month'
);
List<skel.ChronoFiscalPeriodInput> requests = new List<skel.ChronoFiscalPeriodInput>();
for (Integer i = 0; i < 200; i++) {
  skel.ChronoFiscalPeriodInput input = new skel.ChronoFiscalPeriodInput();
  input.valueType = 'PlainDate';
  input.dateValue = Date.today();
  input.calendarSource = 'organisation';
  input.period = periods[Math.mod(i, 3)].Type.toLowerCase();
  requests.add(input);
}
List<skel.ChronoFiscalResult> results = skel.ChronoFiscalPeriodService.resolve(
  requests
);
Assert.areEqual(200, results.size());
for (Integer i = 0; i < 200; i++) {
  Period expected = periods[Math.mod(i, 3)];
  Assert.isTrue(
    results[i].success,
    'Fiscal request ' + i + ': ' + results[i].errorMessage
  );
  Assert.areEqual(expected.Id, results[i].periodId);
  Assert.areEqual(expected.StartDate, results[i].startDate);
  Assert.areEqual(expected.EndDate.addDays(1), results[i].endExclusiveDate);
  Assert.areEqual(expected.FullyQualifiedLabel, results[i].label);
}
results[0].label = 'Changed by caller';
Assert.areEqual(periods[0].FullyQualifiedLabel, results[3].label);
System.debug(
  'PASS: 200 direct Apex fiscal requests match the subscriber year, quarter and month.'
);
