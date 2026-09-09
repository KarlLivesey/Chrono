# ChronoValueResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoValueResult`.

Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.

## Declaration

```apex
global with sharing class ChronoValueResult
```

Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.

Types: [ChronoValueResult](ChronoValueResult.md).

## ChronoValueResult

| Field / property             | Flow label | Contract                                                 |
| ---------------------------- | ---------- | -------------------------------------------------------- |
| `global Boolean success`     | —          | success component; absent optional values are null.      |
| `global String errorMessage` | —          | errorMessage component; absent optional values are null. |
| `global ChronoValue value`   | —          | value component; absent optional values are null.        |
| `global Boolean isOpen`      | —          | isOpen component; absent optional values are null.       |

### ChronoValueResult

```apex
global ChronoValueResult()
```

Creates uninitialised data.

Types: [ChronoValueResult](ChronoValueResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
