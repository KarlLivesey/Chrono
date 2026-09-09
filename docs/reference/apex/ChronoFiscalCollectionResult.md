# ChronoFiscalCollectionResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoFiscalCollectionResult`.

Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.

## Declaration

```apex
global with sharing class ChronoFiscalCollectionResult
```

Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.

Types: [ChronoFiscalCollectionResult](ChronoFiscalCollectionResult.md).

## ChronoFiscalCollectionResult

| Field / property                          | Flow label | Contract                                                                             |
| ----------------------------------------- | ---------- | ------------------------------------------------------------------------------------ |
| `global Boolean success`                  | Success    | Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries. |
| `global String errorMessage`              | Error      | Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries. |
| `global List<ChronoFiscalResult> results` | Results    | Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries. |

### ChronoFiscalCollectionResult

```apex
global ChronoFiscalCollectionResult()
```

Required Flow constructor.

Types: [ChronoFiscalCollectionResult](ChronoFiscalCollectionResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
