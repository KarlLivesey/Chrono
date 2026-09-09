# ChronoTimeAllocationInput

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoTimeAllocationInput`.

Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.

## Declaration

```apex
global with sharing class ChronoTimeAllocationInput
```

Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.

Types: [ChronoTimeAllocationInput](ChronoTimeAllocationInput.md).

## ChronoTimeAllocationInput

| Field / property                 | Flow label           | Contract                                                                                                                                  |
| -------------------------------- | -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `global String valueType`        | Value type           | Value type.                                                                                                                               |
| `global String value`            | ISO value            | ISO value.                                                                                                                                |
| `global Date dateValue`          | Native date          | Native date.                                                                                                                              |
| `global Datetime instantValue`   | Native datetime      | Native datetime.                                                                                                                          |
| `global String timeValue`        | Local time           | ISO time for a native date and time input.                                                                                                |
| `global String timeZoneId`       | Block timezone       | Required. All block clocks and supplied holiday dates use this timezone.                                                                  |
| `global String disambiguation`   | Repeated-time policy | Repeated-time policy.                                                                                                                     |
| `global String endValue`         | End ISO value        | End ISO value.                                                                                                                            |
| `global Date endDate`            | End native date      | End native date.                                                                                                                          |
| `global Datetime endInstant`     | End native datetime  | End native datetime.                                                                                                                      |
| `global String endTime`          | End local time       | Optional clock with a native end date.                                                                                                    |
| `global String blocksText`       | Time blocks          | Ordered named blocks. Configure here or supply the same JSON definition from a Text resource.                                             |
| `global List<Holiday> holidays`  | Bank holidays        | Native Holiday record collection, including unsaved or recurring holidays. Dates use the block timezone.                                  |
| `global String overlapMode`      | Overlapping blocks   | Strict rejects matching overlaps; lax uses the first block; duplicate credits every block; split shares time equally.                     |
| `global String timeBasis`        | Count time as        | Default elapsed: actual time. Clock: local endpoint difference, counting skipped clock time and repeated clock time once.                 |
| `global String allocationUnit`   | Allocate in units of | Default millisecond. Whole units are distributed per segment; remaining units go to earlier blocks. Sub-unit time is reported separately. |
| `global Integer maximumSegments` | Maximum segment rows | Default 1000; allowed 1–5000. Exceeding the limit fails without partial totals.                                                           |

### ChronoTimeAllocationInput

```apex
global ChronoTimeAllocationInput()
```

Required Flow constructor.

Types: [ChronoTimeAllocationInput](ChronoTimeAllocationInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
