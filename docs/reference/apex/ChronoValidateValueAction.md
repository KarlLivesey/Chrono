# ChronoValidateValueAction

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoValidateValueAction`.

Validate a native or ISO value without failing other interviews.

## Declaration

```apex
global with sharing class ChronoValidateValueAction
```

Validate a native or ISO value without failing other interviews.

Types: [ChronoValidateValueAction](ChronoValidateValueAction.md).

## ChronoValidateValueAction

```apex
global class Request
```

Inputs for one Flow interview.

### run

```apex
global static List<ChronoValidationResult> run(List<Request> requests)
```

Validate a native or ISO value without failing other interviews.

Types: [ChronoValidationResult](ChronoValidationResult.md).

## ChronoValidateValueAction.Request

| Field / property               | Flow label           | Contract                                                     |
| ------------------------------ | -------------------- | ------------------------------------------------------------ |
| `global String valueType`      | Value type           | Value type.                                                  |
| `global String value`          | ISO value            | ISO value.                                                   |
| `global Date dateValue`        | Native date          | Native date.                                                 |
| `global Datetime instantValue` | Native datetime      | Native datetime.                                             |
| `global String timeValue`      | Local time           | ISO time for a native date and time input.                   |
| `global String timeZoneId`     | Timezone             | Required when resolving local time or inspecting an instant. |
| `global String disambiguation` | Repeated-time policy | Repeated-time policy.                                        |

### Request

```apex
global Request()
```

Required Flow constructor.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
