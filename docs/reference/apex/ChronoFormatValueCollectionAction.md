# ChronoFormatValueCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoFormatValueCollectionAction`.

Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output.

## Declaration

```apex
global with sharing class ChronoFormatValueCollectionAction
```

Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output.

Types: [ChronoFormatValueCollectionAction](ChronoFormatValueCollectionAction.md).

## ChronoFormatValueCollectionAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoFormatCollectionResult> run(List<Request> requests)
```

Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output.

Types: [ChronoFormatCollectionResult](ChronoFormatCollectionResult.md).

## ChronoFormatValueCollectionAction.Request

| Field / property                            | Flow label       | Contract                             |
| ------------------------------------------- | ---------------- | ------------------------------------ |
| `global List<ChronoFormatValueInput> items` | Input collection | Ordered requests for this interview. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
