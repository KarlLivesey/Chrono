# Action catalogue delivery

Karl approved implementing the proposed catalogue, with these exclusions:
alternate calendar systems, sub-millisecond arithmetic, natural-language date
guessing, external holiday feeds and background job scheduling. Fiscal periods
are business period configuration, not an alternate date calendar.

## Delivery checklist

- [x] Values: construction, replacement, validation, explicit-pattern parsing,
      Unix timestamp conversion and detailed date/time components.
- [x] Calculations: quarter boundaries, additional rounding policies, comparison
      tolerance, same-period checks and fiscal periods.
- [x] Time Zones: preserve-clock conversion, explicit offset override, details,
      zone lists, transition navigation/listing and zone comparisons.
- [x] Durations: construction/components, sign operations, totals, balancing and scaling.
- [x] Formatting: date/time, patterns, duration, ranges and relative time.
- [x] Ranges: validation, containment, relationships, intersection, merging,
      subtraction, gaps, splitting, clamping and coverage.
- [x] Working Hours: opening windows/boundaries, whole-interval checks, continuous
      and shared availability, any-schedule coverage, busy-time subtraction,
      appointment choices, working dates, closure details and validation.
- [x] Recurrence: weekday/ordinal/annual/working-date rules, bounded generation,
      closure adjustment and explicitly supported iCalendar rules.
- [x] Collections: earliest/latest, sorting, deduplication, filtering, calendar
      grouping, duration sums, nearest value and summaries.
- [x] Reusable action editors, labels, category metadata, scalar/collection forms.
- [x] Meaningful tests, existing-org compilation/execution, lint and examples.
- [x] Consolidated skip-validation beta and subscriber tests. No standard builds.

Existing operations remain available under their existing Apex API names.
Category labels become Chrono: Values, Chrono: Calculations, Chrono: Time Zones,
Chrono: Durations, Chrono: Formatting, Chrono: Working Hours, Chrono: Ranges,
Chrono: Recurrence and Chrono: Collections. These are flat Salesforce categories,
not an assumed hierarchy. Input sections remain the responsibility of the editor.

## Boundaries and feasibility

Reuse the installed package's global invocable DTO/primitive/native-record
patterns. No immutable core Chrono objects or redundant schedule DTOs cross Flow.
Global constructors and all referenced types remain visible across the namespace.
New list-valued result fields need actual scalar and collection Flow fixture tests;
compilation alone is not proof of that transport. Keep related UI controls in the
existing reusable literal/resource editor, including native Date/Datetime inputs.

Apex formatting follows the context user's locale. An explicit output pattern is
an intentional format override. Do not claim arbitrary locale/length support from
Datetime.format: style selection needs explicit implementation and tests.

Sources: [Flow types](https://developer.salesforce.com/docs/platform/lwc/guide/use-flow-data-types),
[Apex locale behaviour](https://help.salesforce.com/s/articleView?id=sf.admin_locales_code_methods.htm&language=en_US&type=5),
[invocable annotations](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_annotation_InvocableMethod.htm).

## Validation record

All 169 development-org Apex tests passed after the final engine changes
(`707G1000019WIKI`). This includes execution of the 28 new scalar/collection
Flow harnesses, native schedule inputs and a 200-request schedule batch with
three shared queries and independent results. The final 15 consumer fixtures
also passed in development (`707G1000019WJ8J`). The native Salesforce fiscal
month, quarter and year also matched actual Period records through Flow.

All 106 LWC tests and 13 Temporal tests pass. Formatting and the configured
PMD threshold pass; 328 low-severity findings remain. No browser or screen
capture was used; visual rendering is unverified.

One skip-validation beta, 0.1.0.8 (`04tgK000000KA01QAG`), was created and installed
in the existing subscriber org. All 35 subscriber-owned tests passed
(`707As00001VsqkE`), as did 48 targeted installed-package tests (`707As00001Vspcs`).
All 50 action editor registrations, categories, labels, calendar icons and
corresponding installed LWC bundles were checked through Salesforce APIs.
All 59 Chrono fixtures/examples are active. No standard build or new scratch org
was used. Standard allocation remains 6/6; quick-build allocation is 496/500.
The prior 0.1.0.7 results apply only to the previous 22 actions.

Native `TimeSlot` records must be passed directly: JSON serialisation followed by
Apex deserialisation of a typed schedule request rejects its `Time` fields.
Recurrence copies native schedule references explicitly and performs no DML.

Subscriber Apex cannot use raw `JSON.serialize`/`JSON.deserialize` on these
packaged transport classes under their current access policy. The initial
subscriber fixture exposed that restriction. Requests now use global constructors
and field assignments; results are read through their global fields. All scalar
and collection Flow tests pass through that supported contract. JSON remains an
internal package implementation detail, not a promised subscriber transport API.
