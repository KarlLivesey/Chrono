# Add or subtract working time

**Chrono: Working Hours** · `WorkingTime` · 0.2.0.NEXT · Development source; not the released installation package.

Add time inside Salesforce OperatingHours or BusinessHours, skipping closures and holidays.

| Form       | Builder label                                     | Apex entry point                                                                  |
| ---------- | ------------------------------------------------- | --------------------------------------------------------------------------------- |
| Single     | Chrono: Add or subtract working time              | [ChronoWorkingTimeAction](../apex/ChronoWorkingTimeAction.md)                     |
| Collection | Chrono: Add or subtract working time (collection) | [ChronoWorkingTimeCollectionAction](../apex/ChronoWorkingTimeCollectionAction.md) |

Read [operating hours](../../handbook/operating-hours.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name         | Label                 | Type             | Required               | Meaning                                                                                           |
| ---------------- | --------------------- | ---------------- | ---------------------- | ------------------------------------------------------------------------------------------------- |
| `startInstant`   | Start datetime        | `Datetime`       | Conditional / optional | Native starting instant; alternatively use startValue.                                            |
| `startValue`     | Start ISO value       | `String`         | Conditional / optional | ISO date, local date/time, instant or zoned date/time. Local values require an explicit timezone. |
| `timeZoneId`     | Result time zone      | `String`         | Yes                    | Explicit zone for the result; availability follows the schedule zone.                             |
| `amount`         | Amount                | `Integer`        | Yes                    | Signed whole working units; negative values subtract.                                             |
| `unit`           | Unit                  | `String`         | Yes                    | hours or minutes.                                                                                 |
| `scheduleType`   | Schedule type         | `String`         | Yes                    | OperatingHours or BusinessHours.                                                                  |
| `scheduleId`     | Schedule record ID    | `String`         | Conditional / optional | Saved Salesforce schedule record ID; omit when supplying native OperatingHours records.           |
| `startDate`      | Start date            | `Date`           | Conditional / optional | Native local date; midnight unless startTime is supplied. Requires an explicit timezone.          |
| `startTime`      | Start local time      | `String`         | Conditional / optional | Optional ISO clock time with startDate. Omit for local midnight.                                  |
| `disambiguation` | Repeated-time policy  | `String`         | Conditional / optional | reject (default), earlier or later. Nonexistent times are rejected.                               |
| `operatingHours` | OperatingHours record | `OperatingHours` | Conditional / optional | Supplied native schedule, including unsaved records. Use instead of a saved schedule ID.          |
| `timeSlots`      | Time slots            | `List<TimeSlot>` | Conditional / optional | Normal time slots for the supplied OperatingHours record. No queries or DML.                      |
| `holidays`       | Holidays              | `List<Holiday>`  | Conditional / optional | Holiday records for the supplied schedule, including recurring holidays.                          |

## Results

The scalar result is [ChronoFlowResult](../apex/ChronoFlowResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoFlowCollectionResult](../apex/ChronoFlowCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoWorkingTimeInput](../apex/ChronoWorkingTimeInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-working-time-editor`. Collection editor: `skel-chrono-working-time-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.1.0.19 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
