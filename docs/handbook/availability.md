# Availability and appointments

Use Availability to calculate open intervals or appointment candidates inside a
bounded search range. It reads schedule definitions and returns data; it does
not reserve an appointment or create records.

## Find appointment candidates

Choose the Availability action's `appointments` operation. Supply a supported
dated source type, start/end, a saved or supplied OperatingHours schedule and an
elapsed duration such as `PT30M`. Use exact ISO endpoints or native DateTime when
the intended instants are already known.

You can then add:

| Option              | Meaning                                                    |
| ------------------- | ---------------------------------------------------------- |
| Busy ranges         | Exact ISO start/end intervals to exclude                   |
| Buffer before/after | Free elapsed time required around each appointment         |
| Minimum notice      | Delay after an explicit reference datetime                 |
| Booking horizon     | Latest boundary relative to the explicit reference         |
| Grid anchor         | Exact instant aligning starts across all available windows |

The complete appointment and its buffers must fit the relevant free windows.
Calendar months/days are not valid appointment lengths. A positive horizon and
nonnegative notice/buffers use elapsed ISO durations.

Without a grid anchor, each free window starts its own appointment grid. With an
anchor, openings separated by closures or busy periods keep the same alignment.
This can change which appointment starts are returned.

## Multiple schedules

Use `shared`/`all` when every participating schedule must be open. Use
`anySchedule`/`any` when one is enough, according to the selected operation's
fields. Each schedule is evaluated in its own zone before intersection or union.
Do not compare two schedules simply by matching their local hour labels.

The primary and additional saved schedules share a bulk load. Their permissions
are still checked. An inaccessible schedule must not silently disappear from an
“everyone is available” calculation.

## Other operations

`windows` returns open windows; `boundaries` returns boundaries clipped to the
search interval. `containsRange` checks a complete range, including the relevant
booking constraints. `continuous` finds room for a continuous elapsed duration.
`workingDates`, `holidays` and `validateSchedule` inspect configuration; listing
holidays or working dates does not apply appointment notice/horizon limits.

All windows use inclusive starts and exclusive ends. Search is bounded to 366
days and remains subject to the transaction's CPU and heap limits.

## Present the choices

Use **Chrono: Available appointment** where exposed by the Flow availability
adapter, or compose the UI-only availability picker in your own LWC. The
[component reference](../reference/components/chronoFlowAvailability.md) lists
the exact Builder label and properties.

Keep the final record creation or booking check in your application. Another
transaction can book a slot after it was displayed; Chrono's candidate list is
not a lock on availability. Example 11 demonstrates selecting a candidate and
then applying a working-calendar-day action.
