# ChronoTimeAllocationResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoTimeAllocationResult`.

Data-only time allocation contract; services validate all supplied fields.

## Declaration

```apex
global with sharing class ChronoTimeAllocationResult
```

Data-only time allocation contract; services validate all supplied fields.

Types: [ChronoTimeAllocationResult](ChronoTimeAllocationResult.md).

## ChronoTimeAllocationResult

| Field / property                                | Flow label                      | Contract                                                                                                 |
| ----------------------------------------------- | ------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `global Boolean success`                        | Success                         | Whether allocation completed.                                                                            |
| `global String errorMessage`                    | Error                           | Failure message; failed requests return no partial allocation.                                           |
| `global String timeZoneId`                      | Block timezone                  | Timezone used for block clocks and holiday dates.                                                        |
| `global String timeBasis`                       | Time basis                      | elapsed or clock.                                                                                        |
| `global String overlapMode`                     | Overlap mode                    | strict, lax, duplicate or split.                                                                         |
| `global String allocationUnit`                  | Allocation unit                 | millisecond, second or minute.                                                                           |
| `global Long inputMilliseconds`                 | Input milliseconds              | Worked duration in the selected time basis.                                                              |
| `global Long allocatedMilliseconds`             | Allocated milliseconds          | Sum of credited block totals; duplicate mode can exceed worked duration.                                 |
| `global Long unallocatedMilliseconds`           | Unallocated milliseconds        | Worked time matching no eligible block.                                                                  |
| `global Long duplicateMilliseconds`             | Duplicated milliseconds         | Extra credited budget caused by duplicate mode before rounding.                                          |
| `global Long roundingMilliseconds`              | Rounding remainder milliseconds | Sub-unit remainder not credited; input plus duplicates equals allocated plus unallocated plus remainder. |
| `global List<ChronoTimeAllocationRow> totals`   | Block totals                    | One independent result per block, preserving priority order, including zero totals.                      |
| `global List<ChronoTimeAllocationRow> segments` | Contributing segments           | Ordered matched or unallocated segments; overlaps produce one row per credited block.                    |

### ChronoTimeAllocationResult

```apex
global ChronoTimeAllocationResult()
```

Empty transport constructor.

Types: [ChronoTimeAllocationResult](ChronoTimeAllocationResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
