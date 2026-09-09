# Apex quick start

Subscriber code prefixes the package's global classes with `skel.`. Core values
hold data; the matching service constructs, validates, converts and calculates.
Use `parseIso`, not the old pre-release `parse` instance pattern.

## Create and adjust a date

```apex
skel.ChronoPlainDate source = skel.ChronoPlainDateService.parseIso('2026-01-31');
skel.ChronoPlainDate result = skel.ChronoPlainDateService.addMonths(source, 1);
Assert.areEqual(Date.newInstance(2026, 2, 28), result.value);
Assert.areEqual('2026-01-31', skel.ChronoPlainDateService.toIsoString(source));
```

The result is new data. Native overloads are available where they make sense,
for example `ChronoPlainDateService.addMonths(Date, Integer)`. Check the exact
overload in the [service reference](../reference/apex/ChronoPlainDateService.md).

## Resolve a local datetime

```apex
skel.ChronoPlainDateTime local = skel.ChronoPlainDateTimeService.create(
    Date.newInstance(2026, 9, 8), Time.newInstance(9, 30, 0, 0));
skel.ChronoZonedDateTime zoned = skel.ChronoPlainDateTimeService.toZonedDateTime(local, 'Europe/London');
Datetime exact = skel.ChronoZonedDateTimeService.toDatetime(zoned);
Assert.areEqual(Datetime.newInstanceGmt(2026, 9, 8, 8, 30, 0), exact);
```

Default conversion rejects missing and repeated clocks. An `earlier` or `later`
policy selects an overlap occurrence. Gap correction is an explicit picker/action
choice rather than an implicit core conversion. See [timezones](timezones.md).

## Work with native values

Native DateTime overloads need an explicit zone for zoned operations:

```apex
skel.ChronoZonedDateTime later = skel.ChronoZonedDateTimeService.addHours(
    Datetime.newInstanceGmt(2026, 9, 8, 8, 30, 0), 'Europe/London', 1);
Assert.areEqual('2026-09-08T10:30:00.000+01:00[Europe/London]',
    skel.ChronoZonedDateTimeService.toIsoString(later));
```

For saved or supplied schedules, use the explicit schedule overloads in
[OperatingHours](operating-hours.md). Query-backed conveniences and supplied-data
operations have different query costs.

## Mutable data is validated

Global fields and empty constructors let subscriber Apex build values directly:

```apex
skel.ChronoPlainDate value = new skel.ChronoPlainDate();
value.value = Date.newInstance(2026, 9, 8);
skel.ChronoPlainDateService.validate(value);
```

An empty constructor does not produce a valid date. Services validate at the
boundary before using mutable data. Mutating a duration into mixed signs or
setting an unknown timezone is rejected by the next service operation.

Catch `skel.ChronoException` for Chrono-specific invalid input and unresolved
local times. Native range, permissions and query errors can come from Salesforce.
Do not swallow every exception and substitute a plausible-looking date.

## Other operations from Apex

The eight core services cover value operations. Time allocation has its own
global service. Other catalogue operations are available through their global
action entry points: construct the exact nested `Action.Request`, set its fields,
call `run` with a list and inspect each result's `success`.

Do not infer a `ChronoAvailabilityService` merely from the action family name.
The reference lists actual global declarations. Internal `Operations`, engines,
adapters and LWC controllers are not consumer APIs.

## Runnable checks

Download [the subscriber examples](../examples/services.apex) and run them in an
org with the released package installed:

```sh
sf apex run --target-org your-org --file services.apex
```

The script asserts calendar arithmetic, overlap selection, durations, unsaved
operating hours and allocation. It does not insert records. Each documented
snippet is included in the documentation verification pass.
