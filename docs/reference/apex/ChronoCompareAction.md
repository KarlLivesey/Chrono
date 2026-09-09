# ChronoCompareAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoCompareAction`.

Compare compatible values and return before, equal or after.

## Declaration

```apex
global with sharing class ChronoCompareAction
```

Compare compatible values and return before, equal or after.

Types: [ChronoCompareAction](ChronoCompareAction.md).

## ChronoCompareAction

```apex
global class Request
```

Scalar Flow inputs.

### run

```apex
global static List<ChronoFlowResult> run(List<Request> requests)
```

Compare compatible values and return before, equal or after.

Types: [ChronoFlowResult](ChronoFlowResult.md).

## ChronoCompareAction.Request

| Field / property                    | Flow label                | Contract                                                                                        |
| ----------------------------------- | ------------------------- | ----------------------------------------------------------------------------------------------- |
| `global String valueType`           | Value type                | Chrono type of the source.                                                                      |
| `global String value`               | ISO value                 | ISO source; alternatively supply native fields.                                                 |
| `global Datetime instantValue`      | Native datetime           | Exact source instant; mutually exclusive with ISO value.                                        |
| `global Date dateValue`             | Native date               | Local source date; mutually exclusive with ISO value.                                           |
| `global String timeValue`           | Local time                | ISO local time for native date/time input.                                                      |
| `global String timeZoneId`          | Calculation timezone      | Explicit zone for local resolution or calendar calculations.                                    |
| `global String disambiguation`      | Repeated-time policy      | reject, earlier or later; skipped local times are rejected unless explicitly corrected.         |
| `global String endValueType`        | End value type            | Defaults to the source type; exact types can be compared together.                              |
| `global String endValue`            | End ISO value             | ISO end value; alternatively use native end fields.                                             |
| `global Datetime endInstant`        | End native datetime       | Native exact end instant.                                                                       |
| `global Date endDate`               | End native date           | Native local end date.                                                                          |
| `global String endTime`             | End local time            | ISO local time for a native end date/time.                                                      |
| `global Date referenceDate`         | Duration reference date   | Required when comparing durations containing calendar units.                                    |
| `global Long toleranceMilliseconds` | Tolerance in milliseconds | Optional non-negative tolerance for complete date, clock, exact or duration values.             |
| `global String comparisonPeriod`    | Compare local period      | Optional day, week, month, quarter or year. Exact values require a common calculation timezone. |
| `global Integer weekStartsOn`       | Week starts on            | 1 is Monday through 7 Sunday. Defaults to Monday.                                               |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
