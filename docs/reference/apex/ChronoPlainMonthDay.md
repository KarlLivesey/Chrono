# ChronoPlainMonthDay

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoPlainMonthDay`.

Data-only value. Use ChronoPlainMonthDayService for construction, validation and operations.

Data-only value. Use [ChronoPlainMonthDayService](ChronoPlainMonthDayService.md) for construction and operations. An empty constructor creates uninitialised data; services validate mutable fields.

## Declaration

```apex
global with sharing class ChronoPlainMonthDay
```

Data-only value. Use ChronoPlainMonthDayService for construction, validation and operations.

Types: [ChronoPlainMonthDay](ChronoPlainMonthDay.md).

## ChronoPlainMonthDay

| Field / property       | Flow label | Contract                                   |
| ---------------------- | ---------- | ------------------------------------------ |
| `global Integer month` | —          | Month component; validated by the service. |
| `global Integer day`   | —          | Day component; validated by the service.   |

### ChronoPlainMonthDay

```apex
global ChronoPlainMonthDay()
```

Creates uninitialised data for explicit field assignment.

Types: [ChronoPlainMonthDay](ChronoPlainMonthDay.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
