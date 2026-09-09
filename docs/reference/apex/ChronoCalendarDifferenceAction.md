# ChronoCalendarDifferenceAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoCalendarDifferenceAction`.

Count whole calendar months/days from the start, followed by remaining clock or elapsed time.

## Declaration

```apex
global with sharing class ChronoCalendarDifferenceAction
```

Count whole calendar months/days from the start, followed by remaining clock or elapsed time.

Types: [ChronoCalendarDifferenceAction](ChronoCalendarDifferenceAction.md).

## ChronoCalendarDifferenceAction

```apex
global class Request
```

Scalar Flow inputs.

### run

```apex
global static List<ChronoFlowResult> run(List<Request> requests)
```

Count whole calendar months/days from the start, followed by remaining clock or elapsed time.

Types: [ChronoFlowResult](ChronoFlowResult.md).

## ChronoCalendarDifferenceAction.Request

| Field / property               | Flow label           | Contract                                                                                |
| ------------------------------ | -------------------- | --------------------------------------------------------------------------------------- |
| `global String valueType`      | Value type           | Chrono type of the source.                                                              |
| `global String value`          | ISO value            | ISO source; alternatively supply native fields.                                         |
| `global Datetime instantValue` | Native datetime      | Exact source instant; mutually exclusive with ISO value.                                |
| `global Date dateValue`        | Native date          | Local source date; mutually exclusive with ISO value.                                   |
| `global String timeValue`      | Local time           | ISO local time for native date/time input.                                              |
| `global String timeZoneId`     | Calculation timezone | Explicit zone for local resolution or calendar calculations.                            |
| `global String disambiguation` | Repeated-time policy | reject, earlier or later; skipped local times are rejected unless explicitly corrected. |
| `global String endValueType`   | End value type       | Defaults to the source type; exact types can be compared together.                      |
| `global String endValue`       | End ISO value        | ISO end value; alternatively use native end fields.                                     |
| `global Datetime endInstant`   | End native datetime  | Native exact end instant.                                                               |
| `global Date endDate`          | End native date      | Native local end date.                                                                  |
| `global String endTime`        | End local time       | ISO local time for a native end date/time.                                              |
| `global String largestUnit`    | Largest unit         | day, month or year. Defaults to day; years are represented by total calendar months.    |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
