# Date and time picker

`Chrono: Date and time` is a Flow screen component with a separate custom Flow
configuration editor. It supports calendar dates and zoned datetimes, optional
user timezone selection, explicit clock-change choices, and OperatingHours with
holidays. It never saves records.

## Component boundaries

The Flow properties sidebar groups configuration into Field settings, Timezones,
Operating hours, User interaction and outputs. It uses inline controls and
collapsible sections, with no modal or runtime preview. Timezones and operating
hours share a **User selection → Values supplied by** pattern. Saved schedule
and timezone lists use searchable add/remove controls. Existing schedule modes
and resource bindings retain their runtime representation.

For timezone restrictions, `timeZoneSelectionMode=list` uses `timeZoneIdsText`
for a fixed list or `timeZoneIds` for a Flow Text collection. An empty restricted
list rejects selection; it does not silently allow every timezone. A default
timezone must belong to that list. Dynamic list items must arrive through the
bound collection: resource-reference text embedded in saved JSON is not evaluated
by Flow.

Each scalar value uses a compact input-mode button beside its field, with one
visible label. The menu offers **Search Resources** or the appropriate literal
control (Enter Text, Enter Date, Enter Date/Time or Select Value), marks the current
mode, and keeps the value when that mode is selected again. Help appears in an
inline help icon. Resource-only inputs show just the lookup. The implementation
uses Salesforce's [base button menu](https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-button-menu.html)
for SLDS 1/2 styling and keyboard interaction. Existing formulas are selectable
resources; this menu does not launch Salesforce's Formula or Transform editors.

The editor separates the reusable `chronoFlowResourcePicker`,
`chronoFlowListEditor` and `chronoFlowValueEditor`. The resource picker is a compact
SLDS lookup: type to search compatible references and fields, or browse grouped
resources in its dropdown. Empty or incompatible groups are hidden. Typing does
not commit a reference; only choosing a compatible result does. Existing saved
references remain displayed even if absent from the supplied context, but cannot
be added as unlisted text. Escape, outside clicks and leaving the control dismiss
the dropdown; internal focus changes keep it open.

Its inputs are `builderContext`, `automaticOutputVariables` (Flow's separate
automatic-output metadata), `valueType` (such as `DateTime` or `String[]`), optional
`objectType` (the exact SObject/Apex type), `value` and `label`. The parent handles
`choose` with `event.detail.value`, a Flow reference without merge-field braces;
an empty value clears the binding. It needs no caller-built options list and has
no picker-specific date, timezone or operating-hours logic. Required type/context
changes invalidate the open results. Matching supplied records need no schema
permission check merely to select the existing Flow variable.

Record navigation browses readable fields and parent relationships. Search covers
the loaded fields; navigate a parent to load deeper relationships. Schema requests
are deduplicated within an open lookup. `ChronoFlowEditorController` reads schema only, enforces object/field
read access, and is called by an LWC in the same package. It adds no global Apex
API; installed editor registrations and subscriber tests passed on released 0.1.0.19; browser rendering remains unverified.

The approved compact layout uses adjacent base date/time inputs, one label row
with independent timezone and Hours controls, and a small persistent offset
control. Search, occurrence choices and closed-hours alternatives open in
anchored popovers rather than permanent form sections. Fixed controls have a
lock indicator; locking timezone does not lock Hours. Colours consume SLDS 2
semantic global hooks with SLDS 1 light fallbacks, and the base inputs/icons
inherit the host Salesforce theme. There is no custom dark-mode switch.
The UI fills its container up to 26rem; a parent can set
`--chrono-picker-max-width` to match its form layout. Visual rendering in the
Salesforce light/dark themes remains unverified without browser inspection.
Popovers constrain their horizontal position and height to the viewport; Escape
closes them and restores trigger focus. Disabling a control closes its popover.

`dateStyle` selects Salesforce's locale-aware date display: `short` for numeric
dates, `medium` for abbreviated month names (the default), or `long` for full
month names. The Flow editor exposes the same choice. It changes presentation,
not the ISO date value; mobile native pickers follow device presentation rules.
To prefill both date and time, supply `dateTimeValue` with an exact instant.
Supplying only `dateValue` in datetime mode starts at midnight in the selected
timezone, subject to the normal DST and operating-hours checks. Date-only mode
does not produce an instant. Clearing an entered time still requires a new value.

