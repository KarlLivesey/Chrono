# ChronoPlainMonthDayService

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoPlainMonthDayService`.

Stable public API for PlainMonthDay values. Internal operations own validation and calculations.

Call these static entry points from subscriber Apex. Core operations return new values and validate their source. The package owns the implementation behind these signatures. See [Apex usage](../../handbook/apex.md) and [arithmetic semantics](../../handbook/arithmetic.md).

## Declaration

```apex
global with sharing class ChronoPlainMonthDayService
```

Stable public API for PlainMonthDay values. Internal operations own validation and calculations.

Types: [ChronoPlainMonthDayService](ChronoPlainMonthDayService.md).

## ChronoPlainMonthDayService

### create

```apex
global static ChronoPlainMonthDay create(Integer month, Integer day)
```

Constructs an partial date.

Types: [ChronoPlainMonthDay](ChronoPlainMonthDay.md).

### parseIso

```apex
global static ChronoPlainMonthDay parseIso(String value)
```

Parses a partial date.

Types: [ChronoPlainMonthDay](ChronoPlainMonthDay.md).

### toIsoString

```apex
global static String toIsoString(ChronoPlainMonthDay source)
```

Serialises a partial date.

Types: [ChronoPlainMonthDay](ChronoPlainMonthDay.md).

### toPlainDate

```apex
global static ChronoPlainDate toPlainDate(ChronoPlainMonthDay source, Integer year)
```

Completes the date, rejecting invalid calendar components.

Types: [ChronoPlainDate](ChronoPlainDate.md), [ChronoPlainMonthDay](ChronoPlainMonthDay.md).

### validate

```apex
global static void validate(ChronoPlainMonthDay source)
```

Rejects incomplete or invalid data before use.

Types: [ChronoPlainMonthDay](ChronoPlainMonthDay.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
