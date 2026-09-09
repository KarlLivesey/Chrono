// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
// The runner prepends the exact cache class from nested-resolver-cache.apex.
ResolverCacheExperiment cache = new ResolverCacheExperiment();
Date day = Date.newInstance(2026, 9, 8);
Time clockValue = Time.newInstance(12, 30, 0, 0);
List<Datetime> london = cache.resolve(day, clockValue, 'Europe/London');
Assert.areEqual(Datetime.newInstanceGmt(2026, 9, 8, 11, 30, 0), london[0]);
Assert.areEqual(
  Datetime.newInstanceGmt(2026, 9, 8, 12, 30, 0),
  cache.resolve(day, clockValue, 'UTC')[0],
  'Zone separates identical clock fields'
);
Assert.areEqual(
  Datetime.newInstanceGmt(2026, 9, 9, 11, 30, 0),
  cache.resolve(day.addDays(1), clockValue, 'Europe/London')[0],
  'Date separates identical clocks'
);
Assert.areEqual(
  london[0].getTime() + 1,
  cache.resolve(day, Time.newInstance(12, 30, 0, 1), 'Europe/London')[0]
    .getTime(),
  'Time key preserves milliseconds'
);
london.clear();
Assert.areEqual(
  1,
  cache.resolve(day, clockValue, 'Europe/London').size(),
  'Miss result cannot alter cache'
);
List<Datetime> hit = cache.resolve(day, clockValue, 'Europe/London');
hit.clear();
Assert.areEqual(
  1,
  cache.resolve(day, clockValue, 'Europe/London').size(),
  'Hit result cannot alter cache'
);

Date repeatedDay = Date.newInstance(2026, 10, 25);
Time repeatedClock = Time.newInstance(1, 30, 0, 0);
List<Datetime> repeated = cache.resolve(
  repeatedDay,
  repeatedClock,
  'Europe/London'
);
Assert.areEqual(
  new List<Datetime>{
    Datetime.newInstanceGmt(2026, 10, 25, 0, 30, 0),
    Datetime.newInstanceGmt(2026, 10, 25, 1, 30, 0)
  },
  repeated
);
repeated.clear();
Assert.areEqual(
  2,
  cache.resolve(repeatedDay, repeatedClock, 'Europe/London').size()
);
List<Datetime> gap = cache.resolve(
  Date.newInstance(2026, 3, 29),
  repeatedClock,
  'Europe/London'
);
Assert.areEqual(0, gap.size());
gap.add(Datetime.newInstanceGmt(day, clockValue));
Assert.areEqual(
  0,
  cache.resolve(Date.newInstance(2026, 3, 29), repeatedClock, 'Europe/London')
    .size(),
  'Empty results are independently cached'
);
for (Integer invalidInput = 0; invalidInput < 3; invalidInput++) {
  Boolean rejected = false;
  try {
    cache.resolve(
      invalidInput == 0 ? null : day,
      invalidInput == 1 ? null : clockValue,
      invalidInput == 2 ? 'Invalid/ChronoZone' : 'Europe/London'
    );
  } catch (skel.ChronoException expected) {
    rejected = true;
  }
  Assert.isTrue(rejected, 'Invalid inputs still use resolver validation');
}
Assert.areEqual(
  Datetime.newInstanceGmt(2026, 9, 8, 11, 30, 0),
  cache.resolve(day, clockValue, 'Europe/London')[0],
  'Failed requests do not poison valid entries'
);
