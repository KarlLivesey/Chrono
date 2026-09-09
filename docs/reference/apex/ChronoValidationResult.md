# ChronoValidationResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoValidationResult`.

Flat Flow result for validation operations.

## Declaration

```apex
global with sharing class ChronoValidationResult
```

Flat Flow result for validation operations.

Types: [ChronoValidationResult](ChronoValidationResult.md).

## ChronoValidationResult

| Field / property                  | Flow label           | Contract            |
| --------------------------------- | -------------------- | ------------------- |
| `global Boolean success`          | Success              | Success.            |
| `global String errorMessage`      | Error                | Error.              |
| `global Boolean isValid`          | Is valid             | Is valid.           |
| `global String valueType`         | Value type           | Value type.         |
| `global String value`             | Normalised ISO value | Value type.         |
| `global String validationMessage` | Validation message   | Validation message. |

### ChronoValidationResult

```apex
global ChronoValidationResult()
```

Required Flow constructor.

Types: [ChronoValidationResult](ChronoValidationResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
