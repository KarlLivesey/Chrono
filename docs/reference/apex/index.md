# Apex reference

All **147 global classes** in Chrono 0.2.0.NEXT, including nested declarations. The reference contains **1,604 global declarations**. Internal public classes are deliberately excluded.

**Development source; not the released installation package.** See [release notes](../../handbook/releases.md). Start with the core value services or the [direct bulk Apex services](../../bulk-apex-services.md). Flow entry points are also callable from Apex, but their nested requests and specialised results are different from the core values. [Read the quick start](../../handbook/apex.md).

## Services

| Class                                                                   | Purpose                                                                                                      |
| ----------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| [ChronoAvailabilityService](ChronoAvailabilityService.md)               | Direct bulk Apex API. Flow adapters use these same services.                                                 |
| [ChronoCalculationService](ChronoCalculationService.md)                 | Direct bulk Apex API. Flow adapters use these same services.                                                 |
| [ChronoCollectionService](ChronoCollectionService.md)                   | Direct bulk Apex API. Flow adapters use these same services.                                                 |
| [ChronoDurationCalculationService](ChronoDurationCalculationService.md) | Direct bulk Apex API. Flow adapters use these same services.                                                 |
| [ChronoDurationService](ChronoDurationService.md)                       | Stable public API for Duration values. Internal operations own validation and calculations.                  |
| [ChronoFiscalPeriodService](ChronoFiscalPeriodService.md)               | Direct bulk Apex API. Flow adapters use these same services.                                                 |
| [ChronoFormattingService](ChronoFormattingService.md)                   | Direct bulk Apex API. Flow adapters use these same services.                                                 |
| [ChronoInstantService](ChronoInstantService.md)                         | Stable public API for Instant values. Internal operations own validation and calculations.                   |
| [ChronoPlainDateService](ChronoPlainDateService.md)                     | Stable public API for PlainDate values. Internal operations own validation and calculations.                 |
| [ChronoPlainDateTimeService](ChronoPlainDateTimeService.md)             | Stable public API for PlainDateTime values. Internal operations own validation and calculations.             |
| [ChronoPlainMonthDayService](ChronoPlainMonthDayService.md)             | Stable public API for PlainMonthDay values. Internal operations own validation and calculations.             |
| [ChronoPlainTimeService](ChronoPlainTimeService.md)                     | Stable public API for PlainTime values. Internal operations own validation and calculations.                 |
| [ChronoPlainYearMonthService](ChronoPlainYearMonthService.md)           | Stable public API for PlainYearMonth values. Internal operations own validation and calculations.            |
| [ChronoRangeService](ChronoRangeService.md)                             | Direct bulk Apex API. Flow adapters use these same services.                                                 |
| [ChronoRecurrenceService](ChronoRecurrenceService.md)                   | Direct bulk Apex API. Flow adapters use these same services.                                                 |
| [ChronoTimeAllocationService](ChronoTimeAllocationService.md)           | Allocates worked time into named blocks. Inputs are not mutated; results are independent. No queries or DML. |
| [ChronoTimeZoneService](ChronoTimeZoneService.md)                       | Direct bulk Apex API. Flow adapters use these same services.                                                 |
| [ChronoValueService](ChronoValueService.md)                             | Direct bulk Apex API. Flow adapters use these same services.                                                 |
| [ChronoWorkingTimeService](ChronoWorkingTimeService.md)                 | Bulk working-time arithmetic over saved schedules or supplied native OperatingHours records.                 |
| [ChronoZonedDateTimeService](ChronoZonedDateTimeService.md)             | Stable public API for ZonedDateTime values. Internal operations own validation and calculations.             |

## Core values

| Class                                           | Purpose                                                                                       |
| ----------------------------------------------- | --------------------------------------------------------------------------------------------- |
| [ChronoDuration](ChronoDuration.md)             | Data-only value. Use ChronoDurationService for construction, validation and operations.       |
| [ChronoInstant](ChronoInstant.md)               | Data-only value. Use ChronoInstantService for construction, validation and operations.        |
| [ChronoPlainDate](ChronoPlainDate.md)           | Data-only value. Use ChronoPlainDateService for construction, validation and operations.      |
| [ChronoPlainDateTime](ChronoPlainDateTime.md)   | Data-only value. Use ChronoPlainDateTimeService for construction, validation and operations.  |
| [ChronoPlainMonthDay](ChronoPlainMonthDay.md)   | Data-only value. Use ChronoPlainMonthDayService for construction, validation and operations.  |
| [ChronoPlainTime](ChronoPlainTime.md)           | Data-only value. Use ChronoPlainTimeService for construction, validation and operations.      |
| [ChronoPlainYearMonth](ChronoPlainYearMonth.md) | Data-only value. Use ChronoPlainYearMonthService for construction, validation and operations. |
| [ChronoZonedDateTime](ChronoZonedDateTime.md)   | Data-only value. Use ChronoZonedDateTimeService for construction, validation and operations.  |

