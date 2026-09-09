# Apex services and bulk-operation audit — 9 September 2026

**There was further work to do.** This review reproduced an arithmetic defect,
found holes in the architecture checks, and found misleading version labels in
the documentation pipeline. Those are corrected in source. This is a review of
the current implementation, not a claim that no future defect or useful feature
can exist.

The baseline was installed beta **0.2.0.3** (`04tgK000000KIYfQAO`). The source
workspace was reconnected during the review. The corrections below preserve the
1,604 global declarations and 121 core method signatures. They do not change
request fields, Flow metadata or the published package installation link.

## Confirmed findings and corrections

### Zero calendar arithmetic discarded a known repeated-time occurrence

On the installed subscriber package, the input
`2026-10-25T01:30:00.000+00:00[Europe/London]` identifies the second occurrence.
`ChronoWorkingTimeService.addDays` with amount zero and default disambiguation
returned an error. With `earlier`, it returned `00:30Z` instead of `01:30Z`.
The core `addDays`, `addMonths` and `addYears` methods also rejected zero with
the default policy. These were actual subscriber executions, not inferred
failures from reading the code.

The core calendar implementation now preserves the instant when its resulting
local fields are unchanged, returning an independent value. Working-day addition
preserves its resolved instant for zero and still applies the requested
closed-time policy. A repeated target reached by nonzero arithmetic still needs
its normal disambiguation; invalid policies still fail.

