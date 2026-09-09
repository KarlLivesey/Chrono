# ChronoDurationToolsInput

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoDurationToolsInput`.

Construct, inspect, total, balance or scale durations with explicit calendar context.

## Declaration

```apex
global with sharing class ChronoDurationToolsInput
```

Construct, inspect, total, balance or scale durations with explicit calendar context.

Types: [ChronoDurationToolsInput](ChronoDurationToolsInput.md).

## ChronoDurationToolsInput

| Field / property                   | Flow label           | Contract                                                                                                                            |
| ---------------------------------- | -------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `global String operation`          | Operation            | Operation.                                                                                                                          |
| `global String value`              | ISO duration         | ISO duration.                                                                                                                       |
| `global String unit`               | Result unit          | Result unit.                                                                                                                        |
| `global Decimal factor`            | Factor               | Factor.                                                                                                                             |
| `global String scalingMode`        | Scale using          | Components preserves calendar units and requires whole calendar results. Elapsed resolves calendar units at the supplied reference. |
| `global Integer years`             | Years                | Years.                                                                                                                              |
| `global Integer months`            | Months               | Months.                                                                                                                             |
| `global Integer weeks`             | Weeks                | Weeks.                                                                                                                              |
| `global Integer days`              | Days                 | Days.                                                                                                                               |
| `global Long hours`                | Hours                | Hours.                                                                                                                              |
| `global Long minutes`              | Minutes              | Minutes.                                                                                                                            |
| `global Decimal seconds`           | Seconds              | Seconds.                                                                                                                            |
| `global Long milliseconds`         | Milliseconds         | Milliseconds.                                                                                                                       |
| `global Date referenceDate`        | Reference date       | Use one reference date or datetime. A date without a timezone uses a plain midnight clock.                                          |
| `global Datetime referenceInstant` | Reference datetime   | Reference datetime.                                                                                                                 |
| `global String timeZoneId`         | Reference timezone   | Reference timezone.                                                                                                                 |
| `global String disambiguation`     | Repeated-time policy | Repeated-time policy.                                                                                                               |

### ChronoDurationToolsInput

```apex
global ChronoDurationToolsInput()
```

Required Flow constructor.

Types: [ChronoDurationToolsInput](ChronoDurationToolsInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
