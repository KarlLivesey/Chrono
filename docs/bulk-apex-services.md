# Bulk Apex services

These additions are under development for 0.2. They are not in the released 0.1.0.19 package or its public installation link.

Pass the complete request list to a service. Apex callers do not construct an invocable action or call Flow. Scalar and collection Flow actions adapt their inputs to these same services, then convert the results back to the existing Flow outputs.

```apex
List<skel.ChronoCheckWorkingTimeInput> requests = new List<skel.ChronoCheckWorkingTimeInput>();
for (Case ticket : tickets) {
    skel.ChronoCheckWorkingTimeInput request = new skel.ChronoCheckWorkingTimeInput();
    request.valueType = 'Instant';
    request.instantValue = ticket.CreatedDate;
    request.timeZoneId = 'Europe/London';
    request.operatingHoursId = operatingHoursId;
    requests.add(request);
}
List<skel.ChronoWorkingTimeCheckResult> results = skel.ChronoWorkingTimeService.check(requests);
```

The schedule is loaded once for this batch. Results follow the order of `tickets`; check each result's `success` and `errorMessage` before reading `isOpen`.

## Available calls

Every entry takes `List<Request>` and returns `List<Result>` using the classes below. Request records already exposed by the package remain shared, data-only contracts; their Flow annotations do not require a Flow interview. Existing core services remain available for individual typed values.

| Calculation        | Service method                                | Request class                   | Result class                      |
| ------------------ | --------------------------------------------- | ------------------------------- | --------------------------------- |
| Convert            | `ChronoValueService.convert`                  | `ChronoConvertInput`            | `ChronoValueResult`               |
| Adjust             | `ChronoCalculationService.adjust`             | `ChronoAdjustInput`             | `ChronoValueResult`               |
| Difference         | `ChronoCalculationService.difference`         | `ChronoDifferenceInput`         | `ChronoDurationCalculationResult` |
| CalendarDifference | `ChronoCalculationService.calendarDifference` | `ChronoCalendarDifferenceInput` | `ChronoDurationCalculationResult` |
| Compare            | `ChronoCalculationService.compare`            | `ChronoCompareInput`            | `ChronoComparisonResult`          |
| PeriodBoundary     | `ChronoCalculationService.boundary`           | `ChronoPeriodBoundaryInput`     | `ChronoValueResult`               |
| Round              | `ChronoCalculationService.round`              | `ChronoRoundInput`              | `ChronoValueResult`               |
| ResolveLocal       | `ChronoTimeZoneService.resolveLocal`          | `ChronoResolveLocalInput`       | `ChronoLocalResolutionResult`     |
| CheckWorkingTime   | `ChronoWorkingTimeService.check`              | `ChronoCheckWorkingTimeInput`   | `ChronoWorkingTimeCheckResult`    |
| FindWorkingTime    | `ChronoWorkingTimeService.find`               | `ChronoFindWorkingTimeInput`    | `ChronoValueResult`               |
| WorkingDays        | `ChronoWorkingTimeService.addDays`            | `ChronoWorkingDaysInput`        | `ChronoValueResult`               |
| CreateValue        | `ChronoValueService.create`                   | `ChronoCreateValueInput`        | `ChronoValueResult`               |
| ReplaceValue       | `ChronoValueService.replace`                  | `ChronoReplaceValueInput`       | `ChronoValueResult`               |
| ParseValue         | `ChronoValueService.parse`                    | `ChronoParseValueInput`         | `ChronoValueResult`               |
| ValidateValue      | `ChronoValueService.validate`                 | `ChronoValidateValueInput`      | `ChronoValidationResult`          |
| EpochValue         | `ChronoValueService.convertEpoch`             | `ChronoEpochValueInput`         | `ChronoEpochResult`               |
| ValueDetails       | `ChronoValueService.details`                  | `ChronoValueDetailsInput`       | `ChronoDetailsResult`             |
| DurationTools      | `ChronoDurationCalculationService.calculate`  | `ChronoDurationToolsInput`      | `ChronoDurationResult`            |
| ZoneTools          | `ChronoTimeZoneService.calculate`             | `ChronoZoneToolsInput`          | `ChronoZoneResult`                |
| RangeTools         | `ChronoRangeService.calculate`                | `ChronoRangeToolsInput`         | `ChronoRangeResult`               |
| Availability       | `ChronoAvailabilityService.evaluate`          | `ChronoAvailabilityInput`       | `ChronoAvailabilityResult`        |
| CollectionTools    | `ChronoCollectionService.calculate`           | `ChronoCollectionToolsInput`    | `ChronoValuesResult`              |
| FiscalPeriod       | `ChronoFiscalPeriodService.resolve`           | `ChronoFiscalPeriodInput`       | `ChronoFiscalResult`              |
| Recurrence         | `ChronoRecurrenceService.generate`            | `ChronoRecurrenceInput`         | `ChronoRecurrenceResult`          |
| FormatValue        | `ChronoFormattingService.format`              | `ChronoFormatValueInput`        | `ChronoFormatResult`              |
| Working time       | `ChronoWorkingTimeService.add`                | `ChronoWorkingTimeInput`        | `ChronoWorkingTimeResult`         |
| Time allocation    | `ChronoTimeAllocationService.allocateAll`     | `ChronoTimeAllocationRequest`   | `ChronoTimeAllocationResult`      |

