# ChronoRangeToolsInput

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoRangeToolsInput`.

Validate and manipulate half-open ranges: start is included and end is excluded.

## Declaration

```apex
global with sharing class ChronoRangeToolsInput
```

Validate and manipulate half-open ranges: start is included and end is excluded.

Types: [ChronoRangeToolsInput](ChronoRangeToolsInput.md).

## ChronoRangeToolsInput

| Field / property                    | Flow label                  | Contract                                                                            |
| ----------------------------------- | --------------------------- | ----------------------------------------------------------------------------------- |
| `global String operation`           | Operation                   | Operation.                                                                          |
| `global String valueType`           | Value type                  | Value type.                                                                         |
| `global String value`               | ISO value                   | ISO value.                                                                          |
| `global Date dateValue`             | Native date                 | Native date.                                                                        |
| `global Datetime instantValue`      | Native datetime             | Native datetime.                                                                    |
| `global String timeValue`           | Local time                  | ISO time for a native date and time input.                                          |
| `global String timeZoneId`          | Timezone                    | Required when resolving local time or inspecting an instant.                        |
| `global String disambiguation`      | Repeated-time policy        | Repeated-time policy.                                                               |
| `global String endValue`            | End ISO value               | End ISO value.                                                                      |
| `global Date endDate`               | End native date             | End native date.                                                                    |
| `global Datetime endInstant`        | End native datetime         | End native datetime.                                                                |
| `global String endTime`             | End local time              | Optional clock with a native end date.                                              |
| `global String pointValue`          | Point ISO value             | Same value type as the range; a zoned value may use another timezone.               |
| `global String otherStart`          | Other range start ISO       | Other range start ISO.                                                              |
| `global String otherEnd`            | Other range end ISO         | Other range end ISO.                                                                |
| `global List<String> ranges`        | Other ISO ranges            | Text collection of start/end intervals; slashes inside zone IDs are supported.      |
| `global String duration`            | Split duration              | Positive ISO duration. Calendar units are evaluated at each boundary.               |
| `global Integer maximumResults`     | Maximum results             | 1–1000, default 100. Exceeding the limit returns an error, never a partial success. |
| `global String rangesText`          | Fixed ISO ranges            | One start/end interval per line. Use this or a text collection, not both.           |
| `global Date pointDate`             | Point native date           | Use one native or ISO source for this value.                                        |
| `global Datetime pointInstant`      | Point native datetime       | Use one native or ISO source for this value.                                        |
| `global String pointTime`           | Point local time            | Use one native or ISO source for this value.                                        |
| `global Date otherStartDate`        | Other start native date     | Use one native or ISO source for this value.                                        |
| `global Datetime otherStartInstant` | Other start native datetime | Use one native or ISO source for this value.                                        |
| `global String otherStartTime`      | Other start local time      | Use one native or ISO source for this value.                                        |
| `global Date otherEndDate`          | Other end native date       | Use one native or ISO source for this value.                                        |
| `global Datetime otherEndInstant`   | Other end native datetime   | Use one native or ISO source for this value.                                        |
| `global String otherEndTime`        | Other end local time        | Use one native or ISO source for this value.                                        |

### ChronoRangeToolsInput

```apex
global ChronoRangeToolsInput()
```

Required Flow constructor.

Types: [ChronoRangeToolsInput](ChronoRangeToolsInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
