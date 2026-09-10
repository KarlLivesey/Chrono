# Create date/time from components

**Chrono: Values** · `CreateValue` · 0.2.0.NEXT · Development source; not the released installation package.

Construct a validated value from individual calendar and clock components.

| Form       | Builder label                                         | Apex entry point                                                                  |
| ---------- | ----------------------------------------------------- | --------------------------------------------------------------------------------- |
| Single     | Chrono: Create date/time from components              | [ChronoCreateValueAction](../apex/ChronoCreateValueAction.md)                     |
| Collection | Chrono: Create date/time from components (collection) | [ChronoCreateValueCollectionAction](../apex/ChronoCreateValueCollectionAction.md) |

Read [types](../../handbook/types.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name         | Label                | Type      | Required               | Meaning                                                      |
| ---------------- | -------------------- | --------- | ---------------------- | ------------------------------------------------------------ |
| `valueType`      | Value type           | `String`  | Conditional / optional | Value type.                                                  |
| `year`           | Year                 | `Integer` | Conditional / optional | Year.                                                        |
| `month`          | Month                | `Integer` | Conditional / optional | Month.                                                       |
| `day`            | Day                  | `Integer` | Conditional / optional | Day.                                                         |
| `hour`           | Hour                 | `Integer` | Conditional / optional | Hour.                                                        |
| `minute`         | Minute               | `Integer` | Conditional / optional | Minute.                                                      |
| `second`         | Second               | `Integer` | Conditional / optional | Second.                                                      |
| `millisecond`    | Millisecond          | `Integer` | Conditional / optional | Millisecond.                                                 |
| `timeZoneId`     | Timezone             | `String`  | Conditional / optional | Required when resolving local time or inspecting an instant. |
| `disambiguation` | Repeated-time policy | `String`  | Conditional / optional | Repeated-time policy.                                        |

## Editor choices

| Field            | Values                                                                                                   | Applicable source types |
| ---------------- | -------------------------------------------------------------------------------------------------------- | ----------------------- |
| `valueType`      | `PlainDate`, `PlainDateTime`, `PlainTime`, `PlainYearMonth`, `PlainMonthDay`, `Instant`, `ZonedDateTime` | —                       |
| `disambiguation` | `reject`, `earlier`, `later`                                                                             | —                       |

These are field-level choices; they do not imply every operation supports every combination. The runtime rejects combinations requiring missing context or unsupported units.

## Results

The scalar result is [ChronoFlowResult](../apex/ChronoFlowResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoFlowCollectionResult](../apex/ChronoFlowCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoCreateValueInput](../apex/ChronoCreateValueInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-create-value-editor`. Collection editor: `skel-chrono-create-value-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.2.0.4 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