Changes: [core calendar implementation](https://github.com/KarlLivesey/Chrono/blob/main/force-app/main/default/classes/ChronoZonedDateTimeOperations.cls),
[working-day implementation](https://github.com/KarlLivesey/Chrono/blob/main/force-app/main/default/classes/ChronoWorkingDays.cls).
Regression tests cover repeated occurrences, all supported policies, independent
results, a null batch item and zero with a closed-time rejection. Both regression
tests failed on the original implementation before the correction.

### Service coverage checks had a blind spot

The route inventory pointed two families at Flow adapters rather than their
actual Apex service. The dependency check also excluded every `ChronoFlow*`
class, including reusable arithmetic implementations. That exclusion could let a
future shared calculator call a UI controller or an invocable entry point without
failing the check.

The inventory now names all 27 direct service routes. Tests separately verify the
two necessary Flow adapters, inspect shared calculators regardless of historical
name, and require every global service to have a reviewed boundary guard. Existing
core guards verify exact signatures and delegation; batch guards verify thin
facades. No new runtime interface or public abstraction was needed.

### The documentation could describe development APIs as released

The generator read current source but hard-coded `0.1.0.19` and 1,471 declarations.
Rebuilding after the bulk work would publish new services under a released-version
label. The handbook also continued recommending `ChronoWorkingTimeAction.run`
as the Apex entry point, while the new service guide was outside that chapter.

References now derive the source version and declaration count, explicitly say
**development source**, and link to release status. The OperatingHours handbook
leads with the direct 0.2 service, retaining the action-based route only as a
clearly labelled compatibility note for installed 0.1.0.19. The public installer
still points to the released package. No beta is presented as a production release.

### Fallback component tests depended on the host's Temporal availability

Eight LWC tests failed under Node 26 because native Temporal ran instead of the
mocked Apex bridge. The fallback suite now explicitly disables Temporal for that
suite and restores the original global afterwards. Native Temporal remains
covered by the separate JavaScript conformance tests. No production component
behaviour was changed to make the tests pass.

## Coverage examined

The review traced the 54 scalar/collection action entry points through their
adapters, the 20 global service classes and their implementations. It checked
actual query sites, shared configuration loaders, request normalisation,
result copying, per-item error handling, public signature guards, generated
references and the relevant tests. Large generated locale tables were treated
as data, not as a reason to invent another service.

| Area                   | Direct Apex entry points                               | What the implementation provides                                                                                                                      |
| ---------------------- | ------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| Eight core values      | Eight matching value services                          | Query-free construction, validation, native/ISO conversion and applicable arithmetic; saved working-time conveniences delegate to the existing loader |
| Value operations       | `ChronoValueService`                                   | Convert, create, replace, parse, validate, epoch conversion and details                                                                               |
| Calculations           | `ChronoCalculationService`                             | Adjustment, elapsed/scheduled difference, calendar difference, comparison, boundaries and rounding                                                    |
| Timezones              | `ChronoTimeZoneService`                                | Local resolution, conversion, offsets, zone lists and bounded transition searches                                                                     |
| Working time           | `ChronoWorkingTimeService`                             | Add, check, find and working-day addition; saved or supplied native OperatingHours configuration                                                      |
| Durations              | `ChronoDurationCalculationService`                     | Components, sign, totals, balancing, multiplication and division                                                                                      |
| Ranges and collections | `ChronoRangeService`, `ChronoCollectionService`        | Interval operations, splitting, coverage, ordering, deduplication, filtering, grouping, nearest values and duration sums                              |
| Schedules              | `ChronoAvailabilityService`, `ChronoRecurrenceService` | Availability, booking windows, holiday/open-date listings and bounded recurrence                                                                      |
| Fiscal periods         | `ChronoFiscalPeriodService`                            | One shared organisation-calendar query or query-free explicit month-based calendars                                                                   |
| Formatting             | `ChronoFormattingService`                              | Values, ranges, durations and relative display                                                                                                        |
| Allocation             | `ChronoTimeAllocationService`                          | Scalar allocation and `allocateAll`, named blocks, holiday rules, four overlap modes and precision controls                                           |

The [complete bulk catalogue](bulk-apex-services.md) gives request/result types
and examples. No existing action family lacks a direct bulk Apex route. Pure
single-value core operations do not need a separate list overload for each method:
they are query-free, and the batch families already cover the corresponding work.

## Query and batch behaviour

All explicit production SOQL is concentrated in four places:

- `ChronoOperatingSchedules`: three shared queries for schedules, normal slots
  and holiday links, used by all saved OperatingHours calculation families.
- `ChronoWorkingTimeContext`: one optional BusinessHours configuration query.
- `ChronoFiscalPeriods`: one query for the requested organisation-calendar range.
- `ChronoPickerScheduleQuery`: bounded UI search, not calculation performed once
  per Apex item. It is deliberately not another global service.

Batch services preserve input order, isolate ordinary item failures, reuse
identical calculations within a call and return independent result graphs.
Native-record schedules avoid queries and DML. Saved and supplied schedules use
the same interval/holiday engine. The previous 0.2.0.3 tests already established
mixed saved/native 200-item query budgets and actual subscriber Flow execution;
this audit does not relabel those earlier runs as new tests.

Independent calls still load their own configuration. There is no public
transaction-wide cache. Batch loading does not remove CPU, heap or output-size
limits: [Salesforce governor-limit reference](https://resources.docs.salesforce.com/latest/latest/en-us/sfdc/pdf/salesforce_app_limits_cheatsheet.pdf).
A new shared context would add lifecycle/permission semantics and a permanent
managed API; this review found no need to introduce one speculatively.

## Further operations that are possible, but not implemented by this audit

These are concrete capability limits, not missing bulk routes or new promises:

| Possible addition                                     | Current behaviour and an additive route                                                                                                                                                                                                                 |
| ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Sub-minute working-time addition                      | The internal engine measures milliseconds, but the public working-time request accepts whole hours/minutes. Additional second/millisecond units or an optional elapsed-duration field could expose that precision without changing existing signatures. |
| BusinessHours parity                                  | Native BusinessHours is supported by add; check/find/scheduled difference currently target OperatingHours. Supporting the native BusinessHours methods would need explicit request/editor configuration and behaviour tests.                            |
| Multiple supplied schedules in one intersection/union | The primary schedule can use supplied records; additional schedules currently use saved IDs. Supporting several unsaved configurations needs an unambiguous way to associate each schedule's slots and holidays.                                        |

The selected existing scope does not require alternative calendars, nanoseconds,
a second scheduling object model, one public interface per implementation, or
new classes merely to remove historical `ChronoFlow` names. These would not fix
the confirmed issues above. Current service signatures remain static facades over
internal implementations and can gain additive overloads/options subject to
[Salesforce manageability rules](https://developer.salesforce.com/docs/platform/pkg2-dev/guide/sfdx-dev2gp-rules-ancestry-upgrades.html).

## Benchmarks and validation

Four new read-only benchmarks call services directly from subscriber Apex. Each
uses 200 inputs, one warm-up and three measured samples, with a fresh transaction
per sample. Every expected output is asserted; errors are not counted as fast
successful work. [Raw measurements](https://github.com/KarlLivesey/Chrono/blob/main/tests/benchmarks/results/bulk-services-0.2.0.3.json).

| Installed 0.2.0.3 workload                                         | Median operation CPU |
| ------------------------------------------------------------------ | -------------------: |
| Repeated conversions                                               |               197 ms |
| Distinct conversions                                               |               507 ms |
| Distinct availability requests, four zones, ten slots, 64 holidays |             2,817 ms |
| Distinct recurrence requests with the same schedule complexity     |             4,681 ms |

These are measured workloads, not a guarantee for arbitrary horizons or the
caller's surrounding automation. In particular, query bulkification alone does
not prove adequate CPU headroom.

Full development deployment `0AfG100000LNwtpKAD` succeeded with **242 Apex tests**.
The corrected fallback suite passed **145 LWC tests**; **43 Temporal tests**,
**20 contract tests** and **5 documentation tests** passed. The documentation
build checked **224 HTML pages and 11,345 local links/assets/fragments**.
Formatting passed. The initial PMD run reported no severity 1–3 findings, but
its JavaScript parser crashed on four modern LWC files; that scan must not be
presented as complete JavaScript lint coverage. The remaining tooling correction
is recorded in the follow-up commit.
The installed subscriber beta remains 0.2.0.3; the new zero-arithmetic correction
requires a later package build/install before it can be verified there. This
review uses the existing orgs and does not consume a package build allocation.
Browser rendering is unverified; no screen capture or Computer Use was started.
