# ChronoDetailsResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoDetailsResult`.

Flat Flow result for details operations.

## Declaration

```apex
global with sharing class ChronoDetailsResult
```

Flat Flow result for details operations.

Types: [ChronoDetailsResult](ChronoDetailsResult.md).

## ChronoDetailsResult

| Field / property                   | Flow label                    | Contract                       |
| ---------------------------------- | ----------------------------- | ------------------------------ |
| `global Boolean success`           | Success                       | Success.                       |
| `global String errorMessage`       | Error                         | Error.                         |
| `global String valueType`          | Value type                    | Value type.                    |
| `global String value`              | ISO value                     | Value type.                    |
| `global Date dateValue`            | Local date                    | Local date.                    |
| `global String timeValue`          | Local time                    | Local time.                    |
| `global Datetime instantValue`     | Native datetime               | Native datetime.               |
| `global String timeZoneId`         | Timezone                      | Timezone.                      |
| `global Boolean isLeapYear`        | Is leap year                  | Is leap year.                  |
| `global Long durationMilliseconds` | Duration elapsed milliseconds | Duration elapsed milliseconds. |
| `global Integer year`              | Year                          | Year.                          |
| `global Integer month`             | Month                         | Month.                         |
| `global Integer day`               | Day                           | Day.                           |
| `global Integer hour`              | Hour                          | Hour.                          |
| `global Integer minute`            | Minute                        | Minute.                        |
| `global Integer second`            | Second                        | Second.                        |
| `global Integer millisecond`       | Millisecond                   | Millisecond.                   |
| `global Integer dayOfWeek`         | ISO weekday                   | ISO weekday.                   |
| `global Integer dayOfYear`         | Day of year                   | Day of year.                   |
| `global Integer weekOfYear`        | ISO week number               | ISO week number.               |
| `global Integer yearOfWeek`        | ISO week year                 | ISO week year.                 |
| `global Integer daysInMonth`       | Days in month                 | Days in month.                 |
| `global Integer daysInYear`        | Days in year                  | Days in year.                  |
| `global Integer quarter`           | Calendar quarter              | Calendar quarter.              |
| `global Integer offsetSeconds`     | UTC offset seconds            | UTC offset seconds.            |
| `global Integer durationMonths`    | Duration calendar months      | Duration calendar months.      |
| `global Integer durationDays`      | Duration calendar days        | Duration calendar days.        |

### ChronoDetailsResult

```apex
global ChronoDetailsResult()
```

Required Flow constructor.

Types: [ChronoDetailsResult](ChronoDetailsResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
