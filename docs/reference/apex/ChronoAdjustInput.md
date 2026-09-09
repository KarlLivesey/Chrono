# ChronoAdjustInput

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoAdjustInput`.

One calendar or elapsed adjustment.

## Declaration

```apex
global with sharing class ChronoAdjustInput
```

One calendar or elapsed adjustment.

Types: [ChronoAdjustInput](ChronoAdjustInput.md).

## ChronoAdjustInput

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

### ChronoAdjustInput

```apex
global ChronoAdjustInput()
```

Global no-argument constructor required by subscriber Flow.

Types: [ChronoAdjustInput](ChronoAdjustInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
