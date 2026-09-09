# Supported behaviour and limits

Chrono is a native-backed Salesforce library, not a complete JavaScript Temporal
polyfill. The limits below are part of choosing an appropriate operation, not
requests to add missing features to an existing workflow.

| Area                      | Defined limit or behaviour                                                     |
| ------------------------- | ------------------------------------------------------------------------------ |
| Precision                 | Millisecond arithmetic; longer input fractions truncated                       |
| Calendars                 | Native Gregorian model; alternative annotations rejected                       |
| Operating-hours traversal | At most 3,660 calendar days                                                    |
| Working difference        | At most 3,660 UTC dates per item                                               |
| Availability              | At most 366 days                                                               |
| Recurrence                | At most 3,660 days and 1–1,000 results                                         |
| Zone transition search    | At most 366 days; hourly brackets with millisecond bisection                   |
| Allocation                | 50 blocks, 1,000 holidays, 366 days, default 1,000 segment rows; maximum 5,000 |
| Picker schedule search    | At most 50 matches per search                                                  |
| Picker structured filter  | At most ten ANDed Name/TimeZone criteria                                       |
| Locale display patterns   | 279 Salesforce locale IDs; unknown locale falls back to ISO                    |

## Timezone coverage

Salesforce provides the offset rules. Chrono does not bundle its own timezone
database. Zone-interval traversal samples offsets every six hours; transition
listing uses hourly brackets. Those algorithms assume multiple offset changes
do not occur within their sampling interval. Detected transitions are located
to millisecond precision.

Historical offsets containing seconds cannot currently be serialised as normal
zoned strings. An explicit supplied-offset workflow is distinct from claiming
that every historical named-zone instant has a supported canonical string.

## Governor limits still apply

Search limits are safety bounds, not performance promises. Complex allocation
overlaps, holiday recurrence and many schedule windows can exhaust CPU or heap
before a day-count limit. Supplied schedule records avoid queries; saved loads
need object/field access and consume query resources.

The measured mixed-workload subscriber benchmark used 200 distinct allocations
and 20 real Flow interviews per transaction. Three post-warmup measurements used
6,063 / 6,301 / 7,023 ms CPU; worst total including setup/assertions was 7,053 ms
of a 10,000 ms limit. These are measurements for 0.1.0.18's implementation,
unchanged in the released 0.1.0.19 candidate, not a universal capacity guarantee.

## Deliberate exclusions

There is no external holiday feed, natural-language date guessing, background
scheduling engine, price calculation, alternative calendar support or
sub-millisecond arithmetic. RRULE support is a strict documented subset.
Long duration/relative wording is English; locale-aware date/time display has
a broader set of supported patterns.

## Evidence boundaries

The released package passed standard validation, package coverage and installed
subscriber tests. Browser rendering was not inspected, in accordance with this
project's no-screen-capture requirement. An upgrade from a released ancestor was
not possible for the first release; that requires a later descendant candidate.

See [release notes](releases.md) for exact test counts. Benchmark measurements
use a warmup followed by separate measured transactions, assert the results and
record CPU including setup as well as the calculation itself.
