# ChronoFiscalResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoFiscalResult`.

Independent Flow output with native and ISO fields.

## Declaration

```apex
global with sharing class ChronoFiscalResult
```

Independent Flow output with native and ISO fields.

Types: [ChronoFiscalResult](ChronoFiscalResult.md).

## ChronoFiscalResult

| Field / property                      | Flow label                  | Contract                                                         |
| ------------------------------------- | --------------------------- | ---------------------------------------------------------------- |
| `global Boolean success`              | Success                     | Success.                                                         |
| `global String errorMessage`          | Error                       | Error.                                                           |
| `global String periodId`              | Salesforce fiscal period ID | Salesforce fiscal period ID.                                     |
| `global String label`                 | Period label                | Period label.                                                    |
| `global String yearLabel`             | Fiscal year label           | Fiscal year label.                                               |
| `global Integer periodNumber`         | Period number               | Period number.                                                   |
| `global Date startDate`               | First date                  | First date.                                                      |
| `global Date lastDate`                | Last date                   | Last date.                                                       |
| `global Date endExclusiveDate`        | Exclusive end date          | Calendar date following the last date; exclusive range endpoint. |
| `global String startValue`            | Start ISO value             | Start ISO value.                                                 |
| `global String endExclusiveValue`     | Exclusive end ISO value     | Exclusive end ISO value.                                         |
| `global Datetime startInstant`        | Start datetime              | Start datetime.                                                  |
| `global Datetime endExclusiveInstant` | Exclusive end datetime      | Exclusive end datetime.                                          |

### ChronoFiscalResult

```apex
global ChronoFiscalResult()
```

Required Flow constructor.

Types: [ChronoFiscalResult](ChronoFiscalResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
