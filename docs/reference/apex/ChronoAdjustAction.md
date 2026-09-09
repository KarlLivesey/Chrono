# ChronoAdjustAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoAdjustAction`.

Add calendar or elapsed units to a Chrono value.

## Declaration

```apex
global with sharing class ChronoAdjustAction
```

Add calendar or elapsed units to a Chrono value.

Types: [ChronoAdjustAction](ChronoAdjustAction.md).

## ChronoAdjustAction

```apex
global class Request
```

Scalar invocable wrapper targeted by Flow Builder extension metadata.

### run

```apex
global static List<ChronoFlowResult> run(List<Request> requests)
```

Add calendar or elapsed units to a Chrono value. Bulkified across Flow interviews.

Types: [ChronoFlowResult](ChronoFlowResult.md).

## ChronoAdjustAction.Request

| Field / property               | Flow label           | Contract                                                                       |
| ------------------------------ | -------------------- | ------------------------------------------------------------------------------ |
| `global String valueType`      | Value type           | Required. The Chrono type of the input.                                        |
| `global String value`          | ISO value            | ISO representation; provide this or the corresponding native input.            |
| `global Datetime instantValue` | Native datetime      | Native exact instant for Instant or ZonedDateTime inputs.                      |
| `global Date dateValue`        | Native date          | Native date for plain date, partial date or plain datetime inputs.             |
| `global String timeValue`      | Local time           | Local clock time such as 09:30:00.000.                                         |
| `global String timeZoneId`     | Time zone            | Explicit Salesforce time-zone ID; never inferred from the running user.        |
| `global String disambiguation` | Repeated-time policy | reject (default), earlier or later. Skipped local times fail.                  |
| `global String duration`       | ISO duration         | Signed ISO duration, for example P1D or -PT2H. Supply this or amount and unit. |
| `global Integer amount`        | Amount               | Signed whole units to add; negative values subtract.                           |
| `global String unit`           | Unit                 | years, months, weeks, days, hours, minutes, seconds or milliseconds.           |

### Request

```apex
global Request()
```

Global constructor for subscriber Flow.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
