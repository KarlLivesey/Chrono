# Divide worked time into billing blocks

Time allocation divides a worked interval into named blocks and returns their
durations. It does not calculate money, rates, tax or invoices. Use its totals
as inputs to your billing process.

## A basic allocation

For work on Monday 08:00–12:00, define these local blocks in one explicit zone:

| Key     | Block       | Expected allocation |
| ------- | ----------- | ------------------- |
| `one`   | 08:00–10:00 | 2 hours             |
| `two`   | 10:00–11:00 | 1 hour              |
| `three` | 11:00–15:00 | 1 hour              |

Use **Allocate time to blocks**, or call
`skel.ChronoTimeAllocationService.allocate`. The Flow editor has inline block
rows, weekday selection, normal/holiday classification and priority ordering.
Fixed definitions can also come from a Text resource via `blocksText`.

## Choose overlap behaviour

| Mode               | When two or more blocks match                      |
| ------------------ | -------------------------------------------------- |
| `strict` (default) | Fail; no partial allocation                        |
| `lax`              | First configured matching block wins               |
| `duplicate`        | Every matching block gets the full duration        |
| `split`            | Divide the duration equally across current matches |

Input order defines priority. Keep stable block keys so downstream totals refer
to the same business band, even when labels change. Blocks with zero credit
remain present in their original order.

Split shares are recalculated each time the matching set changes. Ten minutes
shared by three blocks gives exactly 3m20s each at default precision. If you
explicitly choose whole minutes, the stable-priority distribution is 4/3/3.

## Holidays have their own blocks

Supply native Holiday records; they can be unsaved or recurring. Their dates
and partial-day windows use the block timezone. During holiday time, only holiday
blocks are eligible. A holiday with no matching holiday block is unallocated,
not charged to the normal-day band.

Holiday windows are unioned first, so overlapping Holiday records do not create
duplicate holiday time. An overnight normal block stops at a holiday midnight
unless an eligible holiday block covers the following time. Weekday restrictions
refer to the date on which the block starts.

## Elapsed versus clock time

Default `elapsed` measures actual instants and counts repeated hours actually
worked. `clock` measures the nominal difference between local endpoints. A local
00:00–03:00 shift is three clock hours even if a transition makes it two or four
elapsed hours.

Clock results have plain local segment endpoints, not exact zoned endpoints.
A backward transition that makes the local end earlier than the local start is
rejected in clock mode. Use elapsed mode when actual worked duration is required.

## Precision and reconciliation

Milliseconds are the default; select seconds or minutes only when your billing
rules require coarser units. Split rounding happens per changing overlap
segment. In lax mode, boundaries belonging only to losing blocks cannot reduce
the winner's credit: rounding applies to the continuous winning interval.

Every successful result reconciles:

```text
inputMilliseconds + duplicateMilliseconds
  = allocatedMilliseconds + unallocatedMilliseconds + roundingMilliseconds
```

Do not silently discard `unallocatedMilliseconds` or `roundingMilliseconds` when
reporting totals. Duplicate mode can legitimately allocate more time than the
worked interval because duplication is the requested rule.

## Worked intervals and limits

For split shifts or unpaid breaks, send separate worked intervals through the
collection action. Each retains its own result. Limits are 50 blocks, 1,000
holidays, 366 days and a default 1,000 segment rows, configurable up to 5,000.
Complex overlaps still share the caller's governor budget.

See [the precise allocation contract](../time-allocation.md),
[Flow field reference](../reference/actions/TimeAllocation.md) and
[Apex request](../reference/apex/ChronoTimeAllocationRequest.md). Example 13 covers
the 2/1/1-hour result and a separate Tuesday holiday block.
