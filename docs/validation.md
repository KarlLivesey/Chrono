# Chrono validation

## Unreleased 0.2.0.3 — date and native-schedule coverage

The two identified bulk-input gaps are fixed across Apex services, scalar/collection Flow actions and custom action editors:

- Working-time add and elapsed difference accept native Date/Datetime and ISO date/local date-time/instant/zoned date-time inputs. Local dates mean midnight in an explicit timezone; difference supports an independent end timezone and repeated-time policy.
- Add, scheduled difference, check and find accept supplied native OperatingHours, TimeSlot and Holiday records, including unsaved records. Shared saved-ID loading remains three queries per invocation; supplied-only calculations need no queries or DML.

Full development deployment `0AfG100000LNgaLKAT` passed **240 Apex tests**. The final focused test deployment `0AfG100000LNaYFKA1` passed **11 tests**. **145 LWC tests**, **43 Temporal tests** and **19 contract tests** pass, as do formatting and the configured PMD severity threshold. Low-severity PMD findings remain.

One skip-validation build produced **0.2.0.3**, `04tgK000000KIYfQAO` (`08cgK000000H4ATQA0`). The existing subscriber was restored to released **0.1.0.19** with its original fixtures, passing **47 tests**, then upgraded successfully to the candidate (`0HfAs000002bZvJKAU`). Post-upgrade deployment `0AfAs00000X89XmKAJ` passed **83 subscriber tests**, including actual scalar and collection Flow execution with native records and local endpoints. Installed action descriptions confirm correct native record types, optional schedule ID and custom-editor registrations.

The original 70 active Chrono fixtures and packaged permission assignment are restored, with four new native-record fixtures added. No new scratch org or standard build was used. This remains an unreleased beta: skip-validation installation and execution evidence does not replace standard release validation. Browser rendering remains unverified.

