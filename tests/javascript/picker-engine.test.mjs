// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { readFile } from "node:fs/promises";
import test from "node:test";
import assert from "node:assert/strict";
// Load the production ES module without changing the Salesforce project's module type.
const source = await readFile(
  new URL(
    "../../force-app/main/default/lwc/chronoPickerEngine/chronoPickerEngine.js",
    import.meta.url
  ),
  "utf8"
);
const {
  resolveLocal,
  projectInstant,
  validDate,
  overrideCandidate,
  projectOverride,
  parseOffset,
  describeZones,
  zoneAbbreviation
} = await import(
  `data:text/javascript;base64,${Buffer.from(source.replace(/export\s*\{[^}]+\}\s*from\s*["']\.\/schedule["'];?/g, "")).toString("base64")}`
);
const noFallback = () => {
  throw new Error("Native Temporal unexpectedly fell back");
};
test("explicit offsets preserve clock fields and round-trip without Temporal", () => {
  const saved = globalThis.Temporal;
  try {
    globalThis.Temporal = undefined;
    const value = overrideCandidate("2026-03-15", "10:00", "+01:00");
    assert.equal(value.instantValue, "2026-03-15T09:00:00.000Z");
    assert.equal(value.localValue, "2026-03-15T10:00:00.000");
    assert.equal(value.choice, "override");
    assert.deepEqual(projectOverride(value.instantValue, "+01:00"), value);
    assert.equal(
      overrideCandidate("2026-03-29", "01:30", "+01:00").instantValue,
      "2026-03-29T00:30:00.000Z"
    );
    assert.equal(
      overrideCandidate("2026-01-01", "00:00:00.001", "+05:45").instantValue,
      "2025-12-31T18:15:00.001Z"
    );
    assert.equal(parseOffset("-03:30"), -12600);
    assert.throws(() => parseOffset("+24:00"), /UTC offset/);
    assert.throws(() => parseOffset("BST"), /UTC offset/);
    assert.throws(
      () => overrideCandidate("0001-01-01", "00:00", "+01:00"),
      /supported date range/
    );
    assert.equal(zoneAbbreviation(value, "Europe/London"), "");
  } finally {
    globalThis.Temporal = saved;
  }
});
test("timezone search offsets use the entered date, including mismatched DST weeks", async () => {
  const zones = [
    "Europe/London",
    "America/New_York",
    "Australia/Sydney",
    "Asia/Kathmandu"
  ];
  const march = await describeZones(zones, "2026-03-15", "10:00", noFallback);
  assert.deepEqual(march, {
    "Europe/London": "UTC+00:00",
    "America/New_York": "UTC−04:00",
    "Australia/Sydney": "UTC+11:00",
    "Asia/Kathmandu": "UTC+05:45"
  });
  const july = await describeZones(zones, "2026-07-15", "10:00", noFallback);
  assert.equal(july["Europe/London"], "UTC+01:00");
  assert.equal(july["Australia/Sydney"], "UTC+10:00");
  const overlap = await describeZones(
    ["Europe/London"],
    "2026-10-25",
    "01:30",
    noFallback
  );
  assert.equal(overlap["Europe/London"], "UTC+01:00 / UTC+00:00");
  const gap = await describeZones(
    ["Europe/London"],
    "2026-03-29",
    "01:30",
    noFallback
  );
  assert.equal(gap["Europe/London"], "Skipped local time");
  assert.deepEqual(await describeZones(zones, "", "", noFallback), {});
});
test("timezone search uses one Apex batch when Temporal is unavailable", async () => {
  const saved = globalThis.Temporal;
  try {
    globalThis.Temporal = undefined;
    let count = 0;
    const result = await describeZones(
      ["Europe/London", "UTC"],
      "2026-07-01",
      "09:00",
      async (args) => {
        count++;
        assert.deepEqual(args.timeZoneIds, ["Europe/London", "UTC"]);
        return {
          "Europe/London": [{ offsetSeconds: 3600, choice: "exact" }],
          UTC: [{ offsetSeconds: 0, choice: "exact" }]
        };
      }
    );
    assert.equal(count, 1);
    assert.equal(result["Europe/London"], "UTC+01:00");
  } finally {
    globalThis.Temporal = saved;
  }
});
test("native Temporal is available for this conformance test", () =>
  assert.ok(globalThis.Temporal));
