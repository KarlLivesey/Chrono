# ChronoPlainDate

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoPlainDate`.

Data-only value. Use ChronoPlainDateService for construction, validation and operations.

Data-only value. Use [ChronoPlainDateService](ChronoPlainDateService.md) for construction and operations. An empty constructor creates uninitialised data; services validate mutable fields.

## Declaration

```apex
global with sharing class ChronoPlainDate
```

Data-only value. Use ChronoPlainDateService for construction, validation and operations.

Types: [ChronoPlainDate](ChronoPlainDate.md).

## ChronoPlainDate

| Field / property    | Flow label | Contract                                   |
| ------------------- | ---------- | ------------------------------------------ |
| `global Date value` | —          | value component; validated by the service. |

### ChronoPlainDate

```apex
global ChronoPlainDate()
```

Creates uninitialised data for explicit field assignment.

Types: [ChronoPlainDate](ChronoPlainDate.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
