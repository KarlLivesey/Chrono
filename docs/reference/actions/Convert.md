# Convert date/time

**Chrono: Values** · `Convert` · 0.2.0.NEXT · Development source; not the released installation package.

Convert or normalise all eight Chrono value types.

| Form       | Builder label                          | Apex entry point                                                          |
| ---------- | -------------------------------------- | ------------------------------------------------------------------------- |
| Single     | Chrono: Convert date/time              | [ChronoConvertAction](../apex/ChronoConvertAction.md)                     |
| Collection | Chrono: Convert date/time (collection) | [ChronoConvertCollectionAction](../apex/ChronoConvertCollectionAction.md) |

Read [types](../../handbook/types.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name         | Label                | Type       | Required               | Meaning                                                                        |
| ---------------- | -------------------- | ---------- | ---------------------- | ------------------------------------------------------------------------------ |
| `valueType`      | Value type           | `String`   | Yes                    | The Chrono type of the input.                                                  |
| `value`          | ISO value            | `String`   | Conditional / optional | ISO representation; provide this or the corresponding native input.            |
| `instantValue`   | Native datetime      | `Datetime` | Conditional / optional | Native exact instant for Instant or ZonedDateTime inputs.                      |
| `dateValue`      | Native date          | `Date`     | Conditional / optional | Native date for plain date, partial date or plain datetime inputs.             |
| `timeValue`      | Local time           | `String`   | Conditional / optional | Local clock time such as 09:30:00.000.                                         |
| `targetType`     | Convert to           | `String`   | Conditional / optional | Output Chrono type; omit to normalise the input type.                          |
| `timeZoneId`     | Time zone            | `String`   | Conditional / optional | Explicit Salesforce time-zone ID; never inferred from the running user.        |
| `disambiguation` | Repeated-time policy | `String`   | Conditional / optional | reject (default), earlier or later. Skipped local times fail.                  |
| `referenceDate`  | Reference date       | `Date`     | Conditional / optional | Supplies the date for a plain time, year for month-day, or day for year-month. |
| `referenceTime`  | Reference time       | `String`   | Conditional / optional | Clock time to combine with a plain or partial date.                            |

## Results

The scalar result is [ChronoFlowResult](../apex/ChronoFlowResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoFlowCollectionResult](../apex/ChronoFlowCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoConvertInput](../apex/ChronoConvertInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-convert-editor`. Collection editor: `skel-chrono-convert-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.2.0.4 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
