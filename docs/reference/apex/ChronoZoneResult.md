# ChronoZoneResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoZoneResult`.

Independent Flow output with native and ISO fields.

## Declaration

```apex
global with sharing class ChronoZoneResult
```

Independent Flow output with native and ISO fields.

Types: [ChronoZoneResult](ChronoZoneResult.md).

## ChronoZoneResult

| Field / property                         | Flow label                        | Contract                           |
| ---------------------------------------- | --------------------------------- | ---------------------------------- |
| `global Boolean success`                 | Success                           | Success.                           |
| `global String errorMessage`             | Error                             | Error.                             |
| `global String value`                    | Zoned ISO value                   | Zoned ISO value.                   |
| `global Datetime instantValue`           | Exact datetime                    | Exact datetime.                    |
| `global String localValue`               | Local ISO date and time           | Local ISO date and time.           |
| `global String timeZoneId`               | Timezone                          | Timezone.                          |
| `global Integer offsetSeconds`           | Actual UTC offset seconds         | Actual UTC offset seconds.         |
| `global String abbreviation`             | Timezone abbreviation             | Timezone abbreviation.             |
| `global String suppliedValue`            | Local value with supplied offset  | Local value with supplied offset.  |
| `global Boolean isOverride`              | Offset differs from zone rules    | Offset differs from zone rules.    |
| `global String otherValue`               | Other zoned value                 | Other zoned value.                 |
| `global Integer offsetDifferenceSeconds` | Other minus source offset seconds | Other minus source offset seconds. |
| `global List<String> timeZoneIds`        | Timezone IDs                      | Timezone IDs.                      |
| `global List<String> transitionValues`   | Transitions as zoned ISO values   | Transitions as zoned ISO values.   |
| `global List<Integer> offsetsBefore`     | Offsets before each transition    | Offsets before each transition.    |
| `global List<Integer> offsetsAfter`      | Offsets after each transition     | Offsets after each transition.     |
| `global Boolean found`                   | Found                             | Found.                             |

### ChronoZoneResult

```apex
global ChronoZoneResult()
```

Required Flow constructor.

Types: [ChronoZoneResult](ChronoZoneResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
