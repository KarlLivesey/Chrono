# ChronoRecurrenceCollectionResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoRecurrenceCollectionResult`.

Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.

## Declaration

```apex
global with sharing class ChronoRecurrenceCollectionResult
```

Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.

Types: [ChronoRecurrenceCollectionResult](ChronoRecurrenceCollectionResult.md).

## ChronoRecurrenceCollectionResult

| Field / property                              | Flow label | Contract                                                                                                     |
| --------------------------------------------- | ---------- | ------------------------------------------------------------------------------------------------------------ |
| `global Boolean success`                      | Success    | Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments. |
| `global String errorMessage`                  | Error      | Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments. |
| `global List<ChronoRecurrenceResult> results` | Results    | Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments. |

### ChronoRecurrenceCollectionResult

```apex
global ChronoRecurrenceCollectionResult()
```

Required Flow constructor.

Types: [ChronoRecurrenceCollectionResult](ChronoRecurrenceCollectionResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
