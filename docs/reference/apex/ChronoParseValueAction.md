# ChronoParseValueAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoParseValueAction`.

Parse an explicitly specified numeric date and time pattern without guessing.

## Declaration

```apex
global with sharing class ChronoParseValueAction
```

Parse an explicitly specified numeric date and time pattern without guessing.

Types: [ChronoParseValueAction](ChronoParseValueAction.md).

## ChronoParseValueAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoFlowResult> run(List<Request> requests)
```

Parse an explicitly specified numeric date and time pattern without guessing.

Types: [ChronoFlowResult](ChronoFlowResult.md).

## ChronoParseValueAction.Request

| Field / property               | Flow label           | Contract                                                           |
| ------------------------------ | -------------------- | ------------------------------------------------------------------ |
| `global String valueType`      | Value type           | Value type.                                                        |
| `global String text`           | Text to parse        | Text to parse.                                                     |
| `global String pattern`        | Input pattern        | Supported tokens: yyyy MM dd HH mm ss SSS and quoted literal text. |
| `global String timeZoneId`     | Timezone             | Required when resolving local time or inspecting an instant.       |
| `global String disambiguation` | Repeated-time policy | Repeated-time policy.                                              |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
