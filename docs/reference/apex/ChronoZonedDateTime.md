# ChronoZonedDateTime

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoZonedDateTime`.

Data-only value. Use ChronoZonedDateTimeService for construction, validation and operations.

Data-only value. Use [ChronoZonedDateTimeService](ChronoZonedDateTimeService.md) for construction and operations. An empty constructor creates uninitialised data; services validate mutable fields.

## Declaration

```apex
global with sharing class ChronoZonedDateTime
```

Data-only value. Use ChronoZonedDateTimeService for construction, validation and operations.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

## ChronoZonedDateTime

| Field / property           | Flow label | Contract                                        |
| -------------------------- | ---------- | ----------------------------------------------- |
| `global Datetime instant`  | —          | instant component; validated by the service.    |
| `global String timeZoneId` | —          | timeZoneId component; validated by the service. |

### ChronoZonedDateTime

```apex
global ChronoZonedDateTime()
```

Creates uninitialised data for explicit field assignment.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
