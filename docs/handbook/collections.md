# Collections and bulk execution

There are three different meanings of “bulk” in Chrono. Choose the one that
matches your Flow.

| Pattern                           | Use it when                                         | Input shape                                      |
| --------------------------------- | --------------------------------------------------- | ------------------------------------------------ |
| Scalar action, batched interviews | Many records launch the same Flow/action            | One request per interview, batched by Salesforce |
| Explicit-collection action        | One interview needs many different calculations     | A collection of the family's request DTO         |
| CollectionTools operation         | You want to sort, filter, group or summarise values | A value collection inside one calculation        |

## Build an explicit request collection

Create an Apex-defined variable of the exact request type, such as
`skel.ChronoConvertInput`, and another variable of that same type with **Allow
multiple values** enabled. Assign source type, source value and options to an
item, then add it to the collection. Clear or replace the item before populating
the next request so previous options do not leak into it.

Pass that collection to **Convert date/time (collection)**. A collection of
`ChronoAdjustInput` is not interchangeable, even if it has some similarly named
fields. Use the family page's exact type.

These request records are not the core Chrono date/time values. Their payloads
remain ISO Text or native Salesforce values. Native schedule records can be
included where the family supports them.

## Preserve correspondence

Chrono preserves the outer interview order and the inner request order. Results
are independent objects: changing a returned item does not change another item
which happened to use the same calculation. Identical calculations may be reused
within the invocation without exposing shared mutable result instances.

Inspect each returned item's success/error, not only the outer collection
envelope. Valid neighbours can succeed when an item has an invalid ISO date.
The [collection example](examples.md) deliberately includes one failure to show
that behaviour.

## Shared schedules

Flow schedule operations bulk-load common saved OperatingHours configurations
across requests and interviews. Avoid putting a query-backed Apex convenience
overload inside an unbounded loop when you can supply native records or use the
bulk action. Supplied schedules need no query or DML.

Bulkification does not create an unlimited CPU or heap budget. Particularly large
allocation, recurrence and appointment requests still share the caller's Apex
transaction limits. Use bounded work and read [limits and performance](limits.md).

## Sort and group values

CollectionTools compares exact values by instant and keeps the original order
for equal sort keys. Nearest-value ties retain the first input. Grouping uses
local period-start ISO dates as keys and needs the appropriate timezone context.
Calendar-duration comparison needs a reference value; one month is not a fixed
number of milliseconds.

Duration sums add components and reject a mixed-sign result that cannot be
represented as one supported ISO duration. A recurrence adjusted around closures
can create duplicate values; apply explicit deduplication if your task needs it.
