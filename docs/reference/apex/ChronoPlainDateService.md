# ChronoPlainDateService

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoPlainDateService`.

Stable public API for PlainDate values. Internal operations own validation and calculations.

Call these static entry points from subscriber Apex. Core operations return new values and validate their source. The package owns the implementation behind these signatures. See [Apex usage](../../handbook/apex.md) and [arithmetic semantics](../../handbook/arithmetic.md).

## Declaration

```apex
global with sharing class ChronoPlainDateService
```

Stable public API for PlainDate values. Internal operations own validation and calculations.

Types: [ChronoPlainDateService](ChronoPlainDateService.md).

## ChronoPlainDateService

### create

```apex
global static ChronoPlainDate create(Date value)
```

Constructs an date value.

Types: [ChronoPlainDate](ChronoPlainDate.md).

### parseIso

```apex
global static ChronoPlainDate parseIso(String value)
```

Parses an ISO representation.

Types: [ChronoPlainDate](ChronoPlainDate.md).

### toIsoString

```apex
global static String toIsoString(ChronoPlainDate source)
```

Serialises an ISO representation.

Types: [ChronoPlainDate](ChronoPlainDate.md).

### toDate

```apex
global static Date toDate(ChronoPlainDate source)
```

Returns the native Salesforce value.

Types: [ChronoPlainDate](ChronoPlainDate.md).

### addDays

```apex
global static ChronoPlainDate addDays(ChronoPlainDate source, Integer amount)
```

Adds calendar days using native date arithmetic.

Types: [ChronoPlainDate](ChronoPlainDate.md).

### addDays

```apex
global static ChronoPlainDate addDays(Date source, Integer amount)
```

Adds calendar days using native date arithmetic.

Types: [ChronoPlainDate](ChronoPlainDate.md).

### addMonths

```apex
global static ChronoPlainDate addMonths(ChronoPlainDate source, Integer amount)
```

Adds calendar months using native date arithmetic.

Types: [ChronoPlainDate](ChronoPlainDate.md).

### addMonths

```apex
global static ChronoPlainDate addMonths(Date source, Integer amount)
```

Adds calendar months using native date arithmetic.

Types: [ChronoPlainDate](ChronoPlainDate.md).

### addYears

```apex
global static ChronoPlainDate addYears(ChronoPlainDate source, Integer amount)
```

Adds calendar years using native date arithmetic.

Types: [ChronoPlainDate](ChronoPlainDate.md).

### addYears

```apex
global static ChronoPlainDate addYears(Date source, Integer amount)
```

Adds calendar years using native date arithmetic.

Types: [ChronoPlainDate](ChronoPlainDate.md).

### toPlainDateTime

```apex
global static ChronoPlainDateTime toPlainDateTime(ChronoPlainDate source, Time localTime)
```

Combines the date with a local time.

Types: [ChronoPlainDate](ChronoPlainDate.md), [ChronoPlainDateTime](ChronoPlainDateTime.md).

### toPlainYearMonth

```apex
global static ChronoPlainYearMonth toPlainYearMonth(ChronoPlainDate source)
```

Extracts the year and month.

Types: [ChronoPlainDate](ChronoPlainDate.md), [ChronoPlainYearMonth](ChronoPlainYearMonth.md).

### toPlainMonthDay

```apex
global static ChronoPlainMonthDay toPlainMonthDay(ChronoPlainDate source)
```

Extracts the month and day.

Types: [ChronoPlainDate](ChronoPlainDate.md), [ChronoPlainMonthDay](ChronoPlainMonthDay.md).

### validate

```apex
global static void validate(ChronoPlainDate source)
```

Rejects incomplete or invalid data before use.

Types: [ChronoPlainDate](ChronoPlainDate.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
