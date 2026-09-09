# ChronoValueService

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoValueService`.

Direct bulk Apex API. Flow adapters use these same services.

Call these static entry points from subscriber Apex. Core operations return new values and validate their source. The package owns the implementation behind these signatures. See [Apex usage](../../handbook/apex.md) and [arithmetic semantics](../../handbook/arithmetic.md).

## Declaration

```apex
global with sharing class ChronoValueService
```

Direct bulk Apex API. Flow adapters use these same services.

Types: [ChronoValueService](ChronoValueService.md).

## ChronoValueService

### convert

```apex
global static List<ChronoValueResult> convert(List<ChronoConvertInput> requests)
```

Bulk Convert operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoConvertInput](ChronoConvertInput.md), [ChronoValueResult](ChronoValueResult.md).

### create

```apex
global static List<ChronoValueResult> create(List<ChronoCreateValueInput> requests)
```

Bulk CreateValue operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoCreateValueInput](ChronoCreateValueInput.md), [ChronoValueResult](ChronoValueResult.md).

### replace

```apex
global static List<ChronoValueResult> replace(List<ChronoReplaceValueInput> requests)
```

Bulk ReplaceValue operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoReplaceValueInput](ChronoReplaceValueInput.md), [ChronoValueResult](ChronoValueResult.md).

### parse

```apex
global static List<ChronoValueResult> parse(List<ChronoParseValueInput> requests)
```

Bulk ParseValue operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoParseValueInput](ChronoParseValueInput.md), [ChronoValueResult](ChronoValueResult.md).

### validate

```apex
global static List<ChronoValidationResult> validate(List<ChronoValidateValueInput> requests)
```

Bulk ValidateValue operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoValidateValueInput](ChronoValidateValueInput.md), [ChronoValidationResult](ChronoValidationResult.md).

### convertEpoch

```apex
global static List<ChronoEpochResult> convertEpoch(List<ChronoEpochValueInput> requests)
```

Bulk EpochValue operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoEpochResult](ChronoEpochResult.md), [ChronoEpochValueInput](ChronoEpochValueInput.md).

### details

```apex
global static List<ChronoDetailsResult> details(List<ChronoValueDetailsInput> requests)
```

Bulk ValueDetails operation. Inputs are unchanged; null/empty lists return empty results. Ordinary errors are isolated per item; governor limits still apply.

Types: [ChronoDetailsResult](ChronoDetailsResult.md), [ChronoValueDetailsInput](ChronoValueDetailsInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
