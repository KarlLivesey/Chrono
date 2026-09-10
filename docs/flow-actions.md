# Chrono in Flow

Released 0.2.0.4 supports dates/local date-times in elapsed and working-time
arithmetic, and supplied native schedules for add, difference, check and find.
See [dates and supplied schedules](bulk-apex-services.md#dates-and-supplied-schedules)
for the inputs and editor choices.

See the [complete action catalogue](action-catalogue.md) for all 54 actions and their categories. The sections below retain the original API examples.

Add an **Action**, then choose the **Chrono** category. All actions have a calendar
icon, labelled inputs and outputs, and descriptions. Single-value actions process
one value per interview; Salesforce can batch many interviews into one call.
Collection actions also accept an explicit Apex-defined collection per interview.

| Action                               | Collection version                                | Purpose                                                                |
| ------------------------------------ | ------------------------------------------------- | ---------------------------------------------------------------------- |
| Chrono: Convert date/time            | Chrono: Convert date/time (collection)            | Convert or normalise the eight Chrono types.                           |
| Chrono: Add or subtract time         | Chrono: Add or subtract time (collection)         | Apply calendar or elapsed arithmetic.                                  |
| Chrono: Elapsed difference           | Chrono: Elapsed difference (collection)           | Return signed elapsed or OperatingHours duration between two instants. |
| Chrono: Add or subtract working time | Chrono: Add or subtract working time (collection) | Skip closures and holidays using OperatingHours or BusinessHours.      |

Assign **Chrono Flow User** to users who need to run the actions. Working-time
calculations also require access to the relevant schedule configuration; the
permission set grants Apex access, not broad access to organisation data.

## Action configuration editor

All 54 actions register an LWC custom property editor in the `skel` namespace.
The editors share reusable value/resource controls with the screen configurator.
Choose a value type and **Input format**, then supply a fixed value or use
**Search Resources**. Only the chosen ISO/native representation is displayed;
changing it clears the previous representation. Resource choices are filtered by
the required type and collection shape. Timezones use a searchable lookup.

Arithmetic offers amount/unit or ISO duration. Difference offers separate start
and end formats and an optional OperatingHours ID. Collection actions show the
compatible request collection selector. Required fields and whole-number amounts
are checked before saving; runtime action validation remains authoritative for
values supplied dynamically by Flow.

Formula resources can be selected through Search Resources. The editor does not
embed Salesforce's Formula or Transform authoring tools.

See [thirteen complete examples and a portable download](handbook/examples.md).

The registration follows Salesforce's [namespaced action-editor contract](https://developer.salesforce.com/docs/platform/lwc/guide/use-flow-custom-property-editor-action-example.html).
Configuration events use the [required bubbling/composed Flow interface](https://developer.salesforce.com/docs/platform/lwc/guide/use-flow-custom-property-editor-interface.html).
All 54 installed editor registrations were verified on released 0.2.0.4, and the
subscriber Apex/Flow suite passed. Browser rendering remains unverified.

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
Optionally supply `operatingHoursId` to count only time when that saved
OperatingHours schedule is open. In a collection, each item can select its own
schedule or omit the ID. Slots and associated holidays use the schedule’s timezone,
independent of the input offsets. Overlapping slots count once; daylight-saving
changes count actual elapsed open time. Reversing the endpoints negates the result;
equal endpoints or an entirely closed interval return zero. Friday 16:30 to Tuesday
09:30 is one working hour for 09:00–17:00 weekdays with Monday a holiday.
The working difference is limited to 3660 UTC dates per item. Without an ID,
no schedule queries run and the existing unrestricted elapsed behaviour remains.
Schedules load once across all collection items and interviews (three user-mode
queries); malformed or inaccessible IDs return item errors.
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
See [validation](validation.md) for the checks actually performed. The screen picker and action editors are implemented separately from the core types.

## Additional operations

Each operation below has a single-value action and a collection action, with a
namespaced LWC editor and the same typed literal/resource controls. These are the original 11 families; the [catalogue](action-catalogue.md) includes the additional 14 families and nine categories.

| Operation                          | Inputs and behaviour                                                                                                                                               | Useful outputs                                                                       |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------ |
| Check working time                 | Date, local date/time, Instant or ZonedDateTime, plus OperatingHours ID. A Date asks whether any opening exists that day; a local date/time requires its timezone. | `isOpen`                                                                             |
| Find next or previous working time | The same inputs, with `next` (on/after) or `previous` (on/before). Already-open values stay unchanged. Holidays and slots use the schedule's timezone.             | Canonical/native result, `isOpen`                                                    |
| Compare date/time values           | Matching plain types, or two exact values even when their zones differ. No implicit comparison between a plain date and an instant.                                | `comparison`: -1 before, 0 equal, 1 after                                            |
| Start or end of period             | Complete Date, local date/time, Instant or ZonedDateTime; day/week/month/year. Instant requires a calculation timezone.                                            | Canonical/native boundary                                                            |
| Round date/time                    | Date (day only), local date/time, time, Instant, ZonedDateTime or Duration. Clock increment plus down/up/nearest policy.                                           | Canonical/native rounded value                                                       |
| Inspect or resolve local time      | Date or local date/time plus timezone. Date means midnight. Inspect, select earlier/later repeated occurrence, or choose backward/forward nearest gap boundary.    | `resolutionStatus`, candidate ISO strings and the selected zoned value when resolved |
| Calendar difference                | Matching Date/local date-time types, or two exact values projected into a common calculation timezone. Both endpoints accept appropriate ISO/native inputs.        | Duration with separate `months`, `days`, `milliseconds`                              |

All eight Chrono types have been considered. Compare supports every type; partial
month/day and year/month values compare their own fields without inventing a year
or day. Other operations reject partial types where a complete date is needed:
use Convert with explicit reference context first. Duration is meaningful for
comparison and rounding, not schedule membership or local-time resolution.

### Working-time membership and navigation

Membership uses half-open intervals: opening time is included and closing time
is excluded. Previous-open returns the last included millisecond when moving back
from a closed interval. Dates return dates; Instants return Instants; local and
zoned date/time inputs return ZonedDateTime so the chosen instant remains explicit.
An empty/unconfigured schedule is an error, rather than a successful closed result.
Navigation uses the existing 3660-day search limit. These actions use saved
OperatingHours IDs and native schedule records loaded in three user-mode queries
per invocation; no BusinessHours substitution or separate schedule engine is used.

### Periods and rounding

Week starts on ISO Monday (1) unless configured as 1–7. Date results end on the
last date; date/time results end at the final millisecond before the next period.
Zoned day boundaries use actual transitions: a skipped midnight advances to the
first valid time and a repeated midnight uses its first occurrence. Days can be
23, 24 or 25 hours (or otherwise affected by historical transitions).

Clock rounding supports hours, minutes, seconds and milliseconds. Positive
increments must divide their parent unit: 24 hours, 60 minutes/seconds or 1000
milliseconds. Calendar-day rounding requires increment 1 and uses the real
elapsed midpoint of the zoned day. Plain time wraps at midnight; plain date/time
carries into the following date. Instant rounding uses the UTC timeline. Rounding
inside a repeated zoned hour keeps the existing occurrence unless an explicit
policy selects another. A rounded clock falling in a gap is rejected; use the
resolution action to choose a correction. Duration rounding retains its calendar
components and rounds its signed elapsed component; it does not balance months
into fixed-length hours.

### Resolution and comparison

Resolution returns `unique`, `repeated` or `nonexistent`. A unique time is resolved
automatically; inspecting a repeated/skipped time succeeds with candidates but
leaves `value` unset. Check the status before using it. Repeated candidates are
`earlierValue` / `laterValue`; gap boundaries are `previousValue` / `nextValue`.
All candidates are zoned ISO Text. Choosing an inapplicable policy returns an item
error. Gap corrections are nearest boundaries, not shifts by the gap length.

Duration comparisons with calendar months/days require a reference date and
calculation timezone; both durations are applied from midnight at that reference.
Pure elapsed durations need no reference. Comparing exact values compares instants,
so identical wall-clock text in a repeated hour need not compare equal.

### Calendar difference and the remainder

The default largest unit is day. Month/year modes count complete, start-anchored
calendar months first, then days; years remain included in total `months`, matching
the existing duration contract. The remaining clock time (plain values) or elapsed
time (exact values) is returned separately in `milliseconds`. **A Flow can ignore
that remainder and use only the whole calendar units**, as requested.

Calendar arithmetic clamps month ends and uses the supplied repeated-time policy;
a skipped intermediate local time is rejected. Reverse differences are anchored
to their own starting value, so they are not necessarily a simple negation around
clamped month ends. Two differently zoned endpoints require an explicit common
calculation timezone. An Instant always needs that calendar context.

Example: 31 January 10:00 to 2 March 12:30 gives one calendar month, two calendar
days and 9,000,000 remaining milliseconds. Across a spring transition, one calendar
day can represent 23 elapsed hours. Date-only inputs have no clock remainder.

See [example 7](flow-examples.md) for a complete workflow using every new operation.
These additions are implemented; their actual packaging/subscriber validation
status is recorded separately in [validation](validation.md).

## Time allocation

**Chrono: Time allocation** contains **Allocate time to blocks** and
**Allocate time to blocks (collection)**. Configure named normal/holiday blocks
inline or supply a Text definition; pass native Holiday records for the calendar.
Choose strict, lax, duplicate or split overlaps and elapsed (default) or clock time.
Outputs include block totals, contributing segments and explicit reconciliation
amounts. See [the contract and examples](time-allocation.md).
