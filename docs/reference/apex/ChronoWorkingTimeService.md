# ChronoWorkingTimeService

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoWorkingTimeService`.

Bulk working-time arithmetic over saved schedules or supplied native OperatingHours records.

Call these static entry points from subscriber Apex. Core operations return new values and validate their source. The package owns the implementation behind these signatures. See [Apex usage](../../handbook/apex.md) and [arithmetic semantics](../../handbook/arithmetic.md).

## Declaration

```apex
global with sharing class ChronoWorkingTimeService
```

Bulk working-time arithmetic over saved schedules or supplied native OperatingHours records.

Types: [ChronoWorkingTimeService](ChronoWorkingTimeService.md).

## ChronoWorkingTimeService

### add

```apex
global static List<ChronoWorkingTimeResult> add(List<ChronoWorkingTimeInput> requests)
```

Adds signed working hours or minutes. Loads saved OperatingHours in three user-mode queries per batch, plus one query when BusinessHours is requested. Supplied-record-only batches use no queries. No DML. Ordinary failures are returned per item; governor limits still apply. Null or empty lists return an empty list.

Types: [ChronoWorkingTimeInput](ChronoWorkingTimeInput.md), [ChronoWorkingTimeResult](ChronoWorkingTimeResult.md).

### check

```apex
global static List<ChronoWorkingTimeCheckResult> check(List<ChronoCheckWorkingTimeInput> requests)
```

Bulk CheckWorkingTime operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoCheckWorkingTimeInput](ChronoCheckWorkingTimeInput.md), [ChronoWorkingTimeCheckResult](ChronoWorkingTimeCheckResult.md).

### find

```apex
global static List<ChronoValueResult> find(List<ChronoFindWorkingTimeInput> requests)
```

Bulk FindWorkingTime operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoFindWorkingTimeInput](ChronoFindWorkingTimeInput.md), [ChronoValueResult](ChronoValueResult.md).

### addDays

```apex
global static List<ChronoValueResult> addDays(List<ChronoWorkingDaysInput> requests)
```

Bulk WorkingDays operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoValueResult](ChronoValueResult.md), [ChronoWorkingDaysInput](ChronoWorkingDaysInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
