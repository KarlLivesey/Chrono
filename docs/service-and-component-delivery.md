# Data-only values and reusable controls

Karl approved replacing core instance methods with data-only values on 8 September 2026. This supersedes the previous instance/static API requirement. All existing
Chrono package versions were checked and are unreleased betas.

## Contracts

The eight core class names remain unchanged. Each has public global fields and an
empty constructor. `Chrono<Type>Service` owns `create`, `parseIso`, `toIsoString`, native
conversion, validation and arithmetic. Services validate supplied data, including
fields changed after construction. Arithmetic returns independent values.

`ChronoPlainYearMonth.value` uses day 1; `ChronoPlainMonthDay.value` uses leap year 2000. These reference-date invariants are validated. Date/time uses separate native
Date and Time fields; zoned datetime uses an instant and named timezone. Duration
retains separate calendar months, calendar days and elapsed milliseconds.

This is a breaking beta Apex API change: use
`ChronoPlainDateService.addDays(value, 1)` instead of `value.addDays(1)`,
`ChronoPlainDateService.create(nativeDate)` instead of the old value constructor,
and the service's `toString(value)` instead of implicit object stringification.
Flow and LWC continue to exchange ISO Text and native Salesforce resources.

`ChronoActionOperation` is an internal interface for substitutable action engines.
It is not global and does not appear in any Flow/LWC contract. Batch execution owns
ordering, deduplication, result isolation and per-request errors; implementations
own calculations and any bulk configuration loading.

Flow request/result records are also data-only. `ChronoOperationInputs` owns
typed transport adaptation, and `ChronoFlowResults` owns failure creation and
independent result copying.

## Authorised delivery

- Data-only core values, services, caller migration and internal action interface.
- Working calendar-day scalar and collection actions.
- Availability notice, horizon, buffers and a shared appointment grid anchor.
- Reusable picker controller separated from Flow transport.
- Record-page field adapter, range picker and appointment choices.
- Duration, time-only and partial-date inputs.
- Recurrence builder with bounded occurrence preview.
- Multi-timezone display.
- Admin configuration, complete examples and automated checks for these controls.

No screen capture or Computer Use. Reuse the two existing scratch orgs. Consolidate
package verification into a skip-validation build; no standard build is authorised.

## Managed-package feasibility

The services and core data classes are global for subscriber Apex. Flow and LWC
retain concrete ISO/native contracts; their types do not reference internal
interfaces. Internal operations implement `ChronoActionOperation`; sort operations
implement Salesforce's [Comparator interface](https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_interface_System_Comparator.htm).
Picker option projection and interval/collection-entry calculations also live in
services rather than on their data holders. Stateful engines and UI controllers
retain methods because they perform work rather than serve as transport records.

The record adapter uses [Lightning Data Service](https://developer.salesforce.com/docs/platform/lwc/guide/reference-update-record.html), including `ifUnmodifiedSince`.
The Flow adapter composes the reusable controller; it does not depend on custom
component inheritance. Final package/subscriber evidence is recorded in validation.md.
Historical fixtures under tests/feasibility describe earlier beta experiments and
are not current API examples or part of the deployable subscriber fixture suite.

The seven reusable controls are exposed for subscriber LWC composition, without
adding App Builder targets. Their Flow/page adapters provide the builder targets.
Salesforce requires `isExposed=true` for cross-namespace use, and public properties
become a managed-package contract after release ([packaging rules](https://developer.salesforce.com/docs/platform/lwc/guide/use-packaging-add.html)).

## Control configuration

| Flow / page component    | Reusable component                                                 | Admin inputs and outputs                                                                                                                                                                                                                    |
| ------------------------ | ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `chronoFlowValueInput`   | `chronoDurationInput`, `chronoTimeInput`, `chronoPartialDateInput` | Choose duration, time, year/month or month/day; bind ISO Text, label, required and disabled.                                                                                                                                                |
| `chronoFlowRange`        | `chronoRangePicker`                                                | Date or zoned datetime; ISO start/end, timezone and optional native schedule records. End is exclusive. Returns interval Text and duration Text.                                                                                            |
| `chronoFlowAvailability` | `chronoAvailabilityPicker`                                         | Native/ISO search limits, schedule records or ID, busy ranges, duration, grid and booking limits. Custom inline editor shares action resource controls. Returns selected native datetimes and ISO values/interval. No reservation is saved. |
| `chronoFlowRecurrence`   | `chronoRecurrenceBuilder`                                          | Initial ISO value, timezone, rule, search-through date, result limit and native schedule. Returns rule and occurrence Text collection after Preview.                                                                                        |
| `chronoZoneDisplay`      | Same read-only component                                           | ISO instant/zoned value or native Datetime; timezone Text collection or fixed list, locale length styles.                                                                                                                                   |
| `chronoRecordDateTime`   | `chronoDateTimeControl`                                            | Record field API name, optional timezone/OperatingHours fields or fixed values. Explicit Save uses LDS and the loaded record version.                                                                                                       |

The recurrence screen edits daily, weekly, monthly and yearly rules with interval,
count and weekly weekdays. Advanced RRULE parts remain available through the
recurrence actions. Preview is bounded by the search-through date and maximum
results. Changed inputs invalidate an old preview. Appointment selections are
restored only when still present in refreshed availability.

Working calendar-day arithmetic counts open dates after the starting date (or
before it for negative amounts). Timed values preserve their schedule-local clock;
`keep`, `reject`, `next` and `previous` control closed target times. This differs
from adding a fixed number of working hours. Booking buffers must fit within open,
unoccupied time; notice/horizon use an explicit reference instant.
