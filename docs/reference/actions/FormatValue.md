# Format date/time for display

**Chrono: Formatting** · `FormatValue` · 0.2.0.NEXT · Development source; not the released installation package.

Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output.

| Form       | Builder label                                     | Apex entry point                                                                  |
| ---------- | ------------------------------------------------- | --------------------------------------------------------------------------------- |
| Single     | Chrono: Format date/time for display              | [ChronoFormatValueAction](../apex/ChronoFormatValueAction.md)                     |
| Collection | Chrono: Format date/time for display (collection) | [ChronoFormatValueCollectionAction](../apex/ChronoFormatValueCollectionAction.md) |

Read [formatting](../../handbook/formatting.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name           | Label                         | Type       | Required               | Meaning                                                                                           |
| ------------------ | ----------------------------- | ---------- | ---------------------- | ------------------------------------------------------------------------------------------------- |
| `operation`        | Operation                     | `String`   | Conditional / optional | Operation.                                                                                        |
| `valueType`        | Value type                    | `String`   | Conditional / optional | Value type.                                                                                       |
| `value`            | ISO value                     | `String`   | Conditional / optional | ISO value.                                                                                        |
| `dateValue`        | Native date                   | `Date`     | Conditional / optional | Native date.                                                                                      |
| `instantValue`     | Native datetime               | `Datetime` | Conditional / optional | Native datetime.                                                                                  |
| `timeValue`        | Local time                    | `String`   | Conditional / optional | ISO time for a native date and time input.                                                        |
| `timeZoneId`       | Timezone                      | `String`   | Conditional / optional | Required when resolving local time or inspecting an instant.                                      |
| `disambiguation`   | Repeated-time policy          | `String`   | Conditional / optional | Repeated-time policy.                                                                             |
| `style`            | Display length                | `String`   | Conditional / optional | Component order and names follow the context user locale. Gregorian years always use four digits. |
| `pattern`          | Explicit output pattern       | `String`   | Conditional / optional | Optional Apex date-format pattern. Overrides display length; parsing never guesses this pattern.  |
| `includeZone`      | Append timezone offset and ID | `Boolean`  | Conditional / optional | Append timezone offset and ID.                                                                    |
| `endValue`         | Range end ISO value           | `String`   | Conditional / optional | The same value family as the start.                                                               |
| `separator`        | Range separator               | `String`   | Conditional / optional | Defaults to an en dash.                                                                           |
| `durationStyle`    | Duration style                | `String`   | Conditional / optional | ISO is language-neutral; compact uses unit symbols and long uses English unit names.              |
| `referenceValue`   | Relative reference ISO value  | `String`   | Conditional / optional | Supply a reference of the same type, or another exact value.                                      |
| `relativeUnit`     | Relative elapsed unit         | `String`   | Conditional / optional | Auto chooses elapsed seconds, minutes, hours or 24-hour days.                                     |
| `referenceDate`    | Reference native date         | `Date`     | Conditional / optional | Use one native or ISO source for this value.                                                      |
| `referenceInstant` | Reference native datetime     | `Datetime` | Conditional / optional | Use one native or ISO source for this value.                                                      |
| `referenceTime`    | Reference local time          | `String`   | Conditional / optional | Use one native or ISO source for this value.                                                      |
| `endDate`          | Range end native date         | `Date`     | Conditional / optional | Use one native or ISO source for this value.                                                      |
| `endInstant`       | Range end native datetime     | `Datetime` | Conditional / optional | Use one native or ISO source for this value.                                                      |
| `endTime`          | Range end local time          | `String`   | Conditional / optional | Use one native or ISO source for this value.                                                      |

## Editor choices

| Field            | Values                                                                                                               | Applicable source types |
| ---------------- | -------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `operation`      | `value`, `range`, `duration`, `relative`                                                                             | —                       |
| `valueType`      | `PlainDate`, `PlainDateTime`, `PlainTime`, `PlainYearMonth`, `PlainMonthDay`, `Instant`, `ZonedDateTime`, `Duration` | —                       |
| `disambiguation` | `reject`, `earlier`, `later`                                                                                         | —                       |
| `style`          | `short`, `medium`, `long`, `full`                                                                                    | —                       |
| `durationStyle`  | `iso`, `compact`, `long`                                                                                             | —                       |
| `relativeUnit`   | `auto`, `second`, `minute`, `hour`, `day`                                                                            | —                       |

These are field-level choices; they do not imply every operation supports every combination. The runtime rejects combinations requiring missing context or unsupported units.

## Results

The scalar result is [ChronoFormatResult](../apex/ChronoFormatResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoFormatCollectionResult](../apex/ChronoFormatCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoFormatValueInput](../apex/ChronoFormatValueInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-format-value-editor`. Collection editor: `skel-chrono-format-value-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.2.0.4 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
