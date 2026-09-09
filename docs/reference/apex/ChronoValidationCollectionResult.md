# ChronoValidationCollectionResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoValidationCollectionResult`.

Validate a native or ISO value without failing other interviews.

## Declaration

```apex
global with sharing class ChronoValidationCollectionResult
```

Validate a native or ISO value without failing other interviews.

Types: [ChronoValidationCollectionResult](ChronoValidationCollectionResult.md).

## ChronoValidationCollectionResult

| Field / property                              | Flow label | Contract                                                         |
| --------------------------------------------- | ---------- | ---------------------------------------------------------------- |
| `global Boolean success`                      | Success    | Validate a native or ISO value without failing other interviews. |
| `global String errorMessage`                  | Error      | Validate a native or ISO value without failing other interviews. |
| `global List<ChronoValidationResult> results` | Results    | Validate a native or ISO value without failing other interviews. |

### ChronoValidationCollectionResult

```apex
global ChronoValidationCollectionResult()
```

Required Flow constructor.

Types: [ChronoValidationCollectionResult](ChronoValidationCollectionResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
