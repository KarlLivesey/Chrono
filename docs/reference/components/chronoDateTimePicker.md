# chronoDateTimePicker

Component `chronoDateTimePicker` · 0.2.0.NEXT · Development source; not the released installation package.

Targets: Composition in a parent LWC; no direct Builder target..

[Component architecture](../../handbook/components.md) · [Screen setup](../../handbook/screen-configuration.md).

## Public LWC members

These are the checked `@api` members. JavaScript defaults are separate from Flow/App Builder metadata defaults. Setters may validate or normalise values; absence of an initializer is not a promise that every empty value is accepted.

| Member                   | Kind     | JS default        |
| ------------------------ | -------- | ----------------- |
| `allowOffsetOverride`    | property | false             |
| `allowTimeZoneSelection` | property | false             |
| `candidate`              | property | Not declared      |
| `candidates`             | property | Array initializer |
| `dateStyle`              | property | "medium"          |
| `dateValue`              | property | ""                |
| `disabled`               | property | false             |
| `errorMessage`           | property | ""                |
| `hasSchedule`            | property | false             |
| `helpText`               | property | ""                |
| `label`                  | property | "Date and time"   |
| `mode`                   | property | "datetime"        |
| `notice`                 | property | ""                |
| `operatingHoursId`       | property | ""                |
| `operatingHoursOptions`  | property | Array initializer |
| `pending`                | property | false             |
| `reportValidity`         | method   | Not declared      |
| `required`               | property | false             |
| `scheduleChoices`        | property | Array initializer |
| `scheduleMessage`        | property | ""                |
| `selectedInstant`        | property | ""                |
| `selectionMode`          | property | "auto"            |
| `showScheduleSearch`     | property | false             |
| `showScheduleSelection`  | property | false             |
| `timeValue`              | property | ""                |
| `timeZoneId`             | property | ""                |
| `timeZoneOptions`        | property | Array initializer |
| `zoneMessage`            | property | ""                |
| `zonePending`            | property | false             |

Generated from exposed component metadata and the checked LWC public-member inventory. Custom events and validation behaviour are described in the component guide; metadata alone does not describe event semantics or prove browser rendering.
