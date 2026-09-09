// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
const options = (pairs) => pairs.map(([value, label]) => ({ value, label }));
export const types = options([
  ["PlainDate", "Date"],
  ["PlainDateTime", "Local date and time"],
  ["ZonedDateTime", "Zoned date and time"],
  ["Instant", "Instant"],
  ["PlainTime", "Time"],
  ["PlainYearMonth", "Year and month"],
  ["PlainMonthDay", "Month and day"],
  ["Duration", "Duration"]
]);
export const formats = options([
  ["iso", "ISO text"],
  ["datetime", "Salesforce Datetime"],
  ["date", "Salesforce Date"]
]);
const field = (name, label, dataType = "String", extra = {}) => ({
  name,
  label,
  dataType,
  ...extra
});
const policies = options([
  ["reject", "Require an unambiguous time"],
  ["earlier", "First occurrence"],
  ["later", "Second occurrence"]
]);
const clocks = ["Instant", "ZonedDateTime", "PlainDateTime", "PlainTime"];
export function sourceFormats(type) {
  return formats.filter(
    (item) =>
      item.value === "iso" ||
      (item.value === "datetime" &&
        ["Instant", "ZonedDateTime"].includes(type)) ||
      (item.value === "date" &&
        [
          "PlainDate",
          "PlainDateTime",
          "PlainYearMonth",
          "PlainMonthDay"
        ].includes(type))
  );
}
export function sourceFields(format, prefix, type) {
  if (prefix) {
    const label = prefix === "start" ? "Start" : "End";
    if (format === "date")
      return [
        field(`${prefix}Date`, `${label} date`, "Date", { required: true }),
        field(`${prefix}Time`, `${label} local time (optional)`, "String", {
          literalType: "time",
          helpText: "Leave blank for midnight in the input timezone."
        })
      ];
    return [
      field(
        format === "datetime" ? `${prefix}Instant` : `${prefix}Value`,
        `${label} value`,
        format === "datetime" ? "DateTime" : "String",
        {
          required: true,
          helpText:
            "ISO date, local date/time, instant or zoned date/time. Dates and local date/times require an input timezone."
        }
      )
    ];
  }
  if (format === "datetime")
    return [field("instantValue", "Value", "DateTime", { required: true })];
  if (format === "date")
    return [
      field("dateValue", "Date", "Date", { required: true }),
      ...(type === "PlainDateTime"
        ? [
            field("timeValue", "Local time", "String", {
              required: true,
              literalType: "time"
            })
          ]
        : [])
    ];
  return [
    field("value", "ISO value", "String", {
      required: true,
      literalType:
        type === "PlainDate" ? "date" : type === "PlainTime" ? "time" : "",
      helpText:
        "Chrono ISO text. Zoned values include the offset and [Area/City]; plain date/time has no offset."
    })
  ];
}
export function operationFields(
  kind,
  type,
  target,
  amountMode,
  scheduleType,
  dynamicType
) {
  const zone = field(
    "timeZoneId",
    kind === "WorkingTime" ? "Input / result timezone" : "Timezone",
    "String",
    {
      searchable: true,
      required: kind === "WorkingTime",
      helpText:
        "Explicit timezone for conversion or the result. OperatingHours uses its own timezone."
    }
  );
  const policy = field("disambiguation", "Repeated time", "String", {
    options: policies,
    helpText:
      "Blank rejects ambiguous times. Nonexistent local times are rejected by the action."
  });
  if (kind === "Difference")
    return [
      {
        ...zone,
        label: "Local input timezone",
        helpText:
          "Required for dates and local date/times. Exact inputs retain their instant."
      },
      policy,
      field("endTimeZoneId", "End timezone (optional)", "String", {
        searchable: true,
        helpText:
          "Defaults to the local input timezone. Only used for a local end value."
      }),
      field(
        "endDisambiguation",
        "End repeated-time choice (optional)",
        "String",
        {
          options: policies,
          helpText: "Defaults to the repeated-time policy above."
        }
      )
    ];
  if (kind === "WorkingTime")
    return [
      zone,
      policy,
      field("amount", "Amount", "Number", {
        required: true,
        helpText: "Negative values subtract working time."
      }),
      field("unit", "Unit", "String", {
        required: true,
        options: options([
          ["hours", "Hours"],
          ["minutes", "Minutes"]
        ])
      }),
      field("scheduleType", "Schedule type", "String", {
        required: true,
        options: options([
          ["OperatingHours", "Operating hours"],
          ["BusinessHours", "Business hours"]
        ])
      })
    ];
  if (kind === "Adjust") {
    const calendar = ["years", "months", "weeks", "days"];
    const clock = ["hours", "minutes", "seconds", "milliseconds"];
    const units = dynamicType
      ? [...calendar, ...clock]
      : type === "PlainYearMonth"
        ? calendar.slice(0, 2)
        : type === "PlainDate"
          ? calendar
          : ["Instant", "PlainTime"].includes(type)
            ? clock
            : [...calendar, ...clock];
    return [
      ...(amountMode === "duration"
        ? [
            field("duration", "ISO duration", "String", {
              required: true,
              helpText: "For example P1D or -PT2H."
            })
          ]
        : [
            field("amount", "Amount", "Number", { required: true }),
            field("unit", "Unit", "String", {
              required: true,
              options: options(
                units.map((value) => [
                  value,
                  value[0].toUpperCase() + value.slice(1)
                ])
              )
            })
          ]),
      ...(["ZonedDateTime", "PlainDateTime"].includes(type) || dynamicType
        ? [zone, policy]
        : [])
    ];
  }
  return [
    field("targetType", "Convert to", "String", {
      options: [
        { value: "", label: "Same type (normalise)" },
        ...types.filter(
          (item) =>
            dynamicType ||
            (type === "Duration"
              ? item.value === "Duration"
              : item.value !== "Duration")
        )
      ]
    }),
    ...(type !== "Duration" || dynamicType ? [zone, policy] : []),
    ...(dynamicType ||
    (["PlainTime", "PlainYearMonth", "PlainMonthDay"].includes(type) &&
      target !== type)
      ? [
          field("referenceDate", "Reference date", "Date", {
            helpText:
              "Supplies the date for a time, the year for month/day, or the day for year/month."
          })
        ]
      : []),
    ...(dynamicType ||
    (["PlainDate", "PlainYearMonth", "PlainMonthDay"].includes(type) &&
      clocks.includes(target))
      ? [
          field("referenceTime", "Reference time", "String", {
            literalType: "time",
            helpText: "Clock time to combine with the date."
          })
        ]
      : [])
  ];
}
