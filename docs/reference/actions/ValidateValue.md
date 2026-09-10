# Validate date/time value

**Chrono: Values** · `ValidateValue` · 0.2.0.NEXT · Development source; not the released installation package.

Validate a native or ISO value without failing other interviews.

| Form       | Builder label                                 | Apex entry point                                                                      |
| ---------- | --------------------------------------------- | ------------------------------------------------------------------------------------- |
| Single     | Chrono: Validate date/time value              | [ChronoValidateValueAction](../apex/ChronoValidateValueAction.md)                     |
| Collection | Chrono: Validate date/time value (collection) | [ChronoValidateValueCollectionAction](../apex/ChronoValidateValueCollectionAction.md) |

Read [types](../../handbook/types.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name         | Label                | Type       | Required               | Meaning                                                      |
| ---------------- | -------------------- | ---------- | ---------------------- | ------------------------------------------------------------ |
| `valueType`      | Value type           | `String`   | Conditional / optional | Value type.                                                  |
| `value`          | ISO value            | `String`   | Conditional / optional | ISO value.                                                   |
| `dateValue`      | Native date          | `Date`     | Conditional / optional | Native date.                                                 |
| `instantValue`   | Native datetime      | `Datetime` | Conditional / optional | Native datetime.                                             |
| `timeValue`      | Local time           | `String`   | Conditional / optional | ISO time for a native date and time input.                   |
| `timeZoneId`     | Timezone             | `String`   | Conditional / optional | Required when resolving local time or inspecting an instant. |
| `disambiguation` | Repeated-time policy | `String`   | Conditional / optional | Repeated-time policy.                                        |

## Editor choices

| Field            | Values                                                                                                               | Applicable source types |
| ---------------- | -------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `valueType`      | `PlainDate`, `PlainDateTime`, `PlainTime`, `PlainYearMonth`, `PlainMonthDay`, `Instant`, `ZonedDateTime`, `Duration` | —                       |
| `disambiguation` | `reject`, `earlier`, `later`                                                                                         | —                       |

These are field-level choices; they do not imply every operation supports every combination. The runtime rejects combinations requiring missing context or unsupported units.

## Results

The scalar result is [ChronoValidationResult](../apex/ChronoValidationResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoValidationCollectionResult](../apex/ChronoValidationCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoValidateValueInput](../apex/ChronoValidateValueInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-validate-value-editor`. Collection editor: `skel-chrono-validate-value-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.2.0.4 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
