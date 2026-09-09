# Calendar, elapsed and working time

Pick the meaning of the unit before choosing the action. Three calculations
that all say “add a day” can answer different business questions.

| Meaning              | Example                                    | Use                        |
| -------------------- | ------------------------------------------ | -------------------------- |
| Calendar             | Same local clock on the next date          | Add/subtract calendar days |
| Elapsed              | Exactly 24 hours later                     | Add 24 hours or `PT24H`    |
| Working              | Consume time only while a schedule is open | Working-time action        |
| Working calendar day | Move to another date with some opening     | WorkingDays action         |

## Month ends

Native Salesforce date arithmetic determines core month addition. **31 January
2026 plus one month is 28 February 2026**. This clamping behaviour differs from
recurrence generation, where an invalid recurring month-end date is skipped.
Do not substitute repeated `addMonths` calls for a recurrence rule without
checking the intended month-end policy.

## A clock-change example

Start at London **28 March 2026, 12:00**. Add one calendar day and the result is
**29 March 12:00**, only 23 elapsed hours later. Add 24 elapsed hours and the
result is **29 March 13:00**.

Zoned calendar arithmetic resolves the target local clock. The default rejects
a repeated or missing target; supported overloads can select an overlap
occurrence. Plain date/time arithmetic works on wall fields and needs no timezone
until you convert its result into an instant.

## Duration addition

A duration keeps calendar months, calendar days and elapsed milliseconds.
Zoned addition applies months and days locally, resolves that intermediate local
time, then adds the elapsed part. Order matters around month ends and transitions.

Instants accept elapsed durations. Plain times wrap across midnight and reject
calendar components. Plain dates accept calendar units. A month-day needs a
reference year before dated arithmetic can be meaningful.

## Difference

Elapsed difference is signed end minus start. The Difference action accepts
native DateTime or ISO instant/zoned endpoints; local values need resolving
first. An optional saved OperatingHours ID restricts the difference to open time.

CalendarDifference reports whole calendar units and a separate time remainder.
Use the calendar part alone when your process intentionally ignores the
remainder. Different input zones require an explicit common calculation zone
where local calendar comparison needs one.

## Rounding and boundaries

Round is an explicit operation with unit, increment and rounding policy. Do not
rely on display formatting to round a stored value. PeriodBoundary finds the
start/end of the selected local period; exact inputs need zone context.

Ranges use an exclusive upper bound. A last representable time inside a range
is not the same as its exclusive endpoint. This distinction matters when you
chain period, range and availability operations.

See the [action reference](../reference/actions/index.md) for each operation's
accepted types and options, and [time allocation](allocation.md) for its separate
precision and rounding rules.
