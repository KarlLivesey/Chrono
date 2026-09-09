# ISO formats and transport

Use ISO values for machine interchange and locale formatting for presentation.
Do not parse a displayed `09/08/2026` without knowing its intended pattern.

| Type           | Accepted shape                     | Canonical example                              |
| -------------- | ---------------------------------- | ---------------------------------------------- |
| Plain date     | `YYYY-MM-DD`                       | `2026-09-08`                                   |
| Plain time     | `HH:mm`, optional seconds/fraction | `09:30:00.000`                                 |
| Plain datetime | Date + `T` + local time            | `2026-09-08T09:30:00.000`                      |
| Instant        | Date/time + `Z` or numeric offset  | `2026-09-08T08:30:00.000Z`                     |
| Zoned datetime | Date/time + offset + `[zone]`      | `2026-09-08T09:30:00.000+01:00[Europe/London]` |
| Year-month     | `YYYY-MM`                          | `2026-09`                                      |
| Month-day      | `--MM-DD`                          | `--09-08`                                      |
| Duration       | Signed ISO duration                | `P1M2DT3H`                                     |

Use `parseIso` and `toIsoString` on the relevant service. Parsing validates the
value. Zoned parsing checks the numeric offset against the named zone at the
represented instant. The bracketed ID is not decorative metadata.

## Fractions

Fractions beyond milliseconds are accepted and truncated, not rounded:

```text
2021-01-13T20:57:01.500944804Z → 2021-01-13T20:57:01.500Z
PT7.987654321S → PT7.987S
-PT0.0009S → zero milliseconds
```

Do not use the output as a lossless archive of nanosecond input. Preserve the raw
source text separately if that matters to another system.

## Durations

Years become calendar months; weeks become calendar days. Months, days and elapsed
milliseconds remain separate. Components must have a consistent sign. A calendar
duration cannot be totalled as milliseconds without the context that gives those
calendar units a length.

`P1D` is one calendar day. `PT24H` is 24 elapsed hours. On a zoned value they can
produce different instants across a daylight-saving transition.

## Range strings

Range operations use ISO endpoint strings separated by `/`, for example:

```text
2026-09-08T09:00:00.000Z/2026-09-08T10:00:00.000Z
```

The slash inside a bracketed timezone ID belongs to the endpoint. Use Chrono's
range operations instead of splitting blindly on every slash. Intervals are
start-inclusive and end-exclusive. Consult [ranges](ranges-recurrence.md).

## What is not a serialisation contract

Generic JSON deserialisation into managed Apex request classes is not the
supported subscriber construction API. Create request objects with their global
constructors and assign fields. Flow transports those envelopes through its own
supported mechanisms.

ISO Text and the documented time-block `blocksText` definition are intentional
text contracts. They do not make every internal JSON representation a public API.
Alternative calendar annotations and unsupported historical second-offset zoned
serialisation are described in [limits](limits.md).
