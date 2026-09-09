# ChronoCreateValueCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoCreateValueCollectionAction`.

Construct a validated value from individual calendar and clock components.

## Declaration

```apex
global with sharing class ChronoCreateValueCollectionAction
```

Construct a validated value from individual calendar and clock components.

Types: [ChronoCreateValueCollectionAction](ChronoCreateValueCollectionAction.md).

## ChronoCreateValueCollectionAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoFlowCollectionResult> run(List<Request> requests)
```

Construct a validated value from individual calendar and clock components.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

## ChronoCreateValueCollectionAction.Request

| Field / property                            | Flow label       | Contract                             |
| ------------------------------------------- | ---------------- | ------------------------------------ |
| `global List<ChronoCreateValueInput> items` | Input collection | Ordered requests for this interview. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
