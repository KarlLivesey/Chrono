# Start or end of period

**Chrono: Calculations** · `PeriodBoundary` · 0.2.0.NEXT · Development source; not the released installation package.

Find a calendar period boundary in an explicit timezone where applicable.

| Form       | Builder label                               | Apex entry point                                                                        |
| ---------- | ------------------------------------------- | --------------------------------------------------------------------------------------- |
| Single     | Chrono: Start or end of period              | [ChronoPeriodBoundaryAction](../apex/ChronoPeriodBoundaryAction.md)                     |
| Collection | Chrono: Start or end of period (collection) | [ChronoPeriodBoundaryCollectionAction](../apex/ChronoPeriodBoundaryCollectionAction.md) |

Read [arithmetic](../../handbook/arithmetic.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name         | Label                | Type       | Required               | Meaning                                                                                 |
| ---------------- | -------------------- | ---------- | ---------------------- | --------------------------------------------------------------------------------------- |
| `valueType`      | Value type           | `String`   | Conditional / optional | Chrono type of the source.                                                              |
| `value`          | ISO value            | `String`   | Conditional / optional | ISO source; alternatively supply native fields.                                         |
| `instantValue`   | Native datetime      | `Datetime` | Conditional / optional | Exact source instant; mutually exclusive with ISO value.                                |
| `dateValue`      | Native date          | `Date`     | Conditional / optional | Local source date; mutually exclusive with ISO value.                                   |
| `timeValue`      | Local time           | `String`   | Conditional / optional | ISO local time for native date/time input.                                              |
| `timeZoneId`     | Calculation timezone | `String`   | Conditional / optional | Explicit zone for local resolution or calendar calculations.                            |
| `disambiguation` | Repeated-time policy | `String`   | Conditional / optional | reject, earlier or later; skipped local times are rejected unless explicitly corrected. |
| `unit`           | Period               | `String`   | Conditional / optional | day, week, month or year.                                                               |
| `boundary`       | Boundary             | `String`   | Conditional / optional | start or end. End is the final millisecond, or final date, in the period.               |
| `weekStartsOn`   | Week starts on       | `Integer`  | Conditional / optional | ISO weekday: 1 Monday through 7 Sunday. Defaults to Monday.                             |

## Results

The scalar result is [ChronoFlowResult](../apex/ChronoFlowResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoFlowCollectionResult](../apex/ChronoFlowCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoPeriodBoundaryInput](../apex/ChronoPeriodBoundaryInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-period-boundary-editor`. Collection editor: `skel-chrono-period-boundary-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.1.0.19 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
