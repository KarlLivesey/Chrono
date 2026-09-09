# Elapsed difference

**Chrono: Calculations** · `Difference` · 0.2.0.NEXT · Development source; not the released installation package.

Calculate signed elapsed time between two instants, optionally counting only OperatingHours.

| Form       | Builder label                           | Apex entry point                                                                |
| ---------- | --------------------------------------- | ------------------------------------------------------------------------------- |
| Single     | Chrono: Elapsed difference              | [ChronoDifferenceAction](../apex/ChronoDifferenceAction.md)                     |
| Collection | Chrono: Elapsed difference (collection) | [ChronoDifferenceCollectionAction](../apex/ChronoDifferenceCollectionAction.md) |

Read [arithmetic](../../handbook/arithmetic.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name            | Label                        | Type             | Required               | Meaning                                                                                                            |
| ------------------- | ---------------------------- | ---------------- | ---------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `startInstant`      | Start datetime               | `Datetime`       | Conditional / optional | Native starting instant; alternatively use startValue.                                                             |
| `startValue`        | Start ISO value              | `String`         | Conditional / optional | ISO date, local date/time, instant or zoned date/time. Local values require an explicit timezone.                  |
| `endInstant`        | End datetime                 | `Datetime`       | Conditional / optional | Native ending instant; alternatively use endValue.                                                                 |
| `endValue`          | End ISO value                | `String`         | Conditional / optional | ISO date, local date/time, instant or zoned date/time. Local values require an explicit timezone.                  |
| `operatingHoursId`  | OperatingHours ID (optional) | `String`         | Conditional / optional | Count only open time in this schedule’s timezone, excluding associated holidays. Leave blank for all elapsed time. |
| `startDate`         | Start date                   | `Date`           | Conditional / optional | Native local date; midnight unless startTime is supplied. Requires an explicit timezone.                           |
| `startTime`         | Start local time             | `String`         | Conditional / optional | Optional ISO clock time with startDate. Omit for local midnight.                                                   |
| `endDate`           | End date                     | `Date`           | Conditional / optional | Native local date; midnight unless endTime is supplied. Requires an explicit timezone.                             |
| `endTime`           | End local time               | `String`         | Conditional / optional | Optional ISO clock time with endDate. Omit for local midnight.                                                     |
| `timeZoneId`        | Local input timezone         | `String`         | Conditional / optional | Explicit timezone for local dates and date/times. Exact inputs retain their instant.                               |
| `disambiguation`    | Repeated-time policy         | `String`         | Conditional / optional | reject (default), earlier or later. Nonexistent times are rejected.                                                |
| `endTimeZoneId`     | End local input timezone     | `String`         | Conditional / optional | Optional separate timezone for the end value. Defaults to timeZoneId.                                              |
| `endDisambiguation` | End repeated-time policy     | `String`         | Conditional / optional | Optional end policy. Defaults to disambiguation; reject, earlier or later.                                         |
| `operatingHours`    | OperatingHours record        | `OperatingHours` | Conditional / optional | Supplied native schedule, including unsaved records. Use instead of a saved schedule ID.                           |
| `timeSlots`         | Time slots                   | `List<TimeSlot>` | Conditional / optional | Normal time slots for the supplied OperatingHours record. No queries or DML.                                       |
| `holidays`          | Holidays                     | `List<Holiday>`  | Conditional / optional | Holiday records for the supplied schedule, including recurring holidays.                                           |

## Results

The scalar result is [ChronoFlowResult](../apex/ChronoFlowResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoFlowCollectionResult](../apex/ChronoFlowCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoDifferenceInput](../apex/ChronoDifferenceInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-difference-editor`. Collection editor: `skel-chrono-difference-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.1.0.19 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
