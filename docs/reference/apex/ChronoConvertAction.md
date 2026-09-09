# ChronoConvertAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoConvertAction`.

Convert or normalise all eight Chrono value types.

## Declaration

```apex
global with sharing class ChronoConvertAction
```

Convert or normalise all eight Chrono value types.

Types: [ChronoConvertAction](ChronoConvertAction.md).

## ChronoConvertAction

```apex
global class Request
```

Scalar invocable wrapper targeted by Flow Builder extension metadata.

### run

```apex
global static List<ChronoFlowResult> run(List<Request> requests)
```

Convert or normalise all eight Chrono value types. Bulkified across Flow interviews.

Types: [ChronoFlowResult](ChronoFlowResult.md).

## ChronoConvertAction.Request

| Field / property               | Flow label           | Contract                                                                       |
| ------------------------------ | -------------------- | ------------------------------------------------------------------------------ |
| `global String valueType`      | Value type           | Required. The Chrono type of the input.                                        |
| `global String value`          | ISO value            | ISO representation; provide this or the corresponding native input.            |
| `global Datetime instantValue` | Native datetime      | Native exact instant for Instant or ZonedDateTime inputs.                      |
| `global Date dateValue`        | Native date          | Native date for plain date, partial date or plain datetime inputs.             |
| `global String timeValue`      | Local time           | Local clock time such as 09:30:00.000.                                         |
| `global String targetType`     | Convert to           | Output Chrono type; omit to normalise the input type.                          |
| `global String timeZoneId`     | Time zone            | Explicit Salesforce time-zone ID; never inferred from the running user.        |
| `global String disambiguation` | Repeated-time policy | reject (default), earlier or later. Skipped local times fail.                  |
| `global Date referenceDate`    | Reference date       | Supplies the date for a plain time, year for month-day, or day for year-month. |
| `global String referenceTime`  | Reference time       | Clock time to combine with a plain or partial date.                            |

### Request

```apex
global Request()
```

Global constructor for subscriber Flow.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
