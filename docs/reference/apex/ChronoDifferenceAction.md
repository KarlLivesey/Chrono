# ChronoDifferenceAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoDifferenceAction`.

Calculate signed elapsed time between two instants, optionally counting only OperatingHours.

## Declaration

```apex
global with sharing class ChronoDifferenceAction
```

Calculate signed elapsed time between two instants, optionally counting only OperatingHours.

Types: [ChronoDifferenceAction](ChronoDifferenceAction.md).

## ChronoDifferenceAction

```apex
global class Request
```

Scalar invocable wrapper targeted by Flow Builder extension metadata.

### run

```apex
global static List<ChronoFlowResult> run(List<Request> requests)
```

Calculate signed elapsed time between two instants, optionally counting only OperatingHours. Bulkified across Flow interviews.

Types: [ChronoFlowResult](ChronoFlowResult.md).

## ChronoDifferenceAction.Request

| Field / property                       | Flow label                   | Contract                                                                                                           |
| -------------------------------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `global Datetime startInstant`         | Start datetime               | Native starting instant; alternatively use startValue.                                                             |
| `global String startValue`             | Start ISO value              | ISO date, local date/time, instant or zoned date/time. Local values require an explicit timezone.                  |
| `global Datetime endInstant`           | End datetime                 | Native ending instant; alternatively use endValue.                                                                 |
| `global String endValue`               | End ISO value                | ISO date, local date/time, instant or zoned date/time. Local values require an explicit timezone.                  |
| `global String operatingHoursId`       | OperatingHours ID (optional) | Count only open time in this schedule’s timezone, excluding associated holidays. Leave blank for all elapsed time. |
| `global Date startDate`                | Start date                   | Native local date; midnight unless startTime is supplied. Requires an explicit timezone.                           |
| `global String startTime`              | Start local time             | Optional ISO clock time with startDate. Omit for local midnight.                                                   |
| `global Date endDate`                  | End date                     | Native local date; midnight unless endTime is supplied. Requires an explicit timezone.                             |
| `global String endTime`                | End local time               | Optional ISO clock time with endDate. Omit for local midnight.                                                     |
| `global String timeZoneId`             | Local input timezone         | Explicit timezone for local dates and date/times. Exact inputs retain their instant.                               |
| `global String disambiguation`         | Repeated-time policy         | reject (default), earlier or later. Nonexistent times are rejected.                                                |
| `global String endTimeZoneId`          | End local input timezone     | Optional separate timezone for the end value. Defaults to timeZoneId.                                              |
| `global String endDisambiguation`      | End repeated-time policy     | Optional end policy. Defaults to disambiguation; reject, earlier or later.                                         |
| `global OperatingHours operatingHours` | OperatingHours record        | Supplied native schedule, including unsaved records. Use instead of a saved schedule ID.                           |
| `global List<TimeSlot> timeSlots`      | Time slots                   | Normal time slots for the supplied OperatingHours record. No queries or DML.                                       |
| `global List<Holiday> holidays`        | Holidays                     | Holiday records for the supplied schedule, including recurring holidays.                                           |

### Request

```apex
global Request()
```

Global constructor for subscriber Flow.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
