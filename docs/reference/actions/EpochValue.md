# Convert Unix timestamp

**Chrono: Values** · `EpochValue` · 0.2.0.NEXT · Development source; not the released installation package.

Convert an exact value to or from Unix seconds or milliseconds.

| Form       | Builder label                               | Apex entry point                                                                |
| ---------- | ------------------------------------------- | ------------------------------------------------------------------------------- |
| Single     | Chrono: Convert Unix timestamp              | [ChronoEpochValueAction](../apex/ChronoEpochValueAction.md)                     |
| Collection | Chrono: Convert Unix timestamp (collection) | [ChronoEpochValueCollectionAction](../apex/ChronoEpochValueCollectionAction.md) |

Read [types](../../handbook/types.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name         | Label                | Type       | Required               | Meaning                                                      |
| ---------------- | -------------------- | ---------- | ---------------------- | ------------------------------------------------------------ |
| `operation`      | Operation            | `String`   | Conditional / optional | Operation.                                                   |
| `valueType`      | Value type           | `String`   | Conditional / optional | Value type.                                                  |
| `value`          | ISO value            | `String`   | Conditional / optional | ISO value.                                                   |
| `dateValue`      | Native date          | `Date`     | Conditional / optional | Native date.                                                 |
| `instantValue`   | Native datetime      | `Datetime` | Conditional / optional | Native datetime.                                             |
| `timeValue`      | Local time           | `String`   | Conditional / optional | ISO time for a native date and time input.                   |
| `timeZoneId`     | Timezone             | `String`   | Conditional / optional | Required when resolving local time or inspecting an instant. |
| `disambiguation` | Repeated-time policy | `String`   | Conditional / optional | Repeated-time policy.                                        |
| `epochValue`     | Unix timestamp       | `Decimal`  | Conditional / optional | Unix timestamp.                                              |
| `epochUnit`      | Timestamp unit       | `String`   | Conditional / optional | Timestamp unit.                                              |

## Editor choices

| Field            | Values                       | Applicable source types |
| ---------------- | ---------------------------- | ----------------------- |
| `operation`      | `fromEpoch`, `toEpoch`       | —                       |
| `valueType`      | `Instant`, `ZonedDateTime`   | —                       |
| `disambiguation` | `reject`, `earlier`, `later` | —                       |
| `epochUnit`      | `second`, `millisecond`      | —                       |

These are field-level choices; they do not imply every operation supports every combination. The runtime rejects combinations requiring missing context or unsupported units.

## Results

The scalar result is [ChronoEpochResult](../apex/ChronoEpochResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoEpochCollectionResult](../apex/ChronoEpochCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoEpochValueInput](../apex/ChronoEpochValueInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-epoch-value-editor`. Collection editor: `skel-chrono-epoch-value-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.2.0.4 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
