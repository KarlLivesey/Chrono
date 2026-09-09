// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { validDate, validTime } from "c/chronoPickerEngine";

export function durationParts(value) {
  if (!value)
    return {
      negative: false,
      months: 0,
      days: 0,
      hours: 0,
      minutes: 0,
      seconds: 0
    };
  const match =
    /^(-)?P(?:(\d+)Y)?(?:(\d+)M)?(?:(\d+)W)?(?:(\d+)D)?(?:T(?:(\d+)H)?(?:(\d+)M)?(?:(\d+(?:\.\d+)?)S)?)?$/.exec(
      value
    );
  if (!match || /P$|T$/.test(value))
    throw new Error("Enter a valid ISO duration.");
  const [
    ,
    sign,
    years = 0,
    months = 0,
    weeks = 0,
    days = 0,
    hours = 0,
    minutes = 0,
    seconds = "0"
  ] = match;
  const result = {
    negative: !!sign,
    months: Number(years) * 12 + Number(months),
    days: Number(weeks) * 7 + Number(days),
    hours: Number(hours),
    minutes: Number(minutes),
    seconds: Number(seconds.replace(/(\.\d{3})\d+$/, "$1"))
  };
  durationText(result);
  return result;
}
export function durationText(parts) {
  for (const key of ["months", "days", "hours", "minutes"]) {
    if (!Number.isSafeInteger(parts[key]) || parts[key] < 0)
      throw new Error(
        "Use non-negative whole numbers for calendar units, hours and minutes."
      );
  }
  if (!Number.isFinite(parts.seconds) || parts.seconds < 0)
    throw new Error("Enter non-negative seconds.");
  if (parts.months > 2147483647 || parts.days > 2147483647)
    throw new Error("Calendar components exceed Salesforce's supported range.");
  const milliseconds =
    parts.hours * 3600000 +
    parts.minutes * 60000 +
    Math.trunc(
      Number(String(parts.seconds).replace(/(\.\d{3})\d+$/, "$1")) * 1000 +
        0.000001
    );
  if (!Number.isSafeInteger(milliseconds))
    throw new Error("The elapsed duration is too large to edit safely.");
  const date = `${parts.months ? `${parts.months}M` : ""}${parts.days ? `${parts.days}D` : ""}`;
  const time = milliseconds
    ? `T${(milliseconds / 1000).toFixed(3).replace(/\.?0+$/, "")}S`
    : "";
  return `${parts.negative && (date || time) ? "-" : ""}P${date}${time || (!date ? "T0S" : "")}`;
}
export function partialText(kind, year, month, day) {
  if (!["monthday", "yearmonth"].includes(kind))
    throw new Error("Choose month/day or year/month.");
  const m = Number(month),
    y = kind === "monthday" ? 2000 : Number(year),
    d = kind === "yearmonth" ? 1 : Number(day);
  if (
    !Number.isInteger(y) ||
    y < 1 ||
    y > 9999 ||
    !Number.isInteger(m) ||
    m < 1 ||
    m > 12 ||
    !Number.isInteger(d) ||
    d < 1
  )
    throw new Error("Complete a valid calendar value.");
  const leap = y % 4 === 0 && (y % 100 !== 0 || y % 400 === 0);
  const length = [31, leap ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][
    m - 1
  ];
  if (d > length)
    throw new Error("That day does not exist in the selected month.");
  const pad = (value, length = 2) => String(value).padStart(length, "0");
  return kind === "monthday"
    ? `--${pad(m)}-${pad(d)}`
    : `${pad(y, 4)}-${pad(m)}`;
}
export function exactMillis(value) {
  const match =
    /^(\d{4}-\d{2}-\d{2})T(\d{2}:\d{2}(?::\d{2}(?:\.\d+)?)?)(Z|[+-](?:[01]\d|2[0-3]):[0-5]\d)(?:\[[^\]\s]+\])?$/.exec(
      value || ""
    );
  if (!match || !validDate(match[1]) || !validTime(match[2]))
    throw new Error("Enter a valid exact datetime with an offset.");
  // Date.parse normalises impossible dates; validate wall fields first and
  // truncate before parsing to match Apex's millisecond precision.
  const clock = match[2].replace(/(\.\d{3})\d+$/, "$1");
  const result = Date.parse(`${match[1]}T${clock}${match[3]}`);
  const year = new Date(result).getUTCFullYear();
  if (!Number.isFinite(result) || year < 1 || year > 9999)
    throw new Error("The exact datetime is outside the supported date range.");
  return result;
}
