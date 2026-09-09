# ChronoValidateValueCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoValidateValueCollectionAction`.

Validate a native or ISO value without failing other interviews.

## Declaration

```apex
global with sharing class ChronoValidateValueCollectionAction
```

Validate a native or ISO value without failing other interviews.

Types: [ChronoValidateValueCollectionAction](ChronoValidateValueCollectionAction.md).

## ChronoValidateValueCollectionAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoValidationCollectionResult> run(List<Request> requests)
```

Validate a native or ISO value without failing other interviews.

Types: [ChronoValidationCollectionResult](ChronoValidationCollectionResult.md).

## ChronoValidateValueCollectionAction.Request

| Field / property                              | Flow label       | Contract                             |
| --------------------------------------------- | ---------------- | ------------------------------------ |
| `global List<ChronoValidateValueInput> items` | Input collection | Ordered requests for this interview. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
