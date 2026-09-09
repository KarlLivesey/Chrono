# ChronoZoneToolsAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoZoneToolsAction`.

Convert zones, inspect date-specific offsets and search bounded timezone transitions.

## Declaration

```apex
global with sharing class ChronoZoneToolsAction
```

Convert zones, inspect date-specific offsets and search bounded timezone transitions.

Types: [ChronoZoneToolsAction](ChronoZoneToolsAction.md).

## ChronoZoneToolsAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoZoneResult> run(List<Request> requests)
```

Convert zones, inspect date-specific offsets and search bounded timezone transitions.

Types: [ChronoZoneResult](ChronoZoneResult.md).

## ChronoZoneToolsAction.Request

| Field / property                 | Flow label           | Contract                                                                                       |
| -------------------------------- | -------------------- | ---------------------------------------------------------------------------------------------- |
| `global String operation`        | Operation            | Operation.                                                                                     |
| `global String valueType`        | Value type           | Value type.                                                                                    |
| `global String value`            | ISO value            | ISO value.                                                                                     |
| `global Date dateValue`          | Native date          | Native date.                                                                                   |
| `global Datetime instantValue`   | Native datetime      | Native datetime.                                                                               |
| `global String timeValue`        | Local time           | ISO time for a native date and time input.                                                     |
| `global String timeZoneId`       | Timezone             | Required when resolving local time or inspecting an instant.                                   |
| `global String disambiguation`   | Repeated-time policy | Repeated-time policy.                                                                          |
| `global String targetTimeZoneId` | Target timezone      | Target timezone.                                                                               |
| `global String conversionMode`   | Keep                 | Keep.                                                                                          |
| `global String suppliedOffset`   | Supplied UTC offset  | An explicit signed offset such as +01:00. The result also includes the actual zone projection. |
| `global String search`           | Filter timezone IDs  | Filter timezone IDs.                                                                           |
| `global Datetime endInstant`     | Search end           | Exclusive end for listing transitions. Searches are limited to 366 days.                       |
| `global Integer searchDays`      | Search days          | 1–366 days for next or previous transition. Defaults to 366.                                   |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
