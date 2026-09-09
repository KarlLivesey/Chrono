# Public service boundary measurements

Measured through installed beta **0.1.0.16** in `chrono-subscriber` on 8 September 2026. Each workload has one warm-up and three measured samples, with 200 operations
or requests per sample. All output assertions passed.

| Workload                 | Median CPU | Measured range | Highest measured transaction CPU |
| ------------------------ | ---------: | -------------: | -------------------------------: |
| Duration parse/serialise |      74 ms |       72–76 ms |                           305 ms |
| Distinct time allocation |   5,116 ms | 4,627–5,178 ms |                         5,209 ms |

Duration samples share one transaction. Allocation samples each run in a fresh
transaction and use four timezones, four blocks and 64 holidays. Transaction CPU
includes setup and assertions; the highest measured allocation transaction retained
4,791 ms of the observed 10,000 ms synchronous limit.

The previous allocation run on 0.1.0.15 measured a 4,643 ms median. This run is
about 10% higher; Salesforce timings vary, and these runs do not isolate the cost
of forwarding calls from other runtime variation. No performance improvement or
fixed headroom is claimed. The allocation workload checks strict mode; the separate
regression tests exercise the lax-rounding correction.

[Raw results](results/service-boundary-0.1.0.16.json)
