# ChronoDurationToolsCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoDurationToolsCollectionAction`.

Construct, inspect, total, balance or scale durations with explicit calendar context.

## Declaration

```apex
global with sharing class ChronoDurationToolsCollectionAction
```

Construct, inspect, total, balance or scale durations with explicit calendar context.

Types: [ChronoDurationToolsCollectionAction](ChronoDurationToolsCollectionAction.md).

## ChronoDurationToolsCollectionAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoDurationCollectionResult> run(List<Request> requests)
```

Construct, inspect, total, balance or scale durations with explicit calendar context.

Types: [ChronoDurationCollectionResult](ChronoDurationCollectionResult.md).

## ChronoDurationToolsCollectionAction.Request

| Field / property                              | Flow label       | Contract                             |
| --------------------------------------------- | ---------------- | ------------------------------------ |
| `global List<ChronoDurationToolsInput> items` | Input collection | Ordered requests for this interview. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