- `chronoDateTimePicker`: controlled UI only. It accepts date/time fields,
  timezone options, resolution candidates and operating-hours choices. It emits
  `edit`, `resolvechoice`, `offsetchange`, `zonesearch`, `schedulechange`,
  `schedulesearch` and `openchoice`
  events. It imports neither Apex nor Flow support. A parent supplies values and
  handles these events; the picker does not mutate its public inputs.
- `chronoPickerPopover`: reusable non-modal disclosure with Escape, outside-click
  dismissal, focus restoration and listener cleanup. Content is supplied by slot.
- `chronoPickerMenu`: searchable scalar choices, shared by timezone and hours.
- `chronoOffsetPicker`: persistent abbreviation/offset/mode indicator, occurrence
  selection and optional explicit-offset editor. No Apex or Flow dependencies.
- `chronoDateTimeControl`: reusable controller. It owns asynchronous resolution,
  schedule reads and validation, and emits ordinary `valuechange` events.
- `chronoFlowDateTime`: thin Flow adapter. It translates those events into native
  and ISO Flow outputs and delegates validation to the controller.
- `chronoFlowDateTimeEditor`: Flow Builder configuration editor. It offers fixed
  values and resource bindings, schedule-source choices, weekly slots and holiday
  controls. `chronoFlowValueEditor` is its separate value/resource input.
- `chronoPickerEngine`: JavaScript resolution and configuration helpers. Native
  Temporal is feature-detected. If the host does not expose it, or cannot handle
  the selected zone, resolution falls back to Chrono Apex. No runtime polyfill
  or implicit JavaScript `Date` parsing of local times is used.

A subscriber LWC can compose `<skel-chrono-date-time-picker>` under Lightning Web
Security. Cross-namespace LWC composition is not supported under legacy Locker.
The Flow wrapper calls Apex within its own package; another package must not
call those controllers directly from LWC. The UI component is intended for
composition, including a record-page parent; it is not a record-editing form.

## Initial values and ISO Chrono outputs

The configurator has one **Initial value** choice. Fixed values use a native
Date/DateTime input. Resource selection accepts native Date/DateTime or Text,
including another Chrono action's ISO output. Text binds to `initialChronoValue`,
which detects and validates a complete ISO date, local datetime, instant or zoned
datetime. Time-only values, durations and partial dates cannot initialise a dated
picker and produce an actionable error; Text resource contents cannot be known
until the Flow runs. Collections and Apex-defined core variables are excluded.
Selecting a different initial resource clears the previous binding.

A local date starts at midnight in datetime mode. An ambiguous local datetime
requires an explicit occurrence. Exact instants are displayed in the configured
zone independently of the source's zone.

| Flow output                | Type | Example                                        |
| -------------------------- | ---- | ---------------------------------------------- |
| `chronoDateValue`          | Text | `2026-10-25`                                   |
| `chronoPlainDateTimeValue` | Text | `2026-10-25T01:30:00.000`                      |
| `chronoTimeValue`          | Text | `01:30:00.000`                                 |
| `chronoInstantValue`       | Text | `2026-10-25T00:30:00.000Z`                     |
| `chronoZonedDateTimeValue` | Text | `2026-10-25T01:30:00.000+01:00[Europe/London]` |

These ISO strings can be assigned to ordinary Flow Text variables, displayed,
passed to Chrono actions and parsed by the corresponding service's `parseIso(String)` method
in Apex. Every parse validates the value. Core values are data-only, with mutable
fields and empty constructors; services validate them at each public boundary.
Native `dateValue` and `dateTimeValue` outputs remain available. Date mode populates
only the date output. Invalid or unresolved edits clear the ISO outputs.

For explicit offset overrides, plain outputs retain the entered wall clock; the
zoned ISO value is projected into the named zone's actual rules so that it remains
parseable without accepting a contradictory offset/zone pair. The separate
`offsetOverride` output preserves the user's supplied offset.

Flow's restored native outputs take precedence over the original initial value
on Previous navigation; later reactive initial-value changes are revalidated.
Schedules use native OperatingHours, TimeSlot and Holiday records, including unsaved
records. The fixed-value configurator produces those same native records.

### Migrating the provisional core-object picker

Replace `initialChronoDate`, `initialChronoPlainDateTime`, `initialChronoInstant`
and `initialChronoZonedDateTime` with `initialChronoValue` bound to ISO Text.
The five `chrono*Value` output names are unchanged, but now require **Text**
variables instead of Apex-defined core variables. Rebind downstream actions to
ISO inputs; Apex consumers use `ChronoPlainDateService.parseIso(text)` and the corresponding
parser for each other type. These experimental properties have not been released.

