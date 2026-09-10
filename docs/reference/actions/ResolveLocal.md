# Inspect or resolve local time

**Chrono: Time Zones** · `ResolveLocal` · 0.2.0.NEXT · Development source; not the released installation package.

Inspect unique/repeated/skipped local times and explicitly select an occurrence or nearest gap boundary.

| Form       | Builder label                                      | Apex entry point                                                                    |
| ---------- | -------------------------------------------------- | ----------------------------------------------------------------------------------- |
| Single     | Chrono: Inspect or resolve local time              | [ChronoResolveLocalAction](../apex/ChronoResolveLocalAction.md)                     |
| Collection | Chrono: Inspect or resolve local time (collection) | [ChronoResolveLocalCollectionAction](../apex/ChronoResolveLocalCollectionAction.md) |

Read [timezones](../../handbook/timezones.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

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
| `resolution`     | Resolution           | `String`   | Conditional / optional | inspect, earlier, later, backward or forward. Defaults to inspect.                      |

## Results

The scalar result is [ChronoFlowResult](../apex/ChronoFlowResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoFlowCollectionResult](../apex/ChronoFlowCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoResolveLocalInput](../apex/ChronoResolveLocalInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-resolve-local-editor`. Collection editor: `skel-chrono-resolve-local-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.2.0.4 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
