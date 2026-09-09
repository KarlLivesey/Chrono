# ChronoParseValueInput

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoParseValueInput`.

Parse an explicitly specified numeric date and time pattern without guessing.

## Declaration

```apex
global with sharing class ChronoParseValueInput
```

Parse an explicitly specified numeric date and time pattern without guessing.

Types: [ChronoParseValueInput](ChronoParseValueInput.md).

## ChronoParseValueInput

| Field / property               | Flow label           | Contract                                                           |
| ------------------------------ | -------------------- | ------------------------------------------------------------------ |
| `global String valueType`      | Value type           | Value type.                                                        |
| `global String text`           | Text to parse        | Text to parse.                                                     |
| `global String pattern`        | Input pattern        | Supported tokens: yyyy MM dd HH mm ss SSS and quoted literal text. |
| `global String timeZoneId`     | Timezone             | Required when resolving local time or inspecting an instant.       |
| `global String disambiguation` | Repeated-time policy | Repeated-time policy.                                              |

### ChronoParseValueInput

```apex
global ChronoParseValueInput()
```

Required Flow constructor.

Types: [ChronoParseValueInput](ChronoParseValueInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
