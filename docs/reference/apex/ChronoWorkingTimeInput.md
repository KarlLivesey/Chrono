# ChronoWorkingTimeInput

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoWorkingTimeInput`.

One schedule-aware calculation.

## Declaration

```apex
global with sharing class ChronoWorkingTimeInput
```

One schedule-aware calculation.

Types: [ChronoWorkingTimeInput](ChronoWorkingTimeInput.md).

## ChronoWorkingTimeInput

| Field / property                       | Flow label            | Contract                                                                                          |
| -------------------------------------- | --------------------- | ------------------------------------------------------------------------------------------------- |
| `global Datetime startInstant`         | Start datetime        | Native starting instant; alternatively use startValue.                                            |
| `global String startValue`             | Start ISO value       | ISO date, local date/time, instant or zoned date/time. Local values require an explicit timezone. |
| `global String timeZoneId`             | Result time zone      | Required. Explicit zone for the result; availability follows the schedule zone.                   |
| `global Integer amount`                | Amount                | Required. Signed whole working units; negative values subtract.                                   |
| `global String unit`                   | Unit                  | Required. hours or minutes.                                                                       |
| `global String scheduleType`           | Schedule type         | Required. OperatingHours or BusinessHours.                                                        |
| `global String scheduleId`             | Schedule record ID    | Saved Salesforce schedule record ID; omit when supplying native OperatingHours records.           |
| `global Date startDate`                | Start date            | Native local date; midnight unless startTime is supplied. Requires an explicit timezone.          |
| `global String startTime`              | Start local time      | Optional ISO clock time with startDate. Omit for local midnight.                                  |
| `global String disambiguation`         | Repeated-time policy  | reject (default), earlier or later. Nonexistent times are rejected.                               |
| `global OperatingHours operatingHours` | OperatingHours record | Supplied native schedule, including unsaved records. Use instead of a saved schedule ID.          |
| `global List<TimeSlot> timeSlots`      | Time slots            | Normal time slots for the supplied OperatingHours record. No queries or DML.                      |
| `global List<Holiday> holidays`        | Holidays              | Holiday records for the supplied schedule, including recurring holidays.                          |

### ChronoWorkingTimeInput

```apex
global ChronoWorkingTimeInput()
```

Global no-argument constructor required by subscriber Flow.

Types: [ChronoWorkingTimeInput](ChronoWorkingTimeInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