## Flow entry points

| Class                                                                                   | Purpose                                                                                                                                                   |
| --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [ChronoAdjustAction](ChronoAdjustAction.md)                                             | Add calendar or elapsed units to a Chrono value.                                                                                                          |
| [ChronoAdjustCollectionAction](ChronoAdjustCollectionAction.md)                         | Add calendar or elapsed units to a Chrono value. Collection inputs are also bulkified across Flow interviews.                                             |
| [ChronoAvailabilityAction](ChronoAvailabilityAction.md)                                 | Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays.                                         |
| [ChronoAvailabilityCollectionAction](ChronoAvailabilityCollectionAction.md)             | Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays.                                         |
| [ChronoCalendarDifferenceAction](ChronoCalendarDifferenceAction.md)                     | Count whole calendar months/days from the start, followed by remaining clock or elapsed time.                                                             |
| [ChronoCalendarDifferenceCollectionAction](ChronoCalendarDifferenceCollectionAction.md) | Count whole calendar months/days from the start, followed by remaining clock or elapsed time.                                                             |
| [ChronoCheckWorkingTimeAction](ChronoCheckWorkingTimeAction.md)                         | Check whether a date has opening hours or an instant is inside OperatingHours.                                                                            |
| [ChronoCheckWorkingTimeCollectionAction](ChronoCheckWorkingTimeCollectionAction.md)     | Check whether a date has opening hours or an instant is inside OperatingHours.                                                                            |
| [ChronoCollectionToolsAction](ChronoCollectionToolsAction.md)                           | Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow.                                                     |
| [ChronoCollectionToolsCollectionAction](ChronoCollectionToolsCollectionAction.md)       | Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow.                                                     |
| [ChronoCompareAction](ChronoCompareAction.md)                                           | Compare compatible values and return before, equal or after.                                                                                              |
| [ChronoCompareCollectionAction](ChronoCompareCollectionAction.md)                       | Compare compatible values and return before, equal or after.                                                                                              |
| [ChronoConvertAction](ChronoConvertAction.md)                                           | Convert or normalise all eight Chrono value types.                                                                                                        |
| [ChronoConvertCollectionAction](ChronoConvertCollectionAction.md)                       | Convert or normalise all eight Chrono value types. Collection inputs are also bulkified across Flow interviews.                                           |
| [ChronoCreateValueAction](ChronoCreateValueAction.md)                                   | Construct a validated value from individual calendar and clock components.                                                                                |
| [ChronoCreateValueCollectionAction](ChronoCreateValueCollectionAction.md)               | Construct a validated value from individual calendar and clock components.                                                                                |
| [ChronoDifferenceAction](ChronoDifferenceAction.md)                                     | Calculate signed elapsed time between two instants, optionally counting only OperatingHours.                                                              |
| [ChronoDifferenceCollectionAction](ChronoDifferenceCollectionAction.md)                 | Calculate signed elapsed time between two instants, optionally counting only OperatingHours. Collection inputs are also bulkified across Flow interviews. |
| [ChronoDurationToolsAction](ChronoDurationToolsAction.md)                               | Construct, inspect, total, balance or scale durations with explicit calendar context.                                                                     |
| [ChronoDurationToolsCollectionAction](ChronoDurationToolsCollectionAction.md)           | Construct, inspect, total, balance or scale durations with explicit calendar context.                                                                     |
| [ChronoEpochValueAction](ChronoEpochValueAction.md)                                     | Convert an exact value to or from Unix seconds or milliseconds.                                                                                           |
| [ChronoEpochValueCollectionAction](ChronoEpochValueCollectionAction.md)                 | Convert an exact value to or from Unix seconds or milliseconds.                                                                                           |
| [ChronoFindWorkingTimeAction](ChronoFindWorkingTimeAction.md)                           | Find an open value on or after/before the source, including holidays.                                                                                     |
| [ChronoFindWorkingTimeCollectionAction](ChronoFindWorkingTimeCollectionAction.md)       | Find an open value on or after/before the source, including holidays.                                                                                     |
| [ChronoFiscalPeriodAction](ChronoFiscalPeriodAction.md)                                 | Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.                                                                      |
| [ChronoFiscalPeriodCollectionAction](ChronoFiscalPeriodCollectionAction.md)             | Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.                                                                      |
| [ChronoFormatValueAction](ChronoFormatValueAction.md)                                   | Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output.                                               |
| [ChronoFormatValueCollectionAction](ChronoFormatValueCollectionAction.md)               | Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output.                                               |
| [ChronoParseValueAction](ChronoParseValueAction.md)                                     | Parse an explicitly specified numeric date and time pattern without guessing.                                                                             |
| [ChronoParseValueCollectionAction](ChronoParseValueCollectionAction.md)                 | Parse an explicitly specified numeric date and time pattern without guessing.                                                                             |
| [ChronoPeriodBoundaryAction](ChronoPeriodBoundaryAction.md)                             | Find a calendar period boundary in an explicit timezone where applicable.                                                                                 |
| [ChronoPeriodBoundaryCollectionAction](ChronoPeriodBoundaryCollectionAction.md)         | Find a calendar period boundary in an explicit timezone where applicable.                                                                                 |
| [ChronoRangeToolsAction](ChronoRangeToolsAction.md)                                     | Validate and manipulate half-open ranges: start is included and end is excluded.                                                                          |
| [ChronoRangeToolsCollectionAction](ChronoRangeToolsCollectionAction.md)                 | Validate and manipulate half-open ranges: start is included and end is excluded.                                                                          |
| [ChronoRecurrenceAction](ChronoRecurrenceAction.md)                                     | Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.                                              |
| [ChronoRecurrenceCollectionAction](ChronoRecurrenceCollectionAction.md)                 | Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.                                              |
| [ChronoReplaceValueAction](ChronoReplaceValueAction.md)                                 | Replace supplied components and preserve other fields. Resolve zoned values explicitly.                                                                   |
| [ChronoReplaceValueCollectionAction](ChronoReplaceValueCollectionAction.md)             | Replace supplied components and preserve other fields. Resolve zoned values explicitly.                                                                   |
| [ChronoResolveLocalAction](ChronoResolveLocalAction.md)                                 | Inspect unique/repeated/skipped local times and explicitly select an occurrence or nearest gap boundary.                                                  |
| [ChronoResolveLocalCollectionAction](ChronoResolveLocalCollectionAction.md)             | Inspect unique/repeated/skipped local times and explicitly select an occurrence or nearest gap boundary.                                                  |
| [ChronoRoundAction](ChronoRoundAction.md)                                               | Round to a clock increment or a calendar-day boundary.                                                                                                    |
| [ChronoRoundCollectionAction](ChronoRoundCollectionAction.md)                           | Round to a clock increment or a calendar-day boundary.                                                                                                    |
| [ChronoTimeAllocationAction](ChronoTimeAllocationAction.md)                             | Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.                                                         |
| [ChronoTimeAllocationCollectionAction](ChronoTimeAllocationCollectionAction.md)         | Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.                                                         |
| [ChronoValidateValueAction](ChronoValidateValueAction.md)                               | Validate a native or ISO value without failing other interviews.                                                                                          |
| [ChronoValidateValueCollectionAction](ChronoValidateValueCollectionAction.md)           | Validate a native or ISO value without failing other interviews.                                                                                          |
| [ChronoValueDetailsAction](ChronoValueDetailsAction.md)                                 | Inspect calendar and clock components with an explicit timezone for instants.                                                                             |
| [ChronoValueDetailsCollectionAction](ChronoValueDetailsCollectionAction.md)             | Inspect calendar and clock components with an explicit timezone for instants.                                                                             |
| [ChronoWorkingDaysAction](ChronoWorkingDaysAction.md)                                   | Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays.                                               |
| [ChronoWorkingDaysCollectionAction](ChronoWorkingDaysCollectionAction.md)               | Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays.                                               |
| [ChronoWorkingTimeAction](ChronoWorkingTimeAction.md)                                   | Add time inside Salesforce OperatingHours or BusinessHours, skipping closures and holidays.                                                               |
| [ChronoWorkingTimeCollectionAction](ChronoWorkingTimeCollectionAction.md)               | Add time inside Salesforce OperatingHours or BusinessHours, skipping closures and holidays. Collection inputs are also bulkified across Flow interviews.  |
| [ChronoZoneToolsAction](ChronoZoneToolsAction.md)                                       | Convert zones, inspect date-specific offsets and search bounded timezone transitions.                                                                     |
| [ChronoZoneToolsCollectionAction](ChronoZoneToolsCollectionAction.md)                   | Convert zones, inspect date-specific offsets and search bounded timezone transitions.                                                                     |

