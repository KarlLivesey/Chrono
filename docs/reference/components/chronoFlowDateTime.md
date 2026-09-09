# Chrono: Date and time

Component `chronoFlowDateTime` · 0.2.0.NEXT · Development source; not the released installation package.

Date or zoned date/time picker with explicit clock-change choices.

Targets: `lightning__FlowScreen`.

[Component architecture](../../handbook/components.md) · [Screen setup](../../handbook/screen-configuration.md).

## lightning__FlowScreen

Configuration editor: `skel-chrono-flow-date-time-editor`.

| Property                      | Label                              | Type                                  | Direction    | Default / required  | Meaning                                                                                                                                                |
| ----------------------------- | ---------------------------------- | ------------------------------------- | ------------ | ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `allowOffsetOverride`         | Allow supplied-offset overrides    | `Boolean`                             | inputOnly    | false               | Allow entering an explicit UTC offset independently of the selected timezone's rules.                                                                  |
| `initialChronoValue`          | Initial ISO date or datetime       | `String`                              | inputOnly    | No metadata default | A Chrono ISO date, local datetime, instant or zoned datetime. Use a Text resource or another Chrono action output.                                     |
| `chronoDateValue`             | Chrono plain date (ISO text)       | `String`                              | outputOnly   | No metadata default | —                                                                                                                                                      |
| `chronoPlainDateTimeValue`    | Chrono plain date/time (ISO text)  | `String`                              | outputOnly   | No metadata default | —                                                                                                                                                      |
| `chronoTimeValue`             | Chrono plain time (ISO text)       | `String`                              | outputOnly   | No metadata default | —                                                                                                                                                      |
| `chronoInstantValue`          | Chrono instant (ISO text)          | `String`                              | outputOnly   | No metadata default | —                                                                                                                                                      |
| `chronoZonedDateTimeValue`    | Chrono zoned date/time (ISO text)  | `String`                              | outputOnly   | No metadata default | —                                                                                                                                                      |
| `offsetOverride`              | Supplied UTC offset                | `String`                              | Input/output | No metadata default | Optional +01:00 or -05:00 override. Used with the entered wall time to derive the instant. Returned when changed; empty restores automatic zone rules. |
| `offsetMode`                  | Offset selection mode              | `String`                              | outputOnly   | No metadata default | auto, selected, or override.                                                                                                                           |
| `lockOperatingHoursSelection` | Lock operating-hours selection     | `Boolean`                             | inputOnly    | false               | For collection or search sources, lock the supplied selected ID. Single-record and dynamic schedules are always fixed.                                 |
| `mode`                        | Input mode                         | `String`                              | inputOnly    | datetime            | Use date for a calendar date, or datetime for a date and time in a time zone.                                                                          |
| `dateStyle`                   | Date display style                 | `String`                              | inputOnly    | medium              | Locale-aware short (numeric), medium (abbreviated month), or long (full month) display.                                                                |
| `timeZoneSelectionMode`       | Timezone selection scope           | `String`                              | inputOnly    | all                 | all preserves unrestricted selection; list restricts selection to supplied IDs. An empty list never enables all timezones.                             |
| `timeZoneIds`                 | Allowed timezones from Flow        | `String[]`                            | inputOnly    | No metadata default | Text collection of timezone IDs. Combined with the fixed allowed timezones.                                                                            |
| `timeZoneIdsText`             | Fixed allowed timezones            | `String`                              | inputOnly    | No metadata default | Timezone IDs maintained by the inline list editor.                                                                                                     |
| `label`                       | Label                              | `String`                              | inputOnly    | Date and time       | —                                                                                                                                                      |
| `helpText`                    | Help text                          | `String`                              | inputOnly    | No metadata default | —                                                                                                                                                      |
| `required`                    | Require a value                    | `Boolean`                             | inputOnly    | false               | —                                                                                                                                                      |
| `disabled`                    | Disable editing                    | `Boolean`                             | inputOnly    | false               | —                                                                                                                                                      |
| `allowTimeZoneSelection`      | Allow the user to change time zone | `Boolean`                             | inputOnly    | false               | —                                                                                                                                                      |
| `timeZoneId`                  | Time-zone ID                       | `String`                              | Input/output | No metadata default | For example Europe/London. Defaults to the running user's zone. Returned when the user changes it. Ignored in date mode.                               |
| `dateValue`                   | Date value                         | `Date`                                | Input/output | No metadata default | Calendar date in date mode; selected local date in datetime mode. No timezone conversion in date mode.                                                 |
| `dateTimeValue`               | Datetime value                     | `DateTime`                            | Input/output | No metadata default | Exact UTC instant in datetime mode. An existing value is displayed in the configured zone. Cleared while an edited time is unresolved.                 |
| `operatingHoursMode`          | Operating-hours source             | `String`                              | inputOnly    | No metadata default | —                                                                                                                                                      |
| `operatingHoursId`            | OperatingHours ID                  | `String`                              | Input/output | No metadata default | —                                                                                                                                                      |
| `operatingHoursIds`           | Allowed OperatingHours IDs         | `String[]`                            | inputOnly    | No metadata default | —                                                                                                                                                      |
| `operatingHoursFilter`        | OperatingHours filter              | `String`                              | inputOnly    | No metadata default | —                                                                                                                                                      |
| `operatingHoursRecord`        | OperatingHours record              | `@salesforce/schema/OperatingHours`   | inputOnly    | No metadata default | —                                                                                                                                                      |
| `operatingHoursRecords`       | OperatingHours records             | `@salesforce/schema/OperatingHours[]` | inputOnly    | No metadata default | —                                                                                                                                                      |
| `timeSlots`                   | Supplied time slots                | `@salesforce/schema/TimeSlot[]`       | inputOnly    | No metadata default | —                                                                                                                                                      |
| `holidays`                    | Supplied holidays                  | `@salesforce/schema/Holiday[]`        | inputOnly    | No metadata default | —                                                                                                                                                      |
| `fixedHours`                  | Fixed hours configuration          | `String`                              | inputOnly    | No metadata default | —                                                                                                                                                      |
| `operatingHoursIdsText`       | Fixed allowed OperatingHours IDs   | `String`                              | inputOnly    | No metadata default | Comma-separated IDs, combined with any supplied ID collection.                                                                                         |

