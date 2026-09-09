# ChronoWorkingDaysCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoWorkingDaysCollectionAction`.

Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays.

## Declaration

```apex
global with sharing class ChronoWorkingDaysCollectionAction
```

Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays.

Types: [ChronoWorkingDaysCollectionAction](ChronoWorkingDaysCollectionAction.md).

## ChronoWorkingDaysCollectionAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoFlowCollectionResult> run(List<Request> requests)
```

Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays.

Types: [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md).

## ChronoWorkingDaysCollectionAction.Request

| Field / property                            | Flow label       | Contract                             |
| ------------------------------------------- | ---------------- | ------------------------------------ |
| `global List<ChronoWorkingDaysInput> items` | Input collection | Ordered requests for this interview. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
