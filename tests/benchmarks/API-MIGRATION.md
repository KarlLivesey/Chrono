# API migration benchmark

Measured against installed skip-validation beta **0.1.0.17** in the existing
subscriber org. Each workload performs one warm-up and three measured samples;
all workload assertions passed. The allocation workload uses distinct requests,
so identical-input caching does not replace the intended calculations.

| Workload                 | Operations per sample | Median CPU (ms) | Range (ms) |
| ------------------------ | --------------------- | --------------- | ---------- |
| parse-format-Duration    | 200                   | 83              | 82–86      |
| time-allocation-distinct | 200                   | 4820            | 4816–5550  |

These are observed transaction CPU timings, not response-time guarantees or proof
of a performance change. The preceding 0.1.0.16 run measured 74 ms for duration
round trips and 5,116 ms for allocation. Environment and measurement variation
limit comparisons between runs.

The workload scripts now call `parseIso`/`toIsoString` and read the explicit
allocation row fields. [Raw measurements](results/api-migration-0.1.0.17.json)
include per-sample CPU and heap. The runner fails if any workload assertion fails.
