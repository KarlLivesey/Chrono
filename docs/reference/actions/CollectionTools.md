# Work with date/time collections

**Chrono: Collections** · `CollectionTools` · 0.2.0.NEXT · Development source; not the released installation package.

Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow.

| Form       | Builder label                                        | Apex entry point                                                                          |
| ---------- | ---------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| Single     | Chrono: Work with date/time collections              | [ChronoCollectionToolsAction](../apex/ChronoCollectionToolsAction.md)                     |
| Collection | Chrono: Work with date/time collections (collection) | [ChronoCollectionToolsCollectionAction](../apex/ChronoCollectionToolsCollectionAction.md) |

Read [collections](../../handbook/collections.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name        | Label                             | Type             | Required               | Meaning                                                              |
| --------------- | --------------------------------- | ---------------- | ---------------------- | -------------------------------------------------------------------- |
| `operation`     | Operation                         | `String`         | Conditional / optional | Operation.                                                           |
| `valueType`     | Value type                        | `String`         | Conditional / optional | Value type.                                                          |
| `values`        | ISO values                        | `List<String>`   | Conditional / optional | Ordered ISO text collection, or fixed values with one item per line. |
| `valuesText`    | Fixed ISO values                  | `String`         | Conditional / optional | One ISO value per line.                                              |
| `dates`         | Native dates                      | `List<Date>`     | Conditional / optional | Alternative Date collection; do not supply another source.           |
| `datetimes`     | Native datetimes                  | `List<Datetime>` | Conditional / optional | Alternative Datetime collection; do not supply another source.       |
| `timeZoneId`    | Calculation timezone              | `String`         | Conditional / optional | Required for exact calendar grouping or zoned native input.          |
| `referenceDate` | Duration reference date           | `Date`           | Conditional / optional | Required to order durations containing calendar units.               |
| `direction`     | Sort order                        | `String`         | Conditional / optional | Sort order.                                                          |
| `lowerValue`    | Lower ISO value                   | `String`         | Conditional / optional | Included lower filter boundary.                                      |
| `upperValue`    | Upper ISO value                   | `String`         | Conditional / optional | Excluded upper filter boundary.                                      |
| `period`        | Group by                          | `String`         | Conditional / optional | Group by.                                                            |
| `weekStartsOn`  | Week starts on                    | `Integer`        | Conditional / optional | 1 is Monday through 7 Sunday; defaults to Monday.                    |
| `pointValue`    | Nearest to ISO value              | `String`         | Conditional / optional | Nearest to ISO value.                                                |
| `lowerDate`     | Lower boundary native date        | `Date`           | Conditional / optional | Use one native or ISO source for this value.                         |
| `lowerInstant`  | Lower boundary native datetime    | `Datetime`       | Conditional / optional | Use one native or ISO source for this value.                         |
| `lowerTime`     | Lower boundary local time         | `String`         | Conditional / optional | Use one native or ISO source for this value.                         |
| `upperDate`     | Upper boundary native date        | `Date`           | Conditional / optional | Use one native or ISO source for this value.                         |
| `upperInstant`  | Upper boundary native datetime    | `Datetime`       | Conditional / optional | Use one native or ISO source for this value.                         |
| `upperTime`     | Upper boundary local time         | `String`         | Conditional / optional | Use one native or ISO source for this value.                         |
| `pointDate`     | Nearest reference native date     | `Date`           | Conditional / optional | Use one native or ISO source for this value.                         |
| `pointInstant`  | Nearest reference native datetime | `Datetime`       | Conditional / optional | Use one native or ISO source for this value.                         |
| `pointTime`     | Nearest reference local time      | `String`         | Conditional / optional | Use one native or ISO source for this value.                         |

## Editor choices

| Field       | Values                                                                                                               | Applicable source types |
| ----------- | -------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `operation` | `earliest`, `latest`, `sort`, `deduplicate`, `filter`, `group`, `sumDurations`, `nearest`, `summary`                 | —                       |
| `valueType` | `PlainDate`, `PlainDateTime`, `PlainTime`, `PlainYearMonth`, `PlainMonthDay`, `Instant`, `ZonedDateTime`, `Duration` | —                       |
| `direction` | `ascending`, `descending`                                                                                            | —                       |
| `period`    | `day`, `week`, `month`, `quarter`, `year`                                                                            | —                       |

These are field-level choices; they do not imply every operation supports every combination. The runtime rejects combinations requiring missing context or unsupported units.

## Results

The scalar result is [ChronoValuesResult](../apex/ChronoValuesResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoValuesCollectionResult](../apex/ChronoValuesCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoCollectionToolsInput](../apex/ChronoCollectionToolsInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-collection-tools-editor`. Collection editor: `skel-chrono-collection-tools-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.1.0.19 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
