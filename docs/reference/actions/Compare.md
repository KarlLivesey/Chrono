# Compare date/time values

**Chrono: Calculations** · `Compare` · 0.2.0.NEXT · Development source; not the released installation package.

Compare compatible values and return before, equal or after.

| Form       | Builder label                                 | Apex entry point                                                          |
| ---------- | --------------------------------------------- | ------------------------------------------------------------------------- |
| Single     | Chrono: Compare date/time values              | [ChronoCompareAction](../apex/ChronoCompareAction.md)                     |
| Collection | Chrono: Compare date/time values (collection) | [ChronoCompareCollectionAction](../apex/ChronoCompareCollectionAction.md) |

Read [arithmetic](../../handbook/arithmetic.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name                | Label                     | Type       | Required               | Meaning                                                                                         |
| ----------------------- | ------------------------- | ---------- | ---------------------- | ----------------------------------------------------------------------------------------------- |
| `valueType`             | Value type                | `String`   | Conditional / optional | Chrono type of the source.                                                                      |
| `value`                 | ISO value                 | `String`   | Conditional / optional | ISO source; alternatively supply native fields.                                                 |
| `instantValue`          | Native datetime           | `Datetime` | Conditional / optional | Exact source instant; mutually exclusive with ISO value.                                        |
| `dateValue`             | Native date               | `Date`     | Conditional / optional | Local source date; mutually exclusive with ISO value.                                           |
| `timeValue`             | Local time                | `String`   | Conditional / optional | ISO local time for native date/time input.                                                      |
| `timeZoneId`            | Calculation timezone      | `String`   | Conditional / optional | Explicit zone for local resolution or calendar calculations.                                    |
| `disambiguation`        | Repeated-time policy      | `String`   | Conditional / optional | reject, earlier or later; skipped local times are rejected unless explicitly corrected.         |
| `endValueType`          | End value type            | `String`   | Conditional / optional | Defaults to the source type; exact types can be compared together.                              |
| `endValue`              | End ISO value             | `String`   | Conditional / optional | ISO end value; alternatively use native end fields.                                             |
| `endInstant`            | End native datetime       | `Datetime` | Conditional / optional | Native exact end instant.                                                                       |
| `endDate`               | End native date           | `Date`     | Conditional / optional | Native local end date.                                                                          |
| `endTime`               | End local time            | `String`   | Conditional / optional | ISO local time for a native end date/time.                                                      |
| `referenceDate`         | Duration reference date   | `Date`     | Conditional / optional | Required when comparing durations containing calendar units.                                    |
| `toleranceMilliseconds` | Tolerance in milliseconds | `Long`     | Conditional / optional | Optional non-negative tolerance for complete date, clock, exact or duration values.             |
| `comparisonPeriod`      | Compare local period      | `String`   | Conditional / optional | Optional day, week, month, quarter or year. Exact values require a common calculation timezone. |
| `weekStartsOn`          | Week starts on            | `Integer`  | Conditional / optional | 1 is Monday through 7 Sunday. Defaults to Monday.                                               |

## Results

The scalar result is [ChronoFlowResult](../apex/ChronoFlowResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoFlowCollectionResult](../apex/ChronoFlowCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoCompareInput](../apex/ChronoCompareInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-compare-editor`. Collection editor: `skel-chrono-compare-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.2.0.4 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
