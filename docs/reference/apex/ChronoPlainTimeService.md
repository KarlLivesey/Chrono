# ChronoPlainTimeService

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoPlainTimeService`.

Stable public API for PlainTime values. Internal operations own validation and calculations.

Call these static entry points from subscriber Apex. Core operations return new values and validate their source. The package owns the implementation behind these signatures. See [Apex usage](../../handbook/apex.md) and [arithmetic semantics](../../handbook/arithmetic.md).

## Declaration

```apex
global with sharing class ChronoPlainTimeService
```

Stable public API for PlainTime values. Internal operations own validation and calculations.

Types: [ChronoPlainTimeService](ChronoPlainTimeService.md).

## ChronoPlainTimeService

### create

```apex
global static ChronoPlainTime create(Time value)
```

Constructs an time value.

Types: [ChronoPlainTime](ChronoPlainTime.md).

### parseIso

```apex
global static ChronoPlainTime parseIso(String value)
```

Parses an ISO representation.

Types: [ChronoPlainTime](ChronoPlainTime.md).

### toIsoString

```apex
global static String toIsoString(ChronoPlainTime source)
```

Serialises an ISO representation.

Types: [ChronoPlainTime](ChronoPlainTime.md).

### toTime

```apex
global static Time toTime(ChronoPlainTime source)
```

Returns the native Salesforce value.

Types: [ChronoPlainTime](ChronoPlainTime.md).

### addHours

```apex
global static ChronoPlainTime addHours(ChronoPlainTime source, Integer amount)
```

Adds hours and wraps at midnight.

Types: [ChronoPlainTime](ChronoPlainTime.md).

### addHours

```apex
global static ChronoPlainTime addHours(Time source, Integer amount)
```

Adds hours and wraps at midnight.

Types: [ChronoPlainTime](ChronoPlainTime.md).

### addMinutes

```apex
global static ChronoPlainTime addMinutes(ChronoPlainTime source, Integer amount)
```

Adds minutes and wraps at midnight.

Types: [ChronoPlainTime](ChronoPlainTime.md).

### addMinutes

```apex
global static ChronoPlainTime addMinutes(Time source, Integer amount)
```

Adds minutes and wraps at midnight.

Types: [ChronoPlainTime](ChronoPlainTime.md).

### addSeconds

```apex
global static ChronoPlainTime addSeconds(ChronoPlainTime source, Integer amount)
```

Adds seconds and wraps at midnight.

Types: [ChronoPlainTime](ChronoPlainTime.md).

### addSeconds

```apex
global static ChronoPlainTime addSeconds(Time source, Integer amount)
```

Adds seconds and wraps at midnight.

Types: [ChronoPlainTime](ChronoPlainTime.md).

### addMilliseconds

```apex
global static ChronoPlainTime addMilliseconds(ChronoPlainTime source, Long amount)
```

Adds milliseconds and wraps at midnight.

Types: [ChronoPlainTime](ChronoPlainTime.md).

### addMilliseconds

```apex
global static ChronoPlainTime addMilliseconds(Time source, Long amount)
```

Adds milliseconds and wraps at midnight.

Types: [ChronoPlainTime](ChronoPlainTime.md).

### toPlainDateTime

```apex
global static ChronoPlainDateTime toPlainDateTime(ChronoPlainTime source, Date localDate)
```

Combines this time with a local date.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md), [ChronoPlainTime](ChronoPlainTime.md).

### validate

```apex
global static void validate(ChronoPlainTime source)
```

Rejects incomplete or invalid data before use.

Types: [ChronoPlainTime](ChronoPlainTime.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
