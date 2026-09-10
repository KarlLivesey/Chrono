# Parse formatted date/time

**Chrono: Values** · `ParseValue` · 0.2.0.NEXT · Development source; not the released installation package.

Parse an explicitly specified numeric date and time pattern without guessing.

| Form       | Builder label                                  | Apex entry point                                                                |
| ---------- | ---------------------------------------------- | ------------------------------------------------------------------------------- |
| Single     | Chrono: Parse formatted date/time              | [ChronoParseValueAction](../apex/ChronoParseValueAction.md)                     |
| Collection | Chrono: Parse formatted date/time (collection) | [ChronoParseValueCollectionAction](../apex/ChronoParseValueCollectionAction.md) |

Read [types](../../handbook/types.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name         | Label                | Type     | Required               | Meaning                                                            |
| ---------------- | -------------------- | -------- | ---------------------- | ------------------------------------------------------------------ |
| `valueType`      | Value type           | `String` | Conditional / optional | Value type.                                                        |
| `text`           | Text to parse        | `String` | Conditional / optional | Text to parse.                                                     |
| `pattern`        | Input pattern        | `String` | Conditional / optional | Supported tokens: yyyy MM dd HH mm ss SSS and quoted literal text. |
| `timeZoneId`     | Timezone             | `String` | Conditional / optional | Required when resolving local time or inspecting an instant.       |
| `disambiguation` | Repeated-time policy | `String` | Conditional / optional | Repeated-time policy.                                              |

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

Use an Apex-defined collection of [ChronoParseValueInput](../apex/ChronoParseValueInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-parse-value-editor`. Collection editor: `skel-chrono-parse-value-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.2.0.4 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
