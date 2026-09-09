# Global API audit before release

Audit date: 8 September 2026. Scope: the current working tree and the installed
0.1.0.16 beta (`04tgK000000KDNhQAO`). The requested extensibility is changing our
implementation and adding overloads/options, not subscriber inheritance.

**Status: mapping approved, implemented and validated in installed beta 0.1.0.17.**
See [the validation record](validation.md) for the 210-test subscriber run and
package/build evidence.
Karl approved the full mapping before implementation. The tables retain the old
and new names as the migration reference.

## Coverage and evidence

The source inventory includes 129 top-level global classes and 54 nested global
Request classes: 183 type declarations, 297 callable declarations (including
constructors), and 988 fields. These are declarations, not unique business
operations. The earlier contract check covered only 121 core service methods.

- All 27 single-value action Request field lists match their corresponding
  explicit-collection Input DTO lists in names, types and order.
- No internal Chrono type appears in a global parameter, return type or field.
- Core values are data-only. The eight core services forward into internal
  operations; Flow actions and allocation already delegate to their engines.
- No global interface or virtual core class needs to be introduced for the
  requested implementation/overload evolution. The dynamic timezone picklist's
  framework overrides are intentional.
- All 16 Package2Version records returned by the Dev Hub have `IsReleased=false`.
  This is release-state evidence, not a claim about who has accessed the repository
  or installed a beta.

Focused Execute Anonymous checks ran against the existing subscriber org:

| Check                                                              | Observed result                                                       |
| ------------------------------------------------------------------ | --------------------------------------------------------------------- |
| September fiscal period into Range Tools contains 30 September     | `false`: fiscal endpoints are inclusive, range endpoints exclusive    |
| Assign `2026-12-25` to `ChronoPlainMonthDay.value`, then serialise | Rejected: “Month/day reference date must use leap year 2000.”         |
| `ChronoZonedDateTimeService.addHours(source, 1, null)`             | Compile failure: ambiguous method signature                           |
| `ChronoZonedDateTimeService.addDays(source, 1, null)`              | Runtime rejection: “Disambiguation must be reject, earlier or later.” |

The fiscal check called the packaged fiscal action with PlainDate
`2026-09-07`, month-based configuration starting in January, and period `month`.
It returned `2026-09-01` and `2026-09-30`; passing these unchanged as the range
endpoints excluded 30 September. This is a composition trap, rather than evidence
that the documented inclusive fiscal calculation itself is wrong.

The month/day hidden-year restriction was observed at runtime. The corresponding
year/month restriction (backing date must use day 1) was identified in source.
These are awkward invariants for deliberately mutable, data-only public values.

No package version was created during the read-only audit. The prior 202 installed Apex tests
and 30 conformance fixtures validate the preceding implementation; they do not
validate the changes proposed here. Browser rendering and released-version
upgrade behaviour were not checked in this audit.

## Approved field and representation mapping

These are deliberate pre-release breaking changes. Update implementations,
generators, Flow metadata, editors, consumers, examples and tests together.

| Current public contract                  | New contract                          | Meaning                                                       |
| ---------------------------------------- | ------------------------------------- | ------------------------------------------------------------- |
| `ChronoPlainMonthDay.value: Date`        | `month: Integer`, `day: Integer`      | Actual components; no exposed reference year                  |
| `ChronoPlainYearMonth.value: Date`       | `year: Integer`, `month: Integer`     | Actual components; no exposed reference day                   |
| `ChronoZonedDateTime.zoneId`             | `timeZoneId`                          | Consistent public timezone field naming                       |
| `ChronoTimeAllocationRequest.startValue` | `startInstant`                        | Native `Datetime`, inclusive                                  |
| `ChronoTimeAllocationRequest.endValue`   | `endInstant`                          | Native `Datetime`, exclusive                                  |
| `ChronoTimeAllocationRow.milliseconds`   | `allocatedMilliseconds`               | Credited amount after overlap handling/rounding               |
| `ChronoTimeAllocationRow.duration`       | `allocatedDuration`                   | ISO duration of that credited amount                          |
| `ChronoTimeBlock.days`                   | `weekdays`                            | CSV ISO weekday numbers, not duration days                    |
| Block-definition JSON key `days`         | `weekdays`                            | Same name in the editor and Flow Text format                  |
| `ChronoFiscalResult.endDate`             | `lastDate`                            | Retain the inclusive last calendar date                       |
| No fiscal exclusive Date output          | `ChronoFiscalResult.endExclusiveDate` | Calendar date following `lastDate`                            |
| `ChronoFiscalResult.endValue`            | `endExclusiveValue`                   | ISO exclusive endpoint, calculated without subtracting a tick |
| `ChronoFiscalResult.endInstant`          | `endExclusiveInstant`                 | Exact exclusive endpoint for exact inputs                     |

Fiscal `startDate`, `startValue` and `startInstant` keep their current names and
meanings. For exact inputs, calculate the exclusive endpoint using the next
calendar boundary in the calculation zone, not by adding 24 elapsed hours.
For plain date/time inputs, use the following date at local midnight. Preserve
explicit range validation when a following boundary exceeds the supported date
range. The separate Period Boundary action's end-of-period point remains
inclusive and must be labelled/documented as such.

