# ChronoDurationService

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoDurationService`.

Stable public API for Duration values. Internal operations own validation and calculations.

Call these static entry points from subscriber Apex. Core operations return new values and validate their source. The package owns the implementation behind these signatures. See [Apex usage](../../handbook/apex.md) and [arithmetic semantics](../../handbook/arithmetic.md).

## Declaration

```apex
global with sharing class ChronoDurationService
```

Stable public API for Duration values. Internal operations own validation and calculations.

Types: [ChronoDurationService](ChronoDurationService.md).

## ChronoDurationService

### create

```apex
global static ChronoDuration create(Integer months, Integer days, Long milliseconds)
```

Constructs an duration with calendar and elapsed components.

Types: [ChronoDuration](ChronoDuration.md).

### getMonths

```apex
global static Integer getMonths(ChronoDuration source)
```

Returns the months component.

Types: [ChronoDuration](ChronoDuration.md).

### getDays

```apex
global static Integer getDays(ChronoDuration source)
```

Returns the days component.

Types: [ChronoDuration](ChronoDuration.md).

### getMilliseconds

```apex
global static Long getMilliseconds(ChronoDuration source)
```

Returns the milliseconds component.

Types: [ChronoDuration](ChronoDuration.md).

### negate

```apex
global static ChronoDuration negate(ChronoDuration source)
```

Reverses the sign of every component.

Types: [ChronoDuration](ChronoDuration.md).

### toMilliseconds

```apex
global static Long toMilliseconds(ChronoDuration source)
```

Returns elapsed milliseconds; calendar units require a relative value.

Types: [ChronoDuration](ChronoDuration.md).

### ofHours

```apex
global static ChronoDuration ofHours(Integer amount)
```

Constructs an elapsed duration.

Types: [ChronoDuration](ChronoDuration.md).

### parseIso

```apex
global static ChronoDuration parseIso(String value)
```

Parses an ISO duration, preserving calendar and elapsed components.

Types: [ChronoDuration](ChronoDuration.md).

### toIsoString

```apex
global static String toIsoString(ChronoDuration source)
```

Serialises as months, days and seconds without assuming a day length.

Types: [ChronoDuration](ChronoDuration.md).

### validate

```apex
global static void validate(ChronoDuration source)
```

Rejects incomplete or invalid data before use.

Types: [ChronoDuration](ChronoDuration.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
