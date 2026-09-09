# ChronoAvailabilityCollectionAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoAvailabilityCollectionAction`.

Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays.

## Declaration

```apex
global with sharing class ChronoAvailabilityCollectionAction
```

Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays.

Types: [ChronoAvailabilityCollectionAction](ChronoAvailabilityCollectionAction.md).

## ChronoAvailabilityCollectionAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoAvailabilityCollectionResult> run(List<Request> requests)
```

Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays.

Types: [ChronoAvailabilityCollectionResult](ChronoAvailabilityCollectionResult.md).

## ChronoAvailabilityCollectionAction.Request

| Field / property                             | Flow label       | Contract                             |
| -------------------------------------------- | ---------------- | ------------------------------------ |
| `global List<ChronoAvailabilityInput> items` | Input collection | Ordered requests for this interview. |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
