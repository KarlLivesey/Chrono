# Chrono: Duration, time or partial date

Component `chronoFlowValueInput` · 0.2.0.NEXT · Development source; not the released installation package.

Compact ISO value input with native calendar and clock controls.

Targets: `lightning__FlowScreen`.

[Component architecture](../../handbook/components.md) · [Screen setup](../../handbook/screen-configuration.md).

## lightning__FlowScreen

| Property   | Label      | Type      | Direction    | Default / required  | Meaning                                                           |
| ---------- | ---------- | --------- | ------------ | ------------------- | ----------------------------------------------------------------- |
| `kind`     | Value type | `String`  | inputOnly    | duration            | duration,time,yearmonth,monthday                                  |
| `label`    | Label      | `String`  | inputOnly    | Value               | —                                                                 |
| `required` | Required   | `Boolean` | inputOnly    | false               | —                                                                 |
| `disabled` | Read only  | `Boolean` | inputOnly    | false               | —                                                                 |
| `value`    | ISO value  | `String`  | Input/output | No metadata default | Initial and selected ISO duration, time, year/month or month/day. |

## Public LWC members

These are the checked `@api` members. JavaScript defaults are separate from Flow/App Builder metadata defaults. Setters may validate or normalise values; absence of an initializer is not a promise that every empty value is accepted.

| Member              | Kind     | JS default   |
| ------------------- | -------- | ------------ |
| `disabled`          | property | false        |
| `kind`              | property | "duration"   |
| `label`             | property | "Value"      |
| `reportValidity`    | method   | Not declared |
| `required`          | property | false        |
| `setCustomValidity` | method   | Not declared |
| `validate`          | method   | Not declared |
| `value`             | property | ""           |

Generated from exposed component metadata and the checked LWC public-member inventory. Custom events and validation behaviour are described in the component guide; metadata alone does not describe event semantics or prove browser rendering.
