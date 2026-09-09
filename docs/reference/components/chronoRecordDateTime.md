# Chrono: Record date and time

Component `chronoRecordDateTime` · 0.2.0.NEXT · Development source; not the released installation package.

Edit a native Date or DateTime field with timezone and operating-hours validation.

Targets: `lightning__RecordPage`.

[Component architecture](../../handbook/components.md) · [Screen setup](../../handbook/screen-configuration.md).

## lightning__RecordPage

| Property                 | Label                                           | Type      | Direction    | Default / required            | Meaning           |
| ------------------------ | ----------------------------------------------- | --------- | ------------ | ----------------------------- | ----------------- |
| `dateTimeField`          | Date or DateTime field API name                 | `String`  | Input/output | Required; No metadata default | —                 |
| `timeZoneField`          | Timezone text field API name (optional)         | `String`  | Input/output | No metadata default           | —                 |
| `operatingHoursField`    | OperatingHours lookup field API name (optional) | `String`  | Input/output | No metadata default           | —                 |
| `fixedTimeZone`          | Default timezone ID                             | `String`  | Input/output | No metadata default           | —                 |
| `fixedOperatingHoursId`  | Fixed OperatingHours ID                         | `String`  | Input/output | No metadata default           | —                 |
| `label`                  | Label                                           | `String`  | Input/output | No metadata default           | —                 |
| `allowTimeZoneSelection` | Allow timezone changes                          | `Boolean` | Input/output | false                         | —                 |
| `dateStyle`              | Date display length (user locale)               | `String`  | Input/output | short                         | short,medium,long |

## Public LWC members

These are the checked `@api` members. JavaScript defaults are separate from Flow/App Builder metadata defaults. Setters may validate or normalise values; absence of an initializer is not a promise that every empty value is accepted.

| Member                   | Kind     | JS default      |
| ------------------------ | -------- | --------------- |
| `allowTimeZoneSelection` | property | false           |
| `dateStyle`              | property | "short"         |
| `dateTimeField`          | property | Not declared    |
| `fixedOperatingHoursId`  | property | Not declared    |
| `fixedTimeZone`          | property | Not declared    |
| `label`                  | property | "Date and time" |
| `objectApiName`          | property | Not declared    |
| `operatingHoursField`    | property | Not declared    |
| `recordId`               | property | Not declared    |
| `timeZoneField`          | property | Not declared    |

Generated from exposed component metadata and the checked LWC public-member inventory. Custom events and validation behaviour are described in the component guide; metadata alone does not describe event semantics or prove browser rendering.
