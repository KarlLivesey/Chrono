// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
export const fields = [
  [
    "mode",
    "Input mode",
    "String",
    "general",
    "datetime",
    [
      ["date", "Date only"],
      ["datetime", "Date and time"]
    ]
  ],
  ["label", "Label", "String", "general", "Date and time"],
  [
    "dateStyle",
    "Date display style (user locale)",
    "String",
    "general",
    "medium",
    [
      ["short", "Short — numeric"],
      ["medium", "Medium — abbreviated month"],
      ["long", "Long — full month"]
    ]
  ],
  ["helpText", "Help text", "String", "general", ""],
  ["required", "Require a value", "Boolean", "general", false],
  ["disabled", "Disable editing", "Boolean", "general", false],
  [
    "allowOffsetOverride",
    "Allow supplied-offset overrides",
    "Boolean",
    "general",
    false
  ],
  ["offsetOverride", "Initial supplied UTC offset", "String", "general", ""],
  [
    "allowTimeZoneSelection",
    "Allow timezone selection",
    "Boolean",
    "general",
    false
  ],
  ["timeZoneId", "Timezone / default selection", "String", "general", ""],
  ["dateValue", "Initial date", "Date", "general", ""],
  ["dateTimeValue", "Initial date/time", "DateTime", "general", ""],
  ["operatingHoursMode", "Operating-hours source", "String", "hours", "none"],
  [
    "lockOperatingHoursSelection",
    "Lock operating-hours selection",
    "Boolean",
    "hours",
    false
  ],
  [
    "operatingHoursId",
    "Selected / fixed OperatingHours ID",
    "String",
    "id,ids,filter,all,records",
    ""
  ],
  ["operatingHoursIds", "Allowed record IDs", "String[]", "ids", null],
  [
    "operatingHoursRecord",
    "OperatingHours record",
    "SObject",
    "record,supplied",
    null,
    "OperatingHours"
  ],
  [
    "operatingHoursRecords",
    "OperatingHours record collection",
    "SObject[]",
    "records",
    null,
    "OperatingHours"
  ],
  [
    "timeSlots",
    "TimeSlot record collection",
    "SObject[]",
    "supplied",
    null,
    "TimeSlot"
  ],
  [
    "holidays",
    "Holiday record collection",
    "SObject[]",
    "supplied",
    null,
    "Holiday"
  ],
  [
    "operatingHoursFilter",
    "Filter from a Flow text resource",
    "String",
    "filter",
    ""
  ]
];
fields.push([
  "operatingHoursIdsText",
  "Fixed allowed IDs (comma-separated)",
  "String",
  "ids",
  ""
]);

fields.push(
  ["timeZoneIds", "Allowed timezones", "String[]", "timezone", null],
  ["timeZoneIdsText", "Fixed allowed timezones", "String", "timezone", ""]
);