Old Flow versions can prevent changes to referenced component property types.
Retire the affected versions before deploying the new component, then restore
updated fixtures. Do not delete unrelated subscriber flows or configuration.
The example retains its API name `ChronoCoreScreenProbe` for existing links and is
labelled **Chrono Example — ISO Values**.

## Dates, zones and clock changes

`mode` is `date` or `datetime`. Date mode returns `dateValue` as a native Flow
Date, without converting midnight to an instant. Datetime mode returns
`dateTimeValue` as a native Flow DateTime, plus the selected local `dateValue`
and `timeZoneId`. An initial instant is displayed in the configured zone and
preserves its occurrence during a repeated hour.

`timeZoneId` defaults to the running user's timezone. The author can fix it or
allow user selection. Changing the zone in the picker preserves the entered
wall-clock fields and resolves them again. Changing the zone input externally
projects an existing instant into the new zone.

Repeated local times show both occurrences with their UTC offsets. Neither is
chosen automatically for a newly entered time. Nonexistent local times offer
**the nearest valid boundaries**: the last valid millisecond before the gap and
the first valid instant after it. For London's spring gap, 01:30 offers
00:59:59.999 or 02:00:00.000. This deliberately differs from Temporal's default
shift-by-gap correction. Half-hour changes and skipped calendar dates are
handled using the actual transition. The core plain-to-zoned API still rejects
gaps.

Editing clears an unresolved datetime output. Flow navigation is blocked while
resolution or schedule validation is pending, or an explicit choice is required.
Late responses are discarded. The adapter implements `validate`,
`setCustomValidity` and `reportValidity`, and publishes `FlowAttributeChangeEvent`
updates. Flow's external rich-text errors are rendered with a Salesforce base
component.

## Operating-hours sources

`lockOperatingHoursSelection` fixes the selected ID for collection/search sources;
single-record, supplied-record and fixed schedules are always fixed.
Timezone selection is controlled separately by `allowTimeZoneSelection`.

## Offset choice and customer overrides

The offset control shows the active numeric offset and, when available, the
timezone abbreviation. It distinguishes `Auto`, `Selected` and `Override` and
can be reopened after selection. Returning to automatic re-evaluates the current
wall fields and requires another occurrence choice if they are ambiguous.
Timezone search resolves up to twelve visible IDs at a time for the entered
date/time; overlaps show both offsets and gaps say that the local time is skipped.
It never uses today's offset for a different date.

Enable `allowOffsetOverride` in the Flow configurator for customer data that
uses an offset contrary to the named zone's rules. `offsetOverride` accepts
`+HH:MM` or `-HH:MM` (optionally seconds). The entered wall time is preserved;
the offset determines the instant. For example, 15 March 2026 10:00 at +01:00
is 09:00 UTC, and actually 09:00 GMT in London. It is labelled `Override`, not
BST. `offsetMode` is a Flow output (`auto`, `selected`, `override`). Preserve
`offsetOverride` alongside `dateTimeValue` when passing an overridden value back
into another screen; otherwise the instant projects using the named zone's rules.
Overrides persist across date/time edits until reset, and remain subject to
schedule validation against the resulting instant. Choosing an open-time
alternative returns to the display zone's real rules and clears the override.
The schedule's own timezone/holiday rules are never overridden.

Current platform guidance informing the implementation:

