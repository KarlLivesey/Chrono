// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
// Public Chrono transport uses ISO text; only validated Apex parsers create core objects.
export function chronoDate(value) {
  return value;
}

/** Plain outputs preserve the entered clock; zoned output follows the named zone. */
export function chronoValues(candidate, timeZoneId, canonical = candidate) {
  const [localDate, localTime] = candidate.localValue.split("T");
  const seconds = canonical.offsetSeconds;
  const absolute = Math.abs(seconds);
  const pad = (value) => String(value).padStart(2, "0");
  // Chrono's parser supports minute offsets. Never emit an unparseable zoned value.
  if (seconds % 60 !== 0)
    throw new Error(
      "Historical timezone offsets containing seconds are not supported."
    );
  const offset = `${seconds < 0 ? "-" : "+"}${pad(Math.floor(absolute / 3600))}:${pad(Math.floor(absolute / 60) % 60)}`;
  return {
    chronoDateValue: localDate,
    chronoPlainDateTimeValue: candidate.localValue,
    chronoTimeValue: localTime,
    chronoInstantValue: candidate.instantValue,
    chronoZonedDateTimeValue: `${canonical.localValue}${offset}[${timeZoneId}]`
  };
}
