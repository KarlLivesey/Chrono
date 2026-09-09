# Check working time

**Chrono: Working Hours** · `CheckWorkingTime` · 0.2.0.NEXT · Development source; not the released installation package.

Check whether a date has opening hours or an instant is inside OperatingHours.

| Form       | Builder label                           | Apex entry point                                                                            |
| ---------- | --------------------------------------- | ------------------------------------------------------------------------------------------- |
| Single     | Chrono: Check working time              | [ChronoCheckWorkingTimeAction](../apex/ChronoCheckWorkingTimeAction.md)                     |
| Collection | Chrono: Check working time (collection) | [ChronoCheckWorkingTimeCollectionAction](../apex/ChronoCheckWorkingTimeCollectionAction.md) |

Read [operating hours](../../handbook/operating-hours.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name           | Label                 | Type             | Required               | Meaning                                                                                  |
| ------------------ | --------------------- | ---------------- | ---------------------- | ---------------------------------------------------------------------------------------- |
| `valueType`        | Value type            | `String`         | Conditional / optional | Chrono type of the source.                                                               |
| `value`            | ISO value             | `String`         | Conditional / optional | ISO source; alternatively supply native fields.                                          |
| `instantValue`     | Native datetime       | `Datetime`       | Conditional / optional | Exact source instant; mutually exclusive with ISO value.                                 |
| `dateValue`        | Native date           | `Date`           | Conditional / optional | Local source date; mutually exclusive with ISO value.                                    |
| `timeValue`        | Local time            | `String`         | Conditional / optional | ISO local time for native date/time input.                                               |
| `timeZoneId`       | Calculation timezone  | `String`         | Conditional / optional | Explicit zone for local resolution or calendar calculations.                             |
| `disambiguation`   | Repeated-time policy  | `String`         | Conditional / optional | reject, earlier or later; skipped local times are rejected unless explicitly corrected.  |
| `operatingHoursId` | OperatingHours ID     | `String`         | Conditional / optional | Saved accessible OperatingHours record ID.                                               |
| `operatingHours`   | OperatingHours record | `OperatingHours` | Conditional / optional | Supplied native schedule, including unsaved records. Use instead of a saved schedule ID. |
| `timeSlots`        | Time slots            | `List<TimeSlot>` | Conditional / optional | Normal time slots for the supplied OperatingHours record. No queries or DML.             |
| `holidays`         | Holidays              | `List<Holiday>`  | Conditional / optional | Holiday records for the supplied schedule, including recurring holidays.                 |

## Results

The scalar result is [ChronoFlowResult](../apex/ChronoFlowResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoFlowCollectionResult](../apex/ChronoFlowCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoCheckWorkingTimeInput](../apex/ChronoCheckWorkingTimeInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-check-working-time-editor`. Collection editor: `skel-chrono-check-working-time-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.1.0.19 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
