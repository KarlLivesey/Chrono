// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
// Anonymous Apex experiment; never deployed as a package class.
class ResolverCacheExperiment {
  private Map<String, Map<Date, Map<Time, List<Datetime>>>> entries = new Map<String, Map<Date, Map<Time, List<Datetime>>>>();
  public List<Datetime> resolve(Date day, Time clockValue, String zoneId) {
    Map<Date, Map<Time, List<Datetime>>> dates = entries.get(zoneId);
    Map<Time, List<Datetime>> times = dates == null ? null : dates.get(day);
    List<Datetime> cached = times == null ? null : times.get(clockValue);
    if (cached != null)
      return cached.clone();
    List<Datetime> result = skel.ChronoZoneResolver.resolve(
      day,
      clockValue,
      zoneId
    );
    if (dates == null) {
      dates = new Map<Date, Map<Time, List<Datetime>>>();
      entries.put(zoneId, dates);
    }
    if (times == null) {
      times = new Map<Time, List<Datetime>>();
      dates.put(day, times);
    }
    times.put(clockValue, result.clone());
    return result;
  }
}

String scenario = '__SCENARIO__';
Integer pairIndex = __PAIR__;
Integer count = __COUNT__;
Integer uniqueCount = scenario == 'reuse-90'
  ? Math.max(1, count / 10)
  : (scenario == 'reuse-50'
      ? Math.max(1, count / 2)
      : (scenario == 'reuse-25'
          ? Math.max(1, count * 3 / 4)
          : (scenario.startsWith('repeat-') ? 1 : count)));
List<String> availableZones = new List<String>{
  'Europe/London',
  'UTC',
  'Asia/Kathmandu',
  'Australia/Lord_Howe'
};
List<Integer> offsets = new List<Integer>{ 3600000, 0, 20700000, 37800000 };
List<Date> days = new List<Date>();
List<Time> clocks = new List<Time>();
List<String> zones = new List<String>();
List<List<Datetime>> expected = new List<List<Datetime>>();
for (Integer index = 0; index < count; index++) {
  Integer keyIndex = Math.mod(index, uniqueCount);
  Integer zoneIndex = Math.mod(keyIndex, availableZones.size());
  Date day = Date.newInstance(2026, 9, 8);
  Time clockValue = Time.newInstance(12, 30, 0, keyIndex);
  String zoneId = availableZones[zoneIndex];
  List<Datetime> matches;
  if (scenario == 'repeat-overlap') {
    day = Date.newInstance(2026, 10, 25);
    clockValue = Time.newInstance(1, 30, 0, 0);
    zoneId = 'Europe/London';
    matches = new List<Datetime>{
      Datetime.newInstanceGmt(2026, 10, 25, 0, 30, 0),
      Datetime.newInstanceGmt(2026, 10, 25, 1, 30, 0)
    };
  } else if (scenario == 'repeat-gap') {
    day = Date.newInstance(2026, 3, 29);
    clockValue = Time.newInstance(1, 30, 0, 0);
    zoneId = 'Europe/London';
    matches = new List<Datetime>();
  } else if (scenario == 'distinct-dates') {
    day = day.addDays(keyIndex);
    clockValue = Time.newInstance(12, 30, 0, 0);
    zoneId = 'UTC';
    matches = new List<Datetime>{ Datetime.newInstanceGmt(day, clockValue) };
  } else {
    if (scenario == 'distinct-times') {
      zoneId = 'Europe/London';
      zoneIndex = 0;
    }
    matches = new List<Datetime>{
      Datetime.newInstance(
        Datetime.newInstanceGmt(day, clockValue).getTime() - offsets[zoneIndex]
      )
    };
  }
  days.add(day);
  clocks.add(clockValue);
  zones.add(zoneId);
  expected.add(matches);
}
List<Boolean> order = Math.mod(pairIndex, 2) == 0
  ? new List<Boolean>{ false, true }
  : new List<Boolean>{ true, false };
for (Boolean useCache : order) {
  Integer heapBefore = Limits.getHeapSize();
  Integer queriesBefore = Limits.getQueries();
  Integer dmlBefore = Limits.getDmlStatements();
  Integer cpuBefore = Limits.getCpuTime();
  ResolverCacheExperiment resolver = useCache
    ? new ResolverCacheExperiment()
    : null;
  List<List<Datetime>> results = new List<List<Datetime>>();
  for (Integer index = 0; index < count; index++) {
    results.add(
      useCache
        ? resolver.resolve(days[index], clocks[index], zones[index])
        : skel.ChronoZoneResolver.resolve(
            days[index],
            clocks[index],
            zones[index]
          )
    );
  }
  Integer cpuMs = Limits.getCpuTime() - cpuBefore;
  Integer heapAfter = Limits.getHeapSize();
  Assert.areEqual(
    expected,
    results,
    'Every occurrence, including millisecond keys, must match.'
  );
  Assert.areEqual(queriesBefore, Limits.getQueries(), 'No queries');
  Assert.areEqual(dmlBefore, Limits.getDmlStatements(), 'No DML');
  if (useCache) {
    // Neither a miss result nor a hit result may expose the retained list.
    results[0].clear();
    List<Datetime> hit = resolver.resolve(days[0], clocks[0], zones[0]);
    Assert.areEqual(expected[0], hit, 'Miss result isolation');
    hit.add(Datetime.newInstanceGmt(2000, 1, 1, 0, 0, 0));
    Assert.areEqual(
      expected[0],
      resolver.resolve(days[0], clocks[0], zones[0]),
      'Hit result isolation'
    );
  }
  System.debug(
    LoggingLevel.ERROR,
    'CHRONO_CACHE_BENCH ' +
    JSON.serialize(
      new Map<String, Object>{
        'scenario' => scenario,
        'pair' => pairIndex,
        'cached' => useCache,
        'cachedFirst' => order[0],
        'operations' => count,
        'uniqueKeys' => uniqueCount,
        'cpuMs' => cpuMs,
        'heapAfterBytes' => heapAfter,
        'heapDeltaBytes' => heapAfter - heapBefore
      }
    )
  );
}
