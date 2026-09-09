// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { types, sourceFormats, sourceFields } from "./fields";
export const operationTitles = {
  CheckWorkingTime: "Check working time",
  FindWorkingTime: "Find next or previous working time",
  Compare: "Compare date/time values",
  PeriodBoundary: "Start or end of period",
  Round: "Round date/time",
  ResolveLocal: "Inspect or resolve local time",
  CalendarDifference: "Calendar difference"
};
const dated = ["PlainDate", "PlainDateTime", "Instant", "ZonedDateTime"];
const field = (name, label, extra = {}) => ({
  name,
  label,
  dataType: "String",
  ...extra
});
const choices = (entries) =>
  entries.map(([value, label]) => ({ value, label }));
export function allowedTypes(kind) {
  let allowed = dated;
  if (kind === "Compare") return types;
  if (kind === "Round") allowed = [...dated, "PlainTime", "Duration"];
  if (kind === "ResolveLocal") allowed = ["PlainDate", "PlainDateTime"];
  return types.filter((item) => allowed.includes(item.value));
}
export function operationSources(editor) {
  return (
    ["Compare", "CalendarDifference"].includes(editor.kind) ? ["", "end"] : [""]
  ).map((prefix) => {
    const type = prefix
      ? editor.value("endValueType") || editor.type
      : editor.type;
    const native = prefix ? "endInstant" : "instantValue";
    const date = prefix ? "endDate" : "dateValue";
    const format =
      editor.formatChoices[prefix] ||
      (editor.value(native) ? "datetime" : editor.value(date) ? "date" : "iso");
    const fields = sourceFields(format, "", type).map((item) =>
      prefix
        ? {
            ...item,
            name: {
              value: "endValue",
              instantValue: "endInstant",
              dateValue: "endDate",
              timeValue: "endTime"
            }[item.name],
            label: `End ${item.label.toLowerCase()}`
          }
        : item
    );
    if (prefix)
      fields.unshift(
        field("endValueType", "End value type", {
          options: [
            { label: "Same as source", value: "" },
            ...allowedTypes(editor.kind)
          ]
        })
      );
    return {
      key: prefix || "source",
      prefix,
      format,
      label: prefix ? "End input format" : "Input format",
      options: sourceFormats(type),
      fields: fields.map((item) => editor.view(item))
    };
  });
}
export function additionalFields(editor) {
  const kind = editor.kind,
    type = editor.type;
  const zone = field("timeZoneId", "Calculation timezone", {
    searchable: true,
    helpText:
      "Required for local-time resolution and calendar operations on instants. When supplied, both exact endpoints are projected into this zone."
  });
  const policy = field("disambiguation", "Repeated-time policy", {
    options: choices([
      ["reject", "Require an unambiguous time"],
      ["earlier", "First occurrence"],
      ["later", "Second occurrence"]
    ]),
    helpText:
      "Calendar arithmetic and rounding reject skipped local times. Use Inspect or resolve local time to choose a gap boundary."
  });
  const needsZone =
    ["Instant", "ZonedDateTime", "PlainDateTime", "Duration"].includes(type) ||
    editor.reference("valueType") ||
    kind === "ResolveLocal";
  const context = needsZone
    ? [zone, ...(kind === "ResolveLocal" ? [] : [policy])]
    : [];
  if (["CheckWorkingTime", "FindWorkingTime"].includes(kind))
    return [
      ...context,
      ...(kind === "FindWorkingTime"
        ? [
            field("direction", "Direction", {
              required: true,
              options: choices([
                ["next", "On or after"],
                ["previous", "On or before"]
              ]),
              helpText: "An already-open value is returned unchanged."
            })
          ]
        : [])
    ];
  if (kind === "Compare")
    return [
      ...context,
      field("toleranceMilliseconds", "Tolerance in milliseconds", {
        dataType: "Number",
        helpText:
          "Optional. Returns Within tolerance for complete dates, clocks, exact values or durations."
      }),
      field("comparisonPeriod", "Compare local period", {
        options: choices([
          ["", "Not requested"],
          ["day", "Day"],
          ["week", "Week"],
          ["month", "Month"],
          ["quarter", "Quarter"],
          ["year", "Year"]
        ]),
        helpText:
          "Exact values in different zones need one calculation timezone."
      }),
      ...(editor.value("comparisonPeriod") === "week"
        ? [
            field("weekStartsOn", "Week starts on", {
              dataType: "Number",
              helpText: "1 = Monday through 7 = Sunday."
            })
          ]
        : []),
      ...(type === "Duration" || editor.reference("valueType")
        ? [
            field("referenceDate", "Duration reference date", {
              dataType: "Date",
              helpText:
                "Required with a calculation timezone when either duration contains calendar units. The reference clock is midnight."
            })
          ]
        : [])
    ].filter((item) => {
      if (editor.reference("valueType") || !type) return true;
      if (["comparisonPeriod", "weekStartsOn"].includes(item.name))
        return dated.includes(type);
      return (
        item.name !== "toleranceMilliseconds" ||
        !["PlainMonthDay", "PlainYearMonth"].includes(type)
      );
    });
  if (kind === "CalendarDifference")
    return [
      ...context,
      field("largestUnit", "Largest calendar unit", {
        options: choices([
          ["day", "Days"],
          ["month", "Months and days"],
          ["year", "Years/months and days"]
        ]),
        helpText:
          "Defaults to days. Calendar months/days and the remaining milliseconds are separate outputs, so the remainder can be ignored. Years are included in total calendar months."
      })
    ];
  if (kind === "PeriodBoundary")
    return [
      ...context,
      field("unit", "Period", {
        required: true,
        options: choices([
          ["day", "Day"],
          ["week", "Week"],
          ["month", "Month"],
          ["quarter", "Quarter"],
          ["year", "Year"]
        ])
      }),
      field("boundary", "Boundary", {
        required: true,
        options: choices([
          ["start", "Start"],
          ["end", "End"]
        ])
      }),
      ...(editor.value("unit") === "week" || editor.reference("unit")
        ? [
            field("weekStartsOn", "Week starts on", {
              dataType: "Number",
              helpText: "1 = Monday through 7 = Sunday. Defaults to Monday."
            })
          ]
        : [])
    ];
  if (kind === "ResolveLocal")
    return [
      ...context,
      field("resolution", "Resolution", {
        options: choices([
          ["inspect", "Inspect without choosing"],
          ["earlier", "First repeated occurrence"],
          ["later", "Second repeated occurrence"],
          ["backward", "Previous valid gap boundary"],
          ["forward", "Next valid gap boundary"]
        ]),
        helpText:
          "Returns status and applicable ISO candidates. Inspection leaves a repeated/skipped value unresolved; a Date means midnight."
      })
    ];
  let units = choices([
    ["day", "Day"],
    ["hour", "Hour"],
    ["minute", "Minute"],
    ["second", "Second"],
    ["millisecond", "Millisecond"]
  ]);
  if (type === "PlainDate")
    units = units.filter((item) => item.value === "day");
  if (["PlainTime", "Duration"].includes(type))
    units = units.filter((item) => item.value !== "day");
  return [
    ...context,
    field("unit", "Round to", { required: true, options: units }),
    field("increment", "Increment", {
      dataType: "Number",
      helpText:
        "Defaults to 1. For example, minute + 15. Must divide 24 hours, 60 minutes/seconds or 1000 milliseconds. Day requires 1."
    }),
    field("roundingMode", "Rounding mode", {
      options: choices([
        ["floor", "Round down"],
        ["ceil", "Round up"],
        ["halfExpand", "Nearest (ties away from zero)"],
        ["halfTrunc", "Nearest (ties towards zero)"],
        ["halfEven", "Nearest (ties to even)"],
        ["halfCeil", "Nearest (ties upwards)"],
        ["halfFloor", "Nearest (ties downwards)"],
        ["trunc", "Towards zero"],
        ["expand", "Away from zero"]
      ])
    })
  ];
}
