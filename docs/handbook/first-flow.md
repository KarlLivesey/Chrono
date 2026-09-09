# Your first Flow

This example adds one calendar month to a native Salesforce Date. It shows the
normal pattern: supply a typed source, run an action, check its result, then use
the output. No Apex code or schedule records are required.

## Add the input screen

1. Create a **Screen Flow**.
2. Add a Screen with a standard Date input, API name `StartDate`.
3. Set a default date of **31 January 2026**, or enter that date when debugging.

You can use **Chrono: Date and time** in `date` mode instead. The standard Date
input is sufficient when timezone selection is not part of the task.

## Add the calculation

Add **Chrono: Add or subtract time** after the screen. In its configuration editor:

| Setting      | Value                                              |
| ------------ | -------------------------------------------------- |
| Value type   | `PlainDate`                                        |
| Input format | Native Date                                        |
| Source       | Search Resources → the screen's `StartDate` output |
| Amount       | `1`                                                |
| Unit         | `months`                                           |

Choose the native resource directly. Do not turn it into a formatted string with
a formula. The editor shows the selected representation; ISO and native sources
must not both be supplied for the same value.

## Handle the result

Add a Decision after the action. Test its **Success** output. On success, show
the returned **Local date** or use it in a later Assignment/Update Records step.
For this example the expected date is **28 February 2026**.

On an unsuccessful result, show or handle **Error**. Also connect the action's
Fault path for a platform-level failure. An item-level validation result and a
Flow fault are different paths; a fault-only design can miss `success=false`.

The ISO **value** output is useful for another Chrono action. The native Date
output is usually the natural choice for a Salesforce Date field.

## Try the behaviour

Change the amount to `-1` to subtract a month. Change the input to another
month-end date. These are native calendar-month semantics, including clamping to
the last valid date in the destination month.

For a complete deployable version, see **Example 1: Date arithmetic** in the
[example library](examples.md).

## Next: a timezone-aware appointment

Use **Chrono: Date and time** in `datetime` mode, with timezone `Europe/London`.
Set its initial ISO value to `2026-10-25T01:30:00.000`. The user must choose which
01:30 they mean. Pass its native DateTime output to Convert with source type
`Instant`, target `ZonedDateTime`, and timezone `America/New_York`.

The second London occurrence is 01:30 UTC, displayed as **24 October 21:30** in
New York. Selecting the first occurrence gives a different instant. The
[timezone guide](timezones.md) explains why both answers can be valid.
