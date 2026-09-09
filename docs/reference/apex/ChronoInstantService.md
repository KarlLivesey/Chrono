# ChronoInstantService

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoInstantService`.

Stable public API for Instant values. Internal operations own validation and calculations.

Call these static entry points from subscriber Apex. Core operations return new values and validate their source. The package owns the implementation behind these signatures. See [Apex usage](../../handbook/apex.md) and [arithmetic semantics](../../handbook/arithmetic.md).

## Declaration

```apex
global with sharing class ChronoInstantService
```

Stable public API for Instant values. Internal operations own validation and calculations.

Types: [ChronoInstantService](ChronoInstantService.md).

## ChronoInstantService

### create

```apex
global static ChronoInstant create(Datetime value)
```

Constructs an datetime value.

Types: [ChronoInstant](ChronoInstant.md).

### parseIso

```apex
global static ChronoInstant parseIso(String value)
```

Parses an ISO representation.

Types: [ChronoInstant](ChronoInstant.md).

### toIsoString

```apex
global static String toIsoString(ChronoInstant source)
```

Serialises an ISO representation.

Types: [ChronoInstant](ChronoInstant.md).

### toDatetime

```apex
global static Datetime toDatetime(ChronoInstant source)
```

Returns the native Salesforce value.

Types: [ChronoInstant](ChronoInstant.md).

### addHours

```apex
global static ChronoInstant addHours(ChronoInstant source, Integer amount)
```

Adds elapsed hours.

Types: [ChronoInstant](ChronoInstant.md).

### addHours

```apex
global static ChronoInstant addHours(Datetime source, Integer amount)
```

Adds elapsed hours.

Types: [ChronoInstant](ChronoInstant.md).

### addMinutes

```apex
global static ChronoInstant addMinutes(ChronoInstant source, Integer amount)
```

Adds elapsed minutes.

Types: [ChronoInstant](ChronoInstant.md).

### addMinutes

```apex
global static ChronoInstant addMinutes(Datetime source, Integer amount)
```

Adds elapsed minutes.

Types: [ChronoInstant](ChronoInstant.md).

### addSeconds

```apex
global static ChronoInstant addSeconds(ChronoInstant source, Integer amount)
```

Adds elapsed seconds.

Types: [ChronoInstant](ChronoInstant.md).

### addSeconds

```apex
global static ChronoInstant addSeconds(Datetime source, Integer amount)
```

Adds elapsed seconds.

Types: [ChronoInstant](ChronoInstant.md).

### addMilliseconds

```apex
global static ChronoInstant addMilliseconds(ChronoInstant source, Long amount)
```

Adds elapsed milliseconds.

Types: [ChronoInstant](ChronoInstant.md).

### addMilliseconds

```apex
global static ChronoInstant addMilliseconds(Datetime source, Long amount)
```

Adds elapsed milliseconds.

Types: [ChronoInstant](ChronoInstant.md).

### toZonedDateTime

```apex
global static ChronoZonedDateTime toZonedDateTime(ChronoInstant source, String zoneId)
```

Views this instant in a time zone.

Types: [ChronoInstant](ChronoInstant.md), [ChronoZonedDateTime](ChronoZonedDateTime.md).

### toZonedDateTime

```apex
global static ChronoZonedDateTime toZonedDateTime(Datetime source, String zoneId)
```

Views this instant in a time zone.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### elapsedDifference

```apex
global static ChronoDuration elapsedDifference(ChronoInstant source, ChronoInstant other)
```

Returns the elapsed difference to another instant.

Types: [ChronoDuration](ChronoDuration.md), [ChronoInstant](ChronoInstant.md).

### validate

```apex
global static void validate(ChronoInstant source)
```

Rejects incomplete or invalid data before use.

Types: [ChronoInstant](ChronoInstant.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
