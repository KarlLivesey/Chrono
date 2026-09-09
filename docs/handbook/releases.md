# Release notes

## 0.2 — development, not released

Direct bulk Apex services cover all 27 action families. Working-time add,
elapsed difference, check and find support supplied native schedules; add and
difference also accept native dates and ISO local date/times. See the
[bulk service catalogue](../bulk-apex-services.md).

The installed test package is **0.2.0.3**, a skip-validation beta. Current source
also includes the subsequent zero-calendar-arithmetic correction recorded in
the [service audit](../service-audit-2026-09.md). It is not in that beta yet.
Generated API references describe the development source and are labelled as such.
The public installation link remains the released version below.

## 0.1.0.19 — 8 September 2026

**First released managed-package version.** Namespace `skel`; subscriber package
version `04tgK000000KFNtQAO`. Salesforce promotion succeeded and a fresh package
report confirmed `IsReleased=true`.

This release establishes the first supported contract baseline:

- Eight data-only Chrono values and their service APIs: 121 core service signatures.
- 27 Flow families / 54 scalar and explicit-collection actions, with configuration editors.
- Native Date/DateTime and ISO Text payloads; native OperatingHours/TimeSlot/Holiday configuration.
- Reusable inputs, timezone-aware picker, range, availability, recurrence and record-page components.
- Time allocation with normal/holiday blocks, four overlap modes and millisecond defaults.
- Contract checks covering 1,471 global declarations, 84 component metadata contracts and 61 Apex transport types.

## Verified candidate

| Check                               | Result                                                                          |
| ----------------------------------- | ------------------------------------------------------------------------------- |
| Standard package build              | Succeeded; validation was not skipped                                           |
| Package code coverage               | 91%; coverage check passed                                                      |
| Installed subscriber Apex suite     | 210 passed, zero failures/skips                                                 |
| Shared Temporal/Apex conformance    | 30 passed                                                                       |
| Installed action configuration      | All 54 labels/categories/icons/editor registrations checked                     |
| Example restoration                 | 79 fixture components restored; 13 example Flows active                         |
| Local checks before candidate build | 138 LWC, 43 Temporal and 14 contract regression tests passed                    |
| Documentation Apex examples         | All eight complete snippets/scripts compiled and ran against installed 0.1.0.19 |

The exact standard build request was `08cgK000000H3PhQAK`; subscriber test run
was `707As00001VvBLX`. Browser rendering was not verified. A released upgrade
test awaits a subsequent descendant release.

## Earlier betas

Versions through 0.1.0.18 were unreleased development candidates. Their temporary
core-object Flow properties and instance-style APIs are not the released
contract. Current examples use data-only values with service `parseIso` and
`toIsoString`, native/ISO Flow values, and separate request/result envelopes.

Do not copy a beta example that calls `ChronoPlainDate.parse(...)` or
`value.addHours(...)`. Use the [Apex quick start](apex.md) and generated reference.
Historical engineering notes remain in the repository's `docs/validation.md`;
the current evidence above is the release-specific summary.

## Compatibility from here

Global signatures, fields, supported component properties and documented text
formats are integration contracts. Additions should preserve existing defaults
and meanings. Internal services can change implementation behind the same entry
points; consumers should not depend on package-internal classes.
