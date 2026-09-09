# ChronoTimeAllocationService

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoTimeAllocationService`.

Allocates worked time into named blocks. Inputs are not mutated; results are independent. No queries or DML.

Call these static entry points from subscriber Apex. Core operations return new values and validate their source. The package owns the implementation behind these signatures. See [Apex usage](../../handbook/apex.md) and [arithmetic semantics](../../handbook/arithmetic.md).

## Declaration

```apex
global with sharing class ChronoTimeAllocationService
```

Allocates worked time into named blocks. Inputs are not mutated; results are independent. No queries or DML.

Types: [ChronoTimeAllocationService](ChronoTimeAllocationService.md).

## ChronoTimeAllocationService

### allocate

```apex
global static ChronoTimeAllocationResult allocate(ChronoTimeAllocationRequest input)
```

Applies weekday/holiday, overlap, time-basis and rounding rules. Throws ChronoException for invalid input, strict overlaps or exceeded limits.

Types: [ChronoTimeAllocationRequest](ChronoTimeAllocationRequest.md), [ChronoTimeAllocationResult](ChronoTimeAllocationResult.md).

### allocateAll

```apex
global static List<ChronoTimeAllocationResult> allocateAll(List<ChronoTimeAllocationRequest> requests)
```

Allocates an ordered native request batch without queries or DML. Identical requests share work within this call. Null/empty lists return empty results. Ordinary failures are isolated per item; governor limits still apply.

Types: [ChronoTimeAllocationRequest](ChronoTimeAllocationRequest.md), [ChronoTimeAllocationResult](ChronoTimeAllocationResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
