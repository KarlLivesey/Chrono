# ChronoCheckWorkingTimeInput

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoCheckWorkingTimeInput`.

Check whether a date has opening hours or an instant is inside OperatingHours.

## Declaration

```apex
global with sharing class ChronoCheckWorkingTimeInput
```

Check whether a date has opening hours or an instant is inside OperatingHours.

Types: [ChronoCheckWorkingTimeInput](ChronoCheckWorkingTimeInput.md).

## ChronoCheckWorkingTimeInput

| Field / property                       | Flow label            | Contract                                                                                 |
| -------------------------------------- | --------------------- | ---------------------------------------------------------------------------------------- |
| `global String valueType`              | Value type            | Chrono type of the source.                                                               |
| `global String value`                  | ISO value             | ISO source; alternatively supply native fields.                                          |
| `global Datetime instantValue`         | Native datetime       | Exact source instant; mutually exclusive with ISO value.                                 |
| `global Date dateValue`                | Native date           | Local source date; mutually exclusive with ISO value.                                    |
| `global String timeValue`              | Local time            | ISO local time for native date/time input.                                               |
| `global String timeZoneId`             | Calculation timezone  | Explicit zone for local resolution or calendar calculations.                             |
| `global String disambiguation`         | Repeated-time policy  | reject, earlier or later; skipped local times are rejected unless explicitly corrected.  |
| `global String operatingHoursId`       | OperatingHours ID     | Saved accessible OperatingHours record ID.                                               |
| `global OperatingHours operatingHours` | OperatingHours record | Supplied native schedule, including unsaved records. Use instead of a saved schedule ID. |
| `global List<TimeSlot> timeSlots`      | Time slots            | Normal time slots for the supplied OperatingHours record. No queries or DML.             |
| `global List<Holiday> holidays`        | Holidays              | Holiday records for the supplied schedule, including recurring holidays.                 |

### ChronoCheckWorkingTimeInput

```apex
global ChronoCheckWorkingTimeInput()
```

Required Flow constructor.

Types: [ChronoCheckWorkingTimeInput](ChronoCheckWorkingTimeInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
