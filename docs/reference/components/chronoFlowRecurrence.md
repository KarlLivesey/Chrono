# Chrono: Recurrence builder

Component `chronoFlowRecurrence` · 0.2.0.NEXT · Development source; not the released installation package.

Targets: `lightning__FlowScreen`.

[Component architecture](../../handbook/components.md) · [Screen setup](../../handbook/screen-configuration.md).

## lightning__FlowScreen

| Property                 | Label                        | Type                                | Direction    | Default / required  | Meaning |
| ------------------------ | ---------------------------- | ----------------------------------- | ------------ | ------------------- | ------- |
| `label`                  | Label                        | `String`                            | inputOnly    | No metadata default | —       |
| `timeZoneId`             | Timezone                     | `String`                            | inputOnly    | No metadata default | —       |
| `allowTimeZoneSelection` | Allow timezone selection     | `Boolean`                           | inputOnly    | No metadata default | —       |
| `rule`                   | Recurrence rule              | `String`                            | Input/output | No metadata default | —       |
| `untilDate`              | Search through date          | `Date`                              | Input/output | No metadata default | —       |
| `maximumResults`         | Maximum preview results      | `Integer`                           | inputOnly    | No metadata default | —       |
| `operatingHoursId`       | OperatingHours ID            | `String`                            | inputOnly    | No metadata default | —       |
| `operatingHoursRecord`   | OperatingHours record        | `@salesforce/schema/OperatingHours` | inputOnly    | No metadata default | —       |
| `timeSlots`              | Time slots                   | `@salesforce/schema/TimeSlot[]`     | inputOnly    | No metadata default | —       |
| `holidays`               | Holidays                     | `@salesforce/schema/Holiday[]`      | inputOnly    | No metadata default | —       |
| `disabled`               | Read only                    | `Boolean`                           | inputOnly    | No metadata default | —       |
| `values`                 | Occurrence ISO values        | `String[]`                          | outputOnly   | No metadata default | —       |
| `startValue`             | Starting zoned ISO value     | `String`                            | Input/output | No metadata default | —       |
| `closedPolicy`           | Selected closed-hours policy | `String`                            | Input/output | No metadata default | —       |

## Public LWC members

These are the checked `@api` members. JavaScript defaults are separate from Flow/App Builder metadata defaults. Setters may validate or normalise values; absence of an initializer is not a promise that every empty value is accepted.

| Member                   | Kind     | JS default                       |
| ------------------------ | -------- | -------------------------------- |
| `allowTimeZoneSelection` | property | Not declared                     |
| `closedPolicy`           | property | "keep"                           |
| `disabled`               | property | Not declared                     |
| `holidays`               | property | Not declared                     |
| `label`                  | property | "Repeat"                         |
| `maximumResults`         | property | 100                              |
| `operatingHoursId`       | property | Not declared                     |
| `operatingHoursRecord`   | property | Not declared                     |
| `reportValidity`         | method   | Not declared                     |
| `rule`                   | property | "FREQ=WEEKLY;INTERVAL=1;COUNT=6" |
| `setCustomValidity`      | method   | Not declared                     |
| `startValue`             | get      | Not declared                     |
| `startValue`             | set      | Not declared                     |
| `timeSlots`              | property | Not declared                     |
| `timeZoneId`             | property | Not declared                     |
| `untilDate`              | property | Not declared                     |
| `validate`               | method   | Not declared                     |
| `values`                 | property | Not declared                     |

Generated from exposed component metadata and the checked LWC public-member inventory. Custom events and validation behaviour are described in the component guide; metadata alone does not describe event semantics or prove browser rendering.
