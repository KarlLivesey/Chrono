# ChronoDuration

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoDuration`.

Data-only value. Use ChronoDurationService for construction, validation and operations.

Data-only value. Use [ChronoDurationService](ChronoDurationService.md) for construction and operations. An empty constructor creates uninitialised data; services validate mutable fields.

## Declaration

```apex
global with sharing class ChronoDuration
```

Data-only value. Use ChronoDurationService for construction, validation and operations.

Types: [ChronoDuration](ChronoDuration.md).

## ChronoDuration

| Field / property           | Flow label | Contract                                          |
| -------------------------- | ---------- | ------------------------------------------------- |
| `global Integer months`    | —          | months component; validated by the service.       |
| `global Integer days`      | —          | days component; validated by the service.         |
| `global Long milliseconds` | —          | milliseconds component; validated by the service. |

### ChronoDuration

```apex
global ChronoDuration()
```

Creates uninitialised data for explicit field assignment.

Types: [ChronoDuration](ChronoDuration.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
