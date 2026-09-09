# Chrono: Available appointment

Component `chronoFlowAvailability` · 0.2.0.NEXT · Development source; not the released installation package.

Targets: `lightning__FlowScreen`.

[Component architecture](../../handbook/components.md) · [Screen setup](../../handbook/screen-configuration.md).

## lightning__FlowScreen

Configuration editor: `skel-chrono-availability-screen-editor`.

| Property                 | Label                      | Type                                | Direction    | Default / required  | Meaning                                                                                                                                    |
| ------------------------ | -------------------------- | ----------------------------------- | ------------ | ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| `valueType`              | Value type                 | `String`                            | inputOnly    | No metadata default | Value type.                                                                                                                                |
| `value`                  | ISO value                  | `String`                            | inputOnly    | No metadata default | ISO value.                                                                                                                                 |
| `dateValue`              | Native date                | `Date`                              | inputOnly    | No metadata default | Native date.                                                                                                                               |
| `instantValue`           | Native datetime            | `DateTime`                          | inputOnly    | No metadata default | Native datetime.                                                                                                                           |
| `timeValue`              | Local time                 | `String`                            | inputOnly    | No metadata default | ISO time for a native date and time input.                                                                                                 |
| `timeZoneId`             | Timezone                   | `String`                            | inputOnly    | No metadata default | Required when resolving local time or inspecting an instant.                                                                               |
| `disambiguation`         | Repeated-time policy       | `String`                            | inputOnly    | No metadata default | Repeated-time policy.                                                                                                                      |
| `endValue`               | End ISO value              | `String`                            | inputOnly    | No metadata default | End ISO value.                                                                                                                             |
| `endDate`                | End native date            | `Date`                              | inputOnly    | No metadata default | End native date.                                                                                                                           |
| `endInstant`             | End native datetime        | `DateTime`                          | inputOnly    | No metadata default | End native datetime.                                                                                                                       |
| `endTime`                | End local time             | `String`                            | inputOnly    | No metadata default | Optional clock with a native end date.                                                                                                     |
| `operatingHoursId`       | OperatingHours ID          | `String`                            | inputOnly    | No metadata default | Use one saved ID or a supplied OperatingHours record.                                                                                      |
| `operatingHours`         | OperatingHours record      | `@salesforce/schema/OperatingHours` | inputOnly    | No metadata default | A supplied record can be unsaved. Also supply its TimeSlot and Holiday collections.                                                        |
| `timeSlots`              | Time slots                 | `@salesforce/schema/TimeSlot[]`     | inputOnly    | No metadata default | Normal slots for the supplied schedule; no DML is performed.                                                                               |
| `holidays`               | Holidays                   | `@salesforce/schema/Holiday[]`      | inputOnly    | No metadata default | Holiday records for the supplied schedule, including recurring holidays.                                                                   |
| `otherOperatingHoursIds` | Additional schedule IDs    | `String[]`                          | inputOnly    | No metadata default | Saved schedule IDs to intersect or unite with the primary schedule.                                                                        |
| `scheduleCombination`    | Combine schedules          | `String`                            | inputOnly    | No metadata default | Combine schedules.                                                                                                                         |
| `busyRanges`             | Busy intervals             | `String[]`                          | inputOnly    | No metadata default | ISO exact start/end intervals to exclude from availability.                                                                                |
| `busyRangesText`         | Fixed busy intervals       | `String`                            | inputOnly    | No metadata default | One exact ISO start/end interval per line.                                                                                                 |
| `duration`               | Continuous duration        | `String`                            | inputOnly    | No metadata default | Positive elapsed ISO duration, for example PT30M. Calendar units are not appointment lengths.                                              |
| `stepDuration`           | Appointment start interval | `String`                            | inputOnly    | No metadata default | Positive elapsed ISO duration. Defaults to the appointment duration. Starts are anchored to each open window.                              |
| `maximumResults`         | Maximum results            | `Integer`                           | inputOnly    | No metadata default | 1–1000, default 100. Exceeding it returns an error.                                                                                        |
| `referenceInstant`       | Reference datetime         | `DateTime`                          | inputOnly    | No metadata default | Required when notice or booking horizon is set; use a Flow datetime such as the current datetime.                                          |
| `minimumNotice`          | Minimum notice             | `String`                            | inputOnly    | No metadata default | Non-negative elapsed ISO duration from the reference datetime, for example PT2H.                                                           |
| `bookingHorizon`         | Booking horizon            | `String`                            | inputOnly    | No metadata default | Positive elapsed ISO duration from the reference datetime; the complete appointment must fit before this limit.                            |
| `bufferBefore`           | Buffer before              | `String`                            | inputOnly    | No metadata default | Non-negative elapsed duration kept free before each appointment within operating hours.                                                    |
| `bufferAfter`            | Buffer after               | `String`                            | inputOnly    | No metadata default | Non-negative elapsed duration kept free after each appointment within operating hours.                                                     |
| `gridAnchor`             | Appointment grid anchor    | `DateTime`                          | inputOnly    | No metadata default | Optional exact datetime anchoring appointment starts across all windows and busy breaks. Without it each free window anchors its own grid. |
| `label`                  | Label                      | `String`                            | inputOnly    | Appointment         | —                                                                                                                                          |
| `required`               | Required                   | `Boolean`                           | inputOnly    | false               | —                                                                                                                                          |
| `disabled`               | Read only                  | `Boolean`                           | inputOnly    | false               | —                                                                                                                                          |
| `startValue`             | Chosen start ISO value     | `String`                            | outputOnly   | No metadata default | —                                                                                                                                          |
| `selectedEndValue`       | Chosen end ISO value       | `String`                            | outputOnly   | No metadata default | —                                                                                                                                          |
| `startDateTime`          | Chosen start datetime      | `DateTime`                          | outputOnly   | No metadata default | —                                                                                                                                          |
| `endDateTime`            | Chosen end datetime        | `DateTime`                          | outputOnly   | No metadata default | —                                                                                                                                          |
| `rangeValue`             | Chosen ISO interval        | `String`                            | Input/output | No metadata default | —                                                                                                                                          |

