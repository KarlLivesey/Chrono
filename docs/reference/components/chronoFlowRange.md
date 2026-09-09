# Chrono: Date and time range

Component `chronoFlowRange` · 0.2.0.NEXT · Development source; not the released installation package.

Targets: `lightning__FlowScreen`.

[Component architecture](../../handbook/components.md) · [Screen setup](../../handbook/screen-configuration.md).

## lightning__FlowScreen

| Property                 | Label                     | Type                                | Direction    | Default / required  | Meaning |
| ------------------------ | ------------------------- | ----------------------------------- | ------------ | ------------------- | ------- |
| `mode`                   | date/datetime             | `String`                            | inputOnly    | datetime            | —       |
| `label`                  | Label                     | `String`                            | inputOnly    | Date and time range | —       |
| `timeZoneId`             | Timezone                  | `String`                            | inputOnly    | No metadata default | —       |
| `allowTimeZoneSelection` | Allow timezone changes    | `Boolean`                           | inputOnly    | false               | —       |
| `dateStyle`              | Date length (user locale) | `String`                            | inputOnly    | short               | —       |
| `required`               | Required                  | `Boolean`                           | inputOnly    | false               | —       |
| `disabled`               | Read only                 | `Boolean`                           | inputOnly    | false               | —       |
| `operatingHoursId`       | OperatingHours ID         | `String`                            | inputOnly    | No metadata default | —       |
| `operatingHoursRecord`   | OperatingHours record     | `@salesforce/schema/OperatingHours` | inputOnly    | No metadata default | —       |
| `timeSlots`              | Time slots                | `@salesforce/schema/TimeSlot[]`     | inputOnly    | No metadata default | —       |
| `holidays`               | Holidays                  | `@salesforce/schema/Holiday[]`      | inputOnly    | No metadata default | —       |
| `startValue`             | Start ISO value           | `String`                            | Input/output | No metadata default | —       |
| `endValue`               | End ISO value (exclusive) | `String`                            | Input/output | No metadata default | —       |
| `rangeValue`             | ISO interval              | `String`                            | outputOnly   | No metadata default | —       |
| `duration`               | ISO duration              | `String`                            | outputOnly   | No metadata default | —       |

## Public LWC members

These are the checked `@api` members. JavaScript defaults are separate from Flow/App Builder metadata defaults. Setters may validate or normalise values; absence of an initializer is not a promise that every empty value is accepted.

| Member                   | Kind     | JS default            |
| ------------------------ | -------- | --------------------- |
| `allowTimeZoneSelection` | property | false                 |
| `dateStyle`              | property | "short"               |
| `disabled`               | property | false                 |
| `duration`               | property | Not declared          |
| `endValue`               | get      | Not declared          |
| `endValue`               | set      | Not declared          |
| `holidays`               | property | Not declared          |
| `label`                  | property | "Date and time range" |
| `mode`                   | property | "datetime"            |
| `operatingHoursId`       | property | Not declared          |
| `operatingHoursRecord`   | property | Not declared          |
| `rangeValue`             | property | Not declared          |
| `reportValidity`         | method   | Not declared          |
| `required`               | property | false                 |
| `setCustomValidity`      | method   | Not declared          |
| `startValue`             | get      | Not declared          |
| `startValue`             | set      | Not declared          |
| `timeSlots`              | property | Not declared          |
| `timeZoneId`             | property | Not declared          |
| `validate`               | method   | Not declared          |

Generated from exposed component metadata and the checked LWC public-member inventory. Custom events and validation behaviour are described in the component guide; metadata alone does not describe event semantics or prove browser rendering.
