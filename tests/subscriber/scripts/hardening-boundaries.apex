// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
// Read-only assertions against the installed managed package.
for (
  String value : new List<String>{
    '-P2147483648M',
    '-P2147483648D',
    'PT9223372036854775.807S',
    '-PT9223372036854775.808S'
  }
) {
  Assert.areEqual(
    value,
    skel.ChronoDurationService.toIsoString(
      skel.ChronoDurationService.parseIso(value)
    ),
    'Subscriber duration round trip'
  );
}
for (
  String value : new List<String>{
    'P2147483647Y',
    'P2147483647W',
    'PT9223372036854775.808S'
  }
) {
  Boolean rejected = false;
  try {
    skel.ChronoDurationService.parseIso(value);
  } catch (skel.ChronoException ex) {
    rejected = ex.getMessage().contains('range');
  }
  Assert.isTrue(rejected, 'Oversized duration must be rejected: ' + value);
}
skel.ChronoEpochValueAction.Request input = new skel.ChronoEpochValueAction.Request();
input.operation = 'fromEpoch';
input.epochUnit = 'millisecond';
input.epochValue = Decimal.valueOf('18446744073709551616');
Assert.isFalse(
  skel.ChronoEpochValueAction.run(
      new List<skel.ChronoEpochValueAction.Request>{ input }
    )[0]
    .success,
  'Epoch overflow must be an item error'
);
Boolean rejected = false;
try {
  skel.ChronoPlainDateService.addYears(
    Date.newInstance(2026, 1, 1),
    2147483647
  );
} catch (skel.ChronoException ex) {
  rejected = ex.getMessage().contains('range');
}
Assert.isTrue(rejected, 'Calendar overflow must be rejected');
System.debug(LoggingLevel.ERROR, 'CHRONO_SUBSCRIBER_BOUNDARIES_PASSED');
