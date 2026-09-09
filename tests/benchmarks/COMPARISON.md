# Hardened package benchmark comparison

Same subscriber org and workloads: **0.1.0.10 → 0.1.0.11**. CPU milliseconds are
medians of three measured samples after one warm-up. All output assertions passed.
See [methodology](README.md) and raw samples in `results`.

| Case                         | Operations/items | Baseline CPU ms | Hardened CPU ms |  Change |
| ---------------------------- | ---------------: | --------------: | --------------: | ------: |
| parse-format-PlainDate       |              200 |              39 |              45 |  +15.4% |
| parse-format-PlainTime       |              200 |              31 |              36 |  +16.1% |
| parse-format-PlainDateTime   |              200 |              76 |              77 |   +1.3% |
| parse-format-Instant         |              200 |              72 |              87 |  +20.8% |
| parse-format-ZonedDateTime   |              200 |             177 |             204 |  +15.3% |
| parse-format-PlainYearMonth  |              200 |              28 |              36 |  +28.6% |
| parse-format-PlainMonthDay   |              200 |              26 |              23 |  -11.5% |
| parse-format-Duration        |              200 |              42 |             103 | +145.2% |
| calendar-dst-arithmetic      |              200 |             114 |             157 |  +37.7% |
| convert-200-repeated         |              200 |              13 |              15 |  +15.4% |
| convert-200-distinct         |              200 |             259 |             313 |  +20.8% |
| working-hours-native-records |              200 |             770 |             881 |  +14.4% |
| calendar-difference-bulk     |              200 |              28 |              30 |   +7.1% |
| recurrence-weekly-dst        |              200 |              58 |              61 |   +5.2% |
| availability-collection      |              200 |              65 |              62 |   -4.6% |
| flow-convert-interviews      |               20 |            1288 |            2009 |  +56.0% |

The numeric/date checks add work. Duration parse/serialise increased from
42 to 103 ms per 200 operations (0.210 → 0.515 ms each); the overflow protections
are retained. Repeated conversions still benefit from invocation-local reuse:
15 ms for 200 repeated inputs compared with 313 ms for distinct inputs.

The real Flow case measures separately started interviews, including Salesforce's
Flow runtime overhead. It is substantially slower than invoking one bulk action.
It also increased between runs; that difference must not be attributed entirely
to the arithmetic changes. The raw min/median/max measurements remain available,
and a separate repeat measured **1525 ms** for 20 interviews
(min–max 1496–1624 ms), versus 2,009 ms in the first hardened run.
That variation is why these measurements do not impose a fixed CI timing threshold.

Client measurements in `results/hardened-client.json` include the nine production
engine/input workloads. They use Node's native Temporal implementation, not a
Salesforce browser or an Apex network round trip. The existing engine's gap
boundary search remains the most expensive client case, at about 5 ms per call
in this run. The strict exact-datetime parser is about 0.0013 ms per call.