- [Flow reactivity and public state](https://developer.salesforce.com/docs/platform/lwc/guide/use-best-practices-reactivity.html).
- [LWC event boundaries](https://developer.salesforce.com/docs/platform/lwc/guide/events-best-practices).
- [SLDS semantic styling hooks and theme migration](https://help.salesforce.com/s/articleView?id=001622574&language=en_US&type=1).

## Configuring schedule inputs

Choose the source in the Flow configurator. Record inputs can be Flow resources;
primitive inputs can be fixed values or resource/field references.

| Source            | Inputs                                                      | Behaviour                                                                                                 |
| ----------------- | ----------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| None              | `operatingHoursMode = none`                                 | No schedule restriction.                                                                                  |
| One ID            | `id`, `operatingHoursId`                                    | Load one saved schedule.                                                                                  |
| Allowed IDs       | `ids`, `operatingHoursIds` and/or `operatingHoursIdsText`   | User chooses from an ID collection or comma-separated fixed IDs. Both are combined when supplied.         |
| Filter            | `filter`, `operatingHoursFilter`                            | User chooses an accessible matching schedule.                                                             |
| Unrestricted      | `all`                                                       | User chooses any accessible schedule.                                                                     |
| One record        | `record`, `operatingHoursRecord`                            | Use the record's ID and load its saved slots and holidays.                                                |
| Record collection | `records`, `operatingHoursRecords`                          | User chooses from the supplied saved records.                                                             |
| Supplied records  | `supplied`, `operatingHoursRecord`, `timeSlots`, `holidays` | Evaluate the supplied fields directly, including unsaved records. No schedule queries.                    |
| Fixed values      | `fixed`                                                     | Configure the schedule name, timezone, weekly slots and holidays in the editor. No saved record required. |

Saved-schedule selection and checks use user-mode reads. Grant **Chrono Flow
User**, plus the user's necessary OperatingHours, TimeSlot, OperatingHoursHoliday
and Holiday read permissions. An inaccessible or excluded record produces an
error. ID and filter restrictions are checked again when validating a selected
schedule. Search returns at most 50 matches; narrow the name search to find more.

The criteria editor currently supports `Name` and `TimeZone`, with `eq`, `ne`,
`contains` and `startsWith`, combined with AND. The equivalent value for a Flow
text resource is:

```json
{
  "criteria": [
    { "fieldPath": "TimeZone", "operator": "eq", "value": "Europe/London" }
  ]
}
```

This is a structured filter, not raw SOQL. Values are bound, including literal
wildcard escaping for name searches. At most ten criteria are accepted.

The schedule's timezone controls weekly hours and holidays; the display timezone
can differ. A datetime must lie within an open interval: opening is inclusive,
closing is exclusive. Closed times offer the previous open millisecond and next
opening, skipping weekends and holidays. In date mode, a date is interpreted in
the schedule's timezone and is selectable if any opening remains on that date.
Closed dates offer previous/next open dates.

Normal same-day slots are supported, including multiple or overlapping slots;
overlaps are merged. Conditional appointment slots are rejected because the
picker has no appointment context. Fixed holiday controls support all-day and
partial-day closures; recurring holidays are supplied as native Holiday records. Searches use the core's 3,660-day bound and remain
subject to Apex governor limits.

## One native contract for Apex and Flow

OperatingHours, TimeSlot and Holiday records do not need to be inserted when all
values are supplied. Existing ID-based overloads continue to read the saved
configuration. The new overloads use the supplied lists, even when records happen
to have IDs; they do not load additional related records.

```apex
OperatingHours hours = new OperatingHours(
    Name = 'Support', TimeZone = 'Europe/London'
);
List<TimeSlot> slots = new List<TimeSlot>{
    new TimeSlot(DayOfWeek = 'Monday', Type = 'Normal',
        StartTime = Time.newInstance(9, 0, 0, 0),
        EndTime = Time.newInstance(17, 0, 0, 0))
};
List<Holiday> holidays = new List<Holiday>();
ChronoZonedDateTime result = ChronoZonedDateTimeService.addHours(start, 1, hours, slots, holidays);
// Services also accept a native instant plus result zone.
result = ChronoZonedDateTimeService.addMinutes(
    nativeInstant, 'Europe/London', 60, hours, slots, holidays
);
```

The redundant schedule DTOs and `apex` source mode have been removed. Bind an
OperatingHours record to `operatingHoursRecord` and native record collections to
`timeSlots` and `holidays`, using `operatingHoursMode = supplied` for fully supplied
schedules. Saved record selection and the inline fixed-value editor are unchanged.

At the LWC-to-Apex boundary, TimeSlot time strings are converted to milliseconds
after midnight: Apex's SObject JSON deserialiser does not accept the ISO string
emitted by its serializer. Native numeric and ISO representations are accepted by
the adapter; caller-owned records are not mutated. This is wire-format conversion,
not a separate public schedule type or scheduling engine.

## Platform references

- [Flow screen property types](https://developer.salesforce.com/docs/platform/lwc/guide/targets-lightning-flow-screen.html)
- [Custom editor interface and change events](https://developer.salesforce.com/docs/platform/lwc/guide/use-flow-custom-property-editor-interface.html)
- [Flow validation lifecycle](https://developer.salesforce.com/docs/platform/lwc/guide/use-flow-validate-external-internal-methods.html)
- [LWC Apex supported types and package restrictions](https://developer.salesforce.com/docs/platform/lwc/guide/apex-expose-method.html)
- [LWC namespace and security constraints](https://developer.salesforce.com/docs/platform/lwc/guide/create-components-namespace.html)
- [Temporal zoned datetime semantics](https://tc39.es/proposal-temporal/docs/zoneddatetime.html)

Validation evidence and remaining limitations are recorded separately in
[validation.md](validation.md).
