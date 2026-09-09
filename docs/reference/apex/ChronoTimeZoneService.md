# ChronoTimeZoneService

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoTimeZoneService`.

Direct bulk Apex API. Flow adapters use these same services.

Call these static entry points from subscriber Apex. Core operations return new values and validate their source. The package owns the implementation behind these signatures. See [Apex usage](../../handbook/apex.md) and [arithmetic semantics](../../handbook/arithmetic.md).

## Declaration

```apex
global with sharing class ChronoTimeZoneService
```

Direct bulk Apex API. Flow adapters use these same services.

Types: [ChronoTimeZoneService](ChronoTimeZoneService.md).

## ChronoTimeZoneService

### resolveLocal

```apex
global static List<ChronoLocalResolutionResult> resolveLocal(List<ChronoResolveLocalInput> requests)
```

Bulk ResolveLocal operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoLocalResolutionResult](ChronoLocalResolutionResult.md), [ChronoResolveLocalInput](ChronoResolveLocalInput.md).

### calculate

```apex
global static List<ChronoZoneResult> calculate(List<ChronoZoneToolsInput> requests)
```

Bulk ZoneTools operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoZoneResult](ChronoZoneResult.md), [ChronoZoneToolsInput](ChronoZoneToolsInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