## Batch behaviour

- Null or empty lists return empty results. A null item produces an error result at that position.
- Ordinary validation/calculation errors are isolated per request. Governor-limit failures remain transaction failures.
- Request data is not mutated. Result objects, nested core values and returned lists are independent, including duplicate requests.
- Identical calculations are reused within the invocation. No persistent cache or hidden transaction-wide state is added.
- These services perform no DML. Records supplied by callers, where the request supports them, do not need IDs or insertion.
- Flow collections are flattened across interviews before calling the service and regrouped afterwards. Outer interview and inner collection order remain unchanged.

## Query costs

| Family                                                                             | Queries per non-empty batch                                                                                |
| ---------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| Working-time add                                                                   | Three for saved OperatingHours IDs; zero for supplied records only; one additional query for BusinessHours |
| Working-time check/find, saved-schedule working days, scheduled elapsed difference | Three for saved OperatingHours IDs; zero for supplied native records only                                  |
| Availability and schedule-aware recurrence                                         | Three when saved OperatingHours IDs are supplied; zero for supplied native schedule records                |
| Fiscal periods                                                                     | One for all organisation-calendar dates; zero for explicitly configured month-based calendars              |
| Other calculations and native allocation requests                                  | Zero                                                                                                       |

Schedule and fiscal queries run in user mode. The caller must have access to the required records and fields. Native BusinessHours calculations retain Salesforce's own behaviour. Exact query-count tests use valid saved schedule IDs; empty lists and requests requiring no stored configuration do not incur these loads.

Bulk-safe means shared loading and reused calculations, not unlimited work. Existing horizon, output-count, range and segment limits still apply. Call once with the complete list, not once per record. Independently invoking different services loads each call's configuration afresh.

## Dates and supplied schedules

`ChronoWorkingTimeService.add` and `ChronoCalculationService.difference` accept native Salesforce Date and Datetime values, ISO dates, local date/times, instants and zoned date/times. The same inputs are available on their scalar and collection Flow actions.

| Input                         | Interpretation                                                                                     |
| ----------------------------- | -------------------------------------------------------------------------------------------------- |
| `startInstant` / `endInstant` | Native Salesforce Datetime: an exact instant                                                       |
| `startValue` / `endValue`     | ISO date, local date/time, instant (`Z` or offset), or zoned date/time (`[Area/City]`)             |
| `startDate` / `endDate`       | Native date: local midnight unless the corresponding `startTime` / `endTime` ISO clock is supplied |

Use one representation for each endpoint. Native and ISO fields cannot be combined for the same endpoint. Millisecond precision is retained; additional fractional digits are truncated by the existing parsers.

Local values require `timeZoneId`; Chrono never guesses the running user's timezone. Difference also accepts `endTimeZoneId`, which defaults to `timeZoneId`. Exact endpoints retain their instant. `disambiguation` defaults to `reject`; use `earlier` or `later` for repeated times. `endDisambiguation` overrides that policy for the end alone. Nonexistent local times are rejected. A spring-forward day can therefore have 23 elapsed hours, and an autumn repeated-hour day 25.

For add, difference, check and find, choose either a saved schedule ID or these native fields:

- `operatingHours`: an OperatingHours record with a timezone.
- `timeSlots`: its normal TimeSlot collection.
- `holidays`: optional Holiday records, including recurring holidays.

These records can be unsaved. Supplied-only batches perform no queries or DML, and use the same calculation engine as saved schedules. An ID combined with supplied records, or slots/holidays without an OperatingHours record, produces an item error. BusinessHours continues to require its saved ID.

