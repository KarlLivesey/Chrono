# Chrono action catalogue

Chrono has 27 action families, each with a scalar and an explicit-collection
entry point: **54 Flow actions**. Collection actions are also bulkified across
Flow interviews. This page describes the implemented API; current verification
and package status are recorded in [validation.md](validation.md).

Salesforce categories are flat labels: `Chrono: Values`, `Chrono: Calculations`,
`Chrono: Time Zones`, `Chrono: Durations`, `Chrono: Formatting`,
`Chrono: Working Hours`, `Chrono: Ranges`, `Chrono: Recurrence` and
`Chrono: Collections` and `Chrono: Time allocation`. Each action has its own LWC configuration editor. Salesforce’s action-description API normalises category punctuation, for example returning `Chrono Values`.

## Existing families

| Category      | Action family      | Behaviour                                                                                      |
| ------------- | ------------------ | ---------------------------------------------------------------------------------------------- |
| Values        | Convert            | Convert and normalise the eight Chrono value types.                                            |
| Calculations  | Adjust             | Add/subtract calendar or elapsed units.                                                        |
| Calculations  | Difference         | Signed elapsed difference, optionally restricted to OperatingHours.                            |
| Calculations  | CalendarDifference | Whole calendar units with a separate time remainder which the Flow may ignore.                 |
| Calculations  | Compare            | Ordering, optional tolerance and same local day/week/month/quarter/year.                       |
| Calculations  | PeriodBoundary     | Start/end of day, week, month, quarter or year.                                                |
| Calculations  | Round              | Explicit unit/increment and floor, ceil, expand, trunc or half-rounding policies.              |
| Time Zones    | ResolveLocal       | Inspect or resolve repeated/skipped local times; gap corrections use nearest valid boundaries. |
| Working Hours | WorkingTime        | Add/subtract working time.                                                                     |
| Working Hours | CheckWorkingTime   | Test schedule membership.                                                                      |
| Working Hours | FindWorkingTime    | Find the next/previous open value.                                                             |

## New families

Every row also has a `(collection)` action. Scalar entry points use
`skel.Chrono<Family>Action`; collection entry points use
`skel.Chrono<Family>CollectionAction` and a collection of mutable
`skel.Chrono<Family>Input` request records. These records describe operation requests. Date/time payloads remain native Date/Datetime or ISO text.
Subscriber Apex constructs requests with their global constructors and assigns
fields, and reads returned fields directly. Only documented ISO and block-definition Text formats are versioned serialisation contracts; callers should prefer typed construction for other request/result records.

| Category      | Family / label                                      | Operations                                                                                                                                      |
| ------------- | --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Values        | `CreateValue` — Create date/time from components    | Construct a validated value from individual calendar and clock components.                                                                      |
| Values        | `ReplaceValue` — Replace date/time components       | Replace supplied components and preserve other fields. Resolve zoned values explicitly.                                                         |
| Values        | `ValidateValue` — Validate date/time value          | Validate a native or ISO value without failing other interviews.                                                                                |
| Values        | `ParseValue` — Parse formatted date/time            | Parse an explicitly specified numeric date and time pattern without guessing.                                                                   |
| Values        | `EpochValue` — Convert Unix timestamp               | `fromEpoch`, `toEpoch`                                                                                                                          |
| Values        | `ValueDetails` — Get date/time details              | Inspect calendar and clock components with an explicit timezone for instants.                                                                   |
| Durations     | `DurationTools` — Calculate duration                | `create`, `components`, `negate`, `absolute`, `total`, `balance`, `multiply`, `divide`                                                          |
| Time Zones    | `ZoneTools` — Work with timezones                   | `convert`, `overrideOffset`, `details`, `listZones`, `compareZones`, `transitions`, `nextTransition`, `previousTransition`                      |
| Ranges        | `RangeTools` — Work with date/time ranges           | `validate`, `contains`, `relationship`, `intersection`, `merge`, `subtract`, `gaps`, `split`, `clamp`, `coverage`                               |
| Working Hours | `Availability` — Find working-hour availability     | `windows`, `boundaries`, `containsRange`, `continuous`, `shared`, `anySchedule`, `appointments`, `workingDates`, `holidays`, `validateSchedule` |
| Working Hours | `WorkingDays` — Add working calendar days           | Signed open dates; preserve the schedule-local clock, with keep/reject/next/previous closed-time policy.                                        |
| Collections   | `CollectionTools` — Work with date/time collections | `earliest`, `latest`, `sort`, `deduplicate`, `filter`, `group`, `sumDurations`, `nearest`, `summary`                                            |
| Calculations  | `FiscalPeriod` — Get fiscal period                  | Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.                                                            |
| Recurrence    | `Recurrence` — Generate recurring dates             | `weekday`, `nthWeekday`, `annual`, `nthWorkingDay`, `generate`, `rrule`                                                                         |
| Formatting    | `FormatValue` — Format date/time for display        | `value`, `range`, `duration`, `relative`                                                                                                        |

## Admin configuration

