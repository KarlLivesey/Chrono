# ChronoValue

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoValue`.

Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.

## Declaration

```apex
global with sharing class ChronoValue
```

Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.

Types: [ChronoValue](ChronoValue.md).

## ChronoValue

| Field / property                           | Flow label | Contract                                                  |
| ------------------------------------------ | ---------- | --------------------------------------------------------- |
| `global String valueType`                  | —          | valueType component; absent optional values are null.     |
| `global ChronoInstant instant`             | —          | instant component; absent optional values are null.       |
| `global ChronoZonedDateTime zonedDateTime` | —          | zonedDateTime component; absent optional values are null. |
| `global ChronoPlainDateTime plainDateTime` | —          | plainDateTime component; absent optional values are null. |
| `global ChronoPlainDate plainDate`         | —          | plainDate component; absent optional values are null.     |
| `global ChronoPlainTime plainTime`         | —          | plainTime component; absent optional values are null.     |
| `global ChronoPlainYearMonth yearMonth`    | —          | yearMonth component; absent optional values are null.     |
| `global ChronoPlainMonthDay monthDay`      | —          | monthDay component; absent optional values are null.      |
| `global ChronoDuration duration`           | —          | duration component; absent optional values are null.      |

### ChronoValue

```apex
global ChronoValue()
```

Creates uninitialised data.

Types: [ChronoValue](ChronoValue.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