In Flow's action editor, choose **Working hours → OperatingHours and related records** and bind the three compatible native resource selectors. Difference also offers **All elapsed time**. Switching schedule sources clears conflicting bindings. Choose **Salesforce Date** for a native date and optional local clock; ISO text accepts all four complete dated forms without a separate type setting.

Date-only check/find retains its existing meaning: check asks whether that schedule-local date has any opening, and find navigates to an open date. Add and elapsed difference interpret a Date as midnight in the explicit input timezone. Schedule openings and holidays always use the schedule's own timezone, which can differ from the input/result timezone.

```apex
skel.ChronoWorkingTimeInput request = new skel.ChronoWorkingTimeInput();
request.startDate = Date.newInstance(2026, 8, 28);
request.startTime = '16:30';
request.timeZoneId = 'Europe/London';
request.amount = 1;
request.unit = 'hours';
request.scheduleType = 'OperatingHours';
request.operatingHours = suppliedHours;
request.timeSlots = suppliedSlots;
request.holidays = suppliedHolidays;
List<skel.ChronoWorkingTimeResult> results = skel.ChronoWorkingTimeService.add(
    new List<skel.ChronoWorkingTimeInput>{ request }
);
```

With London Monday–Friday 09:00–17:00 slots and 31 August 2026 as a holiday, the result is Tuesday 1 September at 09:30 London time. For many inputs, populate one request list and call `add` once.

## Typed Apex results

Value operations return `ChronoValueResult`. Its `value` is a data-only tagged value: `valueType` identifies exactly one populated core field (`instant`, `zonedDateTime`, `plainDateTime`, `plainDate`, `plainTime`, `yearMonth`, `monthDay` or `duration`). Existing core services operate on that field.

Elapsed and calendar differences return `ChronoDurationCalculationResult.value`, a `ChronoDuration` with months, days and milliseconds. Local resolution returns typed zoned candidates, including both repeated occurrences and the nearest valid boundaries around a missing time. Check/find/working-day results retain their respective Boolean or value semantics.

Existing specialised result records are reused for ranges, availability, recurrence, fiscal periods, formatting and allocation. Their documented ISO strings, native values and nested rows remain unchanged. This avoids introducing a second competing contract for each family.

The Flow adapters continue returning their existing ISO/native outputs; the nested Apex value records are not newly exposed to Flow. Salesforce does not support subscriber-side `JSON.serialize` for all managed global DTOs. Read and write their global fields directly; do not rely on JSON to clone or transport these request objects across namespaces.

## Compatibility and implementation

Existing method signatures, field types and constructors remain intact. The input-coverage follow-up adds optional date/clock and native schedule fields, updates ISO input labels/descriptions, and makes the working-time schedule ID optional so supplied records can be used. Saved-ID calls retain their behaviour; supplying both forms is an explicit error. The single-request `ChronoTimeAllocationService.allocate(request)` remains unchanged; the list operation is named `allocateAll` so an existing `allocate(null)` call stays unambiguous.

Public service methods forward to internal operation classes. Internal batching, schedule loading, validation and calculation are shared between Apex and Flow. Shared timezone resolution no longer calls the picker controller. Some internal calculator class names retain their historical `ChronoFlow` prefix; they are ordinary Apex implementations and do not invoke Flow or return `ChronoFlowResult` to the services.

Core value operations that are already query-free remain suitable for ordinary Apex loops. The new batch services cover all 27 existing action families, including expensive query-free work that benefits from duplicate calculation reuse. The UI-only search/configuration endpoints remain UI adapters rather than becoming extra public Apex contracts.

## Further audit

The [9 September service audit](service-audit-2026-09.md) records the current
coverage, confirmed zero-arithmetic correction, direct-service benchmarks and
remaining optional capabilities. Its source corrections are newer than installed
beta 0.2.0.3.

## Validation

Current date/native-schedule candidate, verified on 8 September 2026:

