# Distinct workloads and duration parsing

Measured on 8 September 2026 through installed managed package **0.1.0.12** in the
existing `chrono-subscriber` org. Each row has one warm-up and three measured
samples, with 200 operations or distinct requests per sample.

| Workload                            | Median CPU | Measured range | Highest total transaction CPU |
| ----------------------------------- | ---------: | -------------: | ----------------------------: |
| Duration parse/serialise            |      80 ms |       77–88 ms |                        338 ms |
| Availability, 200 distinct requests |   3,239 ms | 3,129–3,466 ms |                      4,285 ms |
| Recurrence, 200 distinct requests   |   4,919 ms | 4,888–6,089 ms |                      6,135 ms |

Availability and recurrence use four schedule timezones, ten weekly slots and
64 holidays. Every result is checked against independently calculated expected
windows or dates. These heavy samples each have a separate transaction; duration
samples share one transaction. Total CPU includes setup and assertions (and all
samples for duration). The observed synchronous limit was 10,000 ms. The most
expensive measured recurrence transaction therefore retained 3,865 ms; this does
not promise equivalent headroom with arbitrary schedules or additional Flow work.

Reusing the duration regex and numeric bounds reduced the median from **118 ms**
in the immediately preceding 0.1.0.11 run to **80 ms**, about **32%** for this
workload. All validation remains active. Salesforce timing varies; this is an
observed comparison, not a fixed performance guarantee or CI threshold.

Raw reports:

- [Before duration caching](results/duration-before-cache.json)
- [Installed follow-up measurements](results/followup-apex.json)
- [Client algorithm measurements](results/followup-client.json)

The client report covers nine algorithm workloads using production modules in
Node. It does not measure browser rendering, LWS overhead or network latency.
