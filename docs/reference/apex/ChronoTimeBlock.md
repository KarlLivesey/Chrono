# ChronoTimeBlock

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoTimeBlock`.

Data-only time allocation contract; services validate all supplied fields.

## Declaration

```apex
global with sharing class ChronoTimeBlock
```

Data-only time allocation contract; services validate all supplied fields.

Types: [ChronoTimeBlock](ChronoTimeBlock.md).

## ChronoTimeBlock

| Field / property          | Flow label | Contract                                                                          |
| ------------------------- | ---------- | --------------------------------------------------------------------------------- |
| `global String key`       | —          | Unique stable identifier; input order defines priority.                           |
| `global String label`     | —          | Readable block name.                                                              |
| `global String weekdays`  | —          | Comma-separated ISO weekdays 1 Monday through 7 Sunday; empty means all weekdays. |
| `global String dayType`   | —          | regular or holiday; default regular. Holidays replace normal time.                |
| `global String startTime` | —          | ISO local time; inclusive.                                                        |
| `global String endTime`   | —          | Exclusive ISO local time; 24:00 is allowed. An earlier end crosses midnight.      |

### ChronoTimeBlock

```apex
global ChronoTimeBlock()
```

Empty transport constructor.

Types: [ChronoTimeBlock](ChronoTimeBlock.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
