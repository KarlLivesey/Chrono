# ChronoInstant

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoInstant`.

Data-only value. Use ChronoInstantService for construction, validation and operations.

Data-only value. Use [ChronoInstantService](ChronoInstantService.md) for construction and operations. An empty constructor creates uninitialised data; services validate mutable fields.

## Declaration

```apex
global with sharing class ChronoInstant
```

Data-only value. Use ChronoInstantService for construction, validation and operations.

Types: [ChronoInstant](ChronoInstant.md).

## ChronoInstant

| Field / property        | Flow label | Contract                                   |
| ----------------------- | ---------- | ------------------------------------------ |
| `global Datetime value` | —          | value component; validated by the service. |

### ChronoInstant

```apex
global ChronoInstant()
```

Creates uninitialised data for explicit field assignment.

Types: [ChronoInstant](ChronoInstant.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
