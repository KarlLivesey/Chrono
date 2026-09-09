# Ranges and recurring dates

Ranges describe bounded time. Recurrence generates candidate dates or datetimes.
Neither automatically schedules jobs, books resources or writes records.

## Half-open ranges

Every range is **[start, end)**: include the start and exclude the end. Equal
endpoints form an empty range. Adjacent 09:00–10:00 and 10:00–11:00 ranges do not
both include the 10:00 boundary.

RangeTools can validate, contain, relate, intersect, merge, subtract, find gaps,
split, clamp and measure coverage. Supply the accepted dated type and consistent
context. A native Date is a calendar endpoint; do not assume it is already an
exact timestamp.

A clamp inside an exclusive end uses the previous calendar date for Date values
and the previous millisecond for timed values. Do not add that unit back before
saving it unless you mean to move to the excluded boundary.

## Recurrence operations

Use a simple operation when it directly describes your need: next weekday,
nth weekday, annual date or nth working day. Use `generate` for a bounded
daily/weekly/monthly/yearly sequence. Use `rrule` for the supported text subset.

Searches are bounded to 3,660 days and 1–1,000 results. An explicit occurrence
count intentionally stops generation. Exceeding a safety result cap fails
instead of silently returning an apparently complete list.

## Supported RRULE subset

Supported parts are `FREQ` (DAILY/WEEKLY/MONTHLY/YEARLY), `INTERVAL`, `COUNT`,
`UNTIL`, plain weekday `BYDAY`, `BYMONTHDAY`, `BYMONTH` and `WKST`.

```text
FREQ=WEEKLY;COUNT=6;BYDAY=SU
```

Supply the seed separately and make sure it matches the filters. Unsupported
parts, including ordinal BYDAY values, are rejected. Use the dedicated nth-weekday
operation instead of `BYDAY=2MO`. Do not describe this as a complete RFC RRULE
implementation.

RRULE skips nonexistent local occurrences without spending COUNT and uses the
first occurrence of a repeated local time. Other recurrence operations expose
their own gap/disambiguation controls. Invalid month-end or annual leap-day
dates are skipped, rather than clamped like native month addition.

## Working schedule adjustments

Generate the calendar occurrence, then apply the chosen closed-schedule policy.
Moving several occurrences to the next open time can make them converge on one
value. Use CollectionTools deduplication if your business meaning requires one
appointment at that instant.

A recurrence supplies dates; operating hours supplies availability. A recurring
09:00 reminder and a 30-minute bookable appointment have different requirements.
For actual slots, combine the range with [Availability](availability.md).

## Flow screens

The range screen returns validated endpoints and an interval. The recurrence
builder allows an administrator to supply rules and a user to preview occurrences
where configured. Both have reusable UI components separate from their Flow
adapters. See [components](../reference/components/index.md) and Examples 10/12.
