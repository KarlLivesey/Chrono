# Bulk working-time service

The next Chrono package version adds `ChronoWorkingTimeService.add(requests)`.
It is not present in released version 0.1.0.19. Existing working-time Flow actions
retain their method signatures and now adapt this service's typed results. Optional date/clock and supplied-record inputs extend the existing request contracts.

```apex
List<skel.ChronoWorkingTimeInput> requests = new List<skel.ChronoWorkingTimeInput>();
// Add one input per calculation, with its own start, amount, zone and schedule.
List<skel.ChronoWorkingTimeResult> results = skel.ChronoWorkingTimeService.add(requests);
```

Each input uses the existing data-only `ChronoWorkingTimeInput`:

- One starting representation: `startInstant` (native Datetime), `startValue` (ISO date/local date-time/instant/zoned date-time), or `startDate` with optional `startTime`. A date alone means local midnight.
- `timeZoneId`: explicit timezone for local inputs and the result; openings follow the schedule's timezone.
- `disambiguation`: `reject` (default), `earlier` or `later` for repeated times; nonexistent local times are rejected.
- `amount`: signed integer; negative values subtract.
- `unit`: `hours` or `minutes`.
- `scheduleType`: `OperatingHours` or `BusinessHours`.
- `scheduleId`: saved record ID, or `operatingHours`, `timeSlots` and optional `holidays` for supplied native records. Do not provide both. Supplied records can be unsaved and require `scheduleType = OperatingHours`.

Each result has `success`, `errorMessage` and `value`. On success, `value` is a
`ChronoZonedDateTime`; on failure it is null and `errorMessage` contains the
ordinary item failure. Convert a successful value with the zoned service or read
its native `instant` and `timeZoneId` fields. The service does not return a Flow
transport envelope. Its data-only result is an Apex contract, not a new
Apex-defined Flow resource.

Call once with the complete list. OperatingHours schedules share three user-mode
queries for the batch; supplied-only batches use no queries. BusinessHours requests add one user-mode record lookup and
use Salesforce's native arithmetic. Results preserve input order; both result
objects and nested zoned values are independent. Identical calculations share
work only within this call. Requests are not mutated. Null/empty lists return an
empty list; a null item returns a failed item. Governor limits still apply.

The global service delegates to internal `ChronoWorkingTimeOperations`;
`ChronoWorkingTimeContext` owns schedule loading and calculation. Flow adapters
only map existing inputs and convert the service results to native/ISO outputs.
Working differences retain the same shared schedule context. Native and ISO endpoint resolution is shared through an internal helper.

Existing methods, field types and constructors are retained. The schedule ID becomes optional when supplying native records; the request gains optional date, clock, policy and native schedule fields. The additive global service and typed
result follow [managed 2GP namespace visibility](https://developer.salesforce.com/docs/platform/pkg2-dev/guide/sfdx-dev-dev2gp-namespace-visibility.html).
A new minor package version is needed; this addition is not a patch to 0.1.0.19.

The wider [bulk Apex service catalogue](bulk-apex-services.md) covers the other calculation families in the upcoming 0.2 version.

## Subscriber check

With the existing London and New York example schedules, run the
[subscriber check](https://github.com/KarlLivesey/Chrono/blob/main/tests/subscriber/scripts/working-time-service.apex):

```sh
sf apex run --target-org chrono-subscriber --file tests/subscriber/scripts/working-time-service.apex
```

It checks 200 mixed native/ISO requests across both schedules, ordered typed
outputs, independent nested values, unchanged inputs and an isolated invalid
item. It performs no DML. The package query count is visible under the `skel`
namespace in the Apex execution log; the subscriber namespace's own counter does
not include managed-package queries.

## Validation — 8 September 2026

- Development deployment `0AfG100000LNarWKAT`: 207 Apex tests, zero failures.
- Contract checks: all released global declarations unchanged; seven additive
  declarations across the new service/result classes. All 14 contract tests pass.
- PMD passes the configured severity threshold; only low-severity findings remain.
- One skip-validation build: `0.2.0.1`, subscriber version `04tgK000000KHXlQAO`,
  request `08cgK000000H3xZQAS`, ancestor released `0.1.0.19`.
- Existing subscriber org upgraded successfully, install `0HfAs000002bYETKA2`.
- Subscriber Apex check: 200 mixed native/ISO inputs across two schedules plus
  one invalid item; ordered typed values and independent nested copies verified.
  The execution log reports exactly three SOQL queries in the `skel` namespace.
- All 49 tests in the eight existing subscriber integration classes passed;
  test run `707As00001Vw9hO`.

The subscriber check compares individual public fields: attempting to JSON-serialise
these managed input objects from the subscriber raised `System.JSONException`.
This service supports typed Apex calls; it does not promise subscriber-side JSON
serialisation of its input/result objects. Flow retains native/ISO transport.

This is an unreleased test build. Validation was skipped, no package coverage was
calculated, and no standard build or promotion was performed for this extraction.
The public documentation for released 0.1.0.19 continues to describe the action
entry point that is actually available in that version.
