# Get fiscal period

**Chrono: Calculations** · `FiscalPeriod` · 0.2.0.NEXT · Development source; not the released installation package.

Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.

| Form       | Builder label                          | Apex entry point                                                                    |
| ---------- | -------------------------------------- | ----------------------------------------------------------------------------------- |
| Single     | Chrono: Get fiscal period              | [ChronoFiscalPeriodAction](../apex/ChronoFiscalPeriodAction.md)                     |
| Collection | Chrono: Get fiscal period (collection) | [ChronoFiscalPeriodCollectionAction](../apex/ChronoFiscalPeriodCollectionAction.md) |

Read [arithmetic](../../handbook/arithmetic.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name         | Label                       | Type       | Required               | Meaning                                                      |
| ---------------- | --------------------------- | ---------- | ---------------------- | ------------------------------------------------------------ |
| `valueType`      | Value type                  | `String`   | Conditional / optional | Value type.                                                  |
| `value`          | ISO value                   | `String`   | Conditional / optional | ISO value.                                                   |
| `dateValue`      | Native date                 | `Date`     | Conditional / optional | Native date.                                                 |
| `instantValue`   | Native datetime             | `Datetime` | Conditional / optional | Native datetime.                                             |
| `timeValue`      | Local time                  | `String`   | Conditional / optional | ISO time for a native date and time input.                   |
| `timeZoneId`     | Timezone                    | `String`   | Conditional / optional | Required when resolving local time or inspecting an instant. |
| `disambiguation` | Repeated-time policy        | `String`   | Conditional / optional | Repeated-time policy.                                        |
| `calendarSource` | Fiscal configuration        | `String`   | Conditional / optional | Fiscal configuration.                                        |
| `period`         | Fiscal period               | `String`   | Conditional / optional | Fiscal period.                                               |
| `startMonth`     | Fiscal year starts in month | `Integer`  | Conditional / optional | 1–12. Used only for a month-based fiscal year.               |

## Editor choices

| Field            | Values                                                   | Applicable source types |
| ---------------- | -------------------------------------------------------- | ----------------------- |
| `valueType`      | `PlainDate`, `PlainDateTime`, `Instant`, `ZonedDateTime` | —                       |
| `disambiguation` | `reject`, `earlier`, `later`                             | —                       |
| `calendarSource` | `organisation`, `monthBased`                             | —                       |
| `period`         | `year`, `quarter`, `month`                               | —                       |

These are field-level choices; they do not imply every operation supports every combination. The runtime rejects combinations requiring missing context or unsupported units.

## Results

The scalar result is [ChronoFiscalResult](../apex/ChronoFiscalResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoFiscalCollectionResult](../apex/ChronoFiscalCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoFiscalPeriodInput](../apex/ChronoFiscalPeriodInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-fiscal-period-editor`. Collection editor: `skel-chrono-fiscal-period-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.1.0.19 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
