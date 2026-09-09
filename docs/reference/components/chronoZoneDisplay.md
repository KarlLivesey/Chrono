# Chrono: Multi-timezone display

Component `chronoZoneDisplay` · 0.2.0.NEXT · Development source; not the released installation package.

Targets: `lightning__FlowScreen`.

[Component architecture](../../handbook/components.md) · [Screen setup](../../handbook/screen-configuration.md).

## lightning__FlowScreen

| Property          | Label                                           | Type       | Direction | Default / required  | Meaning           |
| ----------------- | ----------------------------------------------- | ---------- | --------- | ------------------- | ----------------- |
| `label`           | Accessible label                                | `String`   | inputOnly | Across timezones    | —                 |
| `value`           | ISO instant or zoned datetime                   | `String`   | inputOnly | No metadata default | —                 |
| `dateTimeValue`   | Native datetime (alternative)                   | `DateTime` | inputOnly | No metadata default | —                 |
| `timeZoneIds`     | Timezone collection                             | `String[]` | inputOnly | No metadata default | —                 |
| `timeZoneIdsText` | Fixed timezone IDs (comma or newline separated) | `String`   | inputOnly | No metadata default | —                 |
| `dateStyle`       | Date length (user locale)                       | `String`   | inputOnly | short               | short,medium,long |

## Public LWC members

These are the checked `@api` members. JavaScript defaults are separate from Flow/App Builder metadata defaults. Setters may validate or normalise values; absence of an initializer is not a promise that every empty value is accepted.

| Member            | Kind     | JS default         |
| ----------------- | -------- | ------------------ |
| `dateStyle`       | property | "short"            |
| `dateTimeValue`   | property | Not declared       |
| `label`           | property | "Across timezones" |
| `timeZoneIds`     | property | Not declared       |
| `timeZoneIdsText` | property | Not declared       |
| `value`           | property | Not declared       |

Generated from exposed component metadata and the checked LWC public-member inventory. Custom events and validation behaviour are described in the component guide; metadata alone does not describe event semantics or prove browser rendering.
