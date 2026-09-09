Flow.Interview probe = Flow.Interview.createInterview(
  'ChronoInstalledCoreProbe',
  new Map<String, Object>()
);
probe.start();
String observed = (String) probe.getVariableValue('Answer');
System.debug(LoggingLevel.ERROR, 'CHRONO_INSTALLED_CORE_RESULTS=' + observed);
Map<String, Object> values = (Map<String, Object>) JSON.deserializeUntyped(
  observed
);
Assert.areEqual(
  8,
  values.size(),
  'Every installed core type must survive the Flow variable and action boundary.'
);
Assert.areEqual('2026-10-25', values.get('dateValue'), 'Date preserved.');
Assert.areEqual(
  '01:30:00.000',
  values.get('timeValue'),
  'Native time backing preserved.'
);
Assert.areEqual(
  '2026-10-25T01:30:00.000',
  values.get('dateTimeValue'),
  'Local datetime preserved.'
);
Assert.areEqual(
  '2026-10-25T00:30:00.000Z',
  values.get('instantValue'),
  'Instant preserved.'
);
Assert.areEqual(
  '2026-10-25T01:30:00.000+01:00[Europe/London]',
  values.get('zonedValue'),
  'Zone and offset preserved.'
);
Assert.areEqual(
  '2026-10',
  values.get('yearMonthValue'),
  'Year/month preserved.'
);
Assert.areEqual('--10-25', values.get('monthDayValue'), 'Month/day preserved.');
Assert.areEqual(
  'P1M2DT3.000S',
  values.get('durationValue'),
  'Duration preserved.'
);
