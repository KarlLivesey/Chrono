# ChronoReplaceValueCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoReplaceValueCollectionAction`.

Replace supplied components and preserve other fields. Resolve zoned values explicitly.

## Declaration

```apex
global with sharing class ChronoReplaceValueCollectionAction
```

Replace supplied components and preserve other fields. Resolve zoned values explicitly.

Types: [ChronoReplaceValueCollectionAction](ChronoReplaceValueCollectionAction.md).

## ChronoReplaceValueCollectionAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoFlowCollectionResult> run(List<Request> requests)
```

Replace supplied components and preserve other fields. Resolve zoned values explicitly.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

## ChronoReplaceValueCollectionAction.Request

| Field / property                             | Flow label       | Contract                             |
| -------------------------------------------- | ---------------- | ------------------------------------ |
| `global List<ChronoReplaceValueInput> items` | Input collection | Ordered requests for this interview. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
