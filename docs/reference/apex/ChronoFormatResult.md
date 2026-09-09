# ChronoFormatResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoFormatResult`.

Independent Flow output with native and ISO fields.

## Declaration

```apex
global with sharing class ChronoFormatResult
```

Independent Flow output with native and ISO fields.

Types: [ChronoFormatResult](ChronoFormatResult.md).

## ChronoFormatResult

| Field / property              | Flow label              | Contract                 |
| ----------------------------- | ----------------------- | ------------------------ |
| `global Boolean success`      | Success                 | Success.                 |
| `global String errorMessage`  | Error                   | Error.                   |
| `global String text`          | Formatted text          | Formatted text.          |
| `global String startText`     | Formatted start         | Formatted start.         |
| `global String endText`       | Formatted end           | Formatted end.           |
| `global String locale`        | Context user locale     | Context user locale.     |
| `global Boolean styleApplied` | Requested style applied | Requested style applied. |

### ChronoFormatResult

```apex
global ChronoFormatResult()
```

Required Flow constructor.

Types: [ChronoFormatResult](ChronoFormatResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