## Requests, results and configuration

| Class                                                                           | Purpose                                                                                                           |
| ------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| [ChronoAdjustInput](ChronoAdjustInput.md)                                       | One calendar or elapsed adjustment.                                                                               |
| [ChronoAvailabilityCollectionResult](ChronoAvailabilityCollectionResult.md)     | Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays. |
| [ChronoAvailabilityInput](ChronoAvailabilityInput.md)                           | Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays. |
| [ChronoAvailabilityResult](ChronoAvailabilityResult.md)                         | Independent Flow output with native and ISO fields.                                                               |
| [ChronoCalendarDifferenceInput](ChronoCalendarDifferenceInput.md)               | Count whole calendar months/days from the start, followed by remaining clock or elapsed time.                     |
| [ChronoCheckWorkingTimeInput](ChronoCheckWorkingTimeInput.md)                   | Check whether a date has opening hours or an instant is inside OperatingHours.                                    |
| [ChronoCollectionToolsInput](ChronoCollectionToolsInput.md)                     | Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow.             |
| [ChronoCompareInput](ChronoCompareInput.md)                                     | Compare compatible values and return before, equal or after.                                                      |
| [ChronoComparisonResult](ChronoComparisonResult.md)                             | Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.       |
| [ChronoConvertInput](ChronoConvertInput.md)                                     | One conversion, also usable as an Apex-defined Flow collection item.                                              |
| [ChronoCreateValueInput](ChronoCreateValueInput.md)                             | Construct a validated value from individual calendar and clock components.                                        |
| [ChronoDetailsCollectionResult](ChronoDetailsCollectionResult.md)               | Inspect calendar and clock components with an explicit timezone for instants.                                     |
| [ChronoDetailsResult](ChronoDetailsResult.md)                                   | Flat Flow result for details operations.                                                                          |
| [ChronoDifferenceInput](ChronoDifferenceInput.md)                               | One elapsed-time difference between exact instants.                                                               |
| [ChronoDurationCalculationResult](ChronoDurationCalculationResult.md)           | Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.       |
| [ChronoDurationCollectionResult](ChronoDurationCollectionResult.md)             | Construct, inspect, total, balance or scale durations with explicit calendar context.                             |
| [ChronoDurationResult](ChronoDurationResult.md)                                 | Flat duration calculation outputs. Calendar and elapsed components remain distinct.                               |
| [ChronoDurationToolsInput](ChronoDurationToolsInput.md)                         | Construct, inspect, total, balance or scale durations with explicit calendar context.                             |
| [ChronoEpochCollectionResult](ChronoEpochCollectionResult.md)                   | Convert an exact value to or from Unix seconds or milliseconds.                                                   |
| [ChronoEpochResult](ChronoEpochResult.md)                                       | Flat Flow result for epoch operations.                                                                            |
| [ChronoEpochValueInput](ChronoEpochValueInput.md)                               | Convert an exact value to or from Unix seconds or milliseconds.                                                   |
| [ChronoException](ChronoException.md)                                           | Invalid Chrono input or an operation with no unambiguous result.                                                  |
| [ChronoFindWorkingTimeInput](ChronoFindWorkingTimeInput.md)                     | Find an open value on or after/before the source, including holidays.                                             |
| [ChronoFiscalCollectionResult](ChronoFiscalCollectionResult.md)                 | Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.                              |
| [ChronoFiscalPeriodInput](ChronoFiscalPeriodInput.md)                           | Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.                              |
| [ChronoFiscalResult](ChronoFiscalResult.md)                                     | Independent Flow output with native and ISO fields.                                                               |
| [ChronoFlowCollectionResult](ChronoFlowCollectionResult.md)                     | One collection response per Flow interview; items preserve input order.                                           |
| [ChronoFlowResult](ChronoFlowResult.md)                                         | Independent result for one Flow item. Check success before reading value fields.                                  |
| [ChronoFormatCollectionResult](ChronoFormatCollectionResult.md)                 | Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output.       |
| [ChronoFormatResult](ChronoFormatResult.md)                                     | Independent Flow output with native and ISO fields.                                                               |
| [ChronoFormatValueInput](ChronoFormatValueInput.md)                             | Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output.       |
| [ChronoLocalResolutionResult](ChronoLocalResolutionResult.md)                   | Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.       |
| [ChronoParseValueInput](ChronoParseValueInput.md)                               | Parse an explicitly specified numeric date and time pattern without guessing.                                     |
| [ChronoPeriodBoundaryInput](ChronoPeriodBoundaryInput.md)                       | Find a calendar period boundary in an explicit timezone where applicable.                                         |
| [ChronoRangeCollectionResult](ChronoRangeCollectionResult.md)                   | Validate and manipulate half-open ranges: start is included and end is excluded.                                  |
| [ChronoRangeResult](ChronoRangeResult.md)                                       | Independent Flow output with native and ISO fields.                                                               |
| [ChronoRangeToolsInput](ChronoRangeToolsInput.md)                               | Validate and manipulate half-open ranges: start is included and end is excluded.                                  |
| [ChronoRecurrenceCollectionResult](ChronoRecurrenceCollectionResult.md)         | Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.      |
| [ChronoRecurrenceInput](ChronoRecurrenceInput.md)                               | Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments.      |
| [ChronoRecurrenceResult](ChronoRecurrenceResult.md)                             | Independent Flow output with native and ISO fields.                                                               |
| [ChronoReplaceValueInput](ChronoReplaceValueInput.md)                           | Replace supplied components and preserve other fields. Resolve zoned values explicitly.                           |
| [ChronoResolveLocalInput](ChronoResolveLocalInput.md)                           | Inspect unique/repeated/skipped local times and explicitly select an occurrence or nearest gap boundary.          |
| [ChronoRoundInput](ChronoRoundInput.md)                                         | Round to a clock increment or a calendar-day boundary.                                                            |
| [ChronoTimeAllocationCollectionResult](ChronoTimeAllocationCollectionResult.md) | Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.                 |
| [ChronoTimeAllocationInput](ChronoTimeAllocationInput.md)                       | Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.                 |
| [ChronoTimeAllocationRequest](ChronoTimeAllocationRequest.md)                   | Native Apex allocation request. Defaults: strict overlaps, elapsed time, millisecond allocation.                  |
| [ChronoTimeAllocationResult](ChronoTimeAllocationResult.md)                     | Data-only time allocation contract; services validate all supplied fields.                                        |
| [ChronoTimeAllocationRow](ChronoTimeAllocationRow.md)                           | Data-only time allocation contract; services validate all supplied fields.                                        |
| [ChronoTimeBlock](ChronoTimeBlock.md)                                           | Data-only time allocation contract; services validate all supplied fields.                                        |
| [ChronoTimeZonePicklist](ChronoTimeZonePicklist.md)                             | Flow Builder choices from Salesforce's supported user time-zone values. No record data is read.                   |
| [ChronoValidateValueInput](ChronoValidateValueInput.md)                         | Validate a native or ISO value without failing other interviews.                                                  |
| [ChronoValidationCollectionResult](ChronoValidationCollectionResult.md)         | Validate a native or ISO value without failing other interviews.                                                  |
| [ChronoValidationResult](ChronoValidationResult.md)                             | Flat Flow result for validation operations.                                                                       |
| [ChronoValue](ChronoValue.md)                                                   | Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.       |
| [ChronoValueDetailsInput](ChronoValueDetailsInput.md)                           | Inspect calendar and clock components with an explicit timezone for instants.                                     |
| [ChronoValueResult](ChronoValueResult.md)                                       | Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.       |
| [ChronoValuesCollectionResult](ChronoValuesCollectionResult.md)                 | Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow.             |
| [ChronoValuesResult](ChronoValuesResult.md)                                     | Independent Flow output with native and ISO fields.                                                               |
| [ChronoWorkingDaysInput](ChronoWorkingDaysInput.md)                             | Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays.       |
| [ChronoWorkingTimeCheckResult](ChronoWorkingTimeCheckResult.md)                 | Data-only Apex value; service results initialise the applicable fields. Not an invocable transport wrapper.       |
| [ChronoWorkingTimeInput](ChronoWorkingTimeInput.md)                             | One schedule-aware calculation.                                                                                   |
| [ChronoWorkingTimeResult](ChronoWorkingTimeResult.md)                           | Data-only outcome for one bulk working-time request.                                                              |
| [ChronoZoneCollectionResult](ChronoZoneCollectionResult.md)                     | Convert zones, inspect date-specific offsets and search bounded timezone transitions.                             |
| [ChronoZoneResult](ChronoZoneResult.md)                                         | Independent Flow output with native and ISO fields.                                                               |
| [ChronoZoneToolsInput](ChronoZoneToolsInput.md)                                 | Convert zones, inspect date-specific offsets and search bounded timezone transitions.                             |
