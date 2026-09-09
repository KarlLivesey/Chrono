# ChronoPlainDateTimeService

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoPlainDateTimeService`.

Stable public API for PlainDateTime values. Internal operations own validation and calculations.

Call these static entry points from subscriber Apex. Core operations return new values and validate their source. The package owns the implementation behind these signatures. See [Apex usage](../../handbook/apex.md) and [arithmetic semantics](../../handbook/arithmetic.md).

## Declaration

```apex
global with sharing class ChronoPlainDateTimeService
```

Stable public API for PlainDateTime values. Internal operations own validation and calculations.

Types: [ChronoPlainDateTimeService](ChronoPlainDateTimeService.md).

## ChronoPlainDateTimeService

### create

```apex
global static ChronoPlainDateTime create(Date localDate, Time localTime)
```

Constructs a zone-free date and time.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md).

### parseIso

```apex
global static ChronoPlainDateTime parseIso(String value)
```

Parses a zone-free local datetime.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md).

### toIsoString

```apex
global static String toIsoString(ChronoPlainDateTime source)
```

Serialises the local date and time.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md).

### toDate

```apex
global static Date toDate(ChronoPlainDateTime source)
```

Returns the local component.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md).

### toTime

```apex
global static Time toTime(ChronoPlainDateTime source)
```

Returns the local component.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md).

### toPlainDate

```apex
global static ChronoPlainDate toPlainDate(ChronoPlainDateTime source)
```

Returns the local component.

Types: [ChronoPlainDate](ChronoPlainDate.md), [ChronoPlainDateTime](ChronoPlainDateTime.md).

### toPlainTime

```apex
global static ChronoPlainTime toPlainTime(ChronoPlainDateTime source)
```

Returns the local component.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md), [ChronoPlainTime](ChronoPlainTime.md).

### addDays

```apex
global static ChronoPlainDateTime addDays(ChronoPlainDateTime source, Integer amount)
```

Adds calendar days.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md).

### addMonths

```apex
global static ChronoPlainDateTime addMonths(ChronoPlainDateTime source, Integer amount)
```

Adds calendar months.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md).

### addYears

```apex
global static ChronoPlainDateTime addYears(ChronoPlainDateTime source, Integer amount)
```

Adds calendar years.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md).

### addHours

```apex
global static ChronoPlainDateTime addHours(ChronoPlainDateTime source, Integer amount)
```

Adds wall-clock hours.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md).

### addMinutes

```apex
global static ChronoPlainDateTime addMinutes(ChronoPlainDateTime source, Integer amount)
```

Adds wall-clock minutes.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md).

### addMilliseconds

```apex
global static ChronoPlainDateTime addMilliseconds(ChronoPlainDateTime source, Long amount)
```

Adds wall-clock milliseconds, carrying across midnight.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md).

### toZonedDateTime

```apex
global static ChronoZonedDateTime toZonedDateTime(ChronoPlainDateTime source, String zoneId)
```

Resolves the local datetime; rejects skipped or repeated times.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md), [ChronoZonedDateTime](ChronoZonedDateTime.md).

### toZonedDateTime

```apex
global static ChronoZonedDateTime toZonedDateTime(ChronoPlainDateTime source, String zoneId, String disambiguation)
```

Resolves local time in the supplied zone; nonexistent times always reject.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md), [ChronoZonedDateTime](ChronoZonedDateTime.md).

### add

```apex
global static ChronoPlainDateTime add(ChronoPlainDateTime source, ChronoDuration duration)
```

Adds months, then days, then wall-clock milliseconds.

Types: [ChronoDuration](ChronoDuration.md), [ChronoPlainDateTime](ChronoPlainDateTime.md).

### validate

```apex
global static void validate(ChronoPlainDateTime source)
```

Rejects incomplete or invalid data before use.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
