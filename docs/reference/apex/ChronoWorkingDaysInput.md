# ChronoWorkingDaysInput

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoWorkingDaysInput`.

Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays.

## Declaration

```apex
global with sharing class ChronoWorkingDaysInput
```

Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays.

Types: [ChronoWorkingDaysInput](ChronoWorkingDaysInput.md).

## ChronoWorkingDaysInput

| Field / property                       | Flow label                       | Contract                                                                                                                                                                  |
| -------------------------------------- | -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `global String valueType`              | Value type                       | Value type.                                                                                                                                                               |
| `global String value`                  | ISO value                        | ISO value.                                                                                                                                                                |
| `global Date dateValue`                | Native date                      | Native date.                                                                                                                                                              |
| `global Datetime instantValue`         | Native datetime                  | Native datetime.                                                                                                                                                          |
| `global String timeValue`              | Local time                       | ISO time for a native date and time input.                                                                                                                                |
| `global String timeZoneId`             | Timezone                         | Required when resolving local time or inspecting an instant.                                                                                                              |
| `global String disambiguation`         | Repeated-time policy             | Repeated-time policy.                                                                                                                                                     |
| `global String operatingHoursId`       | OperatingHours ID                | Use one saved ID or a supplied OperatingHours record.                                                                                                                     |
| `global OperatingHours operatingHours` | OperatingHours record            | A supplied record can be unsaved. Also supply its TimeSlot and Holiday collections.                                                                                       |
| `global List<TimeSlot> timeSlots`      | Time slots                       | Normal slots for the supplied schedule; no DML is performed.                                                                                                              |
| `global List<Holiday> holidays`        | Holidays                         | Holiday records for the supplied schedule, including recurring holidays.                                                                                                  |
| `global Integer amount`                | Working calendar days            | Signed whole working dates to add; the starting date is excluded. Maximum search is 3660 calendar days.                                                                   |
| `global String closedTimePolicy`       | If the resulting clock is closed | Keep rejects neither closed clocks nor missing hours; reject requires open hours; next and previous move to the nearest open boundary. Dates only require a working date. |

### ChronoWorkingDaysInput

```apex
global ChronoWorkingDaysInput()
```

Required Flow constructor.

Types: [ChronoWorkingDaysInput](ChronoWorkingDaysInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
