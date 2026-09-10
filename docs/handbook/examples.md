# Example library

The thirteen example Screen Flows are separate from the managed package. They
contain instructions, Chrono action calls, expected results and error paths.
Use them to learn the configuration editor or as a starting point in a test org.

## Get the examples

Download [the example bundle](../downloads/chrono-examples-0.2.0.4.zip), unzip it,
and deploy its Metadata API directory into an org with Chrono 0.2.0.4 installed:

```sh
sf project deploy start --metadata-dir chrono-examples/metadata --target-org your-org --wait 20
```

The archive includes a package manifest, all thirteen Flow files and two optional
demo-data scripts. It does not include old feasibility experiments. Assign
**Chrono Flow User**, then open Setup → Flows and search for the example label.
Use **Debug** to run it and select an action to inspect its editor.

## What to try

| Example                           | API name                      | Expected behaviour                                                 |
| --------------------------------- | ----------------------------- | ------------------------------------------------------------------ |
| 1. Date arithmetic                | `ChronoExampleDate`           | 31 January + one month → 28 February                               |
| 2. Timezones and repeated hours   | `ChronoExampleTimeZones`      | Second London 01:30 on 25 October → New York 24 October 21:30      |
| 3. Missing local time             | `ChronoExampleMissingTime`    | London 29 March 01:30 → nearest valid boundaries                   |
| 4. Operating hours and holidays   | `ChronoExampleWorkingHours`   | Friday 16:30 + one working hour → Tuesday 09:30                    |
| 5. Elapsed and working difference | `ChronoExampleDifference`     | Same endpoints → 89 elapsed hours versus one working hour          |
| 6. Collection conversions         | `ChronoExampleCollections`    | Ordered results with an intentional invalid-date item              |
| 7. Plan the next working time     | `ChronoExamplePlanning`       | Round, check hours, skip closures and compare calendar differences |
| 8. Recurring meetings             | `ChronoExampleRecurrence`     | Six Sundays from 22 March; skip missing 29 March clock             |
| 9. Duration and partial values    | `ChronoExampleValueInputs`    | Edit duration, time, month-day and year-month; total a duration    |
| 10. Range and timezone display    | `ChronoExampleRange`          | Exclusive interval, difference and multiple zone projections       |
| 11. Available appointments        | `ChronoExampleAppointments`   | Select schedule availability and add a working calendar day        |
| 12. Recurrence builder            | `ChronoExampleRuleBuilder`    | Preview a weekly rule and summarise its collection                 |
| 13. Time allocation               | `ChronoExampleTimeAllocation` | Monday blocks 2/1/1 hours; separate Tuesday holiday block          |

Use **Previous** from a result screen to change the inputs. Observe the native
DateTime, local fields and zoned ISO output separately: Salesforce's native
DateTime display can follow the running user's timezone.

## Optional saved demo schedules

Examples using saved hours need the named London/New York demo schedules. In a
test org, run the two supplied scripts in **separate transactions**:

```sh
sf apex run --target-org your-org --file chrono-examples/scripts/seed-example-holiday.apex
sf apex run --target-org your-org --file chrono-examples/scripts/seed-example-hours.apex
```

These scripts create or reuse named demo records. They perform DML. Keep the
holiday and schedule transactions separate to avoid mixed DML. The allocation
example uses an unsaved holiday and writes no records.

## Native Apex examples

[services.apex](../examples/services.apex) contains assertions against the public
managed API: month-end arithmetic, elapsed/calendar differences, overlap choice,
gap rejection, fraction truncation, unsaved hours and allocation. It performs no
DML and can be run with `sf apex run` after installation.

## Verification

All thirteen Flows were restored active in the existing subscriber org with the
released candidate. Automated consumer tests exercise real Flow interviews and
transport. The current release's interactive rendering has not been checked in
a browser; see [release evidence](releases.md).
