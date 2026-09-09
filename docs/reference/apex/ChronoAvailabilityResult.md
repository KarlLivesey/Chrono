# ChronoAvailabilityResult

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoAvailabilityResult`.

Independent Flow output with native and ISO fields.

## Declaration

```apex
global with sharing class ChronoAvailabilityResult
```

Independent Flow output with native and ISO fields.

Types: [ChronoAvailabilityResult](ChronoAvailabilityResult.md).

## ChronoAvailabilityResult

| Field / property                      | Flow label                                 | Contract                                    |
| ------------------------------------- | ------------------------------------------ | ------------------------------------------- |
| `global Boolean success`              | Success                                    | Success.                                    |
| `global String errorMessage`          | Error                                      | Error.                                      |
| `global Boolean isValid`              | Valid schedule                             | Valid schedule.                             |
| `global String validationMessage`     | Validation message                         | Validation message.                         |
| `global Boolean found`                | Found availability                         | Found availability.                         |
| `global Boolean containsRange`        | Entire interval is open                    | Entire interval is open.                    |
| `global List<String> ranges`          | Open or appointment ISO intervals          | Open or appointment ISO intervals.          |
| `global List<String> openingValues`   | Opening zoned ISO values                   | Opening zoned ISO values.                   |
| `global List<String> closingValues`   | Exclusive closing zoned ISO values         | Exclusive closing zoned ISO values.         |
| `global List<Date> workingDates`      | Working dates in primary schedule timezone | Working dates in primary schedule timezone. |
| `global List<Date> holidayDates`      | Holiday dates in primary schedule timezone | Holiday dates in primary schedule timezone. |
| `global List<Holiday> holidayRecords` | Matching holiday records                   | Matching holiday records.                   |
| `global Long milliseconds`            | Elapsed open milliseconds                  | Elapsed open milliseconds.                  |
| `global String timeZoneId`            | Primary schedule timezone                  | Primary schedule timezone.                  |

### ChronoAvailabilityResult

```apex
global ChronoAvailabilityResult()
```

Required Flow constructor.

Types: [ChronoAvailabilityResult](ChronoAvailabilityResult.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
