# ChronoPlainYearMonthService

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoPlainYearMonthService`.

Stable public API for PlainYearMonth values. Internal operations own validation and calculations.

Call these static entry points from subscriber Apex. Core operations return new values and validate their source. The package owns the implementation behind these signatures. See [Apex usage](../../handbook/apex.md) and [arithmetic semantics](../../handbook/arithmetic.md).

## Declaration

```apex
global with sharing class ChronoPlainYearMonthService
```

Stable public API for PlainYearMonth values. Internal operations own validation and calculations.

Types: [ChronoPlainYearMonthService](ChronoPlainYearMonthService.md).

## ChronoPlainYearMonthService

### create

```apex
global static ChronoPlainYearMonth create(Integer year, Integer month)
```

Constructs an partial date.

Types: [ChronoPlainYearMonth](ChronoPlainYearMonth.md).

### parseIso

```apex
global static ChronoPlainYearMonth parseIso(String value)
```

Parses a partial date.

Types: [ChronoPlainYearMonth](ChronoPlainYearMonth.md).

### toIsoString

```apex
global static String toIsoString(ChronoPlainYearMonth source)
```

Serialises a partial date.

Types: [ChronoPlainYearMonth](ChronoPlainYearMonth.md).

### toPlainDate

```apex
global static ChronoPlainDate toPlainDate(ChronoPlainYearMonth source, Integer day)
```

Completes the date, rejecting invalid calendar components.

Types: [ChronoPlainDate](ChronoPlainDate.md), [ChronoPlainYearMonth](ChronoPlainYearMonth.md).

### addMonths

```apex
global static ChronoPlainYearMonth addMonths(ChronoPlainYearMonth source, Integer amount)
```

Adds calendar months.

Types: [ChronoPlainYearMonth](ChronoPlainYearMonth.md).

### validate

```apex
global static void validate(ChronoPlainYearMonth source)
```

Rejects incomplete or invalid data before use.

Types: [ChronoPlainYearMonth](ChronoPlainYearMonth.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
