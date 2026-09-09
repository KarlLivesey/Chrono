# ChronoPlainYearMonth

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoPlainYearMonth`.

Data-only value. Use ChronoPlainYearMonthService for construction, validation and operations.

Data-only value. Use [ChronoPlainYearMonthService](ChronoPlainYearMonthService.md) for construction and operations. An empty constructor creates uninitialised data; services validate mutable fields.

## Declaration

```apex
global with sharing class ChronoPlainYearMonth
```

Data-only value. Use ChronoPlainYearMonthService for construction, validation and operations.

Types: [ChronoPlainYearMonth](ChronoPlainYearMonth.md).

## ChronoPlainYearMonth

| Field / property       | Flow label | Contract                                   |
| ---------------------- | ---------- | ------------------------------------------ |
| `global Integer year`  | —          | Year component; validated by the service.  |
| `global Integer month` | —          | Month component; validated by the service. |

### ChronoPlainYearMonth

```apex
global ChronoPlainYearMonth()
```

Creates uninitialised data for explicit field assignment.

Types: [ChronoPlainYearMonth](ChronoPlainYearMonth.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