## Public LWC members

These are the checked `@api` members. JavaScript defaults are separate from Flow/App Builder metadata defaults. Setters may validate or normalise values; absence of an initializer is not a promise that every empty value is accepted.

| Member                   | Kind     | JS default    |
| ------------------------ | -------- | ------------- |
| `bookingHorizon`         | property | Not declared  |
| `bufferAfter`            | property | Not declared  |
| `bufferBefore`           | property | Not declared  |
| `busyRanges`             | property | Not declared  |
| `busyRangesText`         | property | Not declared  |
| `dateValue`              | property | Not declared  |
| `disabled`               | property | false         |
| `disambiguation`         | property | Not declared  |
| `duration`               | property | Not declared  |
| `endDate`                | property | Not declared  |
| `endDateTime`            | property | Not declared  |
| `endInstant`             | property | Not declared  |
| `endTime`                | property | Not declared  |
| `endValue`               | property | Not declared  |
| `gridAnchor`             | property | Not declared  |
| `holidays`               | property | Not declared  |
| `instantValue`           | property | Not declared  |
| `label`                  | property | "Appointment" |
| `maximumResults`         | property | Not declared  |
| `minimumNotice`          | property | Not declared  |
| `operatingHoursId`       | property | Not declared  |
| `operatingHours`         | property | Not declared  |
| `otherOperatingHoursIds` | property | Not declared  |
| `rangeValue`             | property | Not declared  |
| `referenceInstant`       | property | Not declared  |
| `reportValidity`         | method   | Not declared  |
| `required`               | property | false         |
| `scheduleCombination`    | property | Not declared  |
| `selectedEndValue`       | property | Not declared  |
| `setCustomValidity`      | method   | Not declared  |
| `startDateTime`          | property | Not declared  |
| `startValue`             | property | Not declared  |
| `stepDuration`           | property | Not declared  |
| `timeSlots`              | property | Not declared  |
| `timeValue`              | property | Not declared  |
| `timeZoneId`             | property | Not declared  |
| `validate`               | method   | Not declared  |
| `value`                  | property | Not declared  |
| `valueType`              | property | Not declared  |

Generated from exposed component metadata and the checked LWC public-member inventory. Custom events and validation behaviour are described in the component guide; metadata alone does not describe event semantics or prove browser rendering.
