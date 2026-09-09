# Calculate duration

**Chrono: Durations** · `DurationTools` · 0.2.0.NEXT · Development source; not the released installation package.

Construct, inspect, total, balance or scale durations with explicit calendar context.

| Form       | Builder label                           | Apex entry point                                                                      |
| ---------- | --------------------------------------- | ------------------------------------------------------------------------------------- |
| Single     | Chrono: Calculate duration              | [ChronoDurationToolsAction](../apex/ChronoDurationToolsAction.md)                     |
| Collection | Chrono: Calculate duration (collection) | [ChronoDurationToolsCollectionAction](../apex/ChronoDurationToolsCollectionAction.md) |

Read [arithmetic](../../handbook/arithmetic.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name           | Label                | Type       | Required               | Meaning                                                                                                                             |
| ------------------ | -------------------- | ---------- | ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `operation`        | Operation            | `String`   | Conditional / optional | Operation.                                                                                                                          |
| `value`            | ISO duration         | `String`   | Conditional / optional | ISO duration.                                                                                                                       |
| `unit`             | Result unit          | `String`   | Conditional / optional | Result unit.                                                                                                                        |
| `factor`           | Factor               | `Decimal`  | Conditional / optional | Factor.                                                                                                                             |
| `scalingMode`      | Scale using          | `String`   | Conditional / optional | Components preserves calendar units and requires whole calendar results. Elapsed resolves calendar units at the supplied reference. |
| `years`            | Years                | `Integer`  | Conditional / optional | Years.                                                                                                                              |
| `months`           | Months               | `Integer`  | Conditional / optional | Months.                                                                                                                             |
| `weeks`            | Weeks                | `Integer`  | Conditional / optional | Weeks.                                                                                                                              |
| `days`             | Days                 | `Integer`  | Conditional / optional | Days.                                                                                                                               |
| `hours`            | Hours                | `Long`     | Conditional / optional | Hours.                                                                                                                              |
| `minutes`          | Minutes              | `Long`     | Conditional / optional | Minutes.                                                                                                                            |
| `seconds`          | Seconds              | `Decimal`  | Conditional / optional | Seconds.                                                                                                                            |
| `milliseconds`     | Milliseconds         | `Long`     | Conditional / optional | Milliseconds.                                                                                                                       |
| `referenceDate`    | Reference date       | `Date`     | Conditional / optional | Use one reference date or datetime. A date without a timezone uses a plain midnight clock.                                          |
| `referenceInstant` | Reference datetime   | `Datetime` | Conditional / optional | Reference datetime.                                                                                                                 |
| `timeZoneId`       | Reference timezone   | `String`   | Conditional / optional | Reference timezone.                                                                                                                 |
| `disambiguation`   | Repeated-time policy | `String`   | Conditional / optional | Repeated-time policy.                                                                                                               |

## Editor choices

| Field            | Values                                                                                 | Applicable source types |
| ---------------- | -------------------------------------------------------------------------------------- | ----------------------- |
| `operation`      | `create`, `components`, `negate`, `absolute`, `total`, `balance`, `multiply`, `divide` | —                       |
| `unit`           | `year`, `month`, `week`, `day`, `hour`, `minute`, `second`, `millisecond`              | —                       |
| `scalingMode`    | `components`, `elapsed`                                                                | —                       |
| `disambiguation` | `reject`, `earlier`, `later`                                                           | —                       |

These are field-level choices; they do not imply every operation supports every combination. The runtime rejects combinations requiring missing context or unsupported units.

## Results

The scalar result is [ChronoDurationResult](../apex/ChronoDurationResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoDurationCollectionResult](../apex/ChronoDurationCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoDurationToolsInput](../apex/ChronoDurationToolsInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-duration-tools-editor`. Collection editor: `skel-chrono-duration-tools-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.1.0.19 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
