# Use the Lightning components

Chrono separates user interface, resolution/control, Flow adaptation and record
persistence. Choose the layer that owns the work you need.

| Layer             | Component examples                                                                                                | Responsibility                                                     |
| ----------------- | ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| UI only           | `chronoDateTimePicker`, `chronoRangePicker`, `chronoAvailabilityPicker`                                           | Display supplied state and emit user intent                        |
| Date/time control | `chronoDateTimeControl`                                                                                           | Resolve values, load/check schedules, validate and publish changes |
| Flow screens      | `chronoFlowDateTime`, `chronoFlowRange`, `chronoFlowAvailability`, `chronoFlowRecurrence`, `chronoFlowValueInput` | Adapt values and validation to Flow                                |
| Record page       | `chronoRecordDateTime`                                                                                            | Read and save a configured Date/DateTime field through LDS         |
| Supporting UI     | `chronoOffsetPicker`, `chronoPickerMenu`, `chronoPickerPopover`                                                   | Reusable compact interactions                                      |

See [all exposed components](../reference/components/index.md) for actual public
members, defaults, targets and Flow/App Builder properties.

## Compose a control in a subscriber LWC

With Lightning Web Security enabled, a subscriber parent can compose an exposed
Chrono component. For a controller that handles timezone resolution:

```html
<skel-chrono-date-time-control
  label="Appointment"
  time-zone-id="Europe/London"
  onvaluechange="{handleValueChange}"
>
</skel-chrono-date-time-control>
```

The [control reference](../reference/components/chronoDateTimeControl.md) gives
its members. Its `valuechange` event carries a changed property's `name` and
`value`; store the properties your application needs. Invoke its validation
methods before accepting an unresolved value.

For full control of data loading/resolution, compose `chronoDateTimePicker`
instead. Its parent supplies candidates, selected instant, zone options and
schedule choices. It emits `edit`, `resolvechoice`, `offsetchange`, `zonesearch`,
`schedulechange`, `schedulesearch` and `openchoice`. It imports neither Apex nor
Flow support and does not mutate its public inputs.

## Native Temporal and Apex fallback

The controller feature-detects native Temporal. If it is unavailable or cannot
handle the selected zone, it falls back to the package's Apex resolution. The
package does not ship a runtime Temporal polyfill or rely on implicit JavaScript
Date parsing of local clocks.

Schedule validation can still require Apex even when native Temporal resolves
the time. Treat the pending state as pending, not as a valid selected instant.
Stale asynchronous responses are discarded by the controller.

## Styling and layout

The picker uses Salesforce base inputs and SLDS semantic theme hooks. Its date
and time fields sit together; timezone and Hours are siblings rather than nested
menus. The persistent offset control reopens its choice. The picker normally
fills its container up to 26rem; a parent can set `--chrono-picker-max-width`.

Do not add a second custom dark-mode system inside Salesforce. Let base controls
and semantic hooks inherit the host theme. Automated component tests cover
behaviour; live light/dark rendering has not been browser-verified in this release.

## Event ownership

UI events describe intent. The parent decides whether to update its state,
resolve a value or save a record. Flow adapters translate changes into
`FlowAttributeChangeEvent` and implement Flow's validation lifecycle. The record
adapter owns the explicit save. Avoid mixing these responsibilities in a parent
that assumes every selection has already persisted data.

Cross-package LWC-to-Apex controller calls and legacy Locker composition are not
supported integration paths. Use the exposed components or the global Apex API.
