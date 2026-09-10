# Work with date/time ranges

**Chrono: Ranges** · `RangeTools` · 0.2.0.NEXT · Development source; not the released installation package.

Validate and manipulate half-open ranges: start is included and end is excluded.

| Form       | Builder label                                   | Apex entry point                                                                |
| ---------- | ----------------------------------------------- | ------------------------------------------------------------------------------- |
| Single     | Chrono: Work with date/time ranges              | [ChronoRangeToolsAction](../apex/ChronoRangeToolsAction.md)                     |
| Collection | Chrono: Work with date/time ranges (collection) | [ChronoRangeToolsCollectionAction](../apex/ChronoRangeToolsCollectionAction.md) |

Read [ranges recurrence](../../handbook/ranges-recurrence.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name            | Label                       | Type           | Required               | Meaning                                                                             |
| ------------------- | --------------------------- | -------------- | ---------------------- | ----------------------------------------------------------------------------------- |
| `operation`         | Operation                   | `String`       | Conditional / optional | Operation.                                                                          |
| `valueType`         | Value type                  | `String`       | Conditional / optional | Value type.                                                                         |
| `value`             | ISO value                   | `String`       | Conditional / optional | ISO value.                                                                          |
| `dateValue`         | Native date                 | `Date`         | Conditional / optional | Native date.                                                                        |
| `instantValue`      | Native datetime             | `Datetime`     | Conditional / optional | Native datetime.                                                                    |
| `timeValue`         | Local time                  | `String`       | Conditional / optional | ISO time for a native date and time input.                                          |
| `timeZoneId`        | Timezone                    | `String`       | Conditional / optional | Required when resolving local time or inspecting an instant.                        |
| `disambiguation`    | Repeated-time policy        | `String`       | Conditional / optional | Repeated-time policy.                                                               |
| `endValue`          | End ISO value               | `String`       | Conditional / optional | End ISO value.                                                                      |
| `endDate`           | End native date             | `Date`         | Conditional / optional | End native date.                                                                    |
| `endInstant`        | End native datetime         | `Datetime`     | Conditional / optional | End native datetime.                                                                |
| `endTime`           | End local time              | `String`       | Conditional / optional | Optional clock with a native end date.                                              |
| `pointValue`        | Point ISO value             | `String`       | Conditional / optional | Same value type as the range; a zoned value may use another timezone.               |
| `otherStart`        | Other range start ISO       | `String`       | Conditional / optional | Other range start ISO.                                                              |
| `otherEnd`          | Other range end ISO         | `String`       | Conditional / optional | Other range end ISO.                                                                |
| `ranges`            | Other ISO ranges            | `List<String>` | Conditional / optional | Text collection of start/end intervals; slashes inside zone IDs are supported.      |
| `duration`          | Split duration              | `String`       | Conditional / optional | Positive ISO duration. Calendar units are evaluated at each boundary.               |
| `maximumResults`    | Maximum results             | `Integer`      | Conditional / optional | 1–1000, default 100. Exceeding the limit returns an error, never a partial success. |
| `rangesText`        | Fixed ISO ranges            | `String`       | Conditional / optional | One start/end interval per line. Use this or a text collection, not both.           |
| `pointDate`         | Point native date           | `Date`         | Conditional / optional | Use one native or ISO source for this value.                                        |
| `pointInstant`      | Point native datetime       | `Datetime`     | Conditional / optional | Use one native or ISO source for this value.                                        |
| `pointTime`         | Point local time            | `String`       | Conditional / optional | Use one native or ISO source for this value.                                        |
| `otherStartDate`    | Other start native date     | `Date`         | Conditional / optional | Use one native or ISO source for this value.                                        |
| `otherStartInstant` | Other start native datetime | `Datetime`     | Conditional / optional | Use one native or ISO source for this value.                                        |
| `otherStartTime`    | Other start local time      | `String`       | Conditional / optional | Use one native or ISO source for this value.                                        |
| `otherEndDate`      | Other end native date       | `Date`         | Conditional / optional | Use one native or ISO source for this value.                                        |
| `otherEndInstant`   | Other end native datetime   | `Datetime`     | Conditional / optional | Use one native or ISO source for this value.                                        |
| `otherEndTime`      | Other end local time        | `String`       | Conditional / optional | Use one native or ISO source for this value.                                        |

## Editor choices

| Field            | Values                                                                                                            | Applicable source types |
| ---------------- | ----------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `operation`      | `validate`, `contains`, `relationship`, `intersection`, `merge`, `subtract`, `gaps`, `split`, `clamp`, `coverage` | —                       |
| `valueType`      | `PlainDate`, `PlainDateTime`, `Instant`, `ZonedDateTime`                                                          | —                       |
| `disambiguation` | `reject`, `earlier`, `later`                                                                                      | —                       |

These are field-level choices; they do not imply every operation supports every combination. The runtime rejects combinations requiring missing context or unsupported units.

## Results

The scalar result is [ChronoRangeResult](../apex/ChronoRangeResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoRangeCollectionResult](../apex/ChronoRangeCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoRangeToolsInput](../apex/ChronoRangeToolsInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-range-tools-editor`. Collection editor: `skel-chrono-range-tools-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.2.0.4 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
