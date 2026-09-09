# Troubleshooting

Start with the actual input type, value, timezone and schedule mode. A formatted
date on a screen can conceal a different native instant or an unresolved local
clock. Check the operation result before debugging downstream calculations.

## Common symptoms

| Symptom                                 | Check                                               | Fix                                                                          |
| --------------------------------------- | --------------------------------------------------- | ---------------------------------------------------------------------------- |
| Resource type is incompatible           | Scalar/collection shape and exact request class     | Select the native/ISO input or the correct family's DTO collection           |
| Initial picker value is blank/invalid   | Actual runtime Text contents and selected mode      | Supply a complete supported date/datetime, not a duration or time-only value |
| Date appears a day earlier/later        | Display zone versus the stored instant              | Use a Date for a calendar date; choose an explicit display zone for instants |
| Local time requires a choice            | Repeated-time candidates                            | Choose the intended occurrence, or supply the known exact instant            |
| Local time does not exist               | Clock transition at that date/zone                  | Select a nearest valid boundary or enter another time                        |
| Zoned ISO offset is rejected            | Offset versus named zone at the represented instant | Correct the source, or use an explicit offset override workflow              |
| Schedule selection fails                | IDs, restrictions, record access and source mode    | Use an allowed accessible ID, or `supplied` for native unsaved definitions   |
| 17:00 is rejected for 09:00–17:00 hours | Exclusive closing boundary                          | Choose before closing or the next opening                                    |
| Flow continues after an item error      | Only a Fault path was checked                       | Add a Decision on the returned Success field                                 |
| Collection has some successful items    | Per-item error isolation                            | Inspect every item; preserve request/result correspondence                   |
| Date input contains month words         | Date style is medium/long                           | Choose short; the user's locale still determines format                      |
| API method does not exist               | Old beta instance API or invented service name      | Use the released global reference and service `parseIso`/`toIsoString`       |

## Operating hours look wrong

Check the **schedule's timezone**, not just the user's selected zone. Confirm
that holidays are linked to that OperatingHours model. A holiday configured for
BusinessHours is not automatically an OperatingHours holiday. Partial-day and
recurring Holiday fields matter when records are supplied dynamically.

In `record` mode, a saved ID loads relationships. In `supplied` mode, the supplied
slots and holidays are the definition. Supplying an ID does not make the latter
secretly query additional rows.

## Flow Builder does not show the expected editor

Confirm the installed version and namespace. Each scalar/collection action has
its own registered LWC editor. Distinguish an action editor from a screen's
configuration editor and from the runtime component shown to users.

The editor filters compatible resources; it is not a raw resource-name text
box. Select a lookup result. Existing formulas can be selected, but new formulas
and transforms are authored in Salesforce's own Builder controls.

## Allocation totals look too large or small

`duplicate` intentionally credits each matching block. `split` shares time and
can award remainder units according to priority. Check unallocated time, holiday
classification and optional coarse rounding before comparing totals.

Default precision is milliseconds. Do not round each displayed segment to whole
minutes and then assume their display sum is the engine's exact total. Check
the documented reconciliation equation.

## Limits and unresolved failures

Bound the requested range, result count and allocation segments. Bulkification
does not remove Apex CPU, heap or row limits. Capture the action name, package
version, relevant option values and a minimal non-sensitive reproducer when
reporting an issue at [GitHub Issues](https://github.com/KarlLivesey/Chrono/issues).
Do not include access tokens or private customer records.

See [limits](limits.md) and [release evidence](releases.md) for the scope of
automated verification; a successful package build is not a claim that every
org's UI, permissions and configuration have been tested.
