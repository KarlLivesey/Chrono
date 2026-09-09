# ChronoRecurrenceAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoRecurrenceAction`.

Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.

## Declaration

```apex
global with sharing class ChronoRecurrenceAction
```

Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.

Types: [ChronoRecurrenceAction](ChronoRecurrenceAction.md).

## ChronoRecurrenceAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoRecurrenceResult> run(List<Request> requests)
```

Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.

Types: [ChronoRecurrenceResult](ChronoRecurrenceResult.md).

## ChronoRecurrenceAction.Request

| Field / property                       | Flow label                | Contract                                                                                                                                                        |
| -------------------------------------- | ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `global String operation`              | Operation                 | Operation.                                                                                                                                                      |
| `global String valueType`              | Value type                | Value type.                                                                                                                                                     |
| `global String value`                  | ISO value                 | ISO value.                                                                                                                                                      |
| `global Date dateValue`                | Native date               | Native date.                                                                                                                                                    |
| `global Datetime instantValue`         | Native datetime           | Native datetime.                                                                                                                                                |
| `global String timeValue`              | Local time                | ISO time for a native date and time input.                                                                                                                      |
| `global String timeZoneId`             | Timezone                  | Required when resolving local time or inspecting an instant.                                                                                                    |
| `global String disambiguation`         | Repeated-time policy      | Repeated-time policy.                                                                                                                                           |
| `global String direction`              | Direction                 | Direction.                                                                                                                                                      |
| `global Boolean inclusive`             | Include the starting date | Include the starting date.                                                                                                                                      |
| `global Integer weekday`               | Weekday                   | 1 Monday through 7 Sunday.                                                                                                                                      |
| `global Integer ordinal`               | Occurrence                | Positive from the start; negative from the end. For example -1 is last.                                                                                         |
| `global Integer month`                 | Annual month              | 1–12.                                                                                                                                                           |
| `global Integer day`                   | Annual day                | Invalid dates such as 29 February in a common year are skipped.                                                                                                 |
| `global String frequency`              | Repeat every              | Repeat every.                                                                                                                                                   |
| `global Integer interval`              | Interval                  | Positive frequency interval; defaults to 1.                                                                                                                     |
| `global String weekdays`               | Weekdays                  | Comma-separated MO,TU,WE,TH,FR,SA,SU. Weekly rules only.                                                                                                        |
| `global String rule`                   | iCalendar RRULE           | Supported: FREQ DAILY/WEEKLY/MONTHLY/YEARLY, INTERVAL, COUNT, UNTIL, BYDAY (plain weekday codes), BYMONTHDAY, BYMONTH and WKST. Unsupported parts are rejected. |
| `global Date untilDate`                | Search through date       | Inclusive date boundary, at most 3660 days from the start.                                                                                                      |
| `global Integer count`                 | Occurrence count          | Optional deliberate stop count. Distinct from the safety result limit.                                                                                          |
| `global String gapPolicy`              | Skipped local times       | Skipped local times.                                                                                                                                            |
| `global String closedPolicy`           | Closed schedule dates     | Closed schedule dates.                                                                                                                                          |
| `global Integer maximumResults`        | Maximum results           | 1–1000, default 100. Larger output fails rather than being silently truncated.                                                                                  |
| `global String operatingHoursId`       | OperatingHours ID         | Use one saved ID or a supplied OperatingHours record.                                                                                                           |
| `global OperatingHours operatingHours` | OperatingHours record     | A supplied record can be unsaved. Also supply its TimeSlot and Holiday collections.                                                                             |
| `global List<TimeSlot> timeSlots`      | Time slots                | Normal slots for the supplied schedule; no DML is performed.                                                                                                    |
| `global List<Holiday> holidays`        | Holidays                  | Holiday records for the supplied schedule, including recurring holidays.                                                                                        |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
