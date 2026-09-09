# Configure a date and time screen

Add **Chrono: Date and time** to a Flow Screen. Its sidebar uses inline sections
for field settings, timezones, operating hours and interaction. Runtime users
see a compact date/time pair with independent timezone and Hours controls.

## Field settings

Choose `date` for a calendar date or `datetime` for a timezone-aware date and
clock. Supply a useful label, optional help, required/disabled settings and a
date display length.

The admin chooses **short**, **medium** or **long**; the user's Salesforce locale
determines the order and punctuation for that length. Short gives a UK user a
numeric day/month/year presentation. It does not force every user's date format
to be the same. The datetime Flow component defaults to medium; the record-page
adapter defaults to short. Native mobile controls follow device presentation.

## One initial value

Choose a fixed value or a compatible Flow resource. Native Date, native DateTime
and ISO Text are supported. A Text resource can contain a date, plain datetime,
instant or zoned datetime. Time-only, duration and partial dates cannot initialise
a dated picker.

An exact initial instant is projected into the configured zone. A date in
datetime mode starts at local midnight. A local datetime is resolved in the
selected zone and can require a repeated-time choice. Invalid runtime resource
contents are reported rather than turned into a blank valid value.

## Timezone choices

| Admin intention        | Configuration                                                                |
| ---------------------- | ---------------------------------------------------------------------------- |
| One fixed zone         | Supply a default ID; disallow user timezone changes                          |
| User's zone by default | Omit the default; the running user's zone is used                            |
| Any supported zone     | Allow selection with scope `all`                                             |
| Restrict choices       | Allow selection with scope `list`; supply fixed IDs and/or a Text collection |

The allowed list can combine fixed entries with Flow-supplied IDs. An empty
restricted list is an error, not permission to choose every zone. A configured
default must belong to the list. Use named IDs such as `Europe/London`, not a
fixed offset pretending to be a timezone.

## Operating-hours choices

| Source mode | Supply                                | Result                                              |
| ----------- | ------------------------------------- | --------------------------------------------------- |
| `none`      | Nothing                               | No schedule restriction                             |
| `id`        | One OperatingHours ID                 | One fixed saved schedule                            |
| `ids`       | Fixed IDs and/or ID collection        | Choose from those saved schedules                   |
| `filter`    | Structured criteria                   | Choose from accessible matches                      |
| `all`       | Nothing                               | Choose from accessible schedules                    |
| `record`    | Saved OperatingHours record           | Load its saved related slots/holidays               |
| `records`   | Saved OperatingHours collection       | Choose a saved schedule                             |
| `supplied`  | OperatingHours + TimeSlots + Holidays | Evaluate supplied fields, including unsaved records |
| `fixed`     | Inline weekly hours and holidays      | Build a native schedule without saving records      |

For search/list sources, enable **Lock operating-hours selection** when users
must retain the supplied selection. Single, fixed and supplied schedules are
already fixed. Locking Hours does not lock the timezone, or vice versa.

A saved record mode is not the same as supplied mode. Use `supplied` when your
unsaved slots and holidays are the actual definition; a saved record selection
loads the relationships associated with its ID.

## Filters

Filters accept up to ten ANDed criteria over `Name` and `TimeZone`, using `eq`,
`ne`, `contains` or `startsWith`. They are structured data, not raw SOQL.

```json
{
  "criteria": [
    { "fieldPath": "TimeZone", "operator": "eq", "value": "Europe/London" }
  ]
}
```

The server rechecks restrictions when validating the selected ID. Search returns
at most 50 matches; narrow the name search when necessary. The schedule zone can
be different from the selected display zone.

## Offset and closed-time choices

The offset control shows the current abbreviation/offset and can be reopened.
A newly entered repeated time needs an occurrence choice. A missing time offers
the nearest valid boundaries. If a schedule is configured, a closed time offers
the previous open millisecond or next opening.

Only enable supplied-offset overrides when your business process needs them.
Preserve `offsetOverride` with the native instant when reconstructing that entry.
See [timezone behaviour](timezones.md).

## Outputs and navigation

Use native `dateValue` for a Date field and `dateTimeValue` for a DateTime field.
ISO outputs are `chronoDateValue`, `chronoTimeValue`,
`chronoPlainDateTimeValue`, `chronoInstantValue` and `chronoZonedDateTimeValue`.
Date mode produces date outputs only. Unresolved or invalid edits clear ISO
outputs and block navigation while resolution is required or pending.

The adapter implements Flow validation and attribute-change events. Going
Previous preserves the restored native outputs rather than blindly resetting
to the original initial value. Later reactive input changes are revalidated.
See the [property reference](../reference/components/chronoFlowDateTime.md).
