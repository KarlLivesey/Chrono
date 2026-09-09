# ChronoAvailabilityInput

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoAvailabilityInput`.

Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays.

## Declaration

```apex
global with sharing class ChronoAvailabilityInput
```

Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays.

Types: [ChronoAvailabilityInput](ChronoAvailabilityInput.md).

## ChronoAvailabilityInput

| Field / property                             | Flow label                 | Contract                                                                                                                                   |
| -------------------------------------------- | -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| `global String operation`                    | Operation                  | Operation.                                                                                                                                 |
| `global String valueType`                    | Value type                 | Value type.                                                                                                                                |
| `global String value`                        | ISO value                  | ISO value.                                                                                                                                 |
| `global Date dateValue`                      | Native date                | Native date.                                                                                                                               |
| `global Datetime instantValue`               | Native datetime            | Native datetime.                                                                                                                           |
| `global String timeValue`                    | Local time                 | ISO time for a native date and time input.                                                                                                 |
| `global String timeZoneId`                   | Timezone                   | Required when resolving local time or inspecting an instant.                                                                               |
| `global String disambiguation`               | Repeated-time policy       | Repeated-time policy.                                                                                                                      |
| `global String endValue`                     | End ISO value              | End ISO value.                                                                                                                             |
| `global Date endDate`                        | End native date            | End native date.                                                                                                                           |
| `global Datetime endInstant`                 | End native datetime        | End native datetime.                                                                                                                       |
| `global String endTime`                      | End local time             | Optional clock with a native end date.                                                                                                     |
| `global String operatingHoursId`             | OperatingHours ID          | Use one saved ID or a supplied OperatingHours record.                                                                                      |
| `global OperatingHours operatingHours`       | OperatingHours record      | A supplied record can be unsaved. Also supply its TimeSlot and Holiday collections.                                                        |
| `global List<TimeSlot> timeSlots`            | Time slots                 | Normal slots for the supplied schedule; no DML is performed.                                                                               |
| `global List<Holiday> holidays`              | Holidays                   | Holiday records for the supplied schedule, including recurring holidays.                                                                   |
| `global List<String> otherOperatingHoursIds` | Additional schedule IDs    | Saved schedule IDs to intersect or unite with the primary schedule.                                                                        |
| `global String scheduleCombination`          | Combine schedules          | Combine schedules.                                                                                                                         |
| `global List<String> busyRanges`             | Busy intervals             | ISO exact start/end intervals to exclude from availability.                                                                                |
| `global String busyRangesText`               | Fixed busy intervals       | One exact ISO start/end interval per line.                                                                                                 |
| `global String duration`                     | Continuous duration        | Positive elapsed ISO duration, for example PT30M. Calendar units are not appointment lengths.                                              |
| `global String stepDuration`                 | Appointment start interval | Positive elapsed ISO duration. Defaults to the appointment duration. Starts are anchored to each open window.                              |
| `global Integer maximumResults`              | Maximum results            | 1–1000, default 100. Exceeding it returns an error.                                                                                        |
| `global Datetime referenceInstant`           | Reference datetime         | Required when notice or booking horizon is set; use a Flow datetime such as the current datetime.                                          |
| `global String minimumNotice`                | Minimum notice             | Non-negative elapsed ISO duration from the reference datetime, for example PT2H.                                                           |
| `global String bookingHorizon`               | Booking horizon            | Positive elapsed ISO duration from the reference datetime; the complete appointment must fit before this limit.                            |
| `global String bufferBefore`                 | Buffer before              | Non-negative elapsed duration kept free before each appointment within operating hours.                                                    |
| `global String bufferAfter`                  | Buffer after               | Non-negative elapsed duration kept free after each appointment within operating hours.                                                     |
| `global Datetime gridAnchor`                 | Appointment grid anchor    | Optional exact datetime anchoring appointment starts across all windows and busy breaks. Without it each free window anchors its own grid. |

### ChronoAvailabilityInput

```apex
global ChronoAvailabilityInput()
```

Required Flow constructor.

Types: [ChronoAvailabilityInput](ChronoAvailabilityInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
