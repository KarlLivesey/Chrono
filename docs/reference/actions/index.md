# Flow action reference

**27 families · 54 actions · 10 categories.** Every family has a single-value and explicit-collection form, both bulkified across Flow interviews.

Choose a task below, then open its page for exact inputs, output types and configuration choices. [How to configure actions](../../handbook/flow-configuration.md).

## Calculations

| Action                                       | What it does                                                                                  |
| -------------------------------------------- | --------------------------------------------------------------------------------------------- |
| [Add or subtract time](Adjust.md)            | Add calendar or elapsed units to a Chrono value.                                              |
| [Calendar difference](CalendarDifference.md) | Count whole calendar months/days from the start, followed by remaining clock or elapsed time. |
| [Compare date/time values](Compare.md)       | Compare compatible values and return before, equal or after.                                  |
| [Elapsed difference](Difference.md)          | Calculate signed elapsed time between two instants, optionally counting only OperatingHours.  |
| [Get fiscal period](FiscalPeriod.md)         | Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.          |
| [Start or end of period](PeriodBoundary.md)  | Find a calendar period boundary in an explicit timezone where applicable.                     |
| [Round date/time](Round.md)                  | Round to a clock increment or a calendar-day boundary.                                        |

## Working Hours

| Action                                                   | What it does                                                                                                      |
| -------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| [Find working-hour availability](Availability.md)        | Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays. |
| [Check working time](CheckWorkingTime.md)                | Check whether a date has opening hours or an instant is inside OperatingHours.                                    |
| [Find next or previous working time](FindWorkingTime.md) | Find an open value on or after/before the source, including holidays.                                             |
| [Add working calendar days](WorkingDays.md)              | Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays.       |
| [Add or subtract working time](WorkingTime.md)           | Add time inside Salesforce OperatingHours or BusinessHours, skipping closures and holidays.                       |

## Collections

| Action                                                | What it does                                                                                          |
| ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| [Work with date/time collections](CollectionTools.md) | Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow. |

## Values

| Action                                             | What it does                                                                            |
| -------------------------------------------------- | --------------------------------------------------------------------------------------- |
| [Convert date/time](Convert.md)                    | Convert or normalise all eight Chrono value types.                                      |
| [Create date/time from components](CreateValue.md) | Construct a validated value from individual calendar and clock components.              |
| [Convert Unix timestamp](EpochValue.md)            | Convert an exact value to or from Unix seconds or milliseconds.                         |
| [Parse formatted date/time](ParseValue.md)         | Parse an explicitly specified numeric date and time pattern without guessing.           |
| [Replace date/time components](ReplaceValue.md)    | Replace supplied components and preserve other fields. Resolve zoned values explicitly. |
| [Validate date/time value](ValidateValue.md)       | Validate a native or ISO value without failing other interviews.                        |
| [Get date/time details](ValueDetails.md)           | Inspect calendar and clock components with an explicit timezone for instants.           |

## Durations

| Action                                 | What it does                                                                          |
| -------------------------------------- | ------------------------------------------------------------------------------------- |
| [Calculate duration](DurationTools.md) | Construct, inspect, total, balance or scale durations with explicit calendar context. |

## Formatting

| Action                                         | What it does                                                                                                |
| ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| [Format date/time for display](FormatValue.md) | Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output. |

## Ranges

| Action                                      | What it does                                                                     |
| ------------------------------------------- | -------------------------------------------------------------------------------- |
| [Work with date/time ranges](RangeTools.md) | Validate and manipulate half-open ranges: start is included and end is excluded. |

## Recurrence

| Action                                    | What it does                                                                                                 |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| [Generate recurring dates](Recurrence.md) | Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments. |

## Time Zones

| Action                                           | What it does                                                                                             |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------- |
| [Inspect or resolve local time](ResolveLocal.md) | Inspect unique/repeated/skipped local times and explicitly select an occurrence or nearest gap boundary. |
| [Work with timezones](ZoneTools.md)              | Convert zones, inspect date-specific offsets and search bounded timezone transitions.                    |

## Time allocation

| Action                                       | What it does                                                                                      |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| [Allocate time to blocks](TimeAllocation.md) | Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules. |
