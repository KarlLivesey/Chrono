# Time allocation and billing blocks

`ChronoTimeAllocationService.allocate(request)` breaks one continuous worked
interval into named time blocks. It calculates durations, not prices or invoices.
For split shifts or unpaid breaks, supply separate worked intervals to the
collection action. Each interval retains its own ordered result.

## Rules

- **Strict** (default): fail if worked time matches more than one eligible block.
- **Lax**: the first matching block in the configured list receives the time.
  Later matches remain visible with zero credit in the segment results.
- **Duplicate**: every matching block receives the entire overlapping duration.
- **Split**: divide each overlapping segment equally among its matching blocks.
  Recalculate shares when the matching set changes.

All boundaries are half-open: start included, end excluded. The block list defines
priority, both for lax selection and deterministic split rounding. Blocks have
stable keys and labels; adjacent blocks are never merged across different keys.
Totals include zero-credit blocks in the original order.

A block has start weekdays (ISO 1 Monday through 7 Sunday), a local start/end,
and a normal/holiday classification. An end before the start continues into the
next day. `00:00`–`24:00` means a full day; equal start/end times are rejected.
Weekdays apply to the date the block starts. Holiday classification applies to
**each actual calendar day**, so an overnight normal block stops at a holiday
midnight unless an eligible holiday block covers the following time.

Native `Holiday` collections provide the calendar, including unsaved, recurring,
partial-day and overlapping holiday records. Their dates and local hours are
interpreted in the required block timezone. Holiday windows are unioned before
classification: overlapping holiday records do not duplicate time. Holidays
replace normal blocks; a holiday with no matching holiday block is unallocated.
The service does not infer public holidays or query records. Flow can obtain the
relevant native Holiday records, including those associated with OperatingHours,
and pass the collection. No separate schedule wrapper is needed.

## Elapsed and clock time

**Elapsed** is the default and measures actual instants. Repeated hours count
actual time worked; nonexistent clock time contributes nothing. Segment endpoints
are zoned ISO strings.

**Clock** projects both worked endpoints into the block timezone and measures the
nominal local interval. A 00:00–03:00 interval is three clock hours even on a day
when elapsed time is two or four hours. Clock segment endpoints are plain ISO
date/time strings; they must not be mistaken for exact instants. If a backward
clock change makes the local end precede the local start, clock mode fails with
an instruction to use elapsed mode. Equal local endpoints have zero clock duration.
Local Flow inputs still require explicit timezone resolution; ambiguous endpoints
require a repeated-time choice. Use native/ISO exact endpoints when the occurrence
is already known.

## Rounding and reconciliation

The default allocation unit is one millisecond. Whole-second and whole-minute
allocation are optional. Within **each atomic segment**, split whole units equally
and award remaining whole units to the earliest matching blocks. For ten minutes
and three matches this gives:

- Milliseconds: 3 minutes 20 seconds each.
- Whole minutes: 4, 3 and 3 minutes.

Any sub-unit remainder is reported in `roundingMilliseconds`; it is never silently
dropped. Rounding happens per segment, not once over the entire worked interval.
In **lax mode**, rounding instead applies to each continuous interval with the
same winning block. Boundaries belonging only to losing blocks do not change
the winner's credit. Diagnostic segment rows retain millisecond precision; any
discarded remainder is attributed to the end of that winning interval. A gap
or a change of winner ends the interval. Default millisecond allocation discards
no whole milliseconds in either case.
Duplicate mode reports its additional pre-rounding budget in
`duplicateMilliseconds`. Every successful result satisfies:

```text
inputMilliseconds + duplicateMilliseconds
  = allocatedMilliseconds + unallocatedMilliseconds + roundingMilliseconds
```

`totals` and `segments` contain flat data rows with block key/label,
`matchedMilliseconds`, `allocatedMilliseconds` and `allocatedDuration` (the
credited ISO duration). Segment rows also include
start/end strings. Unallocated segments have a null block key and zero credited
milliseconds; their `matchedMilliseconds` is the uncovered duration. A zero-credit
row can also represent a lower-priority match or a rounded-down split share.

## Apex and Flow

```apex
skel.ChronoTimeBlock block = new skel.ChronoTimeBlock();
block.key = 'morning';
block.label = 'Morning';
block.weekdays = '1,2,3,4,5';
block.startTime = '08:00';
block.endTime = '12:00';

skel.ChronoTimeAllocationRequest request = new skel.ChronoTimeAllocationRequest();
request.startInstant = Datetime.newInstanceGmt(2026, 9, 7, 7, 0, 0);
request.endInstant = Datetime.newInstanceGmt(2026, 9, 7, 11, 0, 0);
request.timeZoneId = 'Europe/London';
request.blocks = new List<skel.ChronoTimeBlock>{ block };
request.overlapMode = 'split';
skel.ChronoTimeAllocationResult result = skel.ChronoTimeAllocationService.allocate(request);
```

The example uses subscriber Apex namespace qualification (`skel.`). Core input and output records
are data-only; validation, allocation and serialisation are performed by services.
Construct these managed-package inputs using their global constructors and fields,
as above. Subscriber-side `JSON.deserialize` into `ChronoTimeBlock` or
`ChronoTimeAllocationInput` is rejected by Salesforce. Flow's `blocksText` input
is parsed inside the package and remains supported.
The service does not mutate input records and performs no queries or DML.

Flow actions under **Chrono: Time allocation**:

- **Allocate time to blocks**
- **Allocate time to blocks (collection)**

They accept ISO date/local-datetime/instant/zoned-datetime inputs and native
Salesforce Date/Datetime variants through the existing editor controls. A native
Date means local midnight; interval ends remain exclusive. The custom editor
provides inline block rows, weekday buttons, holiday selection and priority moves.
Alternatively, bind `blocksText` to a Text resource containing the same definition:

```json
[
  {
    "key": "one",
    "label": "Block 1",
    "startTime": "08:00",
    "endTime": "10:00"
  },
  {
    "key": "two",
    "label": "Block 2",
    "startTime": "10:00",
    "endTime": "11:00"
  },
  {
    "key": "three",
    "label": "Block 3",
    "startTime": "11:00",
    "endTime": "15:00"
  },
  {
    "key": "holiday",
    "dayType": "holiday",
    "startTime": "08:00",
    "endTime": "12:00"
  }
]
```

`ChronoTimeBlock` is the native Apex block contract. Flow block configuration uses
Text; no core Chrono date/time objects or schedule wrappers cross that boundary.
Returned rows are top-level DTOs containing only primitive fields, following
[Salesforce's supported Flow types](https://developer.salesforce.com/docs/platform/lwc/guide/use-flow-data-types).
The dedicated subscriber fixtures check actual scalar/collection transport and a
Flow loop reading row fields; packaging evidence is recorded in `validation.md`.

Both actions preserve interview and collection order, isolate item failures and
return independent result graphs. Identical requests within an invocation reuse
the calculation. Invalid blocks, strict overlaps or limits produce an error with
no partial allocation. Limits are 50 blocks, 1000 holiday records, 366 days and
1000 segment rows by default (configurable to 5000). Complex inputs can still
consume the caller transaction's CPU budget; limits are not a performance guarantee.

`ChronoExampleTimeAllocation` demonstrates the three-block 2/1/1-hour result and
an unsaved Tuesday holiday. It writes no records. Its range picker uses the existing
compact Salesforce component; the block editor is reusable independently.
