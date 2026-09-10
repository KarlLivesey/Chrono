# Find working-hour availability

**Chrono: Working Hours** · `Availability` · 0.2.0.NEXT · Development source; not the released installation package.

Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays.

| Form       | Builder label                                       | Apex entry point                                                                    |
| ---------- | --------------------------------------------------- | ----------------------------------------------------------------------------------- |
| Single     | Chrono: Find working-hour availability              | [ChronoAvailabilityAction](../apex/ChronoAvailabilityAction.md)                     |
| Collection | Chrono: Find working-hour availability (collection) | [ChronoAvailabilityCollectionAction](../apex/ChronoAvailabilityCollectionAction.md) |

Read [operating hours](../../handbook/operating-hours.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name                 | Label                      | Type             | Required               | Meaning                                                                                                                                    |
| ------------------------ | -------------------------- | ---------------- | ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| `operation`              | Operation                  | `String`         | Conditional / optional | Operation.                                                                                                                                 |
| `valueType`              | Value type                 | `String`         | Conditional / optional | Value type.                                                                                                                                |
| `value`                  | ISO value                  | `String`         | Conditional / optional | ISO value.                                                                                                                                 |
| `dateValue`              | Native date                | `Date`           | Conditional / optional | Native date.                                                                                                                               |
| `instantValue`           | Native datetime            | `Datetime`       | Conditional / optional | Native datetime.                                                                                                                           |
| `timeValue`              | Local time                 | `String`         | Conditional / optional | ISO time for a native date and time input.                                                                                                 |
| `timeZoneId`             | Timezone                   | `String`         | Conditional / optional | Required when resolving local time or inspecting an instant.                                                                               |
| `disambiguation`         | Repeated-time policy       | `String`         | Conditional / optional | Repeated-time policy.                                                                                                                      |
| `endValue`               | End ISO value              | `String`         | Conditional / optional | End ISO value.                                                                                                                             |
| `endDate`                | End native date            | `Date`           | Conditional / optional | End native date.                                                                                                                           |
| `endInstant`             | End native datetime        | `Datetime`       | Conditional / optional | End native datetime.                                                                                                                       |
| `endTime`                | End local time             | `String`         | Conditional / optional | Optional clock with a native end date.                                                                                                     |
| `operatingHoursId`       | OperatingHours ID          | `String`         | Conditional / optional | Use one saved ID or a supplied OperatingHours record.                                                                                      |
| `operatingHours`         | OperatingHours record      | `OperatingHours` | Conditional / optional | A supplied record can be unsaved. Also supply its TimeSlot and Holiday collections.                                                        |
| `timeSlots`              | Time slots                 | `List<TimeSlot>` | Conditional / optional | Normal slots for the supplied schedule; no DML is performed.                                                                               |
| `holidays`               | Holidays                   | `List<Holiday>`  | Conditional / optional | Holiday records for the supplied schedule, including recurring holidays.                                                                   |
| `otherOperatingHoursIds` | Additional schedule IDs    | `List<String>`   | Conditional / optional | Saved schedule IDs to intersect or unite with the primary schedule.                                                                        |
| `scheduleCombination`    | Combine schedules          | `String`         | Conditional / optional | Combine schedules.                                                                                                                         |
| `busyRanges`             | Busy intervals             | `List<String>`   | Conditional / optional | ISO exact start/end intervals to exclude from availability.                                                                                |
| `busyRangesText`         | Fixed busy intervals       | `String`         | Conditional / optional | One exact ISO start/end interval per line.                                                                                                 |
| `duration`               | Continuous duration        | `String`         | Conditional / optional | Positive elapsed ISO duration, for example PT30M. Calendar units are not appointment lengths.                                              |
| `stepDuration`           | Appointment start interval | `String`         | Conditional / optional | Positive elapsed ISO duration. Defaults to the appointment duration. Starts are anchored to each open window.                              |
| `maximumResults`         | Maximum results            | `Integer`        | Conditional / optional | 1–1000, default 100. Exceeding it returns an error.                                                                                        |
| `referenceInstant`       | Reference datetime         | `Datetime`       | Conditional / optional | Required when notice or booking horizon is set; use a Flow datetime such as the current datetime.                                          |
| `minimumNotice`          | Minimum notice             | `String`         | Conditional / optional | Non-negative elapsed ISO duration from the reference datetime, for example PT2H.                                                           |
| `bookingHorizon`         | Booking horizon            | `String`         | Conditional / optional | Positive elapsed ISO duration from the reference datetime; the complete appointment must fit before this limit.                            |
| `bufferBefore`           | Buffer before              | `String`         | Conditional / optional | Non-negative elapsed duration kept free before each appointment within operating hours.                                                    |
| `bufferAfter`            | Buffer after               | `String`         | Conditional / optional | Non-negative elapsed duration kept free after each appointment within operating hours.                                                     |
| `gridAnchor`             | Appointment grid anchor    | `Datetime`       | Conditional / optional | Optional exact datetime anchoring appointment starts across all windows and busy breaks. Without it each free window anchors its own grid. |

## Editor choices

| Field                 | Values                                                                                                                                          | Applicable source types |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `operation`           | `windows`, `boundaries`, `containsRange`, `continuous`, `shared`, `anySchedule`, `appointments`, `workingDates`, `holidays`, `validateSchedule` | —                       |
| `valueType`           | `PlainDate`, `PlainDateTime`, `Instant`, `ZonedDateTime`                                                                                        | —                       |
| `disambiguation`      | `reject`, `earlier`, `later`                                                                                                                    | —                       |
| `scheduleCombination` | `all`, `any`                                                                                                                                    | —                       |

These are field-level choices; they do not imply every operation supports every combination. The runtime rejects combinations requiring missing context or unsupported units.

## Results

The scalar result is [ChronoAvailabilityResult](../apex/ChronoAvailabilityResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoAvailabilityCollectionResult](../apex/ChronoAvailabilityCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoAvailabilityInput](../apex/ChronoAvailabilityInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-availability-editor`. Collection editor: `skel-chrono-availability-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.2.0.4 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