test("repeated time returns distinct instants and offsets", async () => {
  const result = await resolveLocal(
    "2026-10-25",
    "01:30",
    "Europe/London",
    noFallback
  );
  assert.deepEqual(
    result.map((x) => [x.instantValue, x.offsetSeconds, x.choice]),
    [
      ["2026-10-25T00:30:00.000Z", 3600, "earlier"],
      ["2026-10-25T01:30:00.000Z", 0, "later"]
    ]
  );
});
for (const [date, time, zone, previous, next] of [
  [
    "2026-03-29",
    "01:30",
    "Europe/London",
    "2026-03-29T00:59:59.999",
    "2026-03-29T02:00:00.000"
  ],
  [
    "2026-10-04",
    "02:15",
    "Australia/Lord_Howe",
    "2026-10-04T01:59:59.999",
    "2026-10-04T02:30:00.000"
  ],
  [
    "2011-12-30",
    "12:00",
    "Pacific/Apia",
    "2011-12-29T23:59:59.999",
    "2011-12-31T00:00:00.000"
  ]
])
  test(`nearest gap boundaries: ${zone}`, async () => {
    const result = await resolveLocal(date, time, zone, noFallback);
    assert.deepEqual(
      result.map((x) => x.localValue),
      [previous, next]
    );
    assert.deepEqual(
      result.map((x) => x.choice),
      ["backward", "forward"]
    );
    assert.equal(
      Date.parse(result[1].instantValue) - Date.parse(result[0].instantValue),
      1
    );
  });
test("normal time and instant projection preserve milliseconds", async () => {
  const [value] = await resolveLocal(
    "2026-09-06",
    "12:34:56.789",
    "Asia/Kathmandu",
    noFallback
  );
  assert.equal(value.instantValue, "2026-09-06T06:49:56.789Z");
  assert.equal(value.choice, "exact");
  assert.deepEqual(
    await projectInstant(value.instantValue, "Asia/Kathmandu", noFallback),
    value
  );
});
test("invalid dates and leap seconds do not normalise or call Apex", async () => {
  assert.equal(validDate("2026-02-29"), false);
  assert.equal(validDate("2024-02-29"), true);
  await assert.rejects(
    resolveLocal("2026-02-29", "12:00", "UTC", noFallback),
    /valid date/
  );
  await assert.rejects(
    resolveLocal("2026-01-01", "23:59:60", "UTC", noFallback),
    /valid date/
  );
});
test("missing Temporal uses injected bridge and propagates errors", async () => {
  const saved = globalThis.Temporal;
  try {
    globalThis.Temporal = undefined;
    let calls = 0;
    const values = await resolveLocal(
      "2026-09-06",
      "12:00",
      "UTC",
      async (args) => {
        calls++;
        assert.equal(args.timeZoneId, "UTC");
        return ["fallback"];
      }
    );
    assert.deepEqual(values, ["fallback"]);
    assert.equal(calls, 1);
    await assert.rejects(
      resolveLocal("2026-09-06", "12:00", "UTC", async () => {
        throw new Error("Access denied");
      }),
      /Access denied/
    );
  } finally {
    globalThis.Temporal = saved;
  }
});

test("extra fractional digits truncate before native Temporal and Apex fallback", async () => {
  const [local] = await resolveLocal(
    "2026-12-31",
    "23:59:59.999999999",
    "UTC",
    noFallback
  );
  assert.equal(local.localValue, "2026-12-31T23:59:59.999");
  const instant = await projectInstant(
    "2021-01-13T20:57:01.500944804Z",
    "UTC",
    noFallback
  );
  assert.equal(instant.instantValue, "2021-01-13T20:57:01.500Z");
  const beforeEpoch = await projectInstant(
    "1969-12-31T23:59:59.999999999Z",
    "UTC",
    noFallback
  );
  assert.equal(beforeEpoch.instantValue, "1969-12-31T23:59:59.999Z");
  const saved = globalThis.Temporal;
  try {
    globalThis.Temporal = undefined;
    await resolveLocal(
      "1995-12-07",
      "03:24:30.0000035",
      "America/Los_Angeles",
      async (args) => {
        assert.equal(args.timeValue, "03:24:30.000");
        return [];
      }
    );
    await projectInstant(
      "2021-01-13T20:57:01.500944804Z",
      "UTC",
      async (args) => {
        assert.equal(args.instantValue, "2021-01-13T20:57:01.500Z");
        return {};
      }
    );
  } finally {
    globalThis.Temporal = saved;
  }
});

test("supplied native time slots truncate fractional digits without rolling over", async () => {
  const scheduleSource = await readFile(
    new URL(
      "../../force-app/main/default/lwc/chronoPickerEngine/schedule.js",
      import.meta.url
    ),
    "utf8"
  );
  const { suppliedSchedule } = await import(
    `data:text/javascript;base64,${Buffer.from(scheduleSource).toString("base64")}`
  );
  const schedule = suppliedSchedule({
    operatingHoursMode: "supplied",
    operatingHoursRecord: { TimeZone: "UTC" },
    timeSlots: [
      { StartTime: "00:00:00.0000035", EndTime: "23:59:59.999999999" }
    ]
  });
  assert.equal(schedule.timeSlots[0].StartTime, 0);
  assert.equal(schedule.timeSlots[0].EndTime, 86399999);
});
