# Individually measured CPU candidates

Measurements use the existing `chrono-dev` org, 200 operations per sample and
five measured samples after a separate warm-up sample. Every sample has its own
transaction. Public service workloads assert their outputs and perform no DML.
No package builds or subscriber installs are involved. CPU milliseconds are not
wall-clock or network timings; small differences require repeat measurements.

Each candidate changes only its stated implementation relative to the preceding
accepted source. Rejected changes are removed before evaluating the next one.
Raw samples include ranges and individual observations, not just medians.

## 1. Lazy operating-hours intervals — rejected

Deferring timezone interval construction until a slot or applicable holiday
needs it reduced weekend work, but increased same-day CPU. The original
implementation was restored. The additional correctness test remains: an invalid
partial holiday on a closed Saturday must still fail working-time arithmetic.

| Public workload, 200 calls                | Original medians | Final candidate medians | Decision                               |
| ----------------------------------------- | ---------------: | ----------------------: | -------------------------------------- |
| Friday through weekend and Monday holiday |     621 / 627 ms |                  473 ms | About 24% less CPU                     |
| One hour on an open weekday               |     200 / 199 ms |            226 / 211 ms | About 6–14% more CPU; reject candidate |

An intermediate implementation measured 469 / 214 ms respectively but failed
PMD complexity checks. Its final replacement extracted the lazy initialisation
into a focused helper and was recompiled, tested and remeasured. The original
implementation was redeployed for the second baseline, then the final candidate
was restored for its same-day confirmation. The decision uses the final code,
not the intermediate timing. Correctness checks: 43 targeted Apex tests and 20
contract tests passed; 24 resolver-adjacent schedule/picker tests were rerun on
restoring the original schedule implementation. Focused final Apex lint passed.

- [Final candidate diff](experiments/lazy-schedule-intervals.patch)
- [Original](results/optimise-schedule-before.json)
- [Intermediate candidate](results/optimise-schedule-after.json)
- [Final candidate](results/optimise-schedule-final.json)
- [Original control repeat](results/optimise-schedule-control.json)
- [Final candidate confirmation](results/optimise-schedule-confirmation.json)

Run `optimise-working-weekend` and `optimise-working-open-day` with
`run-apex.py --target-org chrono-dev --samples 5 --count 200`, a descriptive
`--label` and a new `--output` file. The runner measures the deployed code and
does not deploy the experimental diff itself.
