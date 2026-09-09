// Exercises deployed Flow assignments and explicit Apex-defined collections.
Flow.Interview interview = Flow.Interview.createInterview(
  'ChronoVariableAssignments',
  new Map<String, Object>()
);
interview.start();
Map<String, Object> actual = (Map<String, Object>) JSON.deserializeUntyped(
  (String) interview.getVariableValue('Answer')
);
Map<String, List<String>> expected = new Map<String, List<String>>{
  'date' => new List<String>{ '2026-10-25', '2026-10-26' },
  'time' => new List<String>{ '01:30:00.000', '02:45:00.000' },
  'local' => new List<String>{
    '2026-10-25T01:30:00.000',
    '2026-10-25T02:45:00.000'
  },
  'instant' => new List<String>{
    '2026-10-25T00:30:00.000Z',
    '2026-10-25T02:45:00.000Z'
  },
  'zoned' => new List<String>{
    '2026-10-25T01:30:00.000+01:00[Europe/London]',
    '2026-10-25T02:45:00.000+00:00[Europe/London]'
  },
  'yearMonth' => new List<String>{ '2026-10', '2026-11' },
  'monthDay' => new List<String>{ '--10-25', '--11-26' },
  'duration' => new List<String>{ 'P1M2DT3.000S', 'P1M3DT3.000S' }
};
Assert.areEqual(8, actual.size());
for (String kind : expected.keySet()) {
  List<Object> observed = (List<Object>) actual.get(kind);
  Assert.areEqual(2, observed.size(), kind + ' collection size');
  Assert.areEqual(
    expected.get(kind)[0],
    observed[0],
    kind + ' first value preserved after source edit'
  );
  Assert.areEqual(expected.get(kind)[1], observed[1], kind + ' second value');
}
System.debug(
  LoggingLevel.ERROR,
  'PASS: all eight field-assigned values and ordered independent collection entries'
);
// Report negative observations separately: accepting an invalid value is a defect,
// not a supported contract that this fixture should permanently assert.
Flow.Interview invalid = Flow.Interview.createInterview(
  'ChronoVariableInvalidAssignments',
  new Map<String, Object>()
);
invalid.start();
System.debug(
  LoggingLevel.ERROR,
  'INVALID_ASSIGNMENT_OBSERVATIONS=' + invalid.getVariableValue('Answer')
);
Boolean constructorRejected = false;
try {
  new skel.ChronoDuration(1, -2, 3000L);
} catch (Exception error) {
  constructorRejected = true;
}
Assert.isTrue(
  constructorRejected,
  'The normal constructor must reject a mixed-sign duration.'
);
