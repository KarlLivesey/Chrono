# ChronoTimeAllocationRow

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoTimeAllocationRow`.

Data-only time allocation contract; services validate all supplied fields.

## Declaration

```apex
global with sharing class ChronoTimeAllocationRow
```

Data-only time allocation contract; services validate all supplied fields.

Types: [ChronoTimeAllocationRow](ChronoTimeAllocationRow.md).

## ChronoTimeAllocationRow

| Field / property                    | Flow label             | Contract                                                             |
| ----------------------------------- | ---------------------- | -------------------------------------------------------------------- |
| `global String blockKey`            | Block key              | Null identifies unallocated time in the segment collection.          |
| `global String label`               | Block label            | Readable block name.                                                 |
| `global String startValue`          | Segment start          | Zoned ISO in elapsed mode; plain ISO in clock mode. Empty on totals. |
| `global String endValue`            | Segment end            | Exclusive endpoint in the same representation as the start.          |
| `global Long matchedMilliseconds`   | Matched milliseconds   | Duration matched before splitting or rounding.                       |
| `global Long allocatedMilliseconds` | Allocated milliseconds | Credited duration after overlap handling and unit allocation.        |
| `global String allocatedDuration`   | Allocated ISO duration | ISO elapsed duration for the credited amount.                        |

### ChronoTimeAllocationRow

```apex
global ChronoTimeAllocationRow()
```

Empty transport constructor.

Types: [ChronoTimeAllocationRow](ChronoTimeAllocationRow.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
