// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
export const scheduleModes = [
  ["none", "No operating-hours restriction"],
  ["id", "One saved record ID"],
  ["ids", "Choose from record IDs"],
  ["filter", "Choose using a filter"],
  ["all", "Choose any accessible record"],
  ["record", "One Flow record"],
  ["records", "Choose from Flow records"],
  ["supplied", "Flow records with supplied slots and holidays"],
  ["fixed", "Fixed hours configured here"]
].map(([value, label]) => ({ value, label }));
export function allowedScheduleIds(config) {
  if (config.operatingHoursMode === "id")
    return [config.operatingHoursId].filter(Boolean);
  if (config.operatingHoursMode === "ids")
    return [
      ...new Set([
        ...(config.operatingHoursIds || []),
        ...(config.operatingHoursIdsText || "").split(/[\s,;]+/).filter(Boolean)
      ])
    ];
  if (config.operatingHoursMode === "record")
    return [config.operatingHoursRecord?.Id].filter(Boolean);
  if (config.operatingHoursMode === "records")
    return (config.operatingHoursRecords || [])
      .map((item) => item.Id)
      .filter(Boolean);
  return null;
}
export function scheduleConfigError(config) {
  const mode = config.operatingHoursMode || "none";
  if (!scheduleModes.some((item) => item.value === mode))
    return "Choose a supported operating-hours configuration.";
  if (
    ["id", "ids", "record", "records"].includes(mode) &&
    !allowedScheduleIds(config)?.length
  )
    return "Supply the configured OperatingHours record or IDs.";
  if (mode === "filter" && !config.operatingHoursFilter)
    return "Supply an OperatingHours filter.";
  if (mode === "supplied" && !config.operatingHoursRecord)
    return "Supply the OperatingHours values.";
  if (mode === "fixed" && !config.fixedHours)
    return "Configure the fixed operating hours.";
  return "";
}
function nativeTime(value) {
  if (value == null || value === "") return null;
  if (
    typeof value === "number" &&
    Number.isInteger(value) &&
    value >= 0 &&
    value < 86400000
  )
    return value;
  const match = /^(\d{2}):(\d{2})(?::(\d{2})(?:\.(\d+))?)?Z?$/.exec(value);
  if (!match) throw new Error("Use an ISO time for each time slot.");
  if (
    Number(match[1]) > 23 ||
    Number(match[2]) > 59 ||
    Number(match[3] || 0) > 59
  )
    throw new Error("Time-slot clock fields are out of range.");
  // Apex's SObject Time deserialiser requires milliseconds after midnight,
  // although its serializer emits ISO strings. Convert only at the wire boundary.
  return (
    Number(match[1]) * 3600000 +
    Number(match[2]) * 60000 +
    Number(match[3] || 0) * 1000 +
    Number((match[4] || "").padEnd(3, "0").slice(0, 3))
  );
}
export function suppliedSchedule(config) {
  if (config.operatingHoursMode === "supplied")
    return {
      operatingHours: config.operatingHoursRecord,
      timeSlots: (config.timeSlots || []).map((slot) => ({
        ...slot,
        StartTime: nativeTime(slot.StartTime),
        EndTime: nativeTime(slot.EndTime)
      })),
      holidays: config.holidays || []
    };
  if (config.operatingHoursMode !== "fixed")
    throw new Error("Use native schedule records or fixed hours.");
  const data = JSON.parse(config.fixedHours);
  return {
    operatingHours: {
      Name: data.definition?.name || "Custom operating hours",
      TimeZone: data.definition?.timeZoneId
    },
    timeSlots: (data.slots || []).map((slot) => ({
      DayOfWeek: slot.dayOfWeek,
      StartTime: nativeTime(slot.startTime),
      EndTime: nativeTime(slot.endTime),
      Type: "Normal"
    })),
    holidays: (data.holidays || []).map((day) => ({
      ActivityDate: day.dateValue,
      IsAllDay: day.allDay !== false,
      StartTimeInMinutes: day.startTimeInMinutes,
      EndTimeInMinutes: day.endTimeInMinutes,
      IsRecurrence: day.isRecurrence === true,
      RecurrenceStartDate: day.recurrenceStartDate,
      RecurrenceEndDateOnly: day.recurrenceEndDate,
      RecurrenceType: day.recurrenceType,
      RecurrenceInterval: day.recurrenceInterval,
      RecurrenceDayOfWeekMask: day.recurrenceDayOfWeekMask,
      RecurrenceDayOfMonth: day.recurrenceDayOfMonth,
      RecurrenceInstance: day.recurrenceInstance,
      RecurrenceMonthOfYear: day.recurrenceMonthOfYear
    }))
  };
}
