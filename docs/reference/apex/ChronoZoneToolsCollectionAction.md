# ChronoZoneToolsCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoZoneToolsCollectionAction`.

Convert zones, inspect date-specific offsets and search bounded timezone transitions.

## Declaration

```apex
global with sharing class ChronoZoneToolsCollectionAction
```

Convert zones, inspect date-specific offsets and search bounded timezone transitions.

Types: [ChronoZoneToolsCollectionAction](ChronoZoneToolsCollectionAction.md).

## ChronoZoneToolsCollectionAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoZoneCollectionResult> run(List<Request> requests)
```

Convert zones, inspect date-specific offsets and search bounded timezone transitions.

Types: [ChronoZoneCollectionResult](ChronoZoneCollectionResult.md).

## ChronoZoneToolsCollectionAction.Request

| Field / property                          | Flow label       | Contract                             |
| ----------------------------------------- | ---------------- | ------------------------------------ |
| `global List<ChronoZoneToolsInput> items` | Input collection | Ordered requests for this interview. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
