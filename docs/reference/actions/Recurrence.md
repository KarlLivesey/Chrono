# Generate recurring dates

**Chrono: Recurrence** · `Recurrence` · 0.2.0.NEXT · Development source; not the released installation package.

Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.

| Form       | Builder label                                 | Apex entry point                                                                |
| ---------- | --------------------------------------------- | ------------------------------------------------------------------------------- |
| Single     | Chrono: Generate recurring dates              | [ChronoRecurrenceAction](../apex/ChronoRecurrenceAction.md)                     |
| Collection | Chrono: Generate recurring dates (collection) | [ChronoRecurrenceCollectionAction](../apex/ChronoRecurrenceCollectionAction.md) |

Read [ranges recurrence](../../handbook/ranges-recurrence.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name           | Label                     | Type             | Required               | Meaning                                                                                                                                                         |
| ------------------ | ------------------------- | ---------------- | ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `operation`        | Operation                 | `String`         | Conditional / optional | Operation.                                                                                                                                                      |
| `valueType`        | Value type                | `String`         | Conditional / optional | Value type.                                                                                                                                                     |
| `value`            | ISO value                 | `String`         | Conditional / optional | ISO value.                                                                                                                                                      |
| `dateValue`        | Native date               | `Date`           | Conditional / optional | Native date.                                                                                                                                                    |
| `instantValue`     | Native datetime           | `Datetime`       | Conditional / optional | Native datetime.                                                                                                                                                |
| `timeValue`        | Local time                | `String`         | Conditional / optional | ISO time for a native date and time input.                                                                                                                      |
| `timeZoneId`       | Timezone                  | `String`         | Conditional / optional | Required when resolving local time or inspecting an instant.                                                                                                    |
| `disambiguation`   | Repeated-time policy      | `String`         | Conditional / optional | Repeated-time policy.                                                                                                                                           |
| `direction`        | Direction                 | `String`         | Conditional / optional | Direction.                                                                                                                                                      |
| `inclusive`        | Include the starting date | `Boolean`        | Conditional / optional | Include the starting date.                                                                                                                                      |
| `weekday`          | Weekday                   | `Integer`        | Conditional / optional | 1 Monday through 7 Sunday.                                                                                                                                      |
| `ordinal`          | Occurrence                | `Integer`        | Conditional / optional | Positive from the start; negative from the end. For example -1 is last.                                                                                         |
| `month`            | Annual month              | `Integer`        | Conditional / optional | 1–12.                                                                                                                                                           |
| `day`              | Annual day                | `Integer`        | Conditional / optional | Invalid dates such as 29 February in a common year are skipped.                                                                                                 |
| `frequency`        | Repeat every              | `String`         | Conditional / optional | Repeat every.                                                                                                                                                   |
| `interval`         | Interval                  | `Integer`        | Conditional / optional | Positive frequency interval; defaults to 1.                                                                                                                     |
| `weekdays`         | Weekdays                  | `String`         | Conditional / optional | Comma-separated MO,TU,WE,TH,FR,SA,SU. Weekly rules only.                                                                                                        |
| `rule`             | iCalendar RRULE           | `String`         | Conditional / optional | Supported: FREQ DAILY/WEEKLY/MONTHLY/YEARLY, INTERVAL, COUNT, UNTIL, BYDAY (plain weekday codes), BYMONTHDAY, BYMONTH and WKST. Unsupported parts are rejected. |
| `untilDate`        | Search through date       | `Date`           | Conditional / optional | Inclusive date boundary, at most 3660 days from the start.                                                                                                      |
| `count`            | Occurrence count          | `Integer`        | Conditional / optional | Optional deliberate stop count. Distinct from the safety result limit.                                                                                          |
| `gapPolicy`        | Skipped local times       | `String`         | Conditional / optional | Skipped local times.                                                                                                                                            |
| `closedPolicy`     | Closed schedule dates     | `String`         | Conditional / optional | Closed schedule dates.                                                                                                                                          |
| `maximumResults`   | Maximum results           | `Integer`        | Conditional / optional | 1–1000, default 100. Larger output fails rather than being silently truncated.                                                                                  |
| `operatingHoursId` | OperatingHours ID         | `String`         | Conditional / optional | Use one saved ID or a supplied OperatingHours record.                                                                                                           |
| `operatingHours`   | OperatingHours record     | `OperatingHours` | Conditional / optional | A supplied record can be unsaved. Also supply its TimeSlot and Holiday collections.                                                                             |
| `timeSlots`        | Time slots                | `List<TimeSlot>` | Conditional / optional | Normal slots for the supplied schedule; no DML is performed.                                                                                                    |
| `holidays`         | Holidays                  | `List<Holiday>`  | Conditional / optional | Holiday records for the supplied schedule, including recurring holidays.                                                                                        |

## Editor choices

| Field            | Values                                                                  | Applicable source types |
| ---------------- | ----------------------------------------------------------------------- | ----------------------- |
| `operation`      | `weekday`, `nthWeekday`, `annual`, `nthWorkingDay`, `generate`, `rrule` | —                       |
| `valueType`      | `PlainDate`, `PlainDateTime`, `Instant`, `ZonedDateTime`                | —                       |
| `disambiguation` | `reject`, `earlier`, `later`                                            | —                       |
| `direction`      | `next`, `previous`                                                      | —                       |
| `frequency`      | `daily`, `weekly`, `monthly`, `yearly`                                  | —                       |
| `gapPolicy`      | `reject`, `skip`, `forward`, `backward`                                 | —                       |
| `closedPolicy`   | `keep`, `skip`, `next`, `previous`                                      | —                       |

These are field-level choices; they do not imply every operation supports every combination. The runtime rejects combinations requiring missing context or unsupported units.

## Results

The scalar result is [ChronoRecurrenceResult](../apex/ChronoRecurrenceResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoRecurrenceCollectionResult](../apex/ChronoRecurrenceCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoRecurrenceInput](../apex/ChronoRecurrenceInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-recurrence-editor`. Collection editor: `skel-chrono-recurrence-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.2.0.4 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
