# Timezone sampling comparison

Measured on 9 September 2026 in the existing `chrono-dev` org. This compares
25 six-hour samples over ±72 hours with five daily samples over ±48 hours.

Each sample contains 200 operations; figures are Salesforce CPU milliseconds,
with one warm-up and three measured samples per case. The scan-only cases run
native `TimeZone.getOffset` loops and exclude Chrono validation and candidate
matching. The public API cases execute the actual deployed services, including
validation, conversion and candidate matching, without batch deduplication.

| Workload (200 operations)                                 | 25 samples, median CPU | Five samples, median CPU | Reduction |
| --------------------------------------------------------- | ---------------------: | -----------------------: | --------: |
| Offset sampling only                                      |                  38 ms |                     9 ms |       76% |
| Resolve a repeated London time through the public service |                 108 ms |                    91 ms |       16% |
| Add a calendar day across London's DST change             |                 180 ms |                   157 ms |       13% |

The confirmation run measured 89 ms for repeated-time resolution and 161 ms for
calendar arithmetic: 18% and 11% below the respective baseline medians. The two
five-sample runs are consistent with an approximately 11–18% CPU reduction for
these complete service calls.

These are measured workloads, not a claim that every Chrono operation is 13–16%
faster. Timings vary with Salesforce runtime conditions. The number of offset
lookups per scan is reduced by 80%; total operation CPU includes other work.

The first five-sample run used source commit `337b728`. For the baseline, only
`ChronoZoneResolver` was temporarily restored to its parent revision in the same
development org. The five-sample source was then restored and resolver/picker
correctness tests rerun before a confirmation benchmark. No package builds,
subscriber installation changes or business-record writes were used.

The repeated-time and isolated-loop samples each use fresh transactions.
Calendar arithmetic samples share one transaction after warm-up. The same
transaction mode and workloads apply to both resolver versions. Assertions check
both sampled offsets, the later repeated-time instant and the resulting calendar
clock time; failed calculations cannot count as successful fast operations.

Raw samples and min/median/max timings:

- [Five samples, including both isolated loops](results/timezone-sampling-five.json)
- [25-sample resolver baseline](results/timezone-sampling-twenty-five.json)
- [Restored five-sample confirmation](results/timezone-sampling-five-confirmation.json)

Rerun against the currently deployed implementation:

```sh
python3 tests/benchmarks/run-apex.py --target-org chrono-dev \
  --samples 3 --count 200 \
  --case timezone-offset-sampling-25 --case timezone-offset-sampling-5 \
  --case timezone-resolve-overlap --case calendar-dst-arithmetic \
  --label current-resolver --output /tmp/chrono-timezone-benchmark.json
```

The runner itself does not deploy either resolver version. Its two isolated-loop
cases compare the loop bodies; its public API cases use whichever Chrono version
is already deployed in the target org.
