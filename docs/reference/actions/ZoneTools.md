# Work with timezones

**Chrono: Time Zones** · `ZoneTools` · 0.2.0.NEXT · Development source; not the released installation package.

Convert zones, inspect date-specific offsets and search bounded timezone transitions.

| Form       | Builder label                            | Apex entry point                                                              |
| ---------- | ---------------------------------------- | ----------------------------------------------------------------------------- |
| Single     | Chrono: Work with timezones              | [ChronoZoneToolsAction](../apex/ChronoZoneToolsAction.md)                     |
| Collection | Chrono: Work with timezones (collection) | [ChronoZoneToolsCollectionAction](../apex/ChronoZoneToolsCollectionAction.md) |

Read [timezones](../../handbook/timezones.md) for semantics and [Flow configuration](../../handbook/flow-configuration.md) for literal/resource selection.

## Inputs

Fields below describe the scalar request. “Required” is the universal annotation; additional fields can be conditionally required by an operation. Dynamic resources are validated at runtime.

| API name           | Label                | Type       | Required               | Meaning                                                                                        |
| ------------------ | -------------------- | ---------- | ---------------------- | ---------------------------------------------------------------------------------------------- |
| `operation`        | Operation            | `String`   | Conditional / optional | Operation.                                                                                     |
| `valueType`        | Value type           | `String`   | Conditional / optional | Value type.                                                                                    |
| `value`            | ISO value            | `String`   | Conditional / optional | ISO value.                                                                                     |
| `dateValue`        | Native date          | `Date`     | Conditional / optional | Native date.                                                                                   |
| `instantValue`     | Native datetime      | `Datetime` | Conditional / optional | Native datetime.                                                                               |
| `timeValue`        | Local time           | `String`   | Conditional / optional | ISO time for a native date and time input.                                                     |
| `timeZoneId`       | Timezone             | `String`   | Conditional / optional | Required when resolving local time or inspecting an instant.                                   |
| `disambiguation`   | Repeated-time policy | `String`   | Conditional / optional | Repeated-time policy.                                                                          |
| `targetTimeZoneId` | Target timezone      | `String`   | Conditional / optional | Target timezone.                                                                               |
| `conversionMode`   | Keep                 | `String`   | Conditional / optional | Keep.                                                                                          |
| `suppliedOffset`   | Supplied UTC offset  | `String`   | Conditional / optional | An explicit signed offset such as +01:00. The result also includes the actual zone projection. |
| `search`           | Filter timezone IDs  | `String`   | Conditional / optional | Filter timezone IDs.                                                                           |
| `endInstant`       | Search end           | `Datetime` | Conditional / optional | Exclusive end for listing transitions. Searches are limited to 366 days.                       |
| `searchDays`       | Search days          | `Integer`  | Conditional / optional | 1–366 days for next or previous transition. Defaults to 366.                                   |

## Editor choices

| Field            | Values                                                                                                                     | Applicable source types |
| ---------------- | -------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| `operation`      | `convert`, `overrideOffset`, `details`, `listZones`, `compareZones`, `transitions`, `nextTransition`, `previousTransition` | —                       |
| `valueType`      | `PlainDate`, `PlainDateTime`, `Instant`, `ZonedDateTime`                                                                   | —                       |
| `disambiguation` | `reject`, `earlier`, `later`                                                                                               | —                       |
| `conversionMode` | `instant`, `localClock`                                                                                                    | —                       |

These are field-level choices; they do not imply every operation supports every combination. The runtime rejects combinations requiring missing context or unsupported units.

## Results

The scalar result is [ChronoZoneResult](../apex/ChronoZoneResult.md). Check `success` before consuming its fields; `errorMessage` identifies an item failure.

The collection result is [ChronoZoneCollectionResult](../apex/ChronoZoneCollectionResult.md). Inspect each inner result as well as the collection envelope.

## Collection requests

Use an Apex-defined collection of [ChronoZoneToolsInput](../apex/ChronoZoneToolsInput.md) for this action. Do not substitute another family’s request type. Both forms batch across interviews and preserve item order; returned data is independent.

## Configuration registration

Scalar editor: `skel-chrono-zone-tools-editor`. Collection editor: `skel-chrono-zone-tools-collection-editor`. Both are namespaced package components with a calendar icon. The installed 0.2.0.4 action metadata was checked against these registrations.

Generated from invocable source declarations and the editor catalogue. [All action families](index.md) · [Examples](../../handbook/examples.md).
