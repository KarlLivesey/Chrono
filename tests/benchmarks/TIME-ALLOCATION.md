# Time allocation benchmark

Measured on 8 September 2026 through installed managed package **0.1.0.15** in
the existing `chrono-subscriber` org. One warm-up and three measured samples each
run in a separate transaction. Every sample allocates **200 distinct four-hour
requests** across London, New York, Sydney and UTC, using four named blocks and
64 native holidays. Assertions check exact block totals and reconciliation for
every request, including holiday replacement.

| Measurement                            |         Result |
| -------------------------------------- | -------------: |
| Median allocation CPU per 200 requests |       4,643 ms |
| Measured allocation CPU range          | 4,328–4,661 ms |
| Highest measured total transaction CPU |       4,689 ms |
| Remaining CPU in that transaction      |       5,311 ms |
| Highest measured heap after allocation |  217,688 bytes |

Total transaction CPU includes setup and assertions. The warm-up used 4,897 ms
total CPU. The observed synchronous CPU limit was 10,000 ms. These measurements
are workload-specific observations, not guarantees of headroom for arbitrary
blocks, date ranges or additional Flow work. Browser rendering and network
latency are not measured.

[Raw report](results/time-allocation-0.1.0.15.json)

Repeat with:

```sh
python3 tests/benchmarks/run-apex.py --target-org chrono-subscriber \
  --label Chrono-0.1.0.15 --case time-allocation-distinct --samples 3 \
  --output tests/benchmarks/results/time-allocation-0.1.0.15.json
```
