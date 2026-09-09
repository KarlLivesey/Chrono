// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
// No Salesforce imports: native Temporal when exposed by the host, otherwise
// delegate to the caller's Apex bridge. Never resolve local times with Date.
export function validDate(value) {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(value || "")) return false;
  const [year, month, day] = value.split("-").map(Number);
  const leap = year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0);
  const days = [31, leap ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  return (
    year > 0 && month >= 1 && month <= 12 && day >= 1 && day <= days[month - 1]
  );
}
export function validTime(value) {
  return /^(?:[01]\d|2[0-3]):[0-5]\d(?::[0-5]\d(?:\.\d+)?)?$/.test(value || "");
}
function temporal() {
  // Some Salesforce security/browser combinations do not expose the global.
  try {
    return globalThis.Temporal;
  } catch {
    return undefined;
  }
}
function option(zoned, choice) {
  const instantValue = zoned
    .toInstant()
    .toString({ fractionalSecondDigits: 3 });
  const localValue = zoned
    .toPlainDateTime()
    .toString({ fractionalSecondDigits: 3 });
  if (
    !validDate(instantValue.split("T")[0]) ||
    !validDate(localValue.split("T")[0])
  )
    throw new Error("The datetime is outside the supported date range.");
  return {
    instantValue,
    localValue,
    offsetSeconds: zoned.offsetNanoseconds / 1e9,
    choice
  };
}
export async function resolveLocal(dateValue, timeValue, timeZoneId, fallback) {
  if (!validDate(dateValue) || !validTime(timeValue))
    throw new Error("Enter a valid date and time.");
  if (!timeZoneId) throw new Error("Choose a time zone.");
  // Match Salesforce's millisecond precision before either execution path.
  timeValue = timeValue.replace(/(\.\d{3})\d+/, "$1");
  const api = temporal();
  if (api?.PlainDateTime && api?.ZonedDateTime) {
    try {
      const plain = api.PlainDateTime.from(`${dateValue}T${timeValue}`, {
        overflow: "reject"
      });
      const earlier = plain.toZonedDateTime(timeZoneId, {
        disambiguation: "earlier"
      });
      const later = plain.toZonedDateTime(timeZoneId, {
        disambiguation: "later"
      });
      if (earlier.epochNanoseconds === later.epochNanoseconds)
        return [option(earlier, "exact")];
      const repeated =
        earlier.toPlainDateTime().equals(plain) &&
        later.toPlainDateTime().equals(plain);
      if (repeated) return [option(earlier, "earlier"), option(later, "later")];
      // Find the actual transition rather than assuming a one-hour gap.
      let lower = earlier.epochMilliseconds;
      let upper = later.epochMilliseconds;
      const initialOffset = earlier.offsetNanoseconds;
      while (upper - lower > 1) {
        const middle = Math.floor((lower + upper) / 2);
        const zoned =
          api.Instant.fromEpochMilliseconds(middle).toZonedDateTimeISO(
            timeZoneId
          );
        if (zoned.offsetNanoseconds === initialOffset) lower = middle;
        else upper = middle;
      }
      return [
        option(
          api.Instant.fromEpochMilliseconds(lower).toZonedDateTimeISO(
            timeZoneId
          ),
          "backward"
        ),
        option(
          api.Instant.fromEpochMilliseconds(upper).toZonedDateTimeISO(
            timeZoneId
          ),
          "forward"
        )
      ];
    } catch {
      // A host may expose Temporal but lack support for this Salesforce zone.
      // The Apex bridge performs its own strict validation; errors propagate.
    }
  }
  return fallback({ dateValue, timeValue, timeZoneId });
}
export async function projectInstant(instantValue, timeZoneId, fallback) {
  const parts = /^(\d{4}-\d{2}-\d{2})T(.+)(Z|[+-]\d{2}:\d{2})$/.exec(
    instantValue || ""
  );
  if (!parts || !validDate(parts[1]) || !validTime(parts[2]))
    throw new Error("Enter a valid instant with a UTC offset.");
  if (parts[3] !== "Z") parseOffset(parts[3]);
  instantValue = instantValue.replace(/(\.\d{3})\d+/, "$1");
  const api = temporal();
  if (api?.Instant) {
    try {
      return option(
        api.Instant.from(instantValue).toZonedDateTimeISO(timeZoneId),
        "exact"
      );
    } catch {
      /* Resolve unsupported host/zone combinations through Salesforce. */
    }
  }
  return fallback({ instantValue, timeZoneId });
}
export function offsetLabel(seconds) {
  const absolute = Math.abs(seconds);
  const pad = (value) => String(value).padStart(2, "0");
  const suffix = absolute % 60 ? `:${pad(absolute % 60)}` : "";
  return `UTC${seconds < 0 ? "−" : "+"}${pad(Math.floor(absolute / 3600))}:${pad(Math.floor(absolute / 60) % 60)}${suffix}`;
}
/** Parse an explicit offset; never infer one from the host clock or timezone. */
export function parseOffset(value) {
  const match = /^([+-])([01]\d|2[0-3]):([0-5]\d)(?::([0-5]\d))?$/.exec(
    value || ""
  );
  if (!match)
    throw new Error(
      "Enter a UTC offset as +01:00 or -05:00 (optional :seconds)."
    );
  const seconds =
    Number(match[2]) * 3600 + Number(match[3]) * 60 + Number(match[4] || 0);
  return match[1] === "-" ? -seconds : seconds;
}
/** Fixed-offset interpretation preserves supplied wall fields, including in gaps. */
export function overrideCandidate(date, time, offset) {
  if (!validDate(date) || !validTime(time))
    throw new Error("Enter a valid date and time.");
  const offsetSeconds = parseOffset(offset);
  // Z is deliberate: this is arithmetic on validated fields, not local-zone resolution.
  const wall = new Date(`${date}T${time}Z`);
  const instant = new Date(wall.getTime() - offsetSeconds * 1000);
  if (instant.getUTCFullYear() < 1 || instant.getUTCFullYear() > 9999)
    throw new Error(
      "The offset moves this instant outside the supported date range."
    );
  return {
    instantValue: instant.toISOString(),
    localValue: wall.toISOString().slice(0, -1),
    offsetSeconds,
    choice: "override"
  };
}
/** Recover the original wall value when Flow supplies a saved instant and override. */
export function projectOverride(instant, offset) {
  const seconds = parseOffset(offset);
  const local = new Date(Date.parse(instant) + seconds * 1000);
  if (!Number.isFinite(local.getTime()))
    throw new Error("Enter a valid instant.");
  const value = local.toISOString();
  return overrideCandidate(value.slice(0, 10), value.slice(11, -1), offset);
}
/** Abbreviations are display-only; numeric offsets remain authoritative. */
export function zoneAbbreviation(candidate, zone) {
  if (!candidate || candidate.choice === "override") return "";
  try {
    const date = new Date(candidate.instantValue);
    const hostOffset = new Intl.DateTimeFormat("en-GB", {
      timeZone: zone,
      timeZoneName: "longOffset"
    })
      .formatToParts(date)
      .find((part) => part.type === "timeZoneName")?.value;
    const seconds = ["GMT", "UTC"].includes(hostOffset)
      ? 0
      : parseOffset(hostOffset?.replace(/^(GMT|UTC)/, ""));
    // The Apex and browser timezone databases can differ. Never attach the host's
    // abbreviation to a candidate with a different authoritative numeric offset.
    if (seconds !== candidate.offsetSeconds) return "";
    // en-GB supplies BST/GMT; other zones may legitimately format as GMT+/-n.
    return (
      new Intl.DateTimeFormat("en-GB", {
        timeZone: zone,
        timeZoneName: "short"
      })
        .formatToParts(date)
        .find((part) => part.type === "timeZoneName")?.value || ""
    );
  } catch {
    return "";
  }
}
/** Resolve only the visible search page; unsupported hosts use one batched bridge. */
export async function describeZones(ids, dateValue, timeValue, fallback) {
  if (ids.length > 12) throw new Error("Search at most 12 time zones at once.");
  if (!validDate(dateValue) || !validTime(timeValue)) return {};
  let values;
  if (temporal()?.PlainDateTime) {
    try {
      values = Object.fromEntries(
        await Promise.all(
          ids.map(async (id) => [
            id,
            await resolveLocal(dateValue, timeValue, id, () => {
              throw new Error("Use bridge");
            })
          ])
        )
      );
    } catch {
      /* An unsupported zone is resolved by the same batch Apex bridge. */
    }
  }
  values ||= await fallback({ dateValue, timeValue, timeZoneIds: ids });
  return Object.fromEntries(
    Object.entries(values).map(([id, options]) => [
      id,
      options[0]?.choice === "backward"
        ? "Skipped local time"
        : [
            ...new Set(options.map((item) => offsetLabel(item.offsetSeconds)))
          ].join(" / ")
    ])
  );
}
export function choiceLabel(candidate) {
  const names = {
    earlier: "First occurrence",
    later: "Second occurrence",
    backward: "Move backward",
    forward: "Move forward",
    previousOpen: "Previous open time",
    nextOpen: "Next open time",
    exact: "Selected time",
    override: "Offset override"
  };
  return `${names[candidate.choice]} · ${candidate.localValue.replace("T", " ")} · ${offsetLabel(candidate.offsetSeconds)}`;
}
export {
  scheduleModes,
  allowedScheduleIds,
  scheduleConfigError,
  suppliedSchedule
} from "./schedule";
