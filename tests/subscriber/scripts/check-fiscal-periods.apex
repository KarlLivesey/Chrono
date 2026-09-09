// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
// Requires the ChronoFiscalPeriodHarness fixture and a configured fiscal year covering today.
List<Period> periods = [
  SELECT
    Id,
    Type,
    StartDate,
    EndDate,
    Number,
    FullyQualifiedLabel,
    FiscalYearSettings.Name
  FROM Period
  WHERE StartDate <= TODAY AND EndDate >= TODAY
];
Assert.areEqual(
  3,
  periods.size(),
  'Expected configured year, quarter and month'
);
for (Period row : periods) {
  Flow.Interview interview = Flow.Interview.createInterview(
    'ChronoFiscalPeriodHarness',
    new Map<String, Object>{
      'valueType' => 'PlainDate',
      'dateValue' => Date.today(),
      'calendarSource' => 'organisation',
      'period' => row.Type.toLowerCase()
    }
  );
  interview.start();
  Assert.areEqual(
    true,
    interview.getVariableValue('output_success'),
    'Fiscal action must succeed: ' +
    interview.getVariableValue('output_errorMessage')
  );
  Assert.areEqual(row.Id, interview.getVariableValue('output_periodId'));
  Assert.areEqual(
    row.StartDate,
    interview.getVariableValue('output_startDate')
  );
  Assert.areEqual(row.EndDate, interview.getVariableValue('output_lastDate'));
  Assert.areEqual(
    row.FullyQualifiedLabel,
    interview.getVariableValue('output_label')
  );
}
System.debug(
  'Verified actual Salesforce fiscal year, quarter and month through Flow.'
);
