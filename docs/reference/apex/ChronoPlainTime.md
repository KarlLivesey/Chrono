# ChronoPlainTime

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoPlainTime`.

Data-only value. Use ChronoPlainTimeService for construction, validation and operations.

Data-only value. Use [ChronoPlainTimeService](ChronoPlainTimeService.md) for construction and operations. An empty constructor creates uninitialised data; services validate mutable fields.

## Declaration

```apex
global with sharing class ChronoPlainTime
```

Data-only value. Use ChronoPlainTimeService for construction, validation and operations.

Types: [ChronoPlainTime](ChronoPlainTime.md).

## ChronoPlainTime

| Field / property    | Flow label | Contract                                   |
| ------------------- | ---------- | ------------------------------------------ |
| `global Time value` | —          | value component; validated by the service. |

### ChronoPlainTime

```apex
global ChronoPlainTime()
```

Creates uninitialised data for explicit field assignment.

Types: [ChronoPlainTime](ChronoPlainTime.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
