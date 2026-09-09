# ChronoFlowResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoFlowResult`.

Independent result for one Flow item. Check success before reading value fields.

## Declaration

```apex
global with sharing class ChronoFlowResult
```

Independent result for one Flow item. Check success before reading value fields.

Types: [ChronoFlowResult](ChronoFlowResult.md).

## ChronoFlowResult

| Field / property                 | Flow label           | Contract                                                                               |
| -------------------------------- | -------------------- | -------------------------------------------------------------------------------------- |
| `global Boolean success`         | Success              | Whether this item completed successfully.                                              |
| `global String errorMessage`     | Error                | Failure diagnostic for this item; other items can succeed.                             |
| `global String valueType`        | Value type           | Chrono type of the result.                                                             |
| `global String value`            | ISO value            | Canonical ISO result; usable as input to another Chrono action.                        |
| `global Datetime instantValue`   | Native datetime      | Exact instant, when present.                                                           |
| `global Date dateValue`          | Local date           | Local date, when present.                                                              |
| `global String timeValue`        | Local time           | ISO clock time, when present.                                                          |
| `global String timeZoneId`       | Time zone            | Zone of the returned zoned value.                                                      |
| `global Integer months`          | Calendar months      | Calendar months in a duration.                                                         |
| `global Integer days`            | Calendar days        | Calendar days in a duration.                                                           |
| `global Long milliseconds`       | Elapsed milliseconds | Elapsed milliseconds in a duration.                                                    |
| `global Boolean isOpen`          | Is open              | Whether the value falls in working time; a date asks whether any time is open.         |
| `global Integer comparison`      | Comparison           | -1 before, 0 equal, 1 after.                                                           |
| `global String resolutionStatus` | Resolution status    | unique, repeated or nonexistent.                                                       |
| `global String earlierValue`     | First occurrence     | First valid zoned ISO occurrence for a repeated time.                                  |
| `global String laterValue`       | Second occurrence    | Second valid zoned ISO occurrence for a repeated time.                                 |
| `global String previousValue`    | Previous boundary    | Nearest valid zoned ISO boundary before a skipped time.                                |
| `global String nextValue`        | Next boundary        | Nearest valid zoned ISO boundary after a skipped time.                                 |
| `global Boolean withinTolerance` | Within tolerance     | Whether the difference is within the supplied tolerance; null when not requested.      |
| `global Boolean samePeriod`      | Same local period    | Whether the values share the requested local calendar period; null when not requested. |

### ChronoFlowResult

```apex
global ChronoFlowResult()
```

Global no-argument constructor required by subscriber Flow.

Types: [ChronoFlowResult](ChronoFlowResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
