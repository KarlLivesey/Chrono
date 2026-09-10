# Allocate time to blocks

**Chrono: Time allocation** · `TimeAllocation` · 0.2.0.NEXT · Development source; not the released installation package.

Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.

| Form       | Builder label                                | Apex entry point                                                                        |
| ---------- | -------------------------------------------- | --------------------------------------------------------------------------------------- |
| Single     | Chrono: Allocate time to blocks              | [ChronoTimeAllocationAction](../apex/ChronoTimeAllocationAction.md)                     |
| Collection | Chrono: Allocate time to blocks (collection) | [ChronoTimeAllocationCollectionAction](../apex/ChronoTimeAllocationCollectionAction.md) |

Read [allocation](../../handbook/allocation.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name          | Label                | Type            | Required               | Meaning                                                                                                                                   |
| ----------------- | -------------------- | --------------- | ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `valueType`       | Value type           | `String`        | Conditional / optional | Value type.                                                                                                                               |
| `value`           | ISO value            | `String`        | Conditional / optional | ISO value.                                                                                                                                |
| `dateValue`       | Native date          | `Date`          | Conditional / optional | Native date.                                                                                                                              |
| `instantValue`    | Native datetime      | `Datetime`      | Conditional / optional | Native datetime.                                                                                                                          |
| `timeValue`       | Local time           | `String`        | Conditional / optional | ISO time for a native date and time input.                                                                                                |
| `timeZoneId`      | Block timezone       | `String`        | Conditional / optional | Required. All block clocks and supplied holiday dates use this timezone.                                                                  |
| `disambiguation`  | Repeated-time policy | `String`        | Conditional / optional | Repeated-time policy.                                                                                                                     |
| `endValue`        | End ISO value        | `String`        | Conditional / optional | End ISO value.                                                                                                                            |
| `endDate`         | End native date      | `Date`          | Conditional / optional | End native date.                                                                                                                          |
| `endInstant`      | End native datetime  | `Datetime`      | Conditional / optional | End native datetime.                                                                                                                      |
| `endTime`         | End local time       | `String`        | Conditional / optional | Optional clock with a native end date.                                                                                                    |
| `blocksText`      | Time blocks          | `String`        | Conditional / optional | Ordered named blocks. Configure here or supply the same JSON definition from a Text resource.                                             |
| `holidays`        | Bank holidays        | `List<Holiday>` | Conditional / optional | Native Holiday record collection, including unsaved or recurring holidays. Dates use the block timezone.                                  |
| `overlapMode`     | Overlapping blocks   | `String`        | Conditional / optional | Strict rejects matching overlaps; lax uses the first block; duplicate credits every block; split shares time equally.                     |
| `timeBasis`       | Count time as        | `String`        | Conditional / optional | Default elapsed: actual time. Clock: local endpoint difference, counting skipped clock time and repeated clock time once.                 |
| `allocationUnit`  | Allocate in units of | `String`        | Conditional / optional | Default millisecond. Whole units are distributed per segment; remaining units go to earlier blocks. Sub-unit time is reported separately. |
| `maximumSegments` | Maximum segment rows | `Integer`       | Conditional / optional | Default 1000; allowed 1–5000. Exceeding the limit fails without partial totals.                                                           |

## Editor choices

| Field            | Values                                                   | Applicable source types |
| ---------------- | -------------------------------------------------------- | ----------------------- |
| `valueType`      | `PlainDate`, `PlainDateTime`, `Instant`, `ZonedDateTime` | —                       |
| `disambiguation` | `reject`, `earlier`, `later`                             | —                       |
| `overlapMode`    | `strict`, `lax`, `duplicate`, `split`                    | —                       |
| `timeBasis`      | `elapsed`, `clock`                                       | —                       |
| `allocationUnit` | `millisecond`, `second`, `minute`                        | —                       |

These are field-level choices; they do not imply every operation supports every combination. The runtime rejects combinations requiring missing context or unsupported units.

## Results

The scalar result is [ChronoTimeAllocationResult](../apex/ChronoTimeAllocationResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoTimeAllocationCollectionResult](../apex/ChronoTimeAllocationCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoTimeAllocationInput](../apex/ChronoTimeAllocationInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-time-allocation-editor`. Collection editor: `skel-chrono-time-allocation-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.2.0.4 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
