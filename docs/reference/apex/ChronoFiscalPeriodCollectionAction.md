# ChronoFiscalPeriodCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoFiscalPeriodCollectionAction`.

Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.

## Declaration

```apex
global with sharing class ChronoFiscalPeriodCollectionAction
```

Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.

Types: [ChronoFiscalPeriodCollectionAction](ChronoFiscalPeriodCollectionAction.md).

## ChronoFiscalPeriodCollectionAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoFiscalCollectionResult> run(List<Request> requests)
```

Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.

Types: [ChronoFiscalCollectionResult](ChronoFiscalCollectionResult.md).

## ChronoFiscalPeriodCollectionAction.Request

| Field / property                             | Flow label       | Contract                             |
| -------------------------------------------- | ---------------- | ------------------------------------ |
| `global List<ChronoFiscalPeriodInput> items` | Input collection | Ordered requests for this interview. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
