# ChronoCalculationService

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoCalculationService`.

Direct bulk Apex API. Flow adapters use these same services.

Call these static entry points from subscriber Apex. Core operations return new values and validate their source. The package owns the implementation behind these signatures. See [Apex usage](../../handbook/apex.md) and [arithmetic semantics](../../handbook/arithmetic.md).

## Declaration

```apex
global with sharing class ChronoCalculationService
```

Direct bulk Apex API. Flow adapters use these same services.

Types: [ChronoCalculationService](ChronoCalculationService.md).

## ChronoCalculationService

### adjust

```apex
global static List<ChronoValueResult> adjust(List<ChronoAdjustInput> requests)
```

Bulk Adjust operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoAdjustInput](ChronoAdjustInput.md), [ChronoValueResult](ChronoValueResult.md).

### difference

```apex
global static List<ChronoDurationCalculationResult> difference(List<ChronoDifferenceInput> requests)
```

Bulk Difference operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoDifferenceInput](ChronoDifferenceInput.md), [ChronoDurationCalculationResult](ChronoDurationCalculationResult.md).

### calendarDifference

```apex
global static List<ChronoDurationCalculationResult> calendarDifference(List<ChronoCalendarDifferenceInput> requests)
```

Bulk CalendarDifference operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoCalendarDifferenceInput](ChronoCalendarDifferenceInput.md), [ChronoDurationCalculationResult](ChronoDurationCalculationResult.md).

### compare

```apex
global static List<ChronoComparisonResult> compare(List<ChronoCompareInput> requests)
```

Bulk Compare operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoCompareInput](ChronoCompareInput.md), [ChronoComparisonResult](ChronoComparisonResult.md).

### boundary

```apex
global static List<ChronoValueResult> boundary(List<ChronoPeriodBoundaryInput> requests)
```

Bulk PeriodBoundary operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoPeriodBoundaryInput](ChronoPeriodBoundaryInput.md), [ChronoValueResult](ChronoValueResult.md).

### round

```apex
global static List<ChronoValueResult> round(List<ChronoRoundInput> requests)
```

Bulk Round operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoRoundInput](ChronoRoundInput.md), [ChronoValueResult](ChronoValueResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