Select the value type and one source format. Compatible native resources are
filtered by type; ISO collections can also be entered as one value per line.
Range endpoints, comparison points, filter bounds and formatting references have independently selectable native or ISO sources. A native auxiliary Date for a local date/time defaults to midnight unless a clock is supplied. Saved schedule
IDs and supplied native records are mutually exclusive configuration choices.
Dynamic operation/type references are validated at runtime. Input errors are
reported per request; collection results preserve interview and item order.

The new classes add fields to the existing Compare result: `withinTolerance`
and `samePeriod`. They are only populated when requested. Tolerance is in
milliseconds. Comparing calendar periods across exact values requires a common
calculation timezone. Calendar durations need a reference date and timezone.

## Time allocation

`TimeAllocation` — **Allocate time to blocks**, under **Chrono: Time allocation**,
adds named normal-day and bank-holiday block totals. Choose strict, lax, duplicate
or split overlaps, elapsed or clock time, and millisecond/second/minute allocation.
The single and collection actions preserve ordered totals and contributing segments.
See [the precise allocation contract](time-allocation.md).

## Defined semantics and limits

- Precision is milliseconds. Extra ISO fractional digits are truncated.
- Ranges are **[start, end)**. Equal endpoints form an empty range. A Date clamp
  uses the previous calendar date; other values use the previous millisecond.
- Zone conversion explicitly keeps the instant or the local clock. Offset
  overrides return both supplied-offset text and the actual canonical zoned
  projection; an override is never labelled as a valid zone offset.
- Transition searches use Salesforce offsets, hourly bracketing and millisecond
  bisection, over at most 366 days. This assumes two offset changes do not occur
  within one hour. Navigation is strict; listings include start and exclude end.
- Availability searches span at most 366 days. The primary schedule and other
  saved schedules are evaluated in their own zones before intersection/union.
  Busy intervals are exact ISO ranges. Continuous/appointment durations contain
  elapsed units, not calendar months or days. Appointment grids begin at each
  available window. Boundaries returned by a search are clipped to its interval.
- Supplied OperatingHours, TimeSlot and Holiday records can be unsaved. They
  require no query or DML. Multiple saved schedules share one three-query load.
- Fiscal periods can use the subscriber’s actual `Period` configuration,
  including irregular periods, or an explicit fiscal start month. A missing
  configured fiscal period is an error; no standard-calendar fallback is assumed.
- Recurrence searches are bounded to 3660 days and 1–1000 results. A deliberate
  occurrence count stops generation; exceeding the safety result limit fails.
  Calendar month ends and annual leap days skip invalid dates.
- RRULE supports DAILY/WEEKLY/MONTHLY/YEARLY, INTERVAL, COUNT, UNTIL, plain
  weekday BYDAY, BYMONTHDAY, BYMONTH and WKST. Unsupported parts and ordinal
  BYDAY are rejected; use the separate nth-weekday operation for that selection.
  The seed must match its RRULE filters. RRULE skips nonexistent local times
  without spending COUNT and uses the first occurrence of repeated times.
- Schedule adjustments are applied after recurrence generation. Separate
  occurrences can converge on the same open value; the collection deduplication
  action can remove those duplicates when desired.
- Collection sorting is stable for equal values. Exact values compare by
  instant. Calendar-duration comparison needs a reference. Group keys are local
  period-start ISO dates, one alongside each returned item. Nearest ties retain
  the first input. Duration sums add components and reject mixed-sign totals
  which cannot be represented as one ISO duration.
- Display lengths follow generated Gregorian patterns for 279 Salesforce
  locale IDs; context-user month/day names still come from Salesforce. A new
  unknown locale falls back to ISO and returns `styleApplied=false`. Explicit
  patterns use Apex pattern syntax; partial types reject missing components.
- Duration ISO and compact units are language-neutral. Long duration units and
  relative wording are English. Relative days mean elapsed 24-hour days.
- No alternative calendars, sub-millisecond arithmetic, natural-language date
  guessing, external holiday feeds or background scheduling engine.

The corresponding scalar and collection Flow harnesses are generated by
`scripts/actions/generate-fixtures.py` under `tests/subscriber`. They exercise
the actual Flow data boundary rather than only calling the Apex methods.

### Booking limits and working dates

Availability accepts `referenceInstant`, `minimumNotice`, `bookingHorizon`,
`bufferBefore`, `bufferAfter` and `gridAnchor`. Durations are non-negative elapsed
ISO durations; the horizon is positive. Notice and horizon require an explicit
reference datetime. Buffers must fit within free operating-hour windows, including
around busy intervals. The optional exact grid anchor keeps appointment starts
aligned across gaps between windows. Without it each free window anchors its grid.
`containsRange` also applies these limits; holiday and working-date listings do not.

WorkingDays accepts native Date/Datetime and ISO dates, local datetimes, instants
and zoned datetimes. It skips closed dates and holidays using the schedule timezone.
The starting date is excluded; zero leaves its calendar date unchanged. Timed values
retain the schedule-local clock, then apply the selected closed-time policy. A
nonexistent target clock is rejected; repeated clocks use the chosen disambiguation.
The search is bounded to 3660 calendar dates. Both action forms bulk load schedules
and return independent results; unsaved native schedules require no queries or DML.