See [bulk Apex services](bulk-apex-services.md#validation) for the contract changes, query-budget checks and detailed evidence.

## First released version — 8 September 2026

Karl explicitly approved one standard package build with coverage. The frozen
candidate produced **0.1.0.19**, **`04tgK000000KFNtQAO`**, request
**`08cgK000000H3PhQAK`**. The build succeeded with **91% package coverage**:
`ValidationSkipped=false`, `ValidatedAsync=false`,
`HasPassedCodeCoverageCheck=true`. After Karl separately approved promotion,
**0.1.0.19 was promoted successfully** and a fresh package report confirmed
**`IsReleased=true`**.

Exactly one standard allocation was consumed: **5/6 remain**. Quick-build
allocation remains **490/500**. This approval applies to this build only;
subsequent builds still default to skip-validation unless separately authorised.

The 814-file frozen input snapshot (package sources, scratch configuration and
project settings) has manifest SHA-256
`5bdd33f92171c4b230a3532fb63b23563eff5f819477f31d1f4ece15bf42de9f`.
The API/source implementation was not changed for this build. Workspace package
sources and configuration were checked against the frozen manifest after the
build; only the new version alias differs.

Installation **`0HfAs000002bQFJKA2`** succeeded in `chrono-subscriber`, and its
installed-package inventory confirms **0.1.0.19**. All **30 shared conformance
cases** passed against native Temporal and the installed package
([results](../tests/conformance/results/subscriber-0.1.0.19.json)). All **54
installed actions** passed labels, categories, calendar icons and configuration
editor registration checks. The saved permission assignment was restored.

The fresh subscriber backup contained all 70 Flow versions, eight consumer test
classes and the consumer LWC. Restoration **`0AfAs00000X7kBCKAZ`** succeeded for
all **79 components**, with zero component errors. All **13 example Flows** are
active. The full subscriber run, including managed-package tests, passed **210
tests**, with zero failures or skips, run **`707As00001VvBLX`**.

This is the first released API baseline. Browser rendering and an upgrade from
a released ancestor remain unverified; an upgrade check needs a subsequent
descendant. No additional scratch org or package build was created during
subscriber verification or promotion.

## First-release preflight — 8 September 2026

At preflight, the Dev Hub listed 18 Chrono versions, all unreleased. There is no released ancestor
for an upgrade test yet. The first promoted version will establish that baseline;
subsequent candidate versions must preserve the contracts and specify ancestry.

- Ran only the **24 packaged test classes** in `chrono-dev` with coverage collection:
  **161 tests passed**, run **`707G1000019XVhO`**. The development run reported
  **95% test-run coverage** and **91% org-wide coverage**. These are development
  measurements, not the package-build coverage required for promotion.
- The tested package at preflight was **0.1.0.18**, installed with the 210-test subscriber
  evidence below. A frozen local copy of `force-app`, configuration and package
  settings was prepared for the validated build; no source/API changes were made.
- Before approval, standard allocation was **6/6** and quick allocation **490/500**.
  The prepared standard build with `--code-coverage` awaited explicit approval
  under the allocation policy in `AGENTS.md`; its subsequent result is above.
- Promotion has not been performed. It is irreversible and must follow review of
  the validated package result. A released-version upgrade remains unverified
  until a released baseline and a subsequent descendant exist.

Salesforce documents the [package coverage requirement](https://developer.salesforce.com/docs/platform/pkg2-dev/guide/sfdx-dev-dev2gp-code-coverage.html),
[irreversible promotion](https://developer.salesforce.com/docs/platform/pkg2-dev/guide/sfdx-dev-dev2gp-get-ready-promote.html)
and [package ancestry](https://developer.salesforce.com/docs/platform/pkg2-dev/guide/sfdx-dev-dev2gp-config-ancestors.html).

## Review closure — 8 September 2026

Closed the identified implementation and compatibility-protection items without
changing the native public API or existing Flow/component inputs and outputs:

- Global API checks now detect property accessor visibility changes, enum-member
  changes and implicit global-interface method changes. The original **1,471
  global declarations** and **121 core service signatures** remain unchanged.
- Added a baseline for **84 LWC metadata contracts** (including Flow property
  types, roles, defaults and targets), public LWC members/defaults, and **61 Apex
  transport types**. Controller sharing declarations are included. The check
  rejects overloaded Aura endpoints while allowing native service overloads.
- Replaced cross-class JSON conversions with **15 typed input adapters**. A
  mapping regression check detects shared fields missing from an adapter.
  Existing formatting-reference semantics are preserved. Same-type cloning and
  external JSON definitions retain their appropriate serialisation paths.
- Corrected `ChronoPlainDateTimeService.toZonedDateTime` policy documentation:
  null/omitted means `reject`; `earlier`/`later` select repeated-time occurrences;
  nonexistent times still reject. The installed 0.1.0.17 review reproduced both
  successful London repeated-time choices before changing the documentation.
- Scoped development deployment **`0AfG100000LNDtKKAX`** passed **205 Apex tests**.
  The affected org classes were compared before overriding source-tracking
  conflicts; unrelated org metadata was not deployed. Subsequent source changes
  were documentation-only and were synchronised separately.
- Local checks passed: **14 contract regression tests**, **138 LWC tests**,
  **43 native Temporal tests**, formatting and `git diff --check`. PMD reported
  **zero severity 1–3 findings**, with **628 low-severity findings**.
- Development mixed-workload check passed: 200 distinct allocations plus 20
  real conversion Flow interviews used **5,530 ms** measured CPU (**5,557 ms**
  including setup/assertions) in the measured transaction, with every allocation
  total and Flow result asserted and no DML.

Installed evidence for the review closure:

- One skip-validation package build: **0.1.0.18**, **`04tgK000000KEd7QAG`**,
  request **`08cgK000000H3G1QAK`**. Installation **`0HfAs000002bP37KAE`**
  succeeded in the existing subscriber org. All **six standard build allocations
  remain available**; quick-build allocation is **490/500**. No scratch org was
  created, and no standard/async validation or promotion was performed.
- The fresh backup contained all **70 Flow versions**, **eight consumer test
  classes** and the consumer LWC. Restoration **`0AfAs00000X7i4XKAR`** succeeded
  for **79 components**. All **13 example Flows** are active and the saved
  permission assignment is restored.
- All **54 installed actions** passed labels/categories/calendar-icon/editor
  checks. Subscriber Apex cannot access the new `ChronoRangeInputs` adapter
  (`Type is not visible`).
- All **30 shared conformance cases** passed against both native Temporal and
  the installed package. [Conformance results](../tests/conformance/results/subscriber-0.1.0.18.json).
- The **49 external consumer tests** passed, run **`707As00001Vuv42`**.
  The subsequent full run including managed-package tests passed **210 tests,
  zero failures**, run **`707As00001VuzVT`**.
- Installed mixed-workload benchmark: 200 distinct allocations plus 20 real Flow
  interviews per sample, one warm-up and three fresh measured transactions.
  Median measured CPU was **6,301 ms** (range **6,063–7,023 ms**). Including
  setup/assertions, the highest measured CPU was **7,053/10,000 ms**, leaving
  **2,947 ms** in that transaction. All block totals and Flow outputs passed;
  no DML occurred. These are observed results for this bounded workload, not a
  guarantee for arbitrary customer automation or maximum-size inputs.
  [Raw benchmark results](../tests/benchmarks/results/review-closure-0.1.0.18.json).

The identified review items are closed. The changes preserve existing consumer
contracts and need no consumer migration. Standard release validation and a
released-version upgrade remain separate release checks; this beta validation
does not claim either. Browser rendering was not exercised, and no screen capture
or Computer Use service was started.

## Global API migration — 8 September 2026

Implemented the [approved API mapping](global-api-audit.md): explicit ISO and
elapsed-difference method names, actual partial-date components, consistent
public timezone/allocation fields, native-only time-block annotations removed,
and exclusive fiscal endpoints alongside the inclusive `lastDate`. Explicit null
disambiguation now uses the same `reject` default as omission.

- Development deployment **`0AfG100000LNH0rKAH`** passed **205 Apex tests**.
  Package sources were compared with the successfully deployed sources before
  subscriber validation. The new test assertions were corrected to preserve the
  existing duration spelling (`PT3600.000S`) and Salesforce's non-null assertion
  message requirement; no duration serialisation behaviour was changed.
- One **skip-validation** build: **0.1.0.17**, **`04tgK000000KDynQAG`**,
  request **`08cgK000000H3EPQA0`**. Installed in the existing subscriber org by
  request **`0HfAs000002bOyHKAU`**. No new scratch org or standard/async-validation
  build. Standard allocation remains **6/6**; quick allocation is **491/500**.
- Backed up all **70 subscriber Flow versions**, seven original local test classes
  and the consumer LWC before beta replacement. Fixture restoration
  **`0AfAs00000X7S6EKAV`** deployed **79 components**, including the new external
  API tests. All **13 example Flows** are active and saved package permission
  assignments are restored.
- Final full installed suite: **210 passed, zero failed**, run
  **`707As00001VulaY`**. This includes direct field assignment, partial-date
  validation, null policies, signed elapsed differences, fiscal-to-range
  composition across a DST change, scalar/collection Flow bindings and allocation
  loop fields. The fiscal Flow assertions explicitly account for
  `Flow.Interview` serialising native Date outputs as UTC midnight; the action
  and Flow metadata still declare those fields as Date. The corrected external
  assertion fixture was deployed by **`0AfAs00000X7f3SKAR`** before this full run.
- All **30 shared Temporal/Apex fixtures** passed against the installed package.
  [Saved conformance results](../tests/conformance/results/subscriber-0.1.0.17.json).
- All **54 installed actions** passed label/category/calendar-icon/editor checks.
  The installed fiscal action exposes `lastDate`, `endExclusiveDate`,
  `endExclusiveValue` and `endExclusiveInstant`; retired ambiguous endpoint names
  are absent. Direct subscriber access to `ChronoInstantOperations` still fails
  compilation with **Type is not visible**.
- Local checks: **138 LWC tests**, **43 native Temporal tests** and **four API guard
  regression tests** passed. The guard covers **1,471 global declarations** plus
  all **121 core service signatures** and their forwarding bodies. All **27**
  scalar/collection input field lists match. PMD reported **zero severity 1–3
  findings** and 630 low-severity findings. Formatting and `git diff --check` pass.
- Installed benchmark medians per 200 operations: **83 ms** for duration
  parse/serialise, **4,820 ms** for distinct allocation. All workload assertions
  passed. [Measurements and comparison limits](../tests/benchmarks/API-MIGRATION.md).

These are deliberately breaking beta API changes, including the block-definition
JSON key `days` becoming `weekdays`. Update saved definitions and Apex/Flow bindings
using the migration table. This validates the installed beta; it does not establish
released-version upgrade compatibility, standard package validation, coverage for
promotion or browser rendering. No screen capture or Computer Use was started.

## Public API separation and allocation precision — 8 September 2026

The [API boundary review](api-boundaries.md) separates the eight public core
services from their internal implementations. All **121 signatures** are
unchanged. A source-token comparison confirmed that the moved core algorithm
bodies are unchanged after class/access substitutions. The new contract check
passes and was also exercised against deliberate signature and delegation
violations in temporary copies; both were rejected.

The separate allocation correction preserves the default millisecond precision.
Optional coarse lax rounding now ignores boundaries introduced only by losing
blocks. The prior behaviour was reproduced against installed 0.1.0.15: one
minute's credit became zero after adding a losing block halfway through it.
Two new tests cover the correction, millisecond precision, segment reconciliation,
changes of winner and unallocated gaps.

- Development deployment `0AfG100000LNEMLKA5` succeeded: **197 tests passed**,
  including all 12 allocation tests; zero component/test errors.
- The initial test deployment exposed an already-invalid legacy development
  fixture, `ChronoCoreSubscriberConsumer`, calling the retired core instance API.
  It was backed up and changed to the existing public service calls; repair
  deployment `0AfG100000LNEHVKA5` succeeded. Org-side edits to four action
  extensions were preserved by deploying only the 19 changed Apex classes.
- PMD: **zero severity 1–3 findings**, 622 low-severity findings retained.
  Formatting, `git diff --check` and `npm run test:contracts` pass.
- One **skip-validation** build: **0.1.0.16**, `04tgK000000KDNhQAO`, request
  `08cgK000000H2v3QAC`. No standard/async-validation build or new scratch org.
- Subscriber installation `0HfAs000002bOGjKAM` succeeded. The public allocation
  call now retains 60,000 milliseconds after adding the losing block, with zero
  rounding remainder. A direct subscriber call to `ChronoInstantOperations`
  fails compilation with **Type is not visible**; the public service remains
  usable.
- All **30 shared Temporal/Apex fixtures agree** with their expected results
  against the installed package. See [the report](../tests/conformance/results/subscriber-0.1.0.16.json).
- Installed benchmarks passed their assertions: duration parse/serialise median
  **74 ms**, distinct allocation median **5,116 ms**, each per 200 operations.
  See [the measurements and limits](../tests/benchmarks/SERVICE-BOUNDARY.md).
- Standard allocation remains **6/6**; quick-build allocation is **492/500**.
- Subscriber deployment `0AfAs00000X7auzKAB` restored all **78 fixture components**;
  all **13 example Flows are active** and the package permission assignment is
  restored. Full installed subscriber suite: **202 passed**, run `707As00001VuflH`.

This validates the tested installed beta contracts, including public/internal
visibility. It does not establish released-version upgrade compatibility,
standard package validation or release coverage. Browser rendering remains
unverified; no screen capture or Computer Use service was started.

## Time allocation — 8 September 2026

Installed skip-validation beta **0.1.0.15**, `04tgK000000KDHFQA4`, in the existing
subscriber org. Build request `08cgK000000H2rpQAC`; installation
`0HfAs000002bKhnKAE` succeeded. This feature used **three quick builds**
(0.1.0.13–0.1.0.15): two subsequent editor corrections addressed malformed saved
field types and duplicate missing-block validation messages. No standard or async
validation build and no new scratch org was used. Standard allocation remains
**6/6**; quick-build allocation changed from **496/500 to 493/500**.

- Installed subscriber Apex: **200 passed**, run `707As00001Vu81R`.
  The first run, `707As00001VuSgc`, passed 197 and failed three consumer fixtures
  because they attempted subscriber-side JSON deserialisation into packaged
  classes. The fixtures now construct the public data objects using their global
  constructors and fields. Fixture-only deployment `0AfAs00000X7WWQKA3` succeeded;
  no additional package build was required. The same fixture correction was
  deployed to development in `0AfG100000LNDdBKAX`.
- Development evidence: full suite **197 passed**, run `707G1000019X5Bh`, followed
  by **six consumer tests passing** after the added native-record, error-isolation
  and nested-loop checks. The final constructor-based fixture change was compiled
  in development and exercised in the installed subscriber's full 200-test run.
- Ten allocation engine tests cover adjacent and overnight blocks, native
  partial/recurring holidays, all overlap modes, changing overlap sets, rounding
  reconciliation, DST elapsed/clock differences, limits and 200-interview batching.
- Six external consumer tests execute global services and actual Flow interviews,
  including native Date/Holiday inputs, primitive total fields, scalar loops,
  nested collection loops, independent result graphs and errors with no partial
  totals. Flow block JSON is parsed inside the package; subscriber-side generic
  `JSON.deserialize` into its input classes is not a supported construction path.
- LWC Jest: **138 passed** across 14 suites; native Temporal: **43 passed**.
- PMD: **zero severity 1–3 findings**, 535 low-severity findings retained.
  Formatting and `git diff --check` pass.
- All **54 installed actions** passed label/category/calendar-icon/editor checks.
  All **78 subscriber fixture components** were restored by deployment
  `0AfAs00000X7XieKAF`, together with the saved package permission assignment.
  All **13 example Flows are active**, including `ChronoExampleTimeAllocation`.
- Allocation benchmark: **4,643 ms median CPU per 200 distinct requests**;
  measured range 4,328–4,661 ms, highest measured total transaction CPU 4,689 ms.
  Every request's block totals were asserted. See the
  [workload and raw report](../tests/benchmarks/TIME-ALLOCATION.md).

The new service, data contracts, actions and editor are additive; existing global
signatures are unchanged by this feature. This was beta replacement, not a
released-version upgrade. A skip-validation build does not establish standard
package validation, release coverage or promotability. Live Flow Builder
rendering, screen interaction and keyboard behaviour remain **unverified**; no
Computer Use or screen capture was started.

## Follow-up validation — 8 September 2026

Installed skip-validation beta **0.1.0.12**, `04tgK000000KCxtQAG`, in the existing
subscriber org. Build request `08cgK000000H2dJQAS`; installation
`0HfAs000002bL18KAE` succeeded. No new scratch org or standard build was used. Standard allocation remained **6/6**;
quick-build allocation changed from **497/500 to 496/500**.

- Development Apex: **184 passed**, run `707G1000019X34W`.
- Installed subscriber Apex: **184 passed**, run `707As00001VuHvw`.
- LWC Jest: **131 passed** across 13 suites; native Temporal: **43 passed**.
- Shared dataset: **30/30 fixtures agree** between native Temporal and installed
  Apex, including expected errors. See [saved results](../tests/conformance/results/subscriber-0.1.0.12.json).
- PMD: **zero severity 1–3 findings**, 507 low-severity findings retained.
- All **52 installed actions** passed label/category/icon/editor checks.
- Restored **72 subscriber fixture components**, including the external LWC
  consumer, and restored the package permission assignment. Deployment
  `0AfAs00000X7YOZKA3` succeeded; all **12 example Flows are active**.
- Duration parsing: **118 → 80 ms** median CPU per 200 operations. Distinct
  availability: **3,239 ms**; distinct recurrence: **4,919 ms** per 200 requests.
  See [workloads, raw reports and limits](../tests/benchmarks/FOLLOWUP.md).

These checks validate the installed beta's tested consumer contracts. A quick
build does not provide standard package validation or release coverage. Live
browser rendering and keyboard behaviour remain unverified; no screen capture
or Computer Use service was started.

Validation performed against Salesforce API 67.0. The latest catalogue checks are recorded first.

## Hardening and benchmarks — 8 September 2026

See the [review and corrections](hardening-and-benchmarks.md) and
[repeatable benchmark suite](../tests/benchmarks/README.md).

- Full development-org Apex suite: **183 passed**, run `707G1000019WK3d`.
- Full installed subscriber Apex suite: **183 passed**, run `707As00001Vsrdp`.
- LWC Jest: **127 passed** across 13 suites. Native Temporal: **13 passed**.
- PMD: **zero severity 1–3 findings**, 506 low-severity findings retained.
  Formatting and `git diff --check` pass.
- One additional skip-validation beta: **0.1.0.11**, package version
  `04tgK000000KCBVQA4`, creation request `08cgK000000H2TdQAK`.
- Installation **SUCCESS** in the existing subscriber org, request
  `0HfAs000002bDy1KAE`. This was beta replacement, not a released-version upgrade.
- Backed up and retired all 65 local fixture Flow versions before replacement;
  restored all 72 fixture components successfully, deployment
  `0AfAs00000X76DoKAJ`. All twelve example Flows are active and the saved
  permission assignment is restored.
- Subscriber fixture compilation includes all seven newly exposed reusable LWC
  controls. All **52** installed action labels, categories, icons and editor
  registrations were verified through the Actions API.
- The read-only subscriber script
  `tests/subscriber/scripts/hardening-boundaries.apex` passes against the installed
  global API. It checks minimum signed duration round-trips and explicit rejection
  of overflowing duration, calendar and Unix values.
- Standard package builds remain **6/6 available**; quick builds **493/500**.
  No new scratch org was created. The quick build does not establish standard
  package validation, release coverage or promotability.
- All **16 Apex benchmark cases** and **nine client benchmark cases** passed their
  output assertions. Measurements and observed costs are in the
  [comparison](../tests/benchmarks/COMPARISON.md).
- Browser rendering and live interaction remain **unverified**. No Computer Use,
  browser capture or screen recording was started.

## Data-only services and reusable controls — 8 September 2026

The eight core values and Flow request/result records now contain data and empty
constructors only. Construction, validation, conversion and copying live in
services; action engines share an internal interface. This intentionally breaks
the unreleased beta Apex API. See the [migration and controls](service-and-component-delivery.md).

- **179 development-org Apex tests passed**, run `707G1000019WNKP`, after the
  final request/result adapter migration. Includes manually assigned/mutated core
  fields, native overloads, DST/calendar arithmetic, independent copies, working
  calendar days and booking constraints through scalar/collection Flow interviews.
- **125 LWC tests** and **13 native Temporal tests passed**. New component tests
  cover range ordering and cleared values, changed schedule validation, Flow output
  feedback, appointment restoration/stale responses, recurrence preview invalidation,
  date-specific timezone offsets, record FLS and optimistic record version checks.
- Formatting passes. PMD Recommended/AppExchange has **zero severity 1–3 findings**;
  **494 low findings** remain. Lint is separate from packaging and integration checks.
- Created **two skip-validation betas**. The first, **0.1.0.9**
  (`04tgK000000KBovQAG`, request `08cgK000000H2QPQA0`), exposed a real subscriber
  composition issue: the new reusable LWCs were packaged with `isExposed=false`.
  It also caught missing namespace qualifiers in migrated test fixtures.
  The corrected **0.1.0.10** is `04tgK000000KC0DQAW`, request `08cgK000000H2S1QAK`.
  Seven reusable controls now explicitly allow cross-namespace composition, in
  accordance with [Salesforce packaging rules](https://developer.salesforce.com/docs/platform/lwc/guide/use-packaging-add.html).
  Standard build allocation remains **6/6**; quick builds **494/500**. No new
  scratch org, standard build or async-validation build.
- All twelve example Flow definitions deployed successfully in `chrono-dev`.
  Four new examples cover value controls, ranges, appointments and recurrence.
  [Run and edit links](flow-examples.md) identify the active definitions.

- **0.1.0.10 installed successfully** in the existing subscriber org,
  installation `0HfAs000002bDwPKAU`. All **179 tests passed** with
  `RunAllTestsInOrg`, run `707As00001VslOL`, including installed package tests
  and subscriber-owned fixtures. All six subscriber test classes compiled.
- The subscriber LWC composition fixture compiled using all seven reusable
  controls (plus the existing picker and timezone display). Tooling metadata
  confirms all seven are exposed. All **52 installed action labels, categories,
  calendar icons and editor registrations** match source. All **12 example
  Flows are active**. The original permission assignment and demo schedules
  were preserved.

The subsequent hardening and benchmarking review is recorded separately.

Browser rendering, real pointer/keyboard interaction and record-page save in a live
browser remain **unverified**. No Computer Use or screen capture was started.
Component tests use Salesforce's Jest base-component mocks. A skip-validation
build is not full dependency/coverage/release validation, and cannot be promoted.

## Complete action catalogue — 8 September 2026

Chrono now provides **25 families / 50 Flow actions**, with scalar and explicit
collection forms, nine flat categories and individual LWC configuration editors.
See the [catalogue](action-catalogue.md) for operations, native/ISO inputs,
boundaries and supported recurrence rules.

- **169 development-org Apex tests passed**, run `707G1000019WIKI`. The suite
  includes native inputs, DST gaps/overlaps, range arithmetic, locale formatting,
  recurrence, independent collection outputs and a 200-request availability
  batch with three shared schedule queries. After the namespace-specific fixture
  corrections, all 15 catalogue consumer tests passed again in development
  (`707G1000019WJ8J`).
- **106 LWC tests** and **13 Temporal tests** passed. Formatting and the PMD
  Recommended/AppExchange severity 1–3 gate passed; **328 low** findings remain.
- Created exactly **one skip-validation beta**, **0.1.0.8**
  (`04tgK000000KA01QAG`), request `08cgK000000H25RQAS`. It installed successfully
  in the existing `chrono-subscriber`, installation `0HfAs000002bBRaKAM`.
  No scratch org, standard build or async-validation build was created.
  `Package2VersionCreates` remains **6/6** and quick-build allocation is **496/500**.
- **35 subscriber-owned tests passed**, run `707As00001VsqkE`. The new fixtures
  exercise all 28 added scalar/collection actions through actual Flow interviews,
  including unsaved native OperatingHours/TimeSlot inputs and native auxiliary
  date bounds, collection filters and Datetime references.
- **48 targeted installed-package tests passed**, run `707As00001Vspcs`, covering
  the new engines plus existing calculation extensions. The fiscal Flow action
  separately matched the subscriber’s real Period IDs, labels and boundaries for
  its configured year, quarter and month.
- Salesforce action descriptions confirmed all **50 labels, categories, calendar
  icons and custom-editor registrations**. All 50 referenced editor bundles are
  installed in `skel`. The API normalises category punctuation, for example
  returning `Chrono Values` for the source label `Chrono: Values`.
- Retrieved the previous subscriber fixtures before replacing its beta, retired
  all 30 enumerated Flow versions and their dependent test classes/LWC, and saved
  the permission assignment. After installation, restored the fixtures and the
  original Chrono Flow User assignment. **59 Chrono Flows are active**, including
  eight screen examples. The new recurring-meetings example chains recurrence,
  collection summary, formatting and range validation. Unrelated Flows and saved
  schedule/holiday records were not removed.

Two observed namespace boundaries matter: external JSON deserialisation of the
packaged request classes and JSON serialisation of packaged result classes were
rejected. The consumer fixtures now construct requests using global constructors
and field assignments and read typed result fields directly; the actual scalar
and collection Flow contracts pass. Internally, native TimeSlot records are copied
directly because a typed Apex JSON round trip rejects their serialised Time fields.
No extra JSON access annotation or public conversion API was added to bypass these
restrictions.

Browser rendering, interactive Flow Builder behaviour and the new screen example’s
visual presentation were **not checked in a browser**. No screen capture or Computer
Use service was started. Metadata inspection, component tests, installation and
actual Flow execution are the evidence above. This quick beta cannot be promoted;
standard build validation, package coverage and released-version upgrades remain
separate release checks requiring the appropriate authorisation.

The remaining sections are historical milestones.

## Seven additional operations and installed subscriber validation — 7 September 2026

Chrono now has **11 operations / 22 invocable actions**, each with single-value
and collection entry points and an LWC configuration editor. The additions are
working-time checks, next/previous working time, comparison, period boundaries,
rounding, local-time inspection/resolution and calendar difference. Calendar
months/days and the remaining milliseconds are separate outputs; callers can
ignore the remainder. See [the operation contracts](flow-actions.md).

- **117 Apex tests passed** in the namespaced development org, run
  `707G1000019Vxfl`. After correcting the consumer query-counter assertions,
  both affected consumer classes passed again: **14 tests**, `707G1000019VskK`.
- **94 LWC tests** and **13 JavaScript/Temporal tests** passed. The PMD
  Recommended/AppExchange severity 1–3 gate passed with **208 low** findings.
- Created one **skip-validation** package version, **0.1.0.7**
  (`04tgK000000JvCHQA0`), request `08cgK000000H1pJQAS`, and installed it in the
  existing `chrono-subscriber`. No scratch org was created. All **6 of 6**
  standard `Package2VersionCreates` allocations remain available.
- Before replacing beta 0.1.0.6, retrieved a complete backup of the subscriber
  fixtures, deactivated their FlowDefinitions and retired every enumerated Flow
  version plus dependent subscriber test classes/LWC. The new package installed
  successfully, the current fixtures were restored, and Chrono Flow User was
  assigned. The Salesforce-provided report-export Flow was not touched.
- **20 subscriber-owned Apex tests passed**, run `707As00001VsF4Q`. These invoke
  the installed package through real scalar and collection Flow harnesses,
  including 200-interview platform batches and independent ordered results.
- **14 installed package tests passed**, run `707As00001VsFbo`, specifically the
  working-time and schedule-operation suites. These assert the exact three-query
  schedule load for 200 requests inside the package. The subscriber caller's
  `Limits.getQueries()` reported zero for that work despite correct results;
  consumer tests therefore check their own query budget separately and retain
  exact query-count assertions only when running inside `skel`.
- **All seven screen examples passed live execution in the subscriber org**.
  The planning example chains all seven new operations: Sunday 16:37 rounds to
  16:45, is closed, skips Monday's holiday and returns Tuesday 09:00. Calendar
  wait is one day plus 58,500,000 ms, separately available. The other examples
  cover native dates, repeated and skipped times, working hours, elapsed versus
  working difference, and ordered collection failures.

- **All seven new scalar action editors loaded in subscriber Flow Builder**.
  Read-only checks opened each installed action in its autolaunched fixture and
  verified the shared value-type input and its operation-specific control:
  resolution, rounding unit, schedule ID, direction, boundary, end input format
  and largest calendar unit. The fixture checks avoid the long planning canvas's
  off-screen nodes; no Flow was saved. Collection editor rendering was not checked
  live. Reproduce with [the live-check scripts](../tests/feasibility/flow-editors/README.md).

Live checks used an isolated headless browser with CLI authentication and no
screen capture, video, personal-browser access or Computer Use service. This is
not a screenshot-based light/dark visual audit. A quick build does not validate
package dependencies, calculate package coverage or permit promotion; no standard
build, promotion or released-version upgrade has been tested.

The sections below are historical milestones; the 0.1.0.7 install above supersedes
their statements that the subscriber package predates the latest changes.

## Action editors and complete examples — 7 September 2026

All eight invocable actions now register namespaced LWC custom property editors,
sharing the screen editor's compact literal/resource controls. The fixed schedule
editor uses a timezone lookup, compact weekday controls and paired time fields.
See [the six complete examples](flow-examples.md) and the reproducible
[live-check scripts](../tests/feasibility/flow-editors/README.md).

Observed checks in the existing namespaced `chrono-dev`:

- The action editor loads in actual Flow Builder. Held-mouse timezone choices
  persist. Switching a populated native Datetime input between literal/resource
  modes keeps the native format. Selecting a compatible formula, restoring the
  picker output, saving a new draft, reloading and reopening preserves the binding
  and timezone. Saved draft: `301G100000kgw8lIAA`.
- The fixed-hours screen editor fits the observed **279 px sidebar**: preset
  height **32 px**, paired time fields **126.5 px** each. Selecting Tokyo,
  adding five weekdays and toggling a partial-day holiday works. Test changes
  were discarded; the example's saved schedule selection remains intact.
- Live action execution gives 28 February for January 31 plus one month; the
  second London overlap converts to New York 21:30 on the previous date; the
  spring gap's forward boundary is exactly 02:00 local / 01:00 UTC; Friday 16:30
  plus a working hour returns Tuesday 09:30. Difference gives 89 elapsed hours
  versus one working hour. Collection conversion preserves two successful items
  and reports the invalid third date in order.
- Actual Aura schedule requests exposed a null/empty allowlist transport problem:
  unrestricted lookup returned no schedules despite a successful direct Apex
  query. The bridge now carries explicit `useIdFilter`; false means unrestricted
  readable schedules, true means the supplied allowlist. Missing flags remain
  restricted. User-mode reads and configured filters still apply.
- **85 Apex tests passed**, run `707G1000019Vqp3`, including allowlist behaviour,
  schedule access and existing Flow scalar/collection batching. **83 LWC tests**
  and **13 JavaScript/Temporal tests** pass. The PMD severity 1–3 gate passes with
  145 low-severity findings. Scoped suppressions cover the primitive Aura bridge
  and Salesforce-required bubbling/composed configuration events.

The live checks used isolated headless Chromium through the CLI, without screen
capture, recording or the personal browser. Geometry and interaction were checked;
this is not a screenshot-based light/dark visual audit. No scratch org or package
version was created. The existing subscriber package remains **0.1.0.6**: these
new editor registrations and schedule bridge changes still require an updated
package install and subscriber validation before release.

## OperatingHours difference — 7 September 2026

Both difference actions now accept an optional saved `operatingHoursId` (per item
for collections). Omitting it retains unrestricted elapsed difference with no
schedule queries. Configuration remains native OperatingHours, TimeSlot and
associated Holiday records, read through the existing user-mode bulk loader.
The new exposed field is an optional String on the existing global request
contracts; no new Apex-defined types or package dependencies were introduced.

- Deployed implementation and Flow helper metadata to the existing namespaced
  `chrono-dev`. Final engine deployment: `0AfG100000LMnqoKAD`.
- **85 Apex tests passed**, run `707G1000019Vmxe`. Coverage includes the Friday to
  Tuesday bank-holiday example, negative/equal/closed intervals, partial holidays,
  overlapping slots, millisecond boundaries, spring gaps, autumn repeated windows
  and a historical midnight rollback that revisits the previous date.
- Actual scalar and collection Flow harnesses pass the schedule ID and return
  working-duration results. A platform invocation of 200 scalar Flow interviews
  returns one working hour each with three schedule queries total. Separate
  tests cover 200 collection interviews, multiple schedules, per-item failures,
  calculation reuse and independent result copies.
- Formatting and the PMD recommended/AppExchange severity 1–3 gate passed;
  145 low-priority findings remain. No LWC source changed in this feature.
- No scratch org or package version was created. The installed subscriber beta
  remains 0.1.0.6, so **the new optional input is not yet validated across an
  installed package boundary**. Updated subscriber fixtures are ready for that
  check after a future consolidated quick build. Flow Builder rendering was not
  inspected; helper metadata was accepted by deployment.

The checks below record earlier validation milestones.

## Development checks

- Reused `chrono-dev` in the `skel` namespace.
- **70 Apex test methods passed**: 60 package tests and ten consumer tests.
- Package source coverage: **1,815 of 1,877 executable lines (96.7%)**, calculated
  from development-org test results, excluding consumer and obsolete scratch-only
  classes. This is not package-build coverage.
- Formatting and the PMD recommended/AppExchange severity 1–3 gate passed.
  There are 130 low-priority ApexDoc and test `runAs` suggestions.
- Core tests cover all eight types, native/ISO round trips, both call styles,
  calendar versus elapsed arithmetic, invalid dates, DST gaps/overlaps including
  Lord Howe, recurring/partial holidays, working subtraction and short opening
  windows inside DST transitions.
- Flow tests cover all eight action entry points, single values, collections,
  200-interview batches, nested ordering, partial failures, empty/null inputs,
  duplicate calculation reuse and independent output copies.
- OperatingHours loading uses three queries across multiple schedules and 200
  interviews, including collections. BusinessHours uses one user-mode lookup.
- The Friday 16:30 plus one working hour example returns Tuesday 09:30 with Monday
  configured as a bank holiday. Negative working-time arithmetic is also tested.
- A Minimum Access profile test proves that schedule reads enforce permissions;
  pure conversion remains usable without schedule access.

## Managed package and subscriber checks

The current beta is **0.1.0.6**, subscriber version **`04tgK000000Jp8TQAS`**,
created by request `08cgK000000H1EDQA0` with **`--skip-validation`**.
It installed successfully into the existing, non-namespaced `chrono-subscriber`
org (installation request `0HfAs000002b9b3KAA`).

A deployment (`0AfAs00000X6b8NKAR`) using `RunAllTestsInOrg` passed
**70 test methods with no failures**: **60 packaged tests in `skel` and ten
unpackaged consumer tests**. Consumer tests
exercise global APIs and run eight actual autolaunched Flow harnesses against the
installed actions. They verify:

- Conversion, ordinary arithmetic, elapsed differences and working time, each
  through single-value and explicit-collection Flow actions.
- Apex-defined input/result collections across the package boundary, native
  datetime/date outputs, negative durations, and millisecond values beyond the
  32-bit integer range.
- **200 Flow interviews** submitted through the platform's Flow invocable runtime,
  preserving one ordered result per interview.
- Item-level failures that preserve successful siblings.
- The bank-holiday working-time example through both working-time Flows.
- The global time-zone configuration helper from unpackaged consumer Apex.

The Actions API lists all eight installed actions with their readable labels.
The installed conversion action reports the **Chrono** category, calendar icon
and enumeration metadata for its type, target type, repeated-time policy and
zone inputs. Metadata list/retrieve calls confirm all eight
`InvocableActionExtension` components are installed in `skel`. Their deployment
validated the grouping, ordering, picklist and controlling-field attributes.
Browser rendering was not manually checked; validation uses CLI and automated
checks as requested.

Salesforce's extension validator required action-local invocable request wrappers
for scalar parameter targets. Explicit collection types remain top-level with
global constructors and Aura-enabled fields. Generic cross-namespace
`JSON.deserialize` is not enabled for these package DTOs; subscriber tests create
and populate them through their global constructors/fields, as Flow assignments do.

Salesforce does not permit an in-place beta upgrade. The old consumer test classes
and Flow versions were removed before replacing beta 0.1.0.4 with 0.1.0.5,
then 0.1.0.6. The final build includes narrow-column popover positioning and
reactive schedule validation while the picker is disabled.
Consumer classes, Flows and the LWC fixture were then restored from `tests/subscriber`. Local test
sources were retained throughout. No new scratch org was created for this phase.
This verifies a fresh installation, not released-package upgrade compatibility.

The previous 0.1.0.2 quick beta (`04tgK000000JnGLQA0`) passed 35 tests before the
Flow work. The initial 0.1.0.1 (`04tgK000000JnEjQAK`) used a standard build before
the explicit allocation policy was established. No release has been promoted.

## Allocation usage

The existing `chrono-dev` and `chrono-subscriber` orgs expire 13 September 2026.
Further org creation requires checking with Karl.

| Allocation                              | Before compact picker builds | After                |
| --------------------------------------- | ---------------------------- | -------------------- |
| Package2VersionCreates                  | 6 of 6 remaining             | 6 of 6 remaining     |
| Package2VersionCreatesWithoutValidation | 500 of 500 remaining         | 498 of 500 remaining |
| ActiveScratchOrgs                       | 1 of 3 available             | 1 of 3 available     |
| DailyScratchOrgs                        | 6 of 6 remaining             | 6 of 6 remaining     |

This compact picker phase consumed **two quick builds and no standard builds**. Standard/full
builds and async validation require explicit approval. Quick builds do not
validate package dependencies/metadata or calculate package coverage, and cannot
be promoted. Installation and runtime tests are separate evidence.

## Reproducing checks

```sh
npm run check
sf project deploy start --source-dir force-app --target-org chrono-dev --test-level RunLocalTests --wait 10
# After installing the quick beta into chrono-subscriber:
cd tests/subscriber
sf project deploy start --source-dir force-app --target-org chrono-subscriber --test-level RunAllTestsInOrg --wait 10
```

These checks cover Apex and Flow execution, LWC unit behaviour and subscriber
composition/type contracts in the two existing scratch orgs. They do not establish
interactive browser rendering, integration from another managed package, every
Salesforce licence/edition, or released-package upgrades.

## References and lint exceptions

- [Operating-hours relationships](https://developer.salesforce.com/docs/platform/data-models/guide/field-service-operating-hours.html).
- [Field Service object reference](https://resources.docs.salesforce.com/latest/latest/en-us/sfdc/pdf/field_service_dev.pdf).
- [Scheduler holiday considerations](https://help.salesforce.com/s/articleView?id=sf.ls_considerations_holidays.htm&language=en_US&type=5).
- [Flow configuration and managed-package notes](flow-actions.md).

Global APIs, Flow wrappers and configuration helpers have scoped
`AvoidGlobalModifier` suppressions because subscriber access requires global
visibility. Required no-argument Flow constructors have scoped empty-block
exemptions. Existing aggregate-complexity and four-argument core overload
exemptions remain documented in source; method-level checks remain enabled.
Test assertion/input builders have narrow parameter-count exceptions. No
project-wide rule was disabled.

## Native schedule records — 7 September 2026

Removed `ChronoScheduleDefinition`, `ChronoScheduleSlot` and
`ChronoScheduleHoliday`, their three picker properties, and the `apex` schedule
source option. Native records and the fixed-value configurator share the existing
OperatingHours/TimeSlot/Holiday contract. The configurator still converts its
fixed values to native records; there is no public schedule wrapper.

Deployment `0AfG100000LMoenKAD` updated the code and harness and deleted all three
classes from `chrono-dev`. A Tooling API query confirmed no matching classes remain.
The affected harness version was retired and restored with native inputs.

- **79 local Apex tests** passed (`707G1000019VjFg`).
- **67 LWC tests** and **13 Temporal/bridge tests** passed.
- Formatting and the lint threshold passed (139 low-severity findings).
- The updated `ChronoPickerConsumerTest` passed in `chrono-subscriber`
  (`707As00001Vrwn0`) against its existing installed package. It constructs only
  unsaved native records and checks Friday 16:30 plus one working hour, with Monday
  a holiday, returning Tuesday 09:30 with no queries or DML.

No new package or scratch org was created. The subscriber check establishes native
record compatibility with the existing package; it does not remove classes from
that installed package. A future package build/install must validate the reduced
metadata contract before release.

The working-time Flow actions remain ID-based: **Chrono: Add or subtract working
time** and its **(collection)** counterpart. Native unsaved records are supported
by the picker and Apex API, but are not yet inputs to those Flow actions.

## ISO picker migration — 7 September 2026

Chrono picker values now cross Flow boundaries as ISO Text. The editor offers one
initial Date/DateTime/Text resource choice; the internal endpoint validates ISO
through core parsers. The experimental core fields and empty constructors were
removed. Native outputs and Apex-defined operating-hours configuration remain.

Validation in the existing `chrono-dev` org:

- All **79 local Apex tests** passed (`707G1000019VglX`).
- All **68 LWC tests** and **13 native Temporal/bridge tests** passed.
- Lint passed the configured threshold with **139 low-severity findings**.
- The deployed Flow action accepted all eight ISO types and the supplied
  sub-millisecond examples; malformed mixed-sign duration text returned a failure.
- The isolated headless screen run passed populated initial values, repeated-time
  selection, Next, Previous, edited values and manual offset override. A receiving
  Apex action parsed the actual five string outputs, alongside three other ISO types.
- The Flow Builder action editor loaded all eight string bindings without
  incompatible-type errors. Custom editor resource routing is covered by LWC tests.

Affected example versions and one obsolete saved test interview were retired to
permit the component metadata type change, then the updated examples were restored.
The old field-assignment experiment and helper were retired. The ISO example uses
Flow's automatic output storage; downstream actions reference component outputs.
For manual output storage, persist and rebind the native date/datetime and offset
state needed on return navigation; do not assume unmapped outputs are retained.

No screen capture, recording, personal browser, scratch-org creation or package
build was used. The migrated package has not been installed in `chrono-subscriber`;
that remains a pre-release validation step. Earlier sections below are historical.

## Picker and Flow configurator checks

Direct core-class feasibility was subsequently investigated in both existing
orgs. All eight installed core types survived a subscriber Apex → Flow variable
→ subscriber Apex round trip. See [the observed results and their limits](flow-core-feasibility.md).
This corrects the earlier overly broad claim that Flow requires wrappers for the
core types; it does not establish direct core-class LWC screen serialization.

### Admin sidebar revision — 7 September 2026

The follow-up resource lookup revision deployed the three affected LWC bundles
to `chrono-dev` (`0AfG100000LMhyIKAT`). **56 LWC tests** and all **11 Temporal
tests** pass, as do formatting and the lint threshold (136 low-severity findings).
New cases cover direct field search, incompatible/empty group removal, exact
types and collections, keyboard navigation, internal focus, Escape, stale async
responses, supplied record selection and required-type changes. Apex was not
changed or retested for this LWC-only deployment. Browser rendering and packaged
subscriber behaviour of this revision remain unverified; no package build ran.

The revised inline Flow editor passes **50 LWC Jest tests**, including all ten
saved schedule modes, timezone list persistence and restrictions, typed record
and Apex-defined collections, automatic action outputs, and record-field
navigation. A full source deployment to `chrono-dev` passed **72 Apex tests**
(`0AfG100000LMdgAKAT`), including the new schema-only resource controller tests.
Formatting, all 11 Temporal tests and the lint threshold pass; the analyser
reports 136 low-severity findings and no moderate-or-higher findings.
The initial attempt with only the two editor tests failed deployment coverage
for unrelated classes and was replaced by the full local test run.

This revision has not been built into a package or installed in the subscriber
org. It uses no scratch-org creation or package-version allocation. Flow Builder
rendering remains unverified; no browser or screen-capture service was used.

- **28 LWC Jest tests** pass for the controlled UI, reusable controls, Flow adapter and custom
  configuration editor. They cover explicit occurrence/gap choices, stale-response
  protection, initial instant preservation, Flow validation errors, closed-hour
  alternatives, supplied/native/Apex-defined schedules, resource binding and fixed
  partial-day holiday controls. Additional cases cover independent locks, reopening
  offset choices, manual-offset round trips and reset, stale timezone searches,
  narrow-column positioning, Escape/focus dismissal and disabled reactive updates.
- **11 JavaScript/Temporal tests** pass under Node 24 with `--harmony-temporal`.
  They use the production resolver and independently specified expectations for
  London, Lord Howe and Apia, plus precision, invalid dates and fallback behaviour.
  They also cover explicit-offset arithmetic without Temporal, date-specific
  offsets during mismatched UK/US DST weeks and the batched Apex fallback.
  This flag is only for the Node test process; production uses feature detection.
- The installed subscriber package contains all eight LWC bundles in `skel`.
  `ChronoPickerConsumer` compiles outside the namespace against the packaged
  UI-only component. `ChronoPickerHarness` deploys successfully with both native
  record collections and Apex-defined Flow inputs.
- `ChronoPickerConsumerTest` exercises the global DTO conversions and unsaved
  native-record working-time overload from outside the package, proving the
  Friday/holiday example without queries or DML. A Minimum Access test separately
  proves that saved-schedule reads enforce permissions while supplied values do
  not require schedule-read access.
- The Apex `TimeSlot` JSON boundary is explicitly tested. Its serializer emits
  ISO time strings, but its deserialiser accepts milliseconds after midnight;
  the JavaScript adapter normalises incoming record, Apex-defined and fixed values.
- The component metadata must explicitly declare the Apex-defined inputs as
  `apex://skel.ChronoScheduleDefinition` (and the corresponding slot/holiday
  classes). Omitting the namespace failed the namespaced Flow harness's type
  matching check; the qualified declarations pass in both existing orgs.
- All 13 subscriber Flows are restored and active, including four screen examples.
  The timezone example exposes manual offsets; the working-hours example allows
  independent display-zone and saved-schedule selection. An anonymous Apex smoke
  check executes installed Flow actions against both saved demo schedules:
  Friday 16:30 London plus one working hour returns Tuesday 09:30 for London
  weekdays with Monday's holiday, and Friday 17:30 London for New York weekdays.
  A supplied-offset instant also converts correctly to New York during the week
  when US daylight saving has started but UK daylight saving has not.
- Browser rendering, interactive Flow Builder behaviour and Temporal exposure
  under the user's actual LWS/browser combination were **not visually verified**.
  No browser or screen-capture tooling was used. Automated component behaviour,
  server execution, metadata contracts and subscriber installation are the
  evidence above; they are not a claim of a browser smoke test.

The compact picker phase used **two** `--skip-validation` builds and **zero** standard or
async-validation builds. It created **zero** scratch orgs. After validation,
`Package2VersionCreates` remains **6/6**, and
`Package2VersionCreatesWithoutValidation` is **498/500**. The beta cannot be
promoted; a standard build still requires Karl's explicit approval.

For beta replacement, deactivate the existing test FlowDefinitions, then delete
**every explicit Flow version** (for example `ChronoConvertHarness-1`) along with
the consumer test classes before uninstalling. Unversioned destructive Flow names
returned an access error even after deactivation. Enumerating versions through
Tooling API and using Salesforce's
[documented versioned-deletion procedure](https://help.salesforce.com/s/articleView?id=004630366&language=en_US&type=1)
worked. All fixtures were restored after the successful 0.1.0.6 installation.
