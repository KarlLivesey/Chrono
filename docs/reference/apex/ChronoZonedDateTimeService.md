# ChronoZonedDateTimeService

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoZonedDateTimeService`.

Stable public API for ZonedDateTime values. Internal operations own validation and calculations.

Call these static entry points from subscriber Apex. Core operations return new values and validate their source. The package owns the implementation behind these signatures. See [Apex usage](../../handbook/apex.md) and [arithmetic semantics](../../handbook/arithmetic.md).

## Declaration

```apex
global with sharing class ChronoZonedDateTimeService
```

Stable public API for ZonedDateTime values. Internal operations own validation and calculations.

Types: [ChronoZonedDateTimeService](ChronoZonedDateTimeService.md).

## ChronoZonedDateTimeService

### create

```apex
global static ChronoZonedDateTime create(Datetime instant, String zoneId)
```

Constructs an instant with a named time zone.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### toDatetime

```apex
global static Datetime toDatetime(ChronoZonedDateTime source)
```

Returns the corresponding native value or Chrono representation.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### getTimeZoneId

```apex
global static String getTimeZoneId(ChronoZonedDateTime source)
```

Returns the corresponding native value or Chrono representation.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### toInstant

```apex
global static ChronoInstant toInstant(ChronoZonedDateTime source)
```

Returns the corresponding native value or Chrono representation.

Types: [ChronoInstant](ChronoInstant.md), [ChronoZonedDateTime](ChronoZonedDateTime.md).

### toPlainDateTime

```apex
global static ChronoPlainDateTime toPlainDateTime(ChronoZonedDateTime source)
```

Returns the corresponding native value or Chrono representation.

Types: [ChronoPlainDateTime](ChronoPlainDateTime.md), [ChronoZonedDateTime](ChronoZonedDateTime.md).

### toDate

```apex
global static Date toDate(ChronoZonedDateTime source)
```

Returns the corresponding native value or Chrono representation.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### toTime

```apex
global static Time toTime(ChronoZonedDateTime source)
```

Returns the corresponding native value or Chrono representation.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### withTimeZone

```apex
global static ChronoZonedDateTime withTimeZone(ChronoZonedDateTime source, String targetZoneId)
```

Views the same instant in another zone.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addHours

```apex
global static ChronoZonedDateTime addHours(ChronoZonedDateTime source, Integer amount)
```

Adds elapsed hours.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addHours

```apex
global static ChronoZonedDateTime addHours(Datetime source, String zoneId, Integer amount)
```

Adds elapsed hours.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addMinutes

```apex
global static ChronoZonedDateTime addMinutes(ChronoZonedDateTime source, Integer amount)
```

Adds elapsed minutes.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addMinutes

```apex
global static ChronoZonedDateTime addMinutes(Datetime source, String zoneId, Integer amount)
```

Adds elapsed minutes.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addSeconds

```apex
global static ChronoZonedDateTime addSeconds(ChronoZonedDateTime source, Integer amount)
```

Adds elapsed seconds.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addSeconds

```apex
global static ChronoZonedDateTime addSeconds(Datetime source, String zoneId, Integer amount)
```

Adds elapsed seconds.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addMilliseconds

```apex
global static ChronoZonedDateTime addMilliseconds(ChronoZonedDateTime source, Long amount)
```

Adds elapsed milliseconds.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addDays

```apex
global static ChronoZonedDateTime addDays(ChronoZonedDateTime source, Integer amount)
```

Adds local calendar days; rejects gaps and overlaps.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addDays

```apex
global static ChronoZonedDateTime addDays(ChronoZonedDateTime source, Integer amount, String disambiguation)
```

Adds local calendar days; rejects gaps and overlaps.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addMonths

```apex
global static ChronoZonedDateTime addMonths(ChronoZonedDateTime source, Integer amount)
```

Adds local calendar months; rejects gaps and overlaps.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addMonths

```apex
global static ChronoZonedDateTime addMonths(ChronoZonedDateTime source, Integer amount, String disambiguation)
```

Adds local calendar months; rejects gaps and overlaps.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addYears

```apex
global static ChronoZonedDateTime addYears(ChronoZonedDateTime source, Integer amount)
```

Adds local calendar years; rejects gaps and overlaps.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addYears

```apex
global static ChronoZonedDateTime addYears(ChronoZonedDateTime source, Integer amount, String disambiguation)
```

Adds local calendar years; rejects gaps and overlaps.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### add

```apex
global static ChronoZonedDateTime add(ChronoZonedDateTime source, ChronoDuration duration)
```

Adds months and days locally, then elapsed milliseconds.

Types: [ChronoDuration](ChronoDuration.md), [ChronoZonedDateTime](ChronoZonedDateTime.md).

### add

```apex
global static ChronoZonedDateTime add(ChronoZonedDateTime source, ChronoDuration duration, String disambiguation)
```

Adds months and days locally, then elapsed milliseconds.

Types: [ChronoDuration](ChronoDuration.md), [ChronoZonedDateTime](ChronoZonedDateTime.md).

### elapsedDifference

```apex
global static ChronoDuration elapsedDifference(ChronoZonedDateTime source, ChronoZonedDateTime other)
```

Returns the elapsed difference between instants.

Types: [ChronoDuration](ChronoDuration.md), [ChronoZonedDateTime](ChronoZonedDateTime.md).

### toIsoString

```apex
global static String toIsoString(ChronoZonedDateTime source)
```

Serialises the local datetime, offset and named zone.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### parseIso

```apex
global static ChronoZonedDateTime parseIso(String value)
```

Parses a zoned datetime and validates its offset against the zone.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addHours

```apex
global static ChronoZonedDateTime addHours(ChronoZonedDateTime source, Integer amount, OperatingHours schedule)
```

Adds elapsed hours.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addHours

```apex
global static ChronoZonedDateTime addHours(Datetime source, String zoneId, Integer amount, OperatingHours schedule)
```

Adds elapsed hours.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addHours

```apex
global static ChronoZonedDateTime addHours(ChronoZonedDateTime source, Integer amount, BusinessHours schedule)
```

Adds elapsed hours.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addHours

```apex
global static ChronoZonedDateTime addHours(Datetime source, String zoneId, Integer amount, BusinessHours schedule)
```

Adds elapsed hours.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addMinutes

```apex
global static ChronoZonedDateTime addMinutes(ChronoZonedDateTime source, Integer amount, OperatingHours schedule)
```

Adds elapsed minutes.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addMinutes

```apex
global static ChronoZonedDateTime addMinutes(Datetime source, String zoneId, Integer amount, OperatingHours schedule)
```

Adds elapsed minutes.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addMinutes

```apex
global static ChronoZonedDateTime addMinutes(ChronoZonedDateTime source, Integer amount, BusinessHours schedule)
```

Adds elapsed minutes.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addMinutes

```apex
global static ChronoZonedDateTime addMinutes(Datetime source, String zoneId, Integer amount, BusinessHours schedule)
```

Adds elapsed minutes.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addHours

```apex
global static ChronoZonedDateTime addHours(ChronoZonedDateTime source, Integer amount, OperatingHours schedule, List<TimeSlot> slots, List<Holiday> holidays)
```

Adds elapsed hours.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addHours

```apex
global static ChronoZonedDateTime addHours(Datetime source, String zoneId, Integer amount, OperatingHours schedule, List<TimeSlot> slots, List<Holiday> holidays)
```

Adds elapsed hours.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addMinutes

```apex
global static ChronoZonedDateTime addMinutes(ChronoZonedDateTime source, Integer amount, OperatingHours schedule, List<TimeSlot> slots, List<Holiday> holidays)
```

Adds elapsed minutes.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### addMinutes

```apex
global static ChronoZonedDateTime addMinutes(Datetime source, String zoneId, Integer amount, OperatingHours schedule, List<TimeSlot> slots, List<Holiday> holidays)
```

Adds elapsed minutes.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

### validate

```apex
global static void validate(ChronoZonedDateTime source)
```

Rejects incomplete or invalid data before use.

Types: [ChronoZonedDateTime](ChronoZonedDateTime.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