Partial-date construction still validates month/day combinations (including
29 February) and valid year/month ranges. Converting a month/day to a particular
year must still reject an invalid date in that year. The representation change
does not introduce another calendar or alter ISO output.

Only the named public fields and block JSON key are included in this mapping;
unrelated internal `zoneId`, `days` and `value` variables do not need renaming.

## Approved method mapping

For each of these eight classes, rename `parse(String)` to `parseIso(String)` and
`toString(ChronoType)` to `toIsoString(ChronoType)`, preserving parameter and return
types and existing ISO semantics:

- `ChronoDurationService`
- `ChronoInstantService`
- `ChronoPlainDateService`
- `ChronoPlainDateTimeService`
- `ChronoPlainTimeService`
- `ChronoPlainMonthDayService`
- `ChronoPlainYearMonthService`
- `ChronoZonedDateTimeService`

Additional exact mappings:

| Current method                                    | New method                         | Behaviour                                            |
| ------------------------------------------------- | ---------------------------------- | ---------------------------------------------------- |
| `ChronoDurationService.negated(source)`           | `negate(source)`                   | Unchanged sign reversal                              |
| `ChronoInstantService.until(source, other)`       | `elapsedDifference(source, other)` | Other minus source; elapsed duration                 |
| `ChronoZonedDateTimeService.until(source, other)` | `elapsedDifference(source, other)` | Other instant minus source instant; elapsed duration |

These method renames are naming improvements, not fixes to incorrect arithmetic.
They distinguish interchange serialisation from future display formatting, and
elapsed difference from calendar difference. Keep Flow action API names and
existing ISO strings unchanged. Matching internal operation names can follow the
public method names to preserve the simple forwarding guard.

## Optional arguments and future overloads

Keep existing static façades. An implementation change belongs behind them;
consumers should never need to call an Operations class.

Explicit `null` disambiguation now behaves like omission in core
local-to-zone conversion and zoned calendar arithmetic: use `reject`. Continue
rejecting unsupported non-null policy text. This deliberately changes the prior runtime rejection of null.

Keep the distinct OperatingHours and BusinessHours overloads. A bare `null`
cannot choose between them; calling the existing shorter overload expresses
unrestricted elapsed arithmetic. A typed null schedule must fail validation.
Do not turn a missing required schedule into unrestricted working time.

For future additions:

- Preserve existing parameter/return types, positional meaning, source-first
  convention, defaults and output meanings.
- Check new overloads against existing calls with null literals and native/core
  types. Adding an overload can make previously compiling source ambiguous.
- Use additional arity or a clearly named entry point when type-only overloads
  would collide. Add a focused data-only options class when an operation actually
  needs several independently optional settings; do not create empty extension
  objects or generic maps now.
- New optional request fields must preserve the previous behaviour when absent.
  Validate their interaction with existing fields and update single/collection
  contracts together. Do not add new required Flow inputs to an existing action.
- Keep exact time, wall-clock time, display zones and schedule zones distinct.
  Calendar and working-time options must not silently change elapsed operations.
- Test additions in subscriber Apex and Flow, including existing call sites and
  serialised values. Release compatibility and behavioural compatibility are
  separate checks.

Salesforce permits new overloads, but released global methods cannot have their
existing signature or return type changed, and exposed members have other
manageability restrictions. This is why naming/shape cleanup belongs before
release. See the [Apex Developer Guide's managed-package restrictions](https://resources.docs.salesforce.com/latest/latest/en-us/sfdc/pdf/salesforce_apex_developer_guide.pdf).

Public implementation classes without `@NamespaceAccessible` are package-internal
in managed 2GP, including against other packages in the same namespace. Global
classes remain cross-namespace APIs. See [Salesforce's namespace visibility rules](https://developer.salesforce.com/docs/platform/pkg2-dev/guide/sfdx-dev-dev2gp-namespace-visibility.html).

## Exposure and follow-through

`@AuraEnabled`/`@InvocableVariable` were removed from the native Apex-only
`ChronoTimeBlock` fields. Its global class, fields and constructor remain available
to subscriber Apex. Flow block configuration uses Text JSON. Keep annotations on
actual Flow input/result contracts and the required nested invocable wrappers.

The contract guard now covers **1,471 global declarations**, including global
types, fields, constructors, methods, annotations and modifiers. It requires an
explicit baseline review for changes and retains the focused forwarding checks. A signature snapshot does not replace tests
of defaults, errors, endpoint composition or serialisation.

Convenience omissions can be filled additively later: plain date/time
`addSeconds`, native zoned overloads for milliseconds/calendar arithmetic, and
year/month `addYears`. They are not reasons to redesign the current boundary or
block this audit on implementing new features.

Validation for the approved migration must cover direct struct assignment,
partial-date invalid/leap cases, fiscal-to-range composition for date/local/exact
inputs, unchanged ISO values, signed elapsed differences, null/default policies,
allocation JSON/editor round trips, and both action cardinalities. Compile and
run in existing orgs before consolidating subscriber verification into a quick
build with `--skip-validation`. No claim of released upgrade safety is possible
from the current unreleased beta evidence alone.
