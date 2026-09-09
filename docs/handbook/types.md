# Choose the right value

Use a value that carries exactly the context your calculation needs. A native
Salesforce `Datetime` represents an instant. Its display in a user's timezone
does not change that instant. A plain local datetime has no instant until you
supply a zone and resolve any clock-change ambiguity.

| Value type       | Carries                         | ISO example                                    | Apex data fields                 |
| ---------------- | ------------------------------- | ---------------------------------------------- | -------------------------------- |
| `PlainDate`      | Calendar date                   | `2026-09-08`                                   | `value`                          |
| `PlainTime`      | Local clock, no date            | `09:30:00.000`                                 | `value`                          |
| `PlainDateTime`  | Local date and clock, no zone   | `2026-09-08T09:30:00.000`                      | `localDate`, `localTime`         |
| `Instant`        | Exact point in time             | `2026-09-08T08:30:00.000Z`                     | `value`                          |
| `ZonedDateTime`  | Instant and named zone          | `2026-09-08T09:30:00.000+01:00[Europe/London]` | `instant`, `timeZoneId`          |
| `PlainYearMonth` | Year and month                  | `2026-09`                                      | `year`, `month`                  |
| `PlainMonthDay`  | Month and day                   | `--09-08`                                      | `month`, `day`                   |
| `Duration`       | Calendar and elapsed components | `P1M2DT3H`                                     | `months`, `days`, `milliseconds` |

The Apex names add `Chrono`, such as `skel.ChronoPlainDate`, and the matching
service adds `Service`, such as `skel.ChronoPlainDateService`.

## Missing context is a decision

A birthday's month and day need a year before they become a date. A local time
needs a date before it can be resolved in a timezone. An exact instant needs a
zone before you can ask which local day it falls on. Chrono requires that context
rather than borrowing an unrelated date or timezone from the running user.

The picker has a documented convenience default of the running user's timezone.
That UI default is separate from Apex and action operations which require an
explicit calculation zone where the operation needs one.

## What crosses Flow boundaries

Ordinary date/time payloads are **ISO Text or native Salesforce Date/DateTime**.
You do not need an Apex-defined `ChronoPlainDate` variable to hold a date in Flow.
Clock-only values use Text because the Flow boundary does not use Apex `Time`.

Some collection actions use Apex-defined **request and result records**. These
are operation envelopes with fields such as source type, ISO value and options;
they are distinct from the eight core data values. Schedule inputs use native
OperatingHours, TimeSlot and Holiday records, not redundant schedule wrappers.

## Date mode and midnight

Date-only picker mode produces a date, not a hidden instant. When a dated
operation explicitly promotes a date to a local datetime, or a datetime picker
receives only a date, midnight is the local clock default. Resolving that midnight
still needs a zone and can encounter a transition. A date is not intrinsically a
UTC midnight timestamp.

## Precision and calendars

Arithmetic has millisecond precision. ISO input may contain more fractional
digits; Chrono truncates after three without rounding. A negative fractional
duration is truncated towards zero at that precision.

Only the native Gregorian calendar model is supported. Alternative calendar
annotations are rejected. Partial dates retain their partial representation;
Chrono does not quietly invent a year or day merely to serialise them.

Continue with [ISO formats](iso-formats.md), [calendar versus elapsed arithmetic](arithmetic.md)
and [Apex reference](../reference/apex/index.md).
