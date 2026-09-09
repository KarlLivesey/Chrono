# ChronoRecurrenceCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoRecurrenceCollectionAction`.

Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.

## Declaration

```apex
global with sharing class ChronoRecurrenceCollectionAction
```

Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.

Types: [ChronoRecurrenceCollectionAction](ChronoRecurrenceCollectionAction.md).

## ChronoRecurrenceCollectionAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoRecurrenceCollectionResult> run(List<Request> requests)
```

Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.

Types: [ChronoRecurrenceCollectionResult](ChronoRecurrenceCollectionResult.md).

## ChronoRecurrenceCollectionAction.Request

| Field / property                           | Flow label       | Contract                             |
| ------------------------------------------ | ---------------- | ------------------------------------ |
| `global List<ChronoRecurrenceInput> items` | Input collection | Ordered requests for this interview. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
