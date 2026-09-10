# Operating hours and holidays

OperatingHours answers “when is this schedule open?” Working-time arithmetic
consumes only those open intervals. The schedule's timezone controls its slots
and holidays even when the input or displayed result uses another zone.

## The Friday-to-Tuesday example

Use 09:00–17:00 Monday–Friday hours in `Europe/London`, with **Monday 31 August
2026** as an all-day holiday. Starting **Friday 28 August at 16:30**:

1. Consume 30 minutes before Friday closes.
2. Skip the weekend and Monday's holiday.
3. Consume the remaining 30 minutes on Tuesday.

The result is **Tuesday 1 September, 09:30 London**. The unrestricted elapsed
difference between those endpoints is **89 hours**; the working difference is
**one hour**.

## Saved configuration

Saved schedules use `OperatingHours`, its normal `TimeSlot` records, and
`OperatingHoursHoliday` links to `Holiday`. Use explicit record IDs where possible;
names are not unique identifiers. Holidays are not automatically inferred from a
country or timezone. Provide the records representing your organisation's rules.

Single query-backed Apex working-time overloads perform three user-mode queries
per schedule load. Flow batches common schedules across requests. Access failures
are not interpreted as an empty schedule; they are reported as errors.

## Bulk-safe Apex and Flow

For the released **0.2.0.4 API**, call `skel.ChronoWorkingTimeService.add(requests)`
once with a `List<skel.ChronoWorkingTimeInput>`. It returns ordered,
independent `ChronoWorkingTimeResult` records; check `success` before reading
`value.instant` and `value.timeZoneId`. Saved schedules share three user-mode
queries per call; supplied native schedules use none. BusinessHours adds one
configuration query. The [bulk Apex guide](../bulk-apex-services.md) lists all
27 service operations, complete examples, input choices and query costs.

The public install link installs released **0.2.0.4**, which contains these
services. The older 0.1.0.19 release had only the action entry point
`skel.ChronoWorkingTimeAction.run(List<skel.ChronoWorkingTimeAction.Request>)`,
returning `List<skel.ChronoFlowResult>`. The direct services are the intended
Apex API for 0.2 and do not invoke Flow. See [release status](releases.md).

In Flow, **Chrono: Add or subtract working time** batches separate interviews;
its [collection action](../reference/actions/WorkingTime.md) also accepts explicit
collections. Working elapsed differences similarly batch saved schedules through
`skel.ChronoDifferenceAction.run(requests)`.

For typed `ChronoZonedDateTime` results with schedule records you have already
loaded, use the supplied-record service overload below. It performs no schedule
queries and can be called inside a loop without a query per item.

## Supplied native records

Use an OperatingHours record plus TimeSlot and Holiday collections when the
schedule is dynamic or already loaded. Records may be unsaved. Supplying all
three inputs uses their fields directly, with no schedule queries or DML—even if
some records happen to have IDs.

```apex
OperatingHours hours = new OperatingHours(TimeZone = 'Europe/London');
List<TimeSlot> slots = new List<TimeSlot>();
for (String day : new List<String>{'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'}) {
    slots.add(new TimeSlot(DayOfWeek = day, Type = 'Normal',
        StartTime = Time.newInstance(9, 0, 0, 0), EndTime = Time.newInstance(17, 0, 0, 0)));
}
List<Holiday> holidays = new List<Holiday>{
    new Holiday(ActivityDate = Date.newInstance(2026, 8, 31), IsAllDay = true)
};
skel.ChronoZonedDateTime start = skel.ChronoZonedDateTimeService.parseIso('2026-08-28T16:30:00.000+01:00[Europe/London]');
skel.ChronoZonedDateTime endValue = skel.ChronoZonedDateTimeService.addHours(start, 1, hours, slots, holidays);
Assert.areEqual('2026-09-01T09:30:00.000+01:00[Europe/London]', skel.ChronoZonedDateTimeService.toIsoString(endValue));
```

## Pick the working operation

| Need                                     | Operation                            |
| ---------------------------------------- | ------------------------------------ |
| Add or subtract hours/minutes while open | WorkingTime                          |
| Count open time between exact endpoints  | Difference + saved OperatingHours ID |
| Is this value open?                      | CheckWorkingTime                     |
| Move to the next or previous open time   | FindWorkingTime                      |
| Move a number of working calendar dates  | WorkingDays                          |
| List openings or find appointments       | Availability                         |

The elapsed Difference action takes a saved ID; it does not expose the full
supplied-record input set used by the other schedule operations. Do not infer
identical inputs just because two actions use the same underlying schedule model.

WorkingDays excludes the starting date when counting nonzero days. Timed values
retain the schedule-local clock, then apply `keep`, `reject`, `next` or `previous`
if it is closed. This differs from adding eight working hours.

## Boundaries and holidays

An opening is start-inclusive and end-exclusive. At a 17:00 closing, 17:00 itself
is closed. A previous-open correction can therefore be 16:59:59.999. Multiple
overlapping openings are merged and are not counted twice.

All-day, partial-day and supported Salesforce recurring holidays remove time from
the normal schedule. Native recurrence fields must be supplied when using an
unsaved recurring Holiday. The fixed screen editor supports all-day and partial
closures; use record collections for recurring definitions.

Clock gaps consume no elapsed working time. Repeated openings count actual
occurrences. Extended slots are not generic availability and are excluded;
conditional normal slots require appointment context and raise an explicit error.
Represent overnight OperatingHours coverage as valid slots on separate days.

## BusinessHours is separate

The native BusinessHours overload requires a saved BusinessHours record and
delegates to Salesforce's native calculation. Its timezone and holiday links
belong to that model. The richer OperatingHours search/availability APIs should
not be assumed to accept a BusinessHours ID.

See [permissions](security.md), [screen schedule choices](screen-configuration.md)
and [limits](limits.md) before processing large schedule ranges.
