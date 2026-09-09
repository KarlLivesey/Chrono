# Timezones, offsets and clock changes

A timezone is a set of date-dependent rules. An offset is the difference from
UTC at an instant. `Europe/London` is not permanently `+00:00` or `+01:00`.
Use the date being calculated, never today's offset, to interpret another date.

## Keep the instant or keep the clock

Changing a zoned value's zone through `ChronoZonedDateTimeService.withTimeZone`
preserves the instant. 09:00 in London can become a different clock reading in
New York while describing the same moment.

Keeping the local clock is a different operation. 09:00 London → 09:00 New York
changes the instant and may need another ambiguity check. ZoneTools exposes an
explicit `instant` or `localClock` conversion mode.

The screen picker preserves the entered clock when the **user selects** another
zone. When its parent changes the zone input for an already resolved instant,
the controller projects that instant into the new zone. Do not assume those two
interactions mean the same thing.

## Repeated local times

London's **25 October 2026, 01:30** occurs twice:

| Choice | Local representation | Exact instant |
| ------ | -------------------- | ------------- |
| First  | `01:30 +01:00` (BST) | `00:30Z`      |
| Second | `01:30 +00:00` (GMT) | `01:30Z`      |

The core plain-to-zoned conversion rejects ambiguity by default. Pass `earlier`
or `later` to select an occurrence. The screen offers both choices and keeps a
clickable offset indicator so the user can reopen their choice.

```apex
skel.ChronoPlainDateTime local = skel.ChronoPlainDateTimeService.parseIso('2026-10-25T01:30');
skel.ChronoZonedDateTime second = skel.ChronoPlainDateTimeService.toZonedDateTime(local, 'Europe/London', 'later');
Assert.areEqual(Datetime.newInstanceGmt(2026, 10, 25, 1, 30, 0), second.instant);
```

## Missing local times

London's **29 March 2026, 01:30** does not exist. The picker and ResolveLocal
action can offer the nearest valid boundaries:

- Backward: `2026-03-29T00:59:59.999+00:00[Europe/London]`.
- Forward: `2026-03-29T02:00:00.000+01:00[Europe/London]`.

Forward means the first valid boundary, not 02:30. Backward means the final valid
millisecond before the gap, not 00:30. This also matters for half-hour changes
and skipped dates. The core plain-to-zoned service still rejects gaps; an
`earlier`/`later` overlap policy does not silently correct one.

## Explicit customer offsets

Some source systems send a summer offset before a destination zone has switched.
When that business case is intentional, enable the picker's supplied-offset
override or use ZoneTools `overrideOffset`.

At **15 March 2026, 10:00**, a supplied `+01:00` means **09:00Z**. London is
actually on GMT then, so the canonical London projection is 09:00, not 10:00.
Chrono marks this as an override rather than calling it BST.

Preserve the supplied offset separately if you must reconstruct the original
wall-clock entry. The canonical zoned output always obeys the named zone's real
rules. A normal zoned parser rejects contradictory offset/zone pairs.

An offset override never rewrites an OperatingHours schedule's timezone rules.
The resulting instant must still fall in that schedule's open time.

## Three zones can coexist

The user's display zone, the input value's zone and the operating schedule's
zone can differ. Evaluate each schedule's slots and holidays in its own zone,
then compare exact instants. Present the result in the chosen output zone.
Timezone abbreviations are hints for people; keep a named zone ID for calculations.
