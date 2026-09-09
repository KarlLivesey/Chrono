// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
export default [
  {
    family: "CreateValue",
    title: "Create date/time from components",
    description:
      "Construct a validated value from individual calendar and clock components.",
    category: "Values",
    fields: [
      {
        name: "valueType",
        type: "String",
        label: "Value type",
        help: "Value type.",
        group: "Source",
        options: [
          "PlainDate",
          "PlainDateTime",
          "PlainTime",
          "PlainYearMonth",
          "PlainMonthDay",
          "Instant",
          "ZonedDateTime"
        ]
      },
      {
        name: "year",
        type: "Integer",
        label: "Year",
        help: "Year.",
        group: "Components",
        appliesTo: [
          "PlainDate",
          "PlainDateTime",
          "PlainYearMonth",
          "Instant",
          "ZonedDateTime"
        ],
        required: true
      },
      {
        name: "month",
        type: "Integer",
        label: "Month",
        help: "Month.",
        group: "Components",
        appliesTo: [
          "PlainDate",
          "PlainDateTime",
          "PlainYearMonth",
          "PlainMonthDay",
          "Instant",
          "ZonedDateTime"
        ],
        required: true
      },
      {
        name: "day",
        type: "Integer",
        label: "Day",
        help: "Day.",
        group: "Components",
        appliesTo: [
          "PlainDate",
          "PlainDateTime",
          "PlainMonthDay",
          "Instant",
          "ZonedDateTime"
        ],
        required: true
      },
      {
        name: "hour",
        type: "Integer",
        label: "Hour",
        help: "Hour.",
        group: "Components",
        appliesTo: ["PlainTime", "PlainDateTime", "Instant", "ZonedDateTime"]
      },
      {
        name: "minute",
        type: "Integer",
        label: "Minute",
        help: "Minute.",
        group: "Components",
        appliesTo: ["PlainTime", "PlainDateTime", "Instant", "ZonedDateTime"]
      },
      {
        name: "second",
        type: "Integer",
        label: "Second",
        help: "Second.",
        group: "Components",
        appliesTo: ["PlainTime", "PlainDateTime", "Instant", "ZonedDateTime"]
      },
      {
        name: "millisecond",
        type: "Integer",
        label: "Millisecond",
        help: "Millisecond.",
        group: "Components",
        appliesTo: ["PlainTime", "PlainDateTime", "Instant", "ZonedDateTime"]
      },
      {
        name: "timeZoneId",
        type: "String",
        label: "Timezone",
        help: "Required when resolving local time or inspecting an instant.",
        searchable: true,
        group: "Context"
      },
      {
        name: "disambiguation",
        type: "String",
        label: "Repeated-time policy",
        help: "Repeated-time policy.",
        options: ["reject", "earlier", "later"],
        group: "Context"
      }
    ],
    result: "ChronoFlowResult"
  },
  {
    family: "ReplaceValue",
    title: "Replace date/time components",
    description:
      "Replace supplied components and preserve other fields. Resolve zoned values explicitly.",
    category: "Values",
    fields: [
      {
        name: "valueType",
        type: "String",
        label: "Value type",
        help: "Value type.",
        group: "Source",
        options: [
          "PlainDate",
          "PlainDateTime",
          "PlainTime",
          "PlainYearMonth",
          "PlainMonthDay",
          "Instant",
          "ZonedDateTime"
        ]
      },
      {
        name: "value",
        type: "String",
        label: "ISO value",
        help: "ISO value.",
        group: "Source",
        sourceFormat: "iso"
      },
      {
        name: "dateValue",
        type: "Date",
        label: "Native date",
        help: "Native date.",
        group: "Source",
        sourceFormat: "date"
      },
      {
        name: "instantValue",
        type: "Datetime",
        label: "Native datetime",
        help: "Native datetime.",
        group: "Source",
        sourceFormat: "datetime"
      },
      {
        name: "timeValue",
        type: "String",
        label: "Local time",
        help: "ISO time for a native date and time input.",
        group: "Source",
        sourceFormat: "dateTime"
      },
      {
        name: "timeZoneId",
        type: "String",
        label: "Timezone",
        help: "Required when resolving local time or inspecting an instant.",
        searchable: true,
        group: "Context"
      },
      {
        name: "disambiguation",
        type: "String",
        label: "Repeated-time policy",
        help: "Repeated-time policy.",
        options: ["reject", "earlier", "later"],
        group: "Context"
      },
      {
        name: "year",
        type: "Integer",
        label: "Year",
        help: "Year.",
        group: "Components",
        appliesTo: [
          "PlainDate",
          "PlainDateTime",
          "PlainYearMonth",
          "Instant",
          "ZonedDateTime"
        ]
      },
      {
        name: "month",
        type: "Integer",
        label: "Month",
        help: "Month.",
        group: "Components",
        appliesTo: [
          "PlainDate",
          "PlainDateTime",
          "PlainYearMonth",
          "PlainMonthDay",
          "Instant",
          "ZonedDateTime"
        ]
      },
      {
        name: "day",
        type: "Integer",
        label: "Day",
        help: "Day.",
        group: "Components",
        appliesTo: [
          "PlainDate",
          "PlainDateTime",
          "PlainMonthDay",
          "Instant",
          "ZonedDateTime"
        ]
      },
      {
        name: "hour",
        type: "Integer",
        label: "Hour",
        help: "Hour.",
        group: "Components",
        appliesTo: ["PlainTime", "PlainDateTime", "Instant", "ZonedDateTime"]
      },
      {
        name: "minute",
        type: "Integer",
        label: "Minute",
        help: "Minute.",
        group: "Components",
        appliesTo: ["PlainTime", "PlainDateTime", "Instant", "ZonedDateTime"]
      },
      {
        name: "second",
        type: "Integer",
        label: "Second",
        help: "Second.",
        group: "Components",
        appliesTo: ["PlainTime", "PlainDateTime", "Instant", "ZonedDateTime"]
      },
      {
        name: "millisecond",
        type: "Integer",
        label: "Millisecond",
        help: "Millisecond.",
        group: "Components",
        appliesTo: ["PlainTime", "PlainDateTime", "Instant", "ZonedDateTime"]
      },
      {
        name: "overflow",
        type: "String",
        label: "Invalid date handling",
        help: "Invalid date handling.",
        options: ["reject", "constrain"]
      }
    ],
    result: "ChronoFlowResult"
  },
  {
    family: "ValidateValue",
    title: "Validate date/time value",
    description:
      "Validate a native or ISO value without failing other interviews.",
    category: "Values",
    fields: [
      {
        name: "valueType",
        type: "String",
        label: "Value type",
        help: "Value type.",
        group: "Source",
        options: [
          "PlainDate",
          "PlainDateTime",
          "PlainTime",
          "PlainYearMonth",
          "PlainMonthDay",
          "Instant",
          "ZonedDateTime",
          "Duration"
        ]
      },
      {
        name: "value",
        type: "String",
        label: "ISO value",
        help: "ISO value.",
        group: "Source",
        sourceFormat: "iso"
      },
      {
        name: "dateValue",
        type: "Date",
        label: "Native date",
        help: "Native date.",
        group: "Source",
        sourceFormat: "date"
      },
      {
        name: "instantValue",
        type: "Datetime",
        label: "Native datetime",
        help: "Native datetime.",
        group: "Source",
        sourceFormat: "datetime"
      },
      {
        name: "timeValue",
        type: "String",
        label: "Local time",
        help: "ISO time for a native date and time input.",
        group: "Source",
        sourceFormat: "dateTime"
      },
      {
        name: "timeZoneId",
        type: "String",
        label: "Timezone",
        help: "Required when resolving local time or inspecting an instant.",
        searchable: true,
        group: "Context"
      },
      {
        name: "disambiguation",
        type: "String",
        label: "Repeated-time policy",
        help: "Repeated-time policy.",
        options: ["reject", "earlier", "later"],
        group: "Context"
      }
    ],
    result: "ChronoValidationResult"
  },
  {
    family: "ParseValue",
    title: "Parse formatted date/time",
    description:
      "Parse an explicitly specified numeric date and time pattern without guessing.",
    category: "Values",
    fields: [
      {
        name: "valueType",
        type: "String",
        label: "Value type",
        help: "Value type.",
        group: "Source",
        options: [
          "PlainDate",
          "PlainDateTime",
          "PlainTime",
          "PlainYearMonth",
          "PlainMonthDay",
          "Instant",
          "ZonedDateTime"
        ]
      },
      {
        name: "text",
        type: "String",
        label: "Text to parse",
        help: "Text to parse.",
        required: true
      },
      {
        name: "pattern",
        type: "String",
        label: "Input pattern",
        help: "Supported tokens: yyyy MM dd HH mm ss SSS and quoted literal text.",
        required: true
      },
      {
        name: "timeZoneId",
        type: "String",
        label: "Timezone",
        help: "Required when resolving local time or inspecting an instant.",
        searchable: true,
        group: "Context"
      },
      {
        name: "disambiguation",
        type: "String",
        label: "Repeated-time policy",
        help: "Repeated-time policy.",
        options: ["reject", "earlier", "later"],
        group: "Context"
      }
    ],
    result: "ChronoFlowResult"
  },
  {
    family: "EpochValue",
    title: "Convert Unix timestamp",
    description:
      "Convert an exact value to or from Unix seconds or milliseconds.",
    category: "Values",
    fields: [
      {
        name: "operation",
        type: "String",
        label: "Operation",
        help: "Operation.",
        options: ["fromEpoch", "toEpoch"],
        required: true
      },
      {
        name: "valueType",
        type: "String",
        label: "Value type",
        help: "Value type.",
        group: "Source",
        options: ["Instant", "ZonedDateTime"],
        when: {
          operation: ["toEpoch"]
        }
      },
      {
        name: "value",
        type: "String",
        label: "ISO value",
        help: "ISO value.",
        group: "Source",
        sourceFormat: "iso",
        when: {
          operation: ["toEpoch"]
        }
      },
      {
        name: "dateValue",
        type: "Date",
        label: "Native date",
        help: "Native date.",
        group: "Source",
        sourceFormat: "date",
        when: {
          operation: ["toEpoch"]
        }
      },
      {
        name: "instantValue",
        type: "Datetime",
        label: "Native datetime",
        help: "Native datetime.",
        group: "Source",
        sourceFormat: "datetime",
        when: {
          operation: ["toEpoch"]
        }
      },
      {
        name: "timeValue",
        type: "String",
        label: "Local time",
        help: "ISO time for a native date and time input.",
        group: "Source",
        sourceFormat: "dateTime",
        when: {
          operation: ["toEpoch"]
        }
      },
      {
        name: "timeZoneId",
        type: "String",
        label: "Timezone",
        help: "Required when resolving local time or inspecting an instant.",
        searchable: true,
        group: "Context"
      },
      {
        name: "disambiguation",
        type: "String",
        label: "Repeated-time policy",
        help: "Repeated-time policy.",
        options: ["reject", "earlier", "later"],
        group: "Context"
      },
      {
        name: "epochValue",
        type: "Decimal",
        label: "Unix timestamp",
        help: "Unix timestamp.",
        when: {
          operation: ["fromEpoch"]
        },
        required: true
      },
      {
        name: "epochUnit",
        type: "String",
        label: "Timestamp unit",
        help: "Timestamp unit.",
        options: ["second", "millisecond"],
        required: true
      }
    ],
    result: "ChronoEpochResult"
  },
  {
    family: "ValueDetails",
    title: "Get date/time details",
    description:
      "Inspect calendar and clock components with an explicit timezone for instants.",
    category: "Values",
    fields: [
      {
        name: "valueType",
        type: "String",
        label: "Value type",
        help: "Value type.",
        group: "Source",
        options: [
          "PlainDate",
          "PlainDateTime",
          "PlainTime",
          "PlainYearMonth",
          "PlainMonthDay",
          "Instant",
          "ZonedDateTime",
          "Duration"
        ]
      },
      {
        name: "value",
        type: "String",
        label: "ISO value",
        help: "ISO value.",
        group: "Source",
        sourceFormat: "iso"
      },
      {
        name: "dateValue",
        type: "Date",
        label: "Native date",
        help: "Native date.",
        group: "Source",
        sourceFormat: "date"
      },
      {
        name: "instantValue",
        type: "Datetime",
        label: "Native datetime",
        help: "Native datetime.",
        group: "Source",
        sourceFormat: "datetime"
      },
      {
        name: "timeValue",
        type: "String",
        label: "Local time",
        help: "ISO time for a native date and time input.",
        group: "Source",
        sourceFormat: "dateTime"
      },
      {
        name: "timeZoneId",
        type: "String",
        label: "Timezone",
        help: "Required when resolving local time or inspecting an instant.",
        searchable: true,
        group: "Context"
      },
      {
        name: "disambiguation",
        type: "String",
        label: "Repeated-time policy",
        help: "Repeated-time policy.",
        options: ["reject", "earlier", "later"],
        group: "Context"
      }
    ],
    result: "ChronoDetailsResult"
  },
  {
    family: "DurationTools",
    title: "Calculate duration",
    description:
      "Construct, inspect, total, balance or scale durations with explicit calendar context.",
    category: "Durations",
    result: "ChronoDurationResult",
    fields: [
      {
        name: "operation",
        type: "String",
        label: "Operation",
        help: "Operation.",
        options: [
          "create",
          "components",
          "negate",
          "absolute",
          "total",
          "balance",
          "multiply",
          "divide"
        ],
        required: true
      },
      {
        name: "value",
        type: "String",
        label: "ISO duration",
        help: "ISO duration.",
        required: true,
        when: {
          operation: [
            "components",
            "negate",
            "absolute",
            "total",
            "balance",
            "multiply",
            "divide"
          ]
        }
      },
      {
        name: "unit",
        type: "String",
        label: "Result unit",
        help: "Result unit.",
        options: [
          "year",
          "month",
          "week",
          "day",
          "hour",
          "minute",
          "second",
          "millisecond"
        ],
        required: true,
        when: {
          operation: ["total", "balance"]
        }
      },
      {
        name: "factor",
        type: "Decimal",
        label: "Factor",
        help: "Factor.",
        required: true,
        when: {
          operation: ["multiply", "divide"]
        }
      },
      {
        name: "scalingMode",
        type: "String",
        label: "Scale using",
        help: "Components preserves calendar units and requires whole calendar results. Elapsed resolves calendar units at the supplied reference.",
        options: ["components", "elapsed"],
        when: {
          operation: ["multiply", "divide"]
        }
      },
      {
        name: "years",
        type: "Integer",
        label: "Years",
        help: "Years.",
        when: {
          operation: ["create"]
        }
      },
      {
        name: "months",
        type: "Integer",
        label: "Months",
        help: "Months.",
        when: {
          operation: ["create"]
        }
      },
      {
        name: "weeks",
        type: "Integer",
        label: "Weeks",
        help: "Weeks.",
        when: {
          operation: ["create"]
        }
      },
      {
        name: "days",
        type: "Integer",
        label: "Days",
        help: "Days.",
        when: {
          operation: ["create"]
        }
      },
      {
        name: "hours",
        type: "Long",
        label: "Hours",
        help: "Hours.",
        when: {
          operation: ["create"]
        }
      },
      {
        name: "minutes",
        type: "Long",
        label: "Minutes",
        help: "Minutes.",
        when: {
          operation: ["create"]
        }
      },
      {
        name: "seconds",
        type: "Decimal",
        label: "Seconds",
        help: "Seconds.",
        when: {
          operation: ["create"]
        }
      },
      {
        name: "milliseconds",
        type: "Long",
        label: "Milliseconds",
        help: "Milliseconds.",
        when: {
          operation: ["create"]
        }
      },
      {
        name: "referenceDate",
        type: "Date",
        label: "Reference date",
        help: "Use one reference date or datetime. A date without a timezone uses a plain midnight clock.",
        when: {
          operation: ["total", "balance", "multiply", "divide"]
        }
      },
      {
        name: "referenceInstant",
        type: "Datetime",
        label: "Reference datetime",
        help: "Reference datetime.",
        when: {
          operation: ["total", "balance", "multiply", "divide"]
        }
      },
      {
        name: "timeZoneId",
        type: "String",
        label: "Reference timezone",
        help: "Reference timezone.",
        searchable: true,
        when: {
          operation: ["total", "balance", "multiply", "divide"]
        }
      },
      {
        name: "disambiguation",
        type: "String",
        label: "Repeated-time policy",
        help: "Repeated-time policy.",
        options: ["reject", "earlier", "later"],
        when: {
          operation: ["total", "balance", "multiply", "divide"]
        }
      }
    ]
  },
  {
    family: "ZoneTools",
    title: "Work with timezones",
    category: "Time Zones",
    result: "ChronoZoneResult",
    fields: [
      {
        name: "operation",
        type: "String",
        label: "Operation",
        help: "Operation.",
        options: [
          "convert",
          "overrideOffset",
          "details",
          "listZones",
          "compareZones",
          "transitions",
          "nextTransition",
          "previousTransition"
        ],
        required: true
      },
      {
        name: "valueType",
        type: "String",
        label: "Value type",
        help: "Value type.",
        group: "Source",
        options: ["PlainDate", "PlainDateTime", "Instant", "ZonedDateTime"],
        when: {
          operation: [
            "convert",
            "overrideOffset",
            "details",
            "compareZones",
            "transitions",
            "nextTransition",
            "previousTransition"
          ]
        }
      },
      {
        name: "value",
        type: "String",
        label: "ISO value",
        help: "ISO value.",
        group: "Source",
        sourceFormat: "iso",
        when: {
          operation: [
            "convert",
            "overrideOffset",
            "details",
            "compareZones",
            "transitions",
            "nextTransition",
            "previousTransition"
          ]
        }
      },
      {
        name: "dateValue",
        type: "Date",
        label: "Native date",
        help: "Native date.",
        group: "Source",
        sourceFormat: "date",
        when: {
          operation: [
            "convert",
            "overrideOffset",
            "details",
            "compareZones",
            "transitions",
            "nextTransition",
            "previousTransition"
          ]
        }
      },
      {
        name: "instantValue",
        type: "Datetime",
        label: "Native datetime",
        help: "Native datetime.",
        group: "Source",
        sourceFormat: "datetime",
        when: {
          operation: [
            "convert",
            "overrideOffset",
            "details",
            "compareZones",
            "transitions",
            "nextTransition",
            "previousTransition"
          ]
        }
      },
      {
        name: "timeValue",
        type: "String",
        label: "Local time",
        help: "ISO time for a native date and time input.",
        group: "Source",
        sourceFormat: "dateTime",
        when: {
          operation: [
            "convert",
            "overrideOffset",
            "details",
            "compareZones",
            "transitions",
            "nextTransition",
            "previousTransition"
          ]
        }
      },
      {
        name: "timeZoneId",
        type: "String",
        label: "Timezone",
        help: "Required when resolving local time or inspecting an instant.",
        searchable: true,
        group: "Context",
        when: {
          operation: [
            "convert",
            "overrideOffset",
            "details",
            "compareZones",
            "transitions",
            "nextTransition",
            "previousTransition"
          ]
        }
      },
      {
        name: "disambiguation",
        type: "String",
        label: "Repeated-time policy",
        help: "Repeated-time policy.",
        options: ["reject", "earlier", "later"],
        group: "Context",
        when: {
          operation: [
            "convert",
            "overrideOffset",
            "details",
            "compareZones",
            "transitions",
            "nextTransition",
            "previousTransition"
          ]
        }
      },
      {
        name: "targetTimeZoneId",
        type: "String",
        label: "Target timezone",
        help: "Target timezone.",
        searchable: true,
        required: true,
        when: {
          operation: ["convert", "compareZones"]
        }
      },
      {
        name: "conversionMode",
        type: "String",
        label: "Keep",
        help: "Keep.",
        options: ["instant", "localClock"],
        when: {
          operation: ["convert"]
        }
      },
      {
        name: "suppliedOffset",
        type: "String",
        label: "Supplied UTC offset",
        help: "An explicit signed offset such as +01:00. The result also includes the actual zone projection.",
        required: true,
        when: {
          operation: ["overrideOffset"]
        }
      },
      {
        name: "search",
        type: "String",
        label: "Filter timezone IDs",
        help: "Filter timezone IDs.",
        when: {
          operation: ["listZones"]
        }
      },
      {
        name: "endInstant",
        type: "Datetime",
        label: "Search end",
        help: "Exclusive end for listing transitions. Searches are limited to 366 days.",
        required: true,
        when: {
          operation: ["transitions"]
        }
      },
      {
        name: "searchDays",
        type: "Integer",
        label: "Search days",
        help: "1\u2013366 days for next or previous transition. Defaults to 366.",
        when: {
          operation: ["nextTransition", "previousTransition"]
        }
      }
    ],
    description:
      "Convert zones, inspect date-specific offsets and search bounded timezone transitions."
  },
  {
    family: "RangeTools",
    title: "Work with date/time ranges",
    category: "Ranges",
    result: "ChronoRangeResult",
    fields: [
      {
        name: "operation",
        type: "String",
        label: "Operation",
        help: "Operation.",
        options: [
          "validate",
          "contains",
          "relationship",
          "intersection",
          "merge",
          "subtract",
          "gaps",
          "split",
          "clamp",
          "coverage"
        ],
        required: true
      },
      {
        name: "valueType",
        type: "String",
        label: "Value type",
        help: "Value type.",
        group: "Source",
        options: ["PlainDate", "PlainDateTime", "Instant", "ZonedDateTime"],
        when: {
          operation: [
            "validate",
            "contains",
            "relationship",
            "intersection",
            "merge",
            "subtract",
            "gaps",
            "split",
            "clamp",
            "coverage"
          ]
        }
      },
      {
        name: "value",
        type: "String",
        label: "ISO value",
        help: "ISO value.",
        group: "Source",
        sourceFormat: "iso",
        when: {
          operation: [
            "validate",
            "contains",
            "relationship",
            "intersection",
            "merge",
            "subtract",
            "gaps",
            "split",
            "clamp",
            "coverage"
          ]
        }
      },
      {
        name: "dateValue",
        type: "Date",
        label: "Native date",
        help: "Native date.",
        group: "Source",
        sourceFormat: "date",
        when: {
          operation: [
            "validate",
            "contains",
            "relationship",
            "intersection",
            "merge",
            "subtract",
            "gaps",
            "split",
            "clamp",
            "coverage"
          ]
        }
      },
      {
        name: "instantValue",
        type: "Datetime",
        label: "Native datetime",
        help: "Native datetime.",
        group: "Source",
        sourceFormat: "datetime",
        when: {
          operation: [
            "validate",
            "contains",
            "relationship",
            "intersection",
            "merge",
            "subtract",
            "gaps",
            "split",
            "clamp",
            "coverage"
          ]
        }
      },
      {
        name: "timeValue",
        type: "String",
        label: "Local time",
        help: "ISO time for a native date and time input.",
        group: "Source",
        sourceFormat: "dateTime",
        when: {
          operation: [
            "validate",
            "contains",
            "relationship",
            "intersection",
            "merge",
            "subtract",
            "gaps",
            "split",
            "clamp",
            "coverage"
          ]
        }
      },
      {
        name: "timeZoneId",
        type: "String",
        label: "Timezone",
        help: "Required when resolving local time or inspecting an instant.",
        searchable: true,
        group: "Context",
        when: {
          operation: [
            "validate",
            "contains",
            "relationship",
            "intersection",
            "merge",
            "subtract",
            "gaps",
            "split",
            "clamp",
            "coverage"
          ]
        }
      },
      {
        name: "disambiguation",
        type: "String",
        label: "Repeated-time policy",
        help: "Repeated-time policy.",
        options: ["reject", "earlier", "later"],
        group: "Context",
        when: {
          operation: [
            "validate",
            "contains",
            "relationship",
            "intersection",
            "merge",
            "subtract",
            "gaps",
            "split",
            "clamp",
            "coverage"
          ]
        }
      },
      {
        name: "endValue",
        type: "String",
        label: "End ISO value",
        help: "End ISO value.",
        endpointFormat: "iso"
      },
      {
        name: "endDate",
        type: "Date",
        label: "End native date",
        help: "End native date.",
        endpointFormat: "date"
      },
      {
        name: "endInstant",
        type: "Datetime",
        label: "End native datetime",
        help: "End native datetime.",
        endpointFormat: "datetime"
      },
      {
        name: "endTime",
        type: "String",
        label: "End local time",
        help: "Optional clock with a native end date.",
        endpointFormat: "dateTime"
      },
      {
        name: "pointValue",
        type: "String",
        label: "Point ISO value",
        help: "Same value type as the range; a zoned value may use another timezone.",
        required: true,
        when: {
          operation: ["contains", "clamp"]
        },
        auxiliaryGroup: "point",
        auxiliaryFormat: "iso",
        sourceLabel: "Point"
      },
      {
        name: "otherStart",
        type: "String",
        label: "Other range start ISO",
        help: "Other range start ISO.",
        required: true,
        when: {
          operation: ["relationship", "intersection"]
        },
        auxiliaryGroup: "otherStart",
        auxiliaryFormat: "iso",
        sourceLabel: "Other start"
      },
      {
        name: "otherEnd",
        type: "String",
        label: "Other range end ISO",
        help: "Other range end ISO.",
        required: true,
        when: {
          operation: ["relationship", "intersection"]
        },
        auxiliaryGroup: "otherEnd",
        auxiliaryFormat: "iso",
        sourceLabel: "Other end"
      },
      {
        name: "ranges",
        type: "List<String>",
        label: "Other ISO ranges",
        help: "Text collection of start/end intervals; slashes inside zone IDs are supported.",
        when: {
          operation: ["merge", "subtract", "gaps", "coverage"]
        },
        textAlternative: "rangesText"
      },
      {
        name: "duration",
        type: "String",
        label: "Split duration",
        help: "Positive ISO duration. Calendar units are evaluated at each boundary.",
        required: true,
        when: {
          operation: ["split"]
        }
      },
      {
        name: "maximumResults",
        type: "Integer",
        label: "Maximum results",
        help: "1\u20131000, default 100. Exceeding the limit returns an error, never a partial success."
      },
      {
        name: "rangesText",
        type: "String",
        label: "Fixed ISO ranges",
        help: "One start/end interval per line. Use this or a text collection, not both.",
        hidden: true
      },
      {
        name: "pointDate",
        type: "Date",
        label: "Point native date",
        help: "Use one native or ISO source for this value.",
        required: true,
        when: {
          operation: ["contains", "clamp"]
        },
        auxiliaryGroup: "point",
        auxiliaryFormat: "date",
        sourceLabel: "Point"
      },
      {
        name: "pointInstant",
        type: "Datetime",
        label: "Point native datetime",
        help: "Use one native or ISO source for this value.",
        required: true,
        when: {
          operation: ["contains", "clamp"]
        },
        auxiliaryGroup: "point",
        auxiliaryFormat: "datetime",
        sourceLabel: "Point"
      },
      {
        name: "pointTime",
        type: "String",
        label: "Point local time",
        help: "Use one native or ISO source for this value.",
        required: false,
        when: {
          operation: ["contains", "clamp"]
        },
        auxiliaryGroup: "point",
        auxiliaryFormat: "dateTime",
        sourceLabel: "Point"
      },
      {
        name: "otherStartDate",
        type: "Date",
        label: "Other start native date",
        help: "Use one native or ISO source for this value.",
        required: true,
        when: {
          operation: ["relationship", "intersection"]
        },
        auxiliaryGroup: "otherStart",
        auxiliaryFormat: "date",
        sourceLabel: "Other start"
      },
      {
        name: "otherStartInstant",
        type: "Datetime",
        label: "Other start native datetime",
        help: "Use one native or ISO source for this value.",
        required: true,
        when: {
          operation: ["relationship", "intersection"]
        },
        auxiliaryGroup: "otherStart",
        auxiliaryFormat: "datetime",
        sourceLabel: "Other start"
      },
      {
        name: "otherStartTime",
        type: "String",
        label: "Other start local time",
        help: "Use one native or ISO source for this value.",
        required: false,
        when: {
          operation: ["relationship", "intersection"]
        },
        auxiliaryGroup: "otherStart",
        auxiliaryFormat: "dateTime",
        sourceLabel: "Other start"
      },
      {
        name: "otherEndDate",
        type: "Date",
        label: "Other end native date",
        help: "Use one native or ISO source for this value.",
        required: true,
        when: {
          operation: ["relationship", "intersection"]
        },
        auxiliaryGroup: "otherEnd",
        auxiliaryFormat: "date",
        sourceLabel: "Other end"
      },
      {
        name: "otherEndInstant",
        type: "Datetime",
        label: "Other end native datetime",
        help: "Use one native or ISO source for this value.",
        required: true,
        when: {
          operation: ["relationship", "intersection"]
        },
        auxiliaryGroup: "otherEnd",
        auxiliaryFormat: "datetime",
        sourceLabel: "Other end"
      },
      {
        name: "otherEndTime",
        type: "String",
        label: "Other end local time",
        help: "Use one native or ISO source for this value.",
        required: false,
        when: {
          operation: ["relationship", "intersection"]
        },
        auxiliaryGroup: "otherEnd",
        auxiliaryFormat: "dateTime",
        sourceLabel: "Other end"
      }
    ],
    description:
      "Validate and manipulate half-open ranges: start is included and end is excluded."
  },
  {
    family: "Availability",
    title: "Find working-hour availability",
    category: "Working Hours",
    result: "ChronoAvailabilityResult",
    fields: [
      {
        name: "operation",
        type: "String",
        label: "Operation",
        help: "Operation.",
        options: [
          "windows",
          "boundaries",
          "containsRange",
          "continuous",
          "shared",
          "anySchedule",
          "appointments",
          "workingDates",
          "holidays",
          "validateSchedule"
        ],
        required: true
      },
      {
        name: "valueType",
        type: "String",
        label: "Value type",
        help: "Value type.",
        group: "Source",
        options: ["PlainDate", "PlainDateTime", "Instant", "ZonedDateTime"],
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "value",
        type: "String",
        label: "ISO value",
        help: "ISO value.",
        group: "Source",
        sourceFormat: "iso",
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "dateValue",
        type: "Date",
        label: "Native date",
        help: "Native date.",
        group: "Source",
        sourceFormat: "date",
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "instantValue",
        type: "Datetime",
        label: "Native datetime",
        help: "Native datetime.",
        group: "Source",
        sourceFormat: "datetime",
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "timeValue",
        type: "String",
        label: "Local time",
        help: "ISO time for a native date and time input.",
        group: "Source",
        sourceFormat: "dateTime",
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "timeZoneId",
        type: "String",
        label: "Timezone",
        help: "Required when resolving local time or inspecting an instant.",
        searchable: true,
        group: "Context",
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "disambiguation",
        type: "String",
        label: "Repeated-time policy",
        help: "Repeated-time policy.",
        options: ["reject", "earlier", "later"],
        group: "Context",
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "endValue",
        type: "String",
        label: "End ISO value",
        help: "End ISO value.",
        endpointFormat: "iso",
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "endDate",
        type: "Date",
        label: "End native date",
        help: "End native date.",
        endpointFormat: "date",
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "endInstant",
        type: "Datetime",
        label: "End native datetime",
        help: "End native datetime.",
        endpointFormat: "datetime",
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "endTime",
        type: "String",
        label: "End local time",
        help: "Optional clock with a native end date.",
        endpointFormat: "dateTime",
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "operatingHoursId",
        type: "String",
        label: "OperatingHours ID",
        help: "Use one saved ID or a supplied OperatingHours record."
      },
      {
        name: "operatingHours",
        type: "OperatingHours",
        label: "OperatingHours record",
        help: "A supplied record can be unsaved. Also supply its TimeSlot and Holiday collections.",
        objectType: "OperatingHours"
      },
      {
        name: "timeSlots",
        type: "List<TimeSlot>",
        label: "Time slots",
        help: "Normal slots for the supplied schedule; no DML is performed.",
        objectType: "TimeSlot"
      },
      {
        name: "holidays",
        type: "List<Holiday>",
        label: "Holidays",
        help: "Holiday records for the supplied schedule, including recurring holidays.",
        objectType: "Holiday"
      },
      {
        name: "otherOperatingHoursIds",
        type: "List<String>",
        label: "Additional schedule IDs",
        help: "Saved schedule IDs to intersect or unite with the primary schedule.",
        when: {
          operation: ["shared", "anySchedule", "appointments"]
        }
      },
      {
        name: "scheduleCombination",
        type: "String",
        label: "Combine schedules",
        help: "Combine schedules.",
        options: ["all", "any"],
        when: {
          operation: ["appointments"]
        }
      },
      {
        name: "busyRanges",
        type: "List<String>",
        label: "Busy intervals",
        help: "ISO exact start/end intervals to exclude from availability.",
        textAlternative: "busyRangesText",
        when: {
          operation: [
            "windows",
            "continuous",
            "shared",
            "anySchedule",
            "appointments"
          ]
        }
      },
      {
        name: "busyRangesText",
        type: "String",
        label: "Fixed busy intervals",
        help: "One exact ISO start/end interval per line.",
        hidden: true
      },
      {
        name: "duration",
        type: "String",
        label: "Continuous duration",
        help: "Positive elapsed ISO duration, for example PT30M. Calendar units are not appointment lengths.",
        required: true,
        when: {
          operation: ["continuous", "appointments"]
        }
      },
      {
        name: "stepDuration",
        type: "String",
        label: "Appointment start interval",
        help: "Positive elapsed ISO duration. Defaults to the appointment duration. Starts are anchored to each open window.",
        when: {
          operation: ["appointments"]
        }
      },
      {
        name: "maximumResults",
        type: "Integer",
        label: "Maximum results",
        help: "1\u20131000, default 100. Exceeding it returns an error."
      },
      {
        name: "referenceInstant",
        type: "Datetime",
        label: "Reference datetime",
        help: "Required when notice or booking horizon is set; use a Flow datetime such as the current datetime.",
        group: "Booking limits"
      },
      {
        name: "minimumNotice",
        type: "String",
        label: "Minimum notice",
        help: "Non-negative elapsed ISO duration from the reference datetime, for example PT2H.",
        group: "Booking limits"
      },
      {
        name: "bookingHorizon",
        type: "String",
        label: "Booking horizon",
        help: "Positive elapsed ISO duration from the reference datetime; the complete appointment must fit before this limit.",
        group: "Booking limits"
      },
      {
        name: "bufferBefore",
        type: "String",
        label: "Buffer before",
        help: "Non-negative elapsed duration kept free before each appointment within operating hours.",
        group: "Booking limits"
      },
      {
        name: "bufferAfter",
        type: "String",
        label: "Buffer after",
        help: "Non-negative elapsed duration kept free after each appointment within operating hours.",
        group: "Booking limits"
      },
      {
        name: "gridAnchor",
        type: "Datetime",
        label: "Appointment grid anchor",
        help: "Optional exact datetime anchoring appointment starts across all windows and busy breaks. Without it each free window anchors its own grid.",
        group: "Booking limits"
      }
    ],
    description:
      "Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays."
  },
  {
    family: "CollectionTools",
    title: "Work with date/time collections",
    category: "Collections",
    result: "ChronoValuesResult",
    fields: [
      {
        name: "operation",
        type: "String",
        label: "Operation",
        help: "Operation.",
        options: [
          "earliest",
          "latest",
          "sort",
          "deduplicate",
          "filter",
          "group",
          "sumDurations",
          "nearest",
          "summary"
        ],
        required: true
      },
      {
        name: "valueType",
        type: "String",
        label: "Value type",
        help: "Value type.",
        options: [
          "PlainDate",
          "PlainDateTime",
          "PlainTime",
          "PlainYearMonth",
          "PlainMonthDay",
          "Instant",
          "ZonedDateTime",
          "Duration"
        ],
        required: true,
        optionsByOperation: {
          sumDurations: ["Duration"],
          group: ["PlainDate", "PlainDateTime", "Instant", "ZonedDateTime"],
          nearest: [
            "PlainDate",
            "PlainDateTime",
            "Instant",
            "ZonedDateTime",
            "PlainTime",
            "Duration"
          ]
        }
      },
      {
        name: "values",
        type: "List<String>",
        label: "ISO values",
        help: "Ordered ISO text collection, or fixed values with one item per line.",
        textAlternative: "valuesText"
      },
      {
        name: "valuesText",
        type: "String",
        label: "Fixed ISO values",
        help: "One ISO value per line.",
        hidden: true
      },
      {
        name: "dates",
        type: "List<Date>",
        label: "Native dates",
        help: "Alternative Date collection; do not supply another source."
      },
      {
        name: "datetimes",
        type: "List<Datetime>",
        label: "Native datetimes",
        help: "Alternative Datetime collection; do not supply another source."
      },
      {
        name: "timeZoneId",
        type: "String",
        label: "Calculation timezone",
        help: "Required for exact calendar grouping or zoned native input.",
        searchable: true
      },
      {
        name: "referenceDate",
        type: "Date",
        label: "Duration reference date",
        help: "Required to order durations containing calendar units."
      },
      {
        name: "direction",
        type: "String",
        label: "Sort order",
        help: "Sort order.",
        options: ["ascending", "descending"],
        when: {
          operation: ["sort"]
        }
      },
      {
        name: "lowerValue",
        type: "String",
        label: "Lower ISO value",
        help: "Included lower filter boundary.",
        when: {
          operation: ["filter"]
        },
        auxiliaryGroup: "lower",
        auxiliaryFormat: "iso",
        sourceLabel: "Lower boundary"
      },
      {
        name: "upperValue",
        type: "String",
        label: "Upper ISO value",
        help: "Excluded upper filter boundary.",
        when: {
          operation: ["filter"]
        },
        auxiliaryGroup: "upper",
        auxiliaryFormat: "iso",
        sourceLabel: "Upper boundary"
      },
      {
        name: "period",
        type: "String",
        label: "Group by",
        help: "Group by.",
        options: ["day", "week", "month", "quarter", "year"],
        required: true,
        when: {
          operation: ["group"]
        }
      },
      {
        name: "weekStartsOn",
        type: "Integer",
        label: "Week starts on",
        help: "1 is Monday through 7 Sunday; defaults to Monday.",
        when: {
          operation: ["group"]
        }
      },
      {
        name: "pointValue",
        type: "String",
        label: "Nearest to ISO value",
        help: "Nearest to ISO value.",
        required: true,
        when: {
          operation: ["nearest"]
        },
        auxiliaryGroup: "point",
        auxiliaryFormat: "iso",
        sourceLabel: "Nearest reference"
      },
      {
        name: "lowerDate",
        type: "Date",
        label: "Lower boundary native date",
        help: "Use one native or ISO source for this value.",
        when: {
          operation: ["filter"]
        },
        auxiliaryGroup: "lower",
        auxiliaryFormat: "date",
        sourceLabel: "Lower boundary"
      },
      {
        name: "lowerInstant",
        type: "Datetime",
        label: "Lower boundary native datetime",
        help: "Use one native or ISO source for this value.",
        when: {
          operation: ["filter"]
        },
        auxiliaryGroup: "lower",
        auxiliaryFormat: "datetime",
        sourceLabel: "Lower boundary"
      },
      {
        name: "lowerTime",
        type: "String",
        label: "Lower boundary local time",
        help: "Use one native or ISO source for this value.",
        when: {
          operation: ["filter"]
        },
        auxiliaryGroup: "lower",
        auxiliaryFormat: "dateTime",
        sourceLabel: "Lower boundary",
        required: false
      },
      {
        name: "upperDate",
        type: "Date",
        label: "Upper boundary native date",
        help: "Use one native or ISO source for this value.",
        when: {
          operation: ["filter"]
        },
        auxiliaryGroup: "upper",
        auxiliaryFormat: "date",
        sourceLabel: "Upper boundary"
      },
      {
        name: "upperInstant",
        type: "Datetime",
        label: "Upper boundary native datetime",
        help: "Use one native or ISO source for this value.",
        when: {
          operation: ["filter"]
        },
        auxiliaryGroup: "upper",
        auxiliaryFormat: "datetime",
        sourceLabel: "Upper boundary"
      },
      {
        name: "upperTime",
        type: "String",
        label: "Upper boundary local time",
        help: "Use one native or ISO source for this value.",
        when: {
          operation: ["filter"]
        },
        auxiliaryGroup: "upper",
        auxiliaryFormat: "dateTime",
        sourceLabel: "Upper boundary",
        required: false
      },
      {
        name: "pointDate",
        type: "Date",
        label: "Nearest reference native date",
        help: "Use one native or ISO source for this value.",
        required: true,
        when: {
          operation: ["nearest"]
        },
        auxiliaryGroup: "point",
        auxiliaryFormat: "date",
        sourceLabel: "Nearest reference"
      },
      {
        name: "pointInstant",
        type: "Datetime",
        label: "Nearest reference native datetime",
        help: "Use one native or ISO source for this value.",
        required: true,
        when: {
          operation: ["nearest"]
        },
        auxiliaryGroup: "point",
        auxiliaryFormat: "datetime",
        sourceLabel: "Nearest reference"
      },
      {
        name: "pointTime",
        type: "String",
        label: "Nearest reference local time",
        help: "Use one native or ISO source for this value.",
        required: false,
        when: {
          operation: ["nearest"]
        },
        auxiliaryGroup: "point",
        auxiliaryFormat: "dateTime",
        sourceLabel: "Nearest reference"
      }
    ],
    description:
      "Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow."
  },
  {
    family: "FiscalPeriod",
    title: "Get fiscal period",
    category: "Calculations",
    result: "ChronoFiscalResult",
    fields: [
      {
        name: "valueType",
        type: "String",
        label: "Value type",
        help: "Value type.",
        group: "Source",
        options: ["PlainDate", "PlainDateTime", "Instant", "ZonedDateTime"]
      },
      {
        name: "value",
        type: "String",
        label: "ISO value",
        help: "ISO value.",
        group: "Source",
        sourceFormat: "iso"
      },
      {
        name: "dateValue",
        type: "Date",
        label: "Native date",
        help: "Native date.",
        group: "Source",
        sourceFormat: "date"
      },
      {
        name: "instantValue",
        type: "Datetime",
        label: "Native datetime",
        help: "Native datetime.",
        group: "Source",
        sourceFormat: "datetime"
      },
      {
        name: "timeValue",
        type: "String",
        label: "Local time",
        help: "ISO time for a native date and time input.",
        group: "Source",
        sourceFormat: "dateTime"
      },
      {
        name: "timeZoneId",
        type: "String",
        label: "Timezone",
        help: "Required when resolving local time or inspecting an instant.",
        searchable: true,
        group: "Context"
      },
      {
        name: "disambiguation",
        type: "String",
        label: "Repeated-time policy",
        help: "Repeated-time policy.",
        options: ["reject", "earlier", "later"],
        group: "Context"
      },
      {
        name: "calendarSource",
        type: "String",
        label: "Fiscal configuration",
        help: "Fiscal configuration.",
        options: ["organisation", "monthBased"],
        required: true
      },
      {
        name: "period",
        type: "String",
        label: "Fiscal period",
        help: "Fiscal period.",
        options: ["year", "quarter", "month"],
        required: true
      },
      {
        name: "startMonth",
        type: "Integer",
        label: "Fiscal year starts in month",
        help: "1\u201312. Used only for a month-based fiscal year.",
        required: true,
        when: {
          calendarSource: ["monthBased"]
        }
      }
    ],
    description:
      "Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries."
  },
  {
    family: "Recurrence",
    title: "Generate recurring dates",
    category: "Recurrence",
    result: "ChronoRecurrenceResult",
    fields: [
      {
        name: "operation",
        type: "String",
        label: "Operation",
        help: "Operation.",
        options: [
          "weekday",
          "nthWeekday",
          "annual",
          "nthWorkingDay",
          "generate",
          "rrule"
        ],
        required: true
      },
      {
        name: "valueType",
        type: "String",
        label: "Value type",
        help: "Value type.",
        group: "Source",
        options: ["PlainDate", "PlainDateTime", "Instant", "ZonedDateTime"]
      },
      {
        name: "value",
        type: "String",
        label: "ISO value",
        help: "ISO value.",
        group: "Source",
        sourceFormat: "iso"
      },
      {
        name: "dateValue",
        type: "Date",
        label: "Native date",
        help: "Native date.",
        group: "Source",
        sourceFormat: "date"
      },
      {
        name: "instantValue",
        type: "Datetime",
        label: "Native datetime",
        help: "Native datetime.",
        group: "Source",
        sourceFormat: "datetime"
      },
      {
        name: "timeValue",
        type: "String",
        label: "Local time",
        help: "ISO time for a native date and time input.",
        group: "Source",
        sourceFormat: "dateTime"
      },
      {
        name: "timeZoneId",
        type: "String",
        label: "Timezone",
        help: "Required when resolving local time or inspecting an instant.",
        searchable: true,
        group: "Context"
      },
      {
        name: "disambiguation",
        type: "String",
        label: "Repeated-time policy",
        help: "Repeated-time policy.",
        options: ["reject", "earlier", "later"],
        group: "Context",
        when: {
          operation: [
            "weekday",
            "nthWeekday",
            "annual",
            "nthWorkingDay",
            "generate"
          ]
        }
      },
      {
        name: "direction",
        type: "String",
        label: "Direction",
        help: "Direction.",
        options: ["next", "previous"],
        when: {
          operation: ["weekday", "annual"]
        }
      },
      {
        name: "inclusive",
        type: "Boolean",
        label: "Include the starting date",
        help: "Include the starting date.",
        when: {
          operation: ["weekday", "annual"]
        }
      },
      {
        name: "weekday",
        type: "Integer",
        label: "Weekday",
        help: "1 Monday through 7 Sunday.",
        required: true,
        when: {
          operation: ["weekday", "nthWeekday"]
        }
      },
      {
        name: "ordinal",
        type: "Integer",
        label: "Occurrence",
        help: "Positive from the start; negative from the end. For example -1 is last.",
        required: true,
        when: {
          operation: ["nthWeekday", "nthWorkingDay"]
        }
      },
      {
        name: "month",
        type: "Integer",
        label: "Annual month",
        help: "1\u201312.",
        required: true,
        when: {
          operation: ["annual"]
        }
      },
      {
        name: "day",
        type: "Integer",
        label: "Annual day",
        help: "Invalid dates such as 29 February in a common year are skipped.",
        required: true,
        when: {
          operation: ["annual"]
        }
      },
      {
        name: "frequency",
        type: "String",
        label: "Repeat every",
        help: "Repeat every.",
        options: ["daily", "weekly", "monthly", "yearly"],
        required: true,
        when: {
          operation: ["generate"]
        }
      },
      {
        name: "interval",
        type: "Integer",
        label: "Interval",
        help: "Positive frequency interval; defaults to 1.",
        when: {
          operation: ["generate"]
        }
      },
      {
        name: "weekdays",
        type: "String",
        label: "Weekdays",
        help: "Comma-separated MO,TU,WE,TH,FR,SA,SU. Weekly rules only.",
        when: {
          operation: ["generate"]
        }
      },
      {
        name: "rule",
        type: "String",
        label: "iCalendar RRULE",
        help: "Supported: FREQ DAILY/WEEKLY/MONTHLY/YEARLY, INTERVAL, COUNT, UNTIL, BYDAY (plain weekday codes), BYMONTHDAY, BYMONTH and WKST. Unsupported parts are rejected.",
        required: true,
        when: {
          operation: ["rrule"]
        }
      },
      {
        name: "untilDate",
        type: "Date",
        label: "Search through date",
        help: "Inclusive date boundary, at most 3660 days from the start.",
        required: true,
        when: {
          operation: ["generate", "rrule"]
        }
      },
      {
        name: "count",
        type: "Integer",
        label: "Occurrence count",
        help: "Optional deliberate stop count. Distinct from the safety result limit.",
        when: {
          operation: ["generate"]
        }
      },
      {
        name: "gapPolicy",
        type: "String",
        label: "Skipped local times",
        help: "Skipped local times.",
        options: ["reject", "skip", "forward", "backward"],
        when: {
          operation: ["generate"]
        }
      },
      {
        name: "closedPolicy",
        type: "String",
        label: "Closed schedule dates",
        help: "Closed schedule dates.",
        options: ["keep", "skip", "next", "previous"]
      },
      {
        name: "maximumResults",
        type: "Integer",
        label: "Maximum results",
        help: "1\u20131000, default 100. Larger output fails rather than being silently truncated."
      },
      {
        name: "operatingHoursId",
        type: "String",
        label: "OperatingHours ID",
        help: "Use one saved ID or a supplied OperatingHours record."
      },
      {
        name: "operatingHours",
        type: "OperatingHours",
        label: "OperatingHours record",
        help: "A supplied record can be unsaved. Also supply its TimeSlot and Holiday collections.",
        objectType: "OperatingHours"
      },
      {
        name: "timeSlots",
        type: "List<TimeSlot>",
        label: "Time slots",
        help: "Normal slots for the supplied schedule; no DML is performed.",
        objectType: "TimeSlot"
      },
      {
        name: "holidays",
        type: "List<Holiday>",
        label: "Holidays",
        help: "Holiday records for the supplied schedule, including recurring holidays.",
        objectType: "Holiday"
      }
    ],
    description:
      "Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments."
  },
  {
    family: "FormatValue",
    title: "Format date/time for display",
    category: "Formatting",
    result: "ChronoFormatResult",
    fields: [
      {
        name: "operation",
        type: "String",
        label: "Operation",
        help: "Operation.",
        options: ["value", "range", "duration", "relative"],
        required: true
      },
      {
        name: "valueType",
        type: "String",
        label: "Value type",
        help: "Value type.",
        group: "Source",
        options: [
          "PlainDate",
          "PlainDateTime",
          "PlainTime",
          "PlainYearMonth",
          "PlainMonthDay",
          "Instant",
          "ZonedDateTime",
          "Duration"
        ],
        optionsByOperation: {
          duration: ["Duration"],
          relative: ["PlainDate", "PlainDateTime", "Instant", "ZonedDateTime"],
          range: [
            "PlainDate",
            "PlainDateTime",
            "PlainTime",
            "PlainYearMonth",
            "PlainMonthDay",
            "Instant",
            "ZonedDateTime"
          ]
        }
      },
      {
        name: "value",
        type: "String",
        label: "ISO value",
        help: "ISO value.",
        group: "Source",
        sourceFormat: "iso"
      },
      {
        name: "dateValue",
        type: "Date",
        label: "Native date",
        help: "Native date.",
        group: "Source",
        sourceFormat: "date"
      },
      {
        name: "instantValue",
        type: "Datetime",
        label: "Native datetime",
        help: "Native datetime.",
        group: "Source",
        sourceFormat: "datetime"
      },
      {
        name: "timeValue",
        type: "String",
        label: "Local time",
        help: "ISO time for a native date and time input.",
        group: "Source",
        sourceFormat: "dateTime"
      },
      {
        name: "timeZoneId",
        type: "String",
        label: "Timezone",
        help: "Required when resolving local time or inspecting an instant.",
        searchable: true,
        group: "Context"
      },
      {
        name: "disambiguation",
        type: "String",
        label: "Repeated-time policy",
        help: "Repeated-time policy.",
        options: ["reject", "earlier", "later"],
        group: "Context"
      },
      {
        name: "style",
        type: "String",
        label: "Display length",
        help: "Component order and names follow the context user locale. Gregorian years always use four digits.",
        options: ["short", "medium", "long", "full"],
        when: {
          operation: ["value", "range"]
        }
      },
      {
        name: "pattern",
        type: "String",
        label: "Explicit output pattern",
        help: "Optional Apex date-format pattern. Overrides display length; parsing never guesses this pattern.",
        when: {
          operation: ["value", "range"]
        }
      },
      {
        name: "includeZone",
        type: "Boolean",
        label: "Append timezone offset and ID",
        help: "Append timezone offset and ID.",
        when: {
          operation: ["value", "range"]
        }
      },
      {
        name: "endValue",
        type: "String",
        label: "Range end ISO value",
        help: "The same value family as the start.",
        required: true,
        when: {
          operation: ["range"]
        },
        auxiliaryGroup: "end",
        auxiliaryFormat: "iso",
        sourceLabel: "Range end"
      },
      {
        name: "separator",
        type: "String",
        label: "Range separator",
        help: "Defaults to an en dash.",
        when: {
          operation: ["range"]
        }
      },
      {
        name: "durationStyle",
        type: "String",
        label: "Duration style",
        help: "ISO is language-neutral; compact uses unit symbols and long uses English unit names.",
        options: ["iso", "compact", "long"],
        when: {
          operation: ["duration"]
        }
      },
      {
        name: "referenceValue",
        type: "String",
        label: "Relative reference ISO value",
        help: "Supply a reference of the same type, or another exact value.",
        required: true,
        when: {
          operation: ["relative"]
        },
        auxiliaryGroup: "reference",
        auxiliaryFormat: "iso",
        sourceLabel: "Reference"
      },
      {
        name: "relativeUnit",
        type: "String",
        label: "Relative elapsed unit",
        help: "Auto chooses elapsed seconds, minutes, hours or 24-hour days.",
        options: ["auto", "second", "minute", "hour", "day"],
        when: {
          operation: ["relative"]
        }
      },
      {
        name: "referenceDate",
        type: "Date",
        label: "Reference native date",
        help: "Use one native or ISO source for this value.",
        required: true,
        when: {
          operation: ["relative"]
        },
        auxiliaryGroup: "reference",
        auxiliaryFormat: "date",
        sourceLabel: "Reference"
      },
      {
        name: "referenceInstant",
        type: "Datetime",
        label: "Reference native datetime",
        help: "Use one native or ISO source for this value.",
        required: true,
        when: {
          operation: ["relative"]
        },
        auxiliaryGroup: "reference",
        auxiliaryFormat: "datetime",
        sourceLabel: "Reference"
      },
      {
        name: "referenceTime",
        type: "String",
        label: "Reference local time",
        help: "Use one native or ISO source for this value.",
        required: false,
        when: {
          operation: ["relative"]
        },
        auxiliaryGroup: "reference",
        auxiliaryFormat: "dateTime",
        sourceLabel: "Reference"
      },
      {
        name: "endDate",
        type: "Date",
        label: "Range end native date",
        help: "Use one native or ISO source for this value.",
        required: true,
        when: {
          operation: ["range"]
        },
        auxiliaryGroup: "end",
        auxiliaryFormat: "date",
        sourceLabel: "Range end"
      },
      {
        name: "endInstant",
        type: "Datetime",
        label: "Range end native datetime",
        help: "Use one native or ISO source for this value.",
        required: true,
        when: {
          operation: ["range"]
        },
        auxiliaryGroup: "end",
        auxiliaryFormat: "datetime",
        sourceLabel: "Range end"
      },
      {
        name: "endTime",
        type: "String",
        label: "Range end local time",
        help: "Use one native or ISO source for this value.",
        required: false,
        when: {
          operation: ["range"]
        },
        auxiliaryGroup: "end",
        auxiliaryFormat: "dateTime",
        sourceLabel: "Range end"
      }
    ],
    description:
      "Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output."
  },
  {
    family: "WorkingDays",
    title: "Add working calendar days",
    description:
      "Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays.",
    category: "Working Hours",
    fields: [
      {
        name: "valueType",
        type: "String",
        label: "Value type",
        help: "Value type.",
        group: "Source",
        options: ["PlainDate", "PlainDateTime", "Instant", "ZonedDateTime"],
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "value",
        type: "String",
        label: "ISO value",
        help: "ISO value.",
        group: "Source",
        sourceFormat: "iso",
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "dateValue",
        type: "Date",
        label: "Native date",
        help: "Native date.",
        group: "Source",
        sourceFormat: "date",
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "instantValue",
        type: "Datetime",
        label: "Native datetime",
        help: "Native datetime.",
        group: "Source",
        sourceFormat: "datetime",
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "timeValue",
        type: "String",
        label: "Local time",
        help: "ISO time for a native date and time input.",
        group: "Source",
        sourceFormat: "dateTime",
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "timeZoneId",
        type: "String",
        label: "Timezone",
        help: "Required when resolving local time or inspecting an instant.",
        searchable: true,
        group: "Context",
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "disambiguation",
        type: "String",
        label: "Repeated-time policy",
        help: "Repeated-time policy.",
        options: ["reject", "earlier", "later"],
        group: "Context",
        when: {
          operation: [
            "windows",
            "boundaries",
            "containsRange",
            "continuous",
            "shared",
            "anySchedule",
            "appointments",
            "workingDates",
            "holidays"
          ]
        }
      },
      {
        name: "operatingHoursId",
        type: "String",
        label: "OperatingHours ID",
        help: "Use one saved ID or a supplied OperatingHours record."
      },
      {
        name: "operatingHours",
        type: "OperatingHours",
        label: "OperatingHours record",
        help: "A supplied record can be unsaved. Also supply its TimeSlot and Holiday collections.",
        objectType: "OperatingHours"
      },
      {
        name: "timeSlots",
        type: "List<TimeSlot>",
        label: "Time slots",
        help: "Normal slots for the supplied schedule; no DML is performed.",
        objectType: "TimeSlot"
      },
      {
        name: "holidays",
        type: "List<Holiday>",
        label: "Holidays",
        help: "Holiday records for the supplied schedule, including recurring holidays.",
        objectType: "Holiday"
      },
      {
        name: "amount",
        type: "Integer",
        label: "Working calendar days",
        help: "Signed whole working dates to add; the starting date is excluded. Maximum search is 3660 calendar days.",
        group: "Calculation",
        required: true
      },
      {
        name: "closedTimePolicy",
        type: "String",
        label: "If the resulting clock is closed",
        help: "Keep rejects neither closed clocks nor missing hours; reject requires open hours; next and previous move to the nearest open boundary. Dates only require a working date.",
        group: "Calculation",
        options: ["keep", "reject", "next", "previous"]
      }
    ],
    result: "ChronoFlowResult"
  },
  {
    family: "TimeAllocation",
    title: "Allocate time to blocks",
    result: "ChronoTimeAllocationResult",
    category: "Time allocation",
    description:
      "Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.",
    fields: [
      {
        name: "valueType",
        type: "String",
        label: "Value type",
        help: "Value type.",
        group: "Source",
        options: ["PlainDate", "PlainDateTime", "Instant", "ZonedDateTime"]
      },
      {
        name: "value",
        type: "String",
        label: "ISO value",
        help: "ISO value.",
        group: "Source",
        sourceFormat: "iso"
      },
      {
        name: "dateValue",
        type: "Date",
        label: "Native date",
        help: "Native date.",
        group: "Source",
        sourceFormat: "date"
      },
      {
        name: "instantValue",
        type: "Datetime",
        label: "Native datetime",
        help: "Native datetime.",
        group: "Source",
        sourceFormat: "datetime"
      },
      {
        name: "timeValue",
        type: "String",
        label: "Local time",
        help: "ISO time for a native date and time input.",
        group: "Source",
        sourceFormat: "dateTime"
      },
      {
        name: "timeZoneId",
        type: "String",
        label: "Block timezone",
        help: "Required. All block clocks and supplied holiday dates use this timezone.",
        searchable: true,
        group: "Context",
        required: true
      },
      {
        name: "disambiguation",
        type: "String",
        label: "Repeated-time policy",
        help: "Repeated-time policy.",
        options: ["reject", "earlier", "later"],
        group: "Context"
      },
      {
        name: "endValue",
        type: "String",
        label: "End ISO value",
        help: "End ISO value.",
        endpointFormat: "iso"
      },
      {
        name: "endDate",
        type: "Date",
        label: "End native date",
        help: "End native date.",
        endpointFormat: "date"
      },
      {
        name: "endInstant",
        type: "Datetime",
        label: "End native datetime",
        help: "End native datetime.",
        endpointFormat: "datetime"
      },
      {
        name: "endTime",
        type: "String",
        label: "End local time",
        help: "Optional clock with a native end date.",
        endpointFormat: "dateTime"
      },
      {
        name: "blocksText",
        type: "String",
        label: "Time blocks",
        help: "Ordered named blocks. Configure here or supply the same JSON definition from a Text resource.",
        group: "Blocks",
        required: true,
        literalType: "time-blocks"
      },
      {
        name: "holidays",
        type: "List<Holiday>",
        objectType: "Holiday",
        label: "Bank holidays",
        help: "Native Holiday record collection, including unsaved or recurring holidays. Dates use the block timezone.",
        group: "Blocks"
      },
      {
        name: "overlapMode",
        type: "String",
        label: "Overlapping blocks",
        help: "Strict rejects matching overlaps; lax uses the first block; duplicate credits every block; split shares time equally.",
        group: "Allocation",
        options: ["strict", "lax", "duplicate", "split"],
        default: "strict"
      },
      {
        name: "timeBasis",
        type: "String",
        label: "Count time as",
        help: "Default elapsed: actual time. Clock: local endpoint difference, counting skipped clock time and repeated clock time once.",
        group: "Allocation",
        options: ["elapsed", "clock"],
        default: "elapsed"
      },
      {
        name: "allocationUnit",
        type: "String",
        label: "Allocate in units of",
        help: "Default millisecond. Whole units are distributed per segment; remaining units go to earlier blocks. Sub-unit time is reported separately.",
        group: "Allocation",
        options: ["millisecond", "second", "minute"],
        default: "millisecond"
      },
      {
        name: "maximumSegments",
        type: "Integer",
        label: "Maximum segment rows",
        help: "Default 1000; allowed 1\u20135000. Exceeding the limit fails without partial totals.",
        group: "Limits",
        default: 1000
      }
    ]
  }
];
