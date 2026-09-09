# ChronoDurationResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoDurationResult`.

Flat duration calculation outputs. Calendar and elapsed components remain distinct.

## Declaration

```apex
global with sharing class ChronoDurationResult
```

Flat duration calculation outputs. Calendar and elapsed components remain distinct.

Types: [ChronoDurationResult](ChronoDurationResult.md).

## ChronoDurationResult

| Field / property                 | Flow label             | Contract                |
| -------------------------------- | ---------------------- | ----------------------- |
| `global Boolean success`         | Success                | Success.                |
| `global String errorMessage`     | Error                  | Error.                  |
| `global String value`            | ISO duration           | ISO duration.           |
| `global Integer months`          | Total calendar months  | Total calendar months.  |
| `global Integer days`            | Total calendar days    | Total calendar days.    |
| `global Long milliseconds`       | Elapsed milliseconds   | Elapsed milliseconds.   |
| `global Integer years`           | Whole calendar years   | Whole calendar years.   |
| `global Integer remainingMonths` | Remaining months       | Remaining months.       |
| `global Integer weeks`           | Whole calendar weeks   | Whole calendar weeks.   |
| `global Integer remainingDays`   | Remaining days         | Remaining days.         |
| `global Long hours`              | Whole elapsed hours    | Whole elapsed hours.    |
| `global Integer minutes`         | Remaining minutes      | Remaining minutes.      |
| `global Integer seconds`         | Remaining seconds      | Remaining seconds.      |
| `global Integer millisecondPart` | Remaining milliseconds | Remaining milliseconds. |
| `global Decimal total`           | Total in result unit   | Total in result unit.   |

### ChronoDurationResult

```apex
global ChronoDurationResult()
```

Required Flow constructor.

Types: [ChronoDurationResult](ChronoDurationResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