## Public LWC members

These are the checked `@api` members. JavaScript defaults are separate from Flow/App Builder metadata defaults. Setters may validate or normalise values; absence of an initializer is not a promise that every empty value is accepted.

| Member                        | Kind   | JS default   |
| ----------------------------- | ------ | ------------ |
| `allowOffsetOverride`         | get    | Not declared |
| `allowOffsetOverride`         | set    | Not declared |
| `allowTimeZoneSelection`      | get    | Not declared |
| `allowTimeZoneSelection`      | set    | Not declared |
| `chronoDateValue`             | get    | Not declared |
| `chronoDateValue`             | set    | Not declared |
| `chronoInstantValue`          | get    | Not declared |
| `chronoInstantValue`          | set    | Not declared |
| `chronoPlainDateTimeValue`    | get    | Not declared |
| `chronoPlainDateTimeValue`    | set    | Not declared |
| `chronoTimeValue`             | get    | Not declared |
| `chronoTimeValue`             | set    | Not declared |
| `chronoZonedDateTimeValue`    | get    | Not declared |
| `chronoZonedDateTimeValue`    | set    | Not declared |
| `dateStyle`                   | get    | Not declared |
| `dateStyle`                   | set    | Not declared |
| `dateTimeValue`               | get    | Not declared |
| `dateTimeValue`               | set    | Not declared |
| `dateValue`                   | get    | Not declared |
| `dateValue`                   | set    | Not declared |
| `disabled`                    | get    | Not declared |
| `disabled`                    | set    | Not declared |
| `fixedHours`                  | get    | Not declared |
| `fixedHours`                  | set    | Not declared |
| `helpText`                    | get    | Not declared |
| `helpText`                    | set    | Not declared |
| `holidays`                    | get    | Not declared |
| `holidays`                    | set    | Not declared |
| `initialChronoValue`          | get    | Not declared |
| `initialChronoValue`          | set    | Not declared |
| `label`                       | get    | Not declared |
| `label`                       | set    | Not declared |
| `lockOperatingHoursSelection` | get    | Not declared |
| `lockOperatingHoursSelection` | set    | Not declared |
| `mode`                        | get    | Not declared |
| `mode`                        | set    | Not declared |
| `offsetMode`                  | get    | Not declared |
| `offsetMode`                  | set    | Not declared |
| `offsetOverride`              | get    | Not declared |
| `offsetOverride`              | set    | Not declared |
| `operatingHoursFilter`        | get    | Not declared |
| `operatingHoursFilter`        | set    | Not declared |
| `operatingHoursId`            | get    | Not declared |
| `operatingHoursId`            | set    | Not declared |
| `operatingHoursIds`           | get    | Not declared |
| `operatingHoursIds`           | set    | Not declared |
| `operatingHoursIdsText`       | get    | Not declared |
| `operatingHoursIdsText`       | set    | Not declared |
| `operatingHoursMode`          | get    | Not declared |
| `operatingHoursMode`          | set    | Not declared |
| `operatingHoursRecord`        | get    | Not declared |
| `operatingHoursRecord`        | set    | Not declared |
| `operatingHoursRecords`       | get    | Not declared |
| `operatingHoursRecords`       | set    | Not declared |
| `reportValidity`              | method | Not declared |
| `required`                    | get    | Not declared |
| `required`                    | set    | Not declared |
| `setCustomValidity`           | method | Not declared |
| `timeSlots`                   | get    | Not declared |
| `timeSlots`                   | set    | Not declared |
| `timeZoneId`                  | get    | Not declared |
| `timeZoneId`                  | set    | Not declared |
| `timeZoneIds`                 | get    | Not declared |
| `timeZoneIds`                 | set    | Not declared |
| `timeZoneIdsText`             | get    | Not declared |
| `timeZoneIdsText`             | set    | Not declared |
| `timeZoneSelectionMode`       | get    | Not declared |
| `timeZoneSelectionMode`       | set    | Not declared |
| `validate`                    | method | Not declared |

Generated from exposed component metadata and the checked LWC public-member inventory. Custom events and validation behaviour are described in the component guide; metadata alone does not describe event semantics or prove browser rendering.
