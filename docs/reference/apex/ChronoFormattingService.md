# ChronoFormattingService

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoFormattingService`.

Direct bulk Apex API. Flow adapters use these same services.

Call these static entry points from subscriber Apex. Core operations return new values and validate their source. The package owns the implementation behind these signatures. See [Apex usage](../../handbook/apex.md) and [arithmetic semantics](../../handbook/arithmetic.md).

## Declaration

```apex
global with sharing class ChronoFormattingService
```

Direct bulk Apex API. Flow adapters use these same services.

Types: [ChronoFormattingService](ChronoFormattingService.md).

## ChronoFormattingService

### format

```apex
global static List<ChronoFormatResult> format(List<ChronoFormatValueInput> requests)
```

Bulk FormatValue operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoFormatResult](ChronoFormatResult.md), [ChronoFormatValueInput](ChronoFormatValueInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
