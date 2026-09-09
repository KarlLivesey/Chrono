// Uses the deployed scalar-input/output Flow, including its actual Chrono action.
List<String> types = new List<String>{
  'PlainDate',
  'PlainTime',
  'PlainDateTime',
  'Instant',
  'ZonedDateTime',
  'PlainYearMonth',
  'PlainMonthDay',
  'Duration'
};
List<String> supplied = new List<String>{
  '2026-10-25',
  '23:59:59.999999999',
  '2026-12-31T23:59:59.999999999',
  '2021-01-13T20:57:01.500944804Z',
  '1995-12-07T03:24:30.0000035-08:00[America/Los_Angeles]',
  '2026-10',
  '--10-25',
  'P1Y2M3W4DT5H6M7.987654321S'
};
List<String> expected = new List<String>{
  '2026-10-25',
  '23:59:59.999',
  '2026-12-31T23:59:59.999',
  '2021-01-13T20:57:01.500Z',
  '1995-12-07T03:24:30.000-08:00[America/Los_Angeles]',
  '2026-10',
  '--10-25',
  'P14M25DT18367.987S'
};
for (Integer i = 0; i < types.size(); i++) {
  Flow.Interview interview = Flow.Interview.createInterview(
    'ChronoConvertHarness',
    new Map<String, Object>{ 'valueType' => types[i], 'value' => supplied[i] }
  );
  interview.start();
  Assert.areEqual(
    true,
    interview.getVariableValue('success'),
    'Conversion failed: ' + interview.getVariableValue('errorMessage')
  );
  Assert.areEqual(
    expected[i],
    interview.getVariableValue('valueResult'),
    types[i]
  );
  System.debug(
    LoggingLevel.ERROR,
    'PASS ' + types[i] + ': ' + interview.getVariableValue('valueResult')
  );
}
Flow.Interview invalid = Flow.Interview.createInterview(
  'ChronoConvertHarness',
  new Map<String, Object>{ 'valueType' => 'Duration', 'value' => 'P1M-2DT3S' }
);
invalid.start();
Assert.areEqual(
  false,
  invalid.getVariableValue('success'),
  'Mixed-sign ISO duration must be rejected'
);
Assert.isNotNull(
  invalid.getVariableValue('errorMessage'),
  'Admin must receive a diagnostic'
);
