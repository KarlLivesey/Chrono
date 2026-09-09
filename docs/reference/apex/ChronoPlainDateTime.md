# ChronoPlainDateTime

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoPlainDateTime`.

Data-only value. Use ChronoPlainDateTimeService for construction, validation and operations.

Data-only value. Use [ChronoPlainDateTimeService](ChronoPlainDateTimeService.md) for construction and operations. An empty constructor creates uninitialised data; services validate mutable fields.

## Declaration

```apex
global with sharing class ChronoPlainDateTime
```

Data-only value. Use ChronoPlainDateTimeService for construction, validation and operations.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md).

## ChronoPlainDateTime

| Field / property        | Flow label | Contract                                       |
| ----------------------- | ---------- | ---------------------------------------------- |
| `global Date localDate` | —          | localDate component; validated by the service. |
| `global Time localTime` | —          | localTime component; validated by the service. |

### ChronoPlainDateTime

```apex
global ChronoPlainDateTime()
```

Creates uninitialised data for explicit field assignment.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
