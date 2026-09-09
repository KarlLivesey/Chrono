// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { readFile, writeFile } from "node:fs/promises";
import assert from "node:assert/strict";
import { performance } from "node:perf_hooks";
const output = process.argv[2];
if (!output || !globalThis.Temporal)
  throw new Error(
    "Usage: node --harmony-temporal tests/benchmarks/run-client.mjs output.json"
  );
const source = await readFile(
  new URL(
    "../../force-app/main/default/lwc/chronoPickerEngine/chronoPickerEngine.js",
    import.meta.url
  ),
  "utf8"
);
const engineUrl = `data:text/javascript;base64,${Buffer.from(source.replace(/export\s*\{[^}]+\}\s*from\s*["']\.\/schedule["'];?/g, "")).toString("base64")}`;
const engine = await import(engineUrl);
const valuesSource = await readFile(
  new URL(
    "../../force-app/main/default/lwc/chronoInputValues/chronoInputValues.js",
    import.meta.url
  ),
  "utf8"
);
const values = await import(
  `data:text/javascript;base64,${Buffer.from(valuesSource.replace("c/chronoPickerEngine", engineUrl)).toString("base64")}`
);
const fallback = () => {
  throw new Error("Expected native Temporal, not an Apex fallback");
};
const cases = [
  [
    "duration-roundtrip",
    () =>
      values.durationText(values.durationParts("-P1Y2M3W4DT5H6M7.987654321S")),
    (v) => assert.equal(v, "-P14M25DT18367.987S")
  ],
  [
    "exact-iso-milliseconds",
    () =>
      values.exactMillis("2026-09-08T09:15:12.123456789+01:00[Europe/London]"),
    (v) => assert.equal(v, Date.parse("2026-09-08T08:15:12.123Z"))
  ],
  [
    "partial-date",
    () => values.partialText("monthday", null, 2, 29),
    (v) => assert.equal(v, "--02-29")
  ],

  [
    "resolve-normal",
    () => engine.resolveLocal("2026-09-08", "10:15", "Europe/London", fallback),
    (v) => assert.equal(v[0].instantValue, "2026-09-08T09:15:00.000Z")
  ],
  [
    "resolve-repeated",
    () => engine.resolveLocal("2026-10-25", "01:30", "Europe/London", fallback),
    (v) =>
      assert.deepEqual(
        v.map((x) => x.offsetSeconds),
        [3600, 0]
      )
  ],
  [
    "resolve-gap-boundaries",
    () => engine.resolveLocal("2026-03-29", "01:30", "Europe/London", fallback),
    (v) =>
      assert.deepEqual(
        v.map((x) => x.localValue),
        ["2026-03-29T00:59:59.999", "2026-03-29T02:00:00.000"]
      )
  ],
  [
    "project-instant",
    () =>
      engine.projectInstant("2026-09-08T09:15:00Z", "Asia/Kathmandu", fallback),
    (v) => assert.equal(v.localValue, "2026-09-08T15:00:00.000")
  ],
  [
    "explicit-offset",
    () => engine.overrideCandidate("2026-03-15", "10:00", "+01:00"),
    (v) => assert.equal(v.instantValue, "2026-03-15T09:00:00.000Z")
  ],
  [
    "four-zone-offsets",
    () =>
      engine.describeZones(
        [
          "Europe/London",
          "America/New_York",
          "Australia/Sydney",
          "Asia/Kathmandu"
        ],
        "2026-03-15",
        "10:00",
        fallback
      ),
    (v) => assert.equal(v["Europe/London"], "UTC+00:00")
  ]
];
const report = {
  createdAt: new Date().toISOString(),
  node: process.version,
  platform: process.platform,
  architecture: process.arch,
  operationsPerSample: 200,
  measuredSamples: 5,
  warmupSamples: 1,
  cases: []
};
for (const [name, run, verify] of cases) {
  const samples = [];
  for (let sample = -1; sample < 5; sample++) {
    let result;
    const start = performance.now();
    for (let index = 0; index < 200; index++) result = await run();
    const elapsedMs = performance.now() - start;
    verify(result);
    if (sample >= 0) samples.push(elapsedMs);
  }
  const sorted = [...samples].sort((a, b) => a - b);
  const median = sorted[2];
  report.cases.push({
    name,
    samplesMs: samples,
    medianMs: median,
    medianMsPerOperation: median / 200
  });
  console.log(`${name}: ${median.toFixed(3)} ms / 200 operations`);
}
await writeFile(output, JSON.stringify(report, null, 2) + "\n", { flag: "wx" });
