# Chrono in Flow

Add an **Action**, then choose the **Chrono** category. All actions have a calendar
icon, labelled inputs and outputs, and descriptions. Single-value actions process
one value per interview; Salesforce can batch many interviews into one call.
Collection actions also accept an explicit Apex-defined collection per interview.

| Action                               | Collection version                                | Purpose                                                           |
| ------------------------------------ | ------------------------------------------------- | ----------------------------------------------------------------- |
| Chrono: Convert date/time            | Chrono: Convert date/time (collection)            | Convert or normalise the eight Chrono types.                      |
| Chrono: Add or subtract time         | Chrono: Add or subtract time (collection)         | Apply calendar or elapsed arithmetic.                             |
| Chrono: Elapsed difference           | Chrono: Elapsed difference (collection)           | Return the signed elapsed duration between two instants.          |
| Chrono: Add or subtract working time | Chrono: Add or subtract working time (collection) | Skip closures and holidays using OperatingHours or BusinessHours. |

Assign **Chrono Flow User** to users who need to run the actions. Working-time
calculations also require access to the relevant schedule configuration; the
permission set grants Apex access, not broad access to organisation data.

## Single-value inputs

For conversion and arithmetic, select a **Value type** and supply either an **ISO
value** or its corresponding native input:

- Instant: a Salesforce datetime or an ISO instant with `Z` or an offset.
- Zoned date/time: a Salesforce datetime plus an explicit time-zone ID, or an ISO
  value containing both its offset and zone, such as
  `2026-09-01T09:30+01:00[Europe/London]`.
- Plain date/time: a Salesforce date plus an ISO clock time, or
  `2026-09-01T09:30`.
- Date: a Salesforce date or `2026-09-01`.
- Time: an ISO clock time such as `09:30`.
- Year and month: a Salesforce date (its day is discarded) or `2026-09`.
- Month and day: a Salesforce date (its year is discarded) or `--09-01`.
- Duration: an ISO duration such as `P1M2DT3H`.

Flow clock values use text (`HH:mm:ss.SSS`), while the core Apex library uses
native `Time`. Precision is milliseconds; alternate calendars are unsupported.
Do not mix ISO and native source inputs.

**Convert to** is optional: leaving it unset normalises the source type. Supply
missing information explicitly when completing partial values: **Reference date**
provides a plain time's date, a month-day's year, or a year-month's day; **Reference
time** supplies the clock when completing a date. Resolving a local value into an
instant requires a time zone. An instant requires a zone before extracting local
components. A duration can be normalised but cannot become a date or instant.

**Repeated-time policy** defaults to rejection. Choose the earlier or later
occurrence for an ambiguous daylight-saving time. Skipped local times always fail.
Changing an existing zoned value's time zone during conversion preserves its instant.

For ordinary arithmetic, supply **Amount** and **Unit**, or a signed ISO
**Duration**. Negative values subtract. Calendar months and days retain calendar
semantics; hours and smaller units represent elapsed time for exact values and
clock arithmetic for plain values. Plain dates accept calendar units only;
year-month accepts months/years. Complete a month-day with a reference year before
arithmetic. Instants and plain times reject durations containing calendar units.
Duration arithmetic combines components with matching signs; it does not perform
relative calendar balancing.

For elapsed difference, provide native or ISO starting and ending instants.
The result has zero calendar months/days and signed elapsed milliseconds. For
example, a day spanning the spring clock change can be 23 elapsed hours.

## Working time example

Configure **Chrono: Add or subtract working time** with:

- Start ISO instant: `2026-08-28T16:30+01:00[Europe/London]`.
- Time zone: `Europe/London` (the output zone).
- Amount: `1`; Unit: `hours`.
- Schedule type: `OperatingHours`.
- Schedule ID: the ID of a saved OperatingHours record.

With 09:00–17:00 Monday–Friday slots and Monday 31 August linked as an all-day
holiday, the result is **Tuesday 1 September at 09:30**. The schedule's own zone
controls openings and holidays. The selected output zone controls presentation.

Both schedule models support hours/minutes and negative amounts. OperatingHours
uses its normal time slots and linked holidays; BusinessHours delegates to the
native Salesforce service. See the README for recurrence, partial holidays,
conditional slots and search limits.

## Collections and errors

Create an Apex-defined Flow variable, enable **Allow multiple values**, and use
the corresponding top-level package type:

| Collection action            | Item class                    |
| ---------------------------- | ----------------------------- |
| Convert                      | `skel.ChronoConvertInput`     |
| Add or subtract time         | `skel.ChronoAdjustInput`      |
| Elapsed difference           | `skel.ChronoDifferenceInput`  |
| Add or subtract working time | `skel.ChronoWorkingTimeInput` |

Populate the fields using Flow assignments and pass the collection to the action.
These types have the same input fields as their single-value counterparts.
Collection outputs use `skel.ChronoFlowResult`. The test harness Flows under
`tests/subscriber/force-app/main/default/flows` demonstrate actual metadata wiring;
they are consumer test fixtures, not components installed by the package.

Check **Success** before consuming a result. Results contain a canonical ISO
value, its type and applicable native values. Zoned results include the exact
Salesforce datetime, local date, clock text and zone. Durations include separate
months, days and milliseconds. Unused output fields remain null.

A failed item returns **Success = false** and an **Error**, preserving its position.
A collection's success is false if any item fails; inspect its individual results.
An empty collection succeeds with no items. A missing collection fails explicitly.
Normal platform governor-limit failures still fault the transaction.

Every action preserves interview order; collection actions also preserve item
order. Identical complete inputs share one calculation within that invocation,
including duplicates across collections. Returned objects are independent copies.
Caches do not persist across invocations. OperatingHours configuration loads in
three user-mode queries across all requested schedules; BusinessHours adds one
user-mode lookup when used. Distinct calculations still consume normal Apex CPU,
heap and query-row limits.

## Configuration helpers and managed-package boundaries

`InvocableActionExtension` supplies input order, collapsible groups and labelled
picklists. Salesforce supplies the time-zone choices through
`ChronoTimeZonePicklist`; it does not infer the designer's zone. Amount controls
visibility of the ordinary arithmetic unit. Collection actions display a labelled
collection input; populate individual items using Apex-defined Flow variables.

The API 67 org accepted the attribute keys `Order`, `Group`, `ProvidedValuesList`
and `ControllingField`. Parts of Salesforce's metadata reference currently use
other spellings. Action-local invocable request wrappers were needed for valid
extension targets (`ChronoConvertAction.Request.valueType`, for example).
Collection item/result types remain top-level with global constructors and
Aura-enabled fields. Core immutable value classes remain separate from transport. Subscriber Apex
constructs these DTOs and assigns their global fields; generic cross-namespace
`JSON.deserialize` is not enabled for these classes.

References: [Flow configuration helpers](https://help.salesforce.com/s/articleView?id=release-notes.rn_automate_flow_extend_extended_metadata_invocable_action.htm&language=en_US&type=5),
[picklist attributes](https://help.salesforce.com/s/articleView?id=release-notes.rn_automate_flow_extend_define_picklist_values_for_apex_action_inputs.htm&language=en_US&release=262&type=5),
[managed 2GP component support](https://developer.salesforce.com/docs/platform/pkg2-dev/guide/packaging-packageable-components.html).
See [validation](validation.md) for the checks actually performed. LWC components
for Flow screens and record pages are a later phase.