- **0.2.0.3** (`04tgK000000KIYfQAO`), one skip-validation build (`08cgK000000H4ATQA0`). Salesforce reports `ValidationSkipped=true`, `IsReleased=false`, ancestor `04tgK000000KFNtQAO` (released 0.1.0.19).
- Full development deployment `0AfG100000LNgaLKAT`: **240 Apex tests passed**. The final test-helper cleanup was redeployed and its **11 focused tests passed** (`0AfG100000LNaYFKA1`).
- **145 LWC tests, 43 Temporal tests and 19 contract tests passed**. Formatting passed. PMD has no severity 1–3 findings; low-severity findings remain.
- The reviewed inventory contains **1,604 global declarations**, with all 121 core API method signatures preserved. There are 46 optional input fields added across the four input classes and their scalar wrappers. Existing field types/method signatures remain; the working-time schedule ID annotation changes from required to optional, and ISO labels/descriptions describe the expanded inputs.
- The released ancestor was installed with the original fixtures; **47 subscriber tests passed** (`0AfAs00000X84oEKAR`). Upgrade **0.1.0.19 → 0.2.0.3 succeeded** (`0HfAs000002bZvJKAU`) with those consumers installed.
- Post-upgrade fixture deployment `0AfAs00000X89XmKAJ`: **83 subscriber tests passed**. This includes the previous 69 and 14 additional tests in `ChronoDatedConsumerTest` and `ChronoNativeFlowConsumerTest`.
- Actual Flow interviews verified add/difference/check/find with unsaved OperatingHours, TimeSlot and Holiday records, native dates/clocks, and collection inputs. The difference fixture also verified distinct endpoint timezones and separate repeated-time policies. Scalar Flow fixtures omit the saved schedule ID entirely.
- Installed REST action descriptions confirm the optional schedule ID, native `SOBJECT` inputs for OperatingHours/TimeSlot/Holiday, and all four custom configuration-editor registrations.
- In-package mixed batches of 200 inputs per service verify **three SOQL queries per call**, including saved and supplied schedules together. Supplied-only batches use **zero queries**. Both perform **zero DML**; result order, independent copies, holidays, signed millisecond precision, DST day length and isolated input failures are covered.

The original 70 Chrono Flow fixtures and packaged permission assignment are restored, alongside the four new native-record fixtures. No new scratch org or standard validation build was used. Browser rendering was not checked; component behaviour was checked through Jest and packaged Flow execution.

Earlier 0.2.0.2 evidence follows for history.

Verified on 8 September 2026 (0.2.0.2):

- Development deployment `0AfG100000LNedNKAT`: **229 Apex tests passed**.
- All 1,471 released global declarations and all 1,478 declarations from the previous bulk-working-time candidate remain intact. The current baseline contains 1,558 declarations. All 17 contract tests pass, including coverage of every action family and its service route.
- All 138 LWC tests pass. PMD passes the configured severity threshold; low-severity findings remain.
- One skip-validation build: **0.2.0.2**, subscriber package version `04tgK000000KHsjQAG`, build request `08cgK000000H3zBQAS`. `ValidationSkipped=true`, `IsReleased=false`; ancestor is released 0.1.0.19.
- The released package was reinstalled into the existing subscriber org. All 79 backed-up fixture components were restored; its 47 subscriber tests passed (`0AfAs00000X84JdKAJ`).
- Upgrade **0.1.0.19 → 0.2.0.2** succeeded with those fixtures in place (`0HfAs000002bYuPKAU`).
- Post-upgrade deployment `0AfAs00000X87ZCKAZ`: **69 subscriber Apex tests passed**, comprising the existing 47 plus 22 direct bulk-service tests across four new consumer classes.
- Against actual subscriber data, 200 working-time requests across two schedules/zones passed with **three `skel` SOQL queries**. 200 fiscal requests matched the organisation's year, quarter and month with **one `skel` SOQL query**. Both calls performed zero DML.
- All 70 active Chrono Flow fixtures and the original packaged permission assignment were verified restored. No new scratch org or standard build was used.

Run the direct consumer tests in `tests/subscriber/force-app/main/default/classes/ChronoBulk*ConsumerTest.cls` against a package containing these services. The [working-time script](https://github.com/KarlLivesey/Chrono/blob/main/tests/subscriber/scripts/working-time-service.apex) and [fiscal script](https://github.com/KarlLivesey/Chrono/blob/main/tests/subscriber/scripts/bulk-fiscal-service.apex) exercise actual org data. Query-budget assertions run inside the package; subscriber `Limits` counters do not include queries in the `skel` namespace, so the anonymous execution logs are also checked.

This establishes compilation, installation, upgrade and subscriber execution evidence. The package remains an **unreleased skip-validation beta**; these checks do not substitute for a future standard validation build or promotion.

Salesforce requires an installed beta to be uninstalled before installing another version. Subscriber test fixtures are backed up and restored around that replacement; the released ancestor remains 0.1.0.19. [Salesforce's 2GP upgrade guidance](https://developer.salesforce.com/docs/platform/pkg2-dev/guide/sfdx-dev-dev2gp-install-pkg-upgrade.html).
