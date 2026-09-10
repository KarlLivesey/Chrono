# Add working calendar days

**Chrono: Working Hours** · `WorkingDays` · 0.2.0.NEXT · Development source; not the released installation package.

Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays.

| Form       | Builder label                                  | Apex entry point                                                                  |
| ---------- | ---------------------------------------------- | --------------------------------------------------------------------------------- |
| Single     | Chrono: Add working calendar days              | [ChronoWorkingDaysAction](../apex/ChronoWorkingDaysAction.md)                     |
| Collection | Chrono: Add working calendar days (collection) | [ChronoWorkingDaysCollectionAction](../apex/ChronoWorkingDaysCollectionAction.md) |

Read [operating hours](../../handbook/operating-hours.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name           | Label                            | Type             | Required               | Meaning                                                                                                                                                                   |
| ------------------ | -------------------------------- | ---------------- | ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `valueType`        | Value type                       | `String`         | Conditional / optional | Value type.                                                                                                                                                               |
| `value`            | ISO value                        | `String`         | Conditional / optional | ISO value.                                                                                                                                                                |
| `dateValue`        | Native date                      | `Date`           | Conditional / optional | Native date.                                                                                                                                                              |
| `instantValue`     | Native datetime                  | `Datetime`       | Conditional / optional | Native datetime.                                                                                                                                                          |
| `timeValue`        | Local time                       | `String`         | Conditional / optional | ISO time for a native date and time input.                                                                                                                                |
| `timeZoneId`       | Timezone                         | `String`         | Conditional / optional | Required when resolving local time or inspecting an instant.                                                                                                              |
| `disambiguation`   | Repeated-time policy             | `String`         | Conditional / optional | Repeated-time policy.                                                                                                                                                     |
| `operatingHoursId` | OperatingHours ID                | `String`         | Conditional / optional | Use one saved ID or a supplied OperatingHours record.                                                                                                                     |
| `operatingHours`   | OperatingHours record            | `OperatingHours` | Conditional / optional | A supplied record can be unsaved. Also supply its TimeSlot and Holiday collections.                                                                                       |
| `timeSlots`        | Time slots                       | `List<TimeSlot>` | Conditional / optional | Normal slots for the supplied schedule; no DML is performed.                                                                                                              |
| `holidays`         | Holidays                         | `List<Holiday>`  | Conditional / optional | Holiday records for the supplied schedule, including recurring holidays.                                                                                                  |
| `amount`           | Working calendar days            | `Integer`        | Conditional / optional | Signed whole working dates to add; the starting date is excluded. Maximum search is 3660 calendar days.                                                                   |
| `closedTimePolicy` | If the resulting clock is closed | `String`         | Conditional / optional | Keep rejects neither closed clocks nor missing hours; reject requires open hours; next and previous move to the nearest open boundary. Dates only require a working date. |

## Editor choices

| Field              | Values                                                   | Applicable source types |
| ------------------ | -------------------------------------------------------- | ----------------------- |
| `valueType`        | `PlainDate`, `PlainDateTime`, `Instant`, `ZonedDateTime` | —                       |
| `disambiguation`   | `reject`, `earlier`, `later`                             | —                       |
| `closedTimePolicy` | `keep`, `reject`, `next`, `previous`                     | —                       |

These are field-level choices; they do not imply every operation supports every combination. The runtime rejects combinations requiring missing context or unsupported units.

## Results

The scalar result is [ChronoFlowResult](../apex/ChronoFlowResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoFlowCollectionResult](../apex/ChronoFlowCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoWorkingDaysInput](../apex/ChronoWorkingDaysInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-working-days-editor`. Collection editor: `skel-chrono-working-days-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.2.0.4 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
