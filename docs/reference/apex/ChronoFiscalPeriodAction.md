# ChronoFiscalPeriodAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoFiscalPeriodAction`.

Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.

## Declaration

```apex
global with sharing class ChronoFiscalPeriodAction
```

Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.

Types: [ChronoFiscalPeriodAction](ChronoFiscalPeriodAction.md).

## ChronoFiscalPeriodAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoFiscalResult> run(List<Request> requests)
```

Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.

Types: [ChronoFiscalResult](ChronoFiscalResult.md).

## ChronoFiscalPeriodAction.Request

| Field / property               | Flow label                  | Contract                                                     |
| ------------------------------ | --------------------------- | ------------------------------------------------------------ |
| `global String valueType`      | Value type                  | Value type.                                                  |
| `global String value`          | ISO value                   | ISO value.                                                   |
| `global Date dateValue`        | Native date                 | Native date.                                                 |
| `global Datetime instantValue` | Native datetime             | Native datetime.                                             |
| `global String timeValue`      | Local time                  | ISO time for a native date and time input.                   |
| `global String timeZoneId`     | Timezone                    | Required when resolving local time or inspecting an instant. |
| `global String disambiguation` | Repeated-time policy        | Repeated-time policy.                                        |
| `global String calendarSource` | Fiscal configuration        | Fiscal configuration.                                        |
| `global String period`         | Fiscal period               | Fiscal period.                                               |
| `global Integer startMonth`    | Fiscal year starts in month | 1–12. Used only for a month-based fiscal year.               |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
