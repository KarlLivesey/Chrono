# ChronoFormatValueInput

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoFormatValueInput`.

Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output.

## Declaration

```apex
global with sharing class ChronoFormatValueInput
```

Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output.

Types: [ChronoFormatValueInput](ChronoFormatValueInput.md).

## ChronoFormatValueInput

| Field / property                   | Flow label                    | Contract                                                                                          |
| ---------------------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------- |
| `global String operation`          | Operation                     | Operation.                                                                                        |
| `global String valueType`          | Value type                    | Value type.                                                                                       |
| `global String value`              | ISO value                     | ISO value.                                                                                        |
| `global Date dateValue`            | Native date                   | Native date.                                                                                      |
| `global Datetime instantValue`     | Native datetime               | Native datetime.                                                                                  |
| `global String timeValue`          | Local time                    | ISO time for a native date and time input.                                                        |
| `global String timeZoneId`         | Timezone                      | Required when resolving local time or inspecting an instant.                                      |
| `global String disambiguation`     | Repeated-time policy          | Repeated-time policy.                                                                             |
| `global String style`              | Display length                | Component order and names follow the context user locale. Gregorian years always use four digits. |
| `global String pattern`            | Explicit output pattern       | Optional Apex date-format pattern. Overrides display length; parsing never guesses this pattern.  |
| `global Boolean includeZone`       | Append timezone offset and ID | Append timezone offset and ID.                                                                    |
| `global String endValue`           | Range end ISO value           | The same value family as the start.                                                               |
| `global String separator`          | Range separator               | Defaults to an en dash.                                                                           |
| `global String durationStyle`      | Duration style                | ISO is language-neutral; compact uses unit symbols and long uses English unit names.              |
| `global String referenceValue`     | Relative reference ISO value  | Supply a reference of the same type, or another exact value.                                      |
| `global String relativeUnit`       | Relative elapsed unit         | Auto chooses elapsed seconds, minutes, hours or 24-hour days.                                     |
| `global Date referenceDate`        | Reference native date         | Use one native or ISO source for this value.                                                      |
| `global Datetime referenceInstant` | Reference native datetime     | Use one native or ISO source for this value.                                                      |
| `global String referenceTime`      | Reference local time          | Use one native or ISO source for this value.                                                      |
| `global Date endDate`              | Range end native date         | Use one native or ISO source for this value.                                                      |
| `global Datetime endInstant`       | Range end native datetime     | Use one native or ISO source for this value.                                                      |
| `global String endTime`            | Range end local time          | Use one native or ISO source for this value.                                                      |

### ChronoFormatValueInput

```apex
global ChronoFormatValueInput()
```

Required Flow constructor.

Types: [ChronoFormatValueInput](ChronoFormatValueInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
