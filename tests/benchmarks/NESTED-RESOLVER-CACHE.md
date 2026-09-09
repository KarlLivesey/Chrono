# Native-key resolver cache experiment

On 9 September 2026, a nested `timezone → Date → Time` map produced a substantial
CPU saving for repeated local-time resolution. It generally cost more when every
key was distinct. **This remains a benchmark prototype; the production resolver
has not changed.**

## Measurements

Each arm makes 200 calls to the current five-sample resolver or an instance cache
wrapper around it. Both arms execute in the same anonymous Apex transaction in
`chrono-dev`. Six measured pairs alternate which runs first; a separate warm-up
pair is excluded. Every cached arm starts with a fresh cache, and includes cache
construction, misses, insertions and defensive list copies. Inputs and independent
expected results are prepared before timing; assertions and JSON reporting follow
it. There is no serialisation or date/time formatting in the cache lookup.

| Workload, 200 calls                | Direct resolver median | Cache median | Median paired difference (cache − direct) |
| ---------------------------------- | ---------------------: | -----------: | ----------------------------------------: |
| All identical, one occurrence      |                  42 ms |       4.5 ms |                                    -37 ms |
| All identical, repeated hour       |                  52 ms |       3.5 ms |                                    -48 ms |
| All identical, missing time        |                  48 ms |         4 ms |                                    -44 ms |
| 90% hits, four zones               |                33.5 ms |       6.5 ms |                                    -27 ms |
| 50% hits, four zones               |                37.5 ms |      21.5 ms |                                  -14.5 ms |
| 25% hits, four zones               |                33.5 ms |      28.5 ms |                                   -5.5 ms |
| All distinct times, same zone/date |                35.5 ms |        37 ms |                                      2 ms |
| All distinct dates, UTC            |                37.5 ms |      46.5 ms |                                      4 ms |

The all-identical cases include one miss and 199 hits. The mixed workloads use
20, 100 or 150 distinct keys across London, UTC, Kathmandu and Lord Howe. The
all-distinct time workload includes millisecond differences; the date workload
creates a separate date bucket for each request.

The cache won all six pairs in each repeated/mixed workload. For distinct times
it lost four pairs, won one and tied one; for distinct dates it lost five and won
one. The paired difference is calculated within each transaction before taking
the median, so it need not equal the difference between the two column medians.
See the raw samples for ordering and variation. These are resolver CPU timings,
not end-to-end Flow/LWC performance or the cost of a single native offset lookup.

## Shape and boundaries

```apex
Map<String, Map<Date, Map<Time, List<Datetime>>>> entries;
```

- The timezone string is used directly. Date and Time remain native keys, including milliseconds.
- An instance owns the cache. No static, cross-transaction or org-level cache is introduced.
- Misses call the existing resolver before storing anything, preserving its validation.
- The cache stores complete occurrence lists, including empty gap results and both overlap occurrences.
- Miss results and hit results are independent lists. Native Datetime values need no mutable Chrono-object serialisation.
- The prototype is unbounded within its instance and retains distinct keys. It is not ready to enable globally without an explicit lifetime/capacity decision.
- Reported heap deltas are snapshots, not peak or retained-cache measurements. Garbage collection can make them negative; they do not establish a memory saving.

Checks verified zone/date/millisecond key separation, invalid-input rejection,
gap/overlap preservation and mutation isolation for both hits and misses. No
metadata was deployed, business records written, packages built or orgs created.

## Reproduce and review

- [Exact anonymous Apex experiment](experiments/nested-resolver-cache.apex)
- [Correctness checks](experiments/nested-resolver-cache-checks.apex)
- [Paired raw results](results/nested-resolver-cache.json)
- [Correctness result](results/nested-resolver-cache-checks.json)
- [Runner](run-resolver-cache.py)

```sh
python3 tests/benchmarks/run-resolver-cache.py --target-org chrono-dev \
  --pairs 6 --count 200 --output /tmp/chrono-native-cache.json
python3 tests/benchmarks/run-resolver-cache.py --target-org chrono-dev \
  --checks-only --output /tmp/chrono-native-cache-checks.json
```

The runner calls internal developer-org code through anonymous Apex. It does not
publish a new subscriber API or replace the current resolver. This result supports
evaluating an explicitly scoped cache for workloads with reuse; it does not
support an unconditional cache for all calls.
