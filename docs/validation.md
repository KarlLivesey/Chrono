# Chrono validation

Validation performed on 6 September 2026 against Salesforce API 67.0.

## Development checks

- Reused `chrono-dev` in the `skel` namespace.
- **58 Apex test methods passed**: 49 package tests and nine consumer tests.
- Package source coverage: **1,472 of 1,519 executable lines (96.9%)**, calculated
  from development-org test results, excluding consumer and obsolete scratch-only
  classes. This is not package-build coverage.
- Formatting and the PMD recommended/AppExchange severity 1–3 gate passed.
  There are 99 low-priority ApexDoc and test `runAs` suggestions.
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

The current beta is **0.1.0.3**, subscriber version **`04tgK000000JnHxQAK`**,
created by request `08cgK000000H0mnQAC` with **`--skip-validation`**.
It installed successfully into the existing, non-namespaced `chrono-subscriber`
org (installation request `0HfAs000002aye1KAA`).

A deployment using `RunAllTestsInOrg` passed **58 test methods with no failures**:
**49 packaged tests in `skel` and nine unpackaged consumer tests**. Consumer tests
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

Salesforce does not permit an in-place beta upgrade. The temporary old consumer
test class was removed, beta 0.1.0.2 was uninstalled, and the new beta was installed.
Consumer classes and Flows were then restored from `tests/subscriber`. Local test
sources were retained throughout. No new scratch org was created for this phase.
This verifies a fresh installation, not released-package upgrade compatibility.

The previous 0.1.0.2 quick beta (`04tgK000000JnGLQA0`) passed 35 tests before the
Flow work. The initial 0.1.0.1 (`04tgK000000JnEjQAK`) used a standard build before
the explicit allocation policy was established. No release has been promoted.

## Allocation usage

The existing `chrono-dev` and `chrono-subscriber` orgs expire 13 September 2026.
Further org creation requires checking with Karl.

| Allocation                              | Before this Flow build | After                |
| --------------------------------------- | ---------------------- | -------------------- |
| Package2VersionCreates                  | 5 of 6 remaining       | 5 of 6 remaining     |
| Package2VersionCreatesWithoutValidation | 499 of 500 remaining   | 498 of 500 remaining |
| ActiveScratchOrgs                       | 1 of 3 available       | 1 of 3 available     |
| DailyScratchOrgs                        | 4 of 6 remaining       | 4 of 6 remaining     |

This phase consumed **one quick build and no standard builds**. Standard/full
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

These checks establish the tested Apex and Flow behaviour in the two existing
scratch orgs. They do not establish LWC support, another managed-package
integration, every Salesforce licence/edition, or released-package upgrades.
LWC components remain a later phase.

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
