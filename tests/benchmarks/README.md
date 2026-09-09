# Chrono benchmarks

Run against the **existing** `chrono-subscriber` org with Chrono and the repository's
subscriber fixtures installed. The runners do not create an org, build a package,
deploy metadata or save business records. No new dependencies are needed.

```sh
python3 tests/benchmarks/run-apex.py --target-org chrono-subscriber --output /tmp/chrono-apex.json
node --harmony-temporal tests/benchmarks/run-client.mjs /tmp/chrono-client.json
```

Apex covers all eight parse/serialise services, zoned calendar arithmetic,
repeated versus distinct conversions, working hours with unsaved records and a
holiday, calendar difference, recurrence, collection availability and real
Flow interviews. The client runner loads the production picker engine and
measures native Temporal resolution, repeated times, nearest gap boundaries,
projection, explicit offsets and four-zone offset descriptions. It also measures
client duration round-trips, strict exact-datetime parsing and partial dates.

Use `--label Chrono-0.1.0.11` to identify the installed version in a report.
Use `--case NAME` (repeatable), `--count 1..200` and `--samples 1..10` to select Apex
workloads. The real Flow case caps each sample at 20 interviews. Output files
must be new, preserving earlier runs. Each case asserts its expected result;
an action failure cannot count as a fast successful calculation.

## Reading the measurements

- Apex reports CPU milliseconds, with one warm-up and three measured samples.
  Most cases run in a fresh transaction with samples sharing transaction-local
  caches after warm-up. The two heavy stress cases instead give **each sample its
  own transaction**, including warm-up, so several full batches do not artificially
  exhaust one shared governor limit. Reports record `transactionMode`.
- `stress-availability-distinct` and `stress-recurrence-distinct` each use 200
  distinct requests, four schedule timezones, ten weekly slots and 64 holidays.
  Availability checks exact clipped window boundaries against a native-date oracle;
  recurrence checks the complete ordered list of expected dates. Both assert every
  result succeeded. Each measured workload is one invocation.
- `time-allocation-with-flow` combines 200 distinct allocations with 20 real
  conversion Flow interviews in each sample transaction. Every allocation total
  and Flow output is asserted. This measures representative shared-transaction
  headroom; it is not a guarantee for arbitrary customer automation.
- `cpuUsedMs` includes fixture setup and assertions as well as the measured body;
  compare it with `cpuLimitMs` for the benchmark transaction's remaining headroom.
  `cpuMs` isolates the operation. Neither promises headroom for arbitrary caller
  work, longer searches or more complex schedules.
- Bulk cases measure one invocation containing the stated number of items.
  Service cases call the operation repeatedly. The Flow case includes actual
  Flow execution overhead, and checks every interview succeeded.
- Heap measurements are snapshots and deltas, **not peak heap usage**. Query and
  DML counters belong to the calling namespace; they are not a complete count of
  managed-package namespace usage. Benchmark cases use supplied records and
  contain no record-writing operations.
- The client runner reports elapsed time in Node, with one warm-up and five
  measured samples. These are algorithm measurements, not browser rendering,
  Lightning Web Security or Apex network timings.
- Salesforce tenancy, runtime warm-up and CPU timer resolution introduce noise.
  Compare medians and ranges using the same org, package version, workload and
  settings. A small difference is not proof of a performance regression.
- Benchmarks are separate from correctness tests. There are no brittle timing
  assertions in normal CI. A CPU governor failure still fails the benchmark.

`results/baseline-*.json` contains measurements from installed package **0.1.0.10**
and the corresponding client engine. The Apex runner also includes additional
workloads introduced during the hardening review. See the validation record for
subsequent package results. These are representative workloads, not an exhaustive
performance guarantee for every action and input combination.

Compare matching Apex workloads without imposing a timing threshold:

```sh
python3 tests/benchmarks/compare.py tests/benchmarks/results/baseline-apex.json /tmp/chrono-apex.json
```

See the [readable baseline](BASELINE.md), [hardened package comparison](COMPARISON.md)
[distinct-workload follow-up](FOLLOWUP.md) and
[timezone sampling comparison](TIMEZONE-SAMPLING.md).

## Direct Apex services (0.2 beta)

The `apex-service-*` cases call the services directly, using the same repeated,
distinct and schedule stress workloads as the action benchmarks. They require
0.2.0.3 or later, use a fresh transaction per sample, and assert results and
ordering. See [the September audit](../../docs/service-audit-2026-09.md) and
[its measurements](results/bulk-services-0.2.0.3.json).

See [individually measured optimisation candidates](OPTIMISATIONS.md) for
before/after comparisons, rejected experiments and retained changes.
