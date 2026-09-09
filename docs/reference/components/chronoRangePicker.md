# chronoRangePicker

Component `chronoRangePicker` · 0.2.0.NEXT · Development source; not the released installation package.

Targets: Composition in a parent LWC; no direct Builder target..

[Component architecture](../../handbook/components.md) · [Screen setup](../../handbook/screen-configuration.md).

## Public LWC members

These are the checked `@api` members. JavaScript defaults are separate from Flow/App Builder metadata defaults. Setters may validate or normalise values; absence of an initializer is not a promise that every empty value is accepted.

| Member                   | Kind     | JS default            |
| ------------------------ | -------- | --------------------- |
| `allowTimeZoneSelection` | property | false                 |
| `dateStyle`              | property | "short"               |
| `disabled`               | property | false                 |
| `endValue`               | property | Not declared          |
| `holidays`               | property | Not declared          |
| `label`                  | property | "Date and time range" |
| `mode`                   | property | "datetime"            |
| `operatingHoursId`       | property | Not declared          |
| `operatingHoursRecord`   | property | Not declared          |
| `reportValidity`         | method   | Not declared          |
| `required`               | property | false                 |
| `startValue`             | property | Not declared          |
| `timeSlots`              | property | Not declared          |
| `timeZoneId`             | property | Not declared          |
| `validate`               | method   | Not declared          |

Generated from exposed component metadata and the checked LWC public-member inventory. Custom events and validation behaviour are described in the component guide; metadata alone does not describe event semantics or prove browser rendering.
