// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { readFile } from "node:fs/promises";
import { pathToFileURL } from "node:url";
const source = await readFile(
  new URL(
    "../../force-app/main/default/lwc/chronoPickerEngine/chronoPickerEngine.js",
    import.meta.url
  ),
  "utf8"
);
const engine = await import(
  `data:text/javascript;base64,${Buffer.from(source.replace(/export\s*\{[^}]+\}\s*from\s*["']\.\/schedule["'];?/g, "")).toString("base64")}`
);
export const fixtures = JSON.parse(
  await readFile(new URL("./cases.json", import.meta.url), "utf8")
);
function unavailable() {
  throw new Error("Native Temporal could not resolve this fixture");
}
function candidate(item, zone) {
  const seconds = item.offsetSeconds;
  const absolute = Math.abs(seconds);
  const offset = `${seconds < 0 ? "-" : "+"}${String(Math.floor(absolute / 3600)).padStart(2, "0")}:${String(Math.floor(absolute / 60) % 60).padStart(2, "0")}`;
  return { choice: item.choice, value: `${item.localValue}${offset}[${zone}]` };
}
function durationText(value) {
  const duration = Temporal.Duration.from(value.replace(/(\.\d{3})\d+/, "$1"));
  const months = BigInt(duration.years) * 12n + BigInt(duration.months);
  const days = BigInt(duration.weeks) * 7n + BigInt(duration.days);
  const milliseconds =
    BigInt(duration.hours) * 3600000n +
    BigInt(duration.minutes) * 60000n +
    BigInt(duration.seconds) * 1000n +
    BigInt(duration.milliseconds);
  const abs = (v) => (v < 0n ? -v : v);
  const calendar = `${months ? `${abs(months)}M` : ""}${days ? `${abs(days)}D` : ""}`;
  const elapsed = milliseconds
    ? `T${abs(milliseconds) / 1000n}.${String(abs(milliseconds) % 1000n).padStart(3, "0")}S`
    : "";
  return `${months < 0n || days < 0n || milliseconds < 0n ? "-" : ""}P${calendar}${elapsed || (!calendar ? "T0S" : "")}`;
}
export async function evaluate(fixture) {
  if (!globalThis.Temporal) throw new Error("Run Node with --harmony-temporal");
  try {
    switch (fixture.operation) {
      case "resolve":
        return (
          await engine.resolveLocal(
            fixture.date,
            fixture.time,
            fixture.zone,
            unavailable
          )
        ).map((item) => candidate(item, fixture.zone));
      case "project":
        return [
          candidate(
            await engine.projectInstant(
              fixture.value,
              fixture.zone,
              unavailable
            ),
            fixture.zone
          )
        ];
      case "duration":
        return durationText(fixture.value);
      default:
        throw new Error("Unknown fixture operation");
    }
  } catch {
    return { error: true };
  }
}
if (
  process.argv[1] &&
  import.meta.url === pathToFileURL(process.argv[1]).href
) {
  const results = [];
  for (const fixture of fixtures)
    results.push({ id: fixture.id, actual: await evaluate(fixture) });
  process.stdout.write(JSON.stringify(results));
}
