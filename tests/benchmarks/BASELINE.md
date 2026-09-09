# Benchmark baseline

Installed subscriber package: **0.1.0.10**, before the numeric/date hardening.
See [methodology and commands](README.md) for sample definitions and limitations.

## Apex

CPU milliseconds per measured sample; three samples after one warm-up.

| Case                         | Operations/items | Median CPU ms | Min–max CPU ms |
| ---------------------------- | ---------------: | ------------: | -------------: |
| parse-format-PlainDate       |              200 |            39 |          39–43 |
| parse-format-PlainTime       |              200 |            31 |          31–31 |
| parse-format-PlainDateTime   |              200 |            76 |          76–78 |
| parse-format-Instant         |              200 |            72 |          71–73 |
| parse-format-ZonedDateTime   |              200 |           177 |        174–229 |
| parse-format-PlainYearMonth  |              200 |            28 |          26–30 |
| parse-format-PlainMonthDay   |              200 |            26 |          22–28 |
| parse-format-Duration        |              200 |            42 |          42–42 |
| calendar-dst-arithmetic      |              200 |           114 |        113–115 |
| convert-200-repeated         |              200 |            13 |          12–13 |
| convert-200-distinct         |              200 |           259 |        211–284 |
| working-hours-native-records |              200 |           770 |        756–783 |
| calendar-difference-bulk     |              200 |            28 |          27–28 |
| recurrence-weekly-dst        |              200 |            58 |          54–59 |
| availability-collection      |              200 |            65 |          65–71 |
| flow-convert-interviews      |               20 |          1288 |      1206–1322 |

## Native Temporal client engine

Node v24.17.0, darwin arm64; 200 operations per sample, five measured samples after one warm-up. These measure engine execution, not browser rendering or network requests.

| Case                   | Median elapsed ms / 200 | Median ms / operation |
| ---------------------- | ----------------------: | --------------------: |
| resolve-normal         |                  94.464 |                0.4723 |
| resolve-repeated       |                 159.812 |                0.7991 |
| resolve-gap-boundaries |                 979.936 |                4.8997 |
| project-instant        |                  30.723 |                0.1536 |
| explicit-offset        |                   0.318 |                0.0016 |
| four-zone-offsets      |                 276.826 |                1.3841 |
