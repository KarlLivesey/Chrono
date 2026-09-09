# ChronoTimeAllocationRequest

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoTimeAllocationRequest`.

Native Apex allocation request. Defaults: strict overlaps, elapsed time, millisecond allocation.

## Declaration

```apex
global with sharing class ChronoTimeAllocationRequest
```

Native Apex allocation request. Defaults: strict overlaps, elapsed time, millisecond allocation.

Types: [ChronoTimeAllocationRequest](ChronoTimeAllocationRequest.md).

## ChronoTimeAllocationRequest

| Field / property                      | Flow label | Contract                                                                                         |
| ------------------------------------- | ---------- | ------------------------------------------------------------------------------------------------ |
| `global Datetime startInstant`        | —          | Native Apex allocation request. Defaults: strict overlaps, elapsed time, millisecond allocation. |
| `global Datetime endInstant`          | —          | Native Apex allocation request. Defaults: strict overlaps, elapsed time, millisecond allocation. |
| `global String timeZoneId`            | —          | Native Apex allocation request. Defaults: strict overlaps, elapsed time, millisecond allocation. |
| `global List<ChronoTimeBlock> blocks` | —          | Native Apex allocation request. Defaults: strict overlaps, elapsed time, millisecond allocation. |
| `global List<Holiday> holidays`       | —          | Native Apex allocation request. Defaults: strict overlaps, elapsed time, millisecond allocation. |
| `global String overlapMode`           | —          | Native Apex allocation request. Defaults: strict overlaps, elapsed time, millisecond allocation. |
| `global String timeBasis`             | —          | Native Apex allocation request. Defaults: strict overlaps, elapsed time, millisecond allocation. |
| `global String allocationUnit`        | —          | Native Apex allocation request. Defaults: strict overlaps, elapsed time, millisecond allocation. |
| `global Integer maximumSegments`      | —          | Native Apex allocation request. Defaults: strict overlaps, elapsed time, millisecond allocation. |

### ChronoTimeAllocationRequest

```apex
global ChronoTimeAllocationRequest()
```

Empty data constructor.

Types: [ChronoTimeAllocationRequest](ChronoTimeAllocationRequest.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
