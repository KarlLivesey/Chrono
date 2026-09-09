# ChronoAvailabilityCollectionResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoAvailabilityCollectionResult`.

Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays.

## Declaration

```apex
global with sharing class ChronoAvailabilityCollectionResult
```

Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays.

Types: [ChronoAvailabilityCollectionResult](ChronoAvailabilityCollectionResult.md).

## ChronoAvailabilityCollectionResult

| Field / property                                | Flow label | Contract                                                                                                          |
| ----------------------------------------------- | ---------- | ----------------------------------------------------------------------------------------------------------------- |
| `global Boolean success`                        | Success    | Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays. |
| `global String errorMessage`                    | Error      | Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays. |
| `global List<ChronoAvailabilityResult> results` | Results    | Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays. |

### ChronoAvailabilityCollectionResult

```apex
global ChronoAvailabilityCollectionResult()
```

Required Flow constructor.

Types: [ChronoAvailabilityCollectionResult](ChronoAvailabilityCollectionResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
