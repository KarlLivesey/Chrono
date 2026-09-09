# Flow examples

These twelve active examples are deployed to the existing `chrono-dev` org. Each
includes instructions, actual Chrono actions, expected results and a failure
path. Use **Previous** on the result screen to try another input.

The links below require an existing Salesforce session. To sign in:

```sh
sf org open --target-org chrono-dev
```

| Example                           | What to try and expect                                                                                                                                                                                                                        | Open                                                                                                                                                                                                                                         |
| --------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1. Date arithmetic                | Native Date 31 January 2026 plus one month returns 28 February. Change the date or the action's amount/unit in Builder.                                                                                                                       | [Run](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/flow/ChronoExampleDate) · [Edit](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/builder_platform_interaction/flowBuilder.app?flowId=301G100000khHBbIAM)         |
| 2. Timezones and repeated hours   | London 25 October 2026, 01:30 occurs twice. Choose the second (GMT); the conversion action returns 24 October, 21:30 in New York. Reopen the offset to change the occurrence or enter an explicit override.                                   | [Run](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/flow/ChronoExampleTimeZones) · [Edit](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/builder_platform_interaction/flowBuilder.app?flowId=301G100000khHBgIAM)    |
| 3. Missing local time             | London 29 March 2026, 01:30 does not exist. Forward chooses 02:00 exactly; backward chooses 00:59:59.999. The action converts the chosen instant to UTC.                                                                                      | [Run](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/flow/ChronoExampleMissingTime) · [Edit](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/builder_platform_interaction/flowBuilder.app?flowId=301G100000khHBdIAM)  |
| 4. Operating hours and holidays   | Friday 28 August, 16:30 plus one working hour returns Tuesday 1 September, 09:30. The London schedule excludes Monday's holiday. Display timezone and schedule are independently selectable.                                                  | [Run](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/flow/ChronoExampleWorkingHours) · [Edit](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/builder_platform_interaction/flowBuilder.app?flowId=301G100000khHBhIAM) |
| 5. Elapsed and working difference | The same Friday-to-Tuesday range returns **89 elapsed hours** and **1 working hour**. Both actions receive zoned ISO strings; only the working calculation receives the OperatingHours ID. Reverse the endpoints to get negative differences. | [Run](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/flow/ChronoExampleDifference) · [Edit](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/builder_platform_interaction/flowBuilder.app?flowId=301G100000khHBcIAM)   |
| 6. Collection conversions         | Assignments create three requests, one collection action processes them and a loop displays the ordered results: year/month, London zoned date/time, then an intentional invalid-date error. Successful items survive the failing item.       | [Run](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/flow/ChronoExampleCollections) · [Edit](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/builder_platform_interaction/flowBuilder.app?flowId=301G100000khHBaIAM)  |
| 7. Plan the next working time     | Chains all seven new operations. Sunday 16:37 rounds to 16:45, is closed, then advances past Monday’s holiday to Tuesday 09:00. Shows the day boundary, comparison and one calendar day plus a 16h15m remainder.                              | [Run](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/flow/ChronoExamplePlanning) · [Edit](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/builder_platform_interaction/flowBuilder.app?flowId=301G100000khHBeIAM)     |

| 8. Recurring meetings | Six weekly Sunday meetings starting 22 March 2026 at 01:30 London. Skips the nonexistent 29 March time; the last meeting is 3 May. Chains recurrence, collection summary, locale formatting and range validation. | [Run](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/flow/ChronoExampleRecurrence) · [Edit](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/builder_platform_interaction/flowBuilder.app?flowId=301G100000khHBfIAM) |

| Example                        | What to try                                                                                            | Open                                                                                                                                                                                                                                         |
| ------------------------------ | ------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 9. Duration and partial values | Edit duration, time, month/day and year/month inputs; total the elapsed duration with an action.       | [Run](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/flow/ChronoExampleValueInputs) · [Edit](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/builder_platform_interaction/flowBuilder.app?flowId=301G100000khHCEIA2)  |
| 10. Range and timezone display | Choose an exclusive range; calculate its difference and display its starting instant in several zones. | [Run](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/flow/ChronoExampleRange) · [Edit](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/builder_platform_interaction/flowBuilder.app?flowId=301G100000khHCCIA2)        |
| 11. Available appointments     | Choose from London operating-hours availability, then add one working calendar day.                    | [Run](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/flow/ChronoExampleAppointments) · [Edit](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/builder_platform_interaction/flowBuilder.app?flowId=301G100000khHCBIA2) |
| 12. Recurrence builder         | Preview an editable weekly rule, then summarise the occurrence collection through an action.           | [Run](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/flow/ChronoExampleRuleBuilder) · [Edit](https://ability-data-1978-dev-ed.scratch.my.salesforce.com/builder_platform_interaction/flowBuilder.app?flowId=301G100000khMfZIAU)  |

In Builder, select an action to see its LWC configuration editor. Choose the input
format first; the compact mode menu switches between a fixed value and a compatible
Flow resource. Example 2 binds a native Datetime screen output, example 5 binds ISO
Text outputs, and example 6 binds the exact request collection type. Collection
requests use the existing mutable invocable input types; date/time values themselves
remain ISO Text or native Salesforce values, not core Chrono objects.

Datetime result screens also show the local date, local date/time, zoned value,
instant and native Datetime available to later Flow elements. Salesforce formats
native Datetime display text in the running user's timezone; the zoned ISO value
retains the explicitly chosen zone.

## Deploying the fixtures elsewhere

The source is in `tests/subscriber/force-app/main/default/flows/ChronoExample*.flow-meta.xml`.
The target must already contain the matching Chrono implementation and the running
user needs **Chrono Flow User**, plus permission to read the schedules.

Seed the holiday and schedules in separate transactions to avoid mixed DML:

```sh
sf apex run --target-org chrono-dev --file tests/subscriber/scripts/seed-example-holiday.apex
sf apex run --target-org chrono-dev --file tests/subscriber/scripts/seed-example-hours.apex
```

The scripts create or reuse the named London/New York demo schedules. Examples 4, 5
and 7 show setup guidance if the London record is absent. These examples are test
fixtures, outside the managed package source directory.

The new screen examples are deployed and metadata-validated. Their action engines
are exercised through automated Flow interviews; browser interaction and visual
rendering remain unverified. See [validation](validation.md) for exact evidence.

## Example 13 — Time allocation and holiday blocks

`ChronoExampleTimeAllocation` starts with Monday 08:00–12:00 and three bands:
08:00–10:00, 10:00–11:00 and 11:00–15:00. The allocation action returns 2, 1
and 1 hour. Moving both endpoints to Tuesday 8 September demonstrates a separate
08:00–12:00 holiday block using an unsaved native Holiday record. No records are
written. The Flow loops over the typed block totals and displays their labels,
hours and ISO durations, plus unallocated/duplicated/rounding amounts. Edit the
action to try the other overlap modes and precision settings.
