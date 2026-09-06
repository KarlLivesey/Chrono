# Chrono

Salesforce second-generation managed package in the `skel` namespace, using
`skel-devhub` as its Dev Hub.

The managed package is registered in the Dev Hub with package ID
`0HogK0000004dxFSAQ` and local alias `Chrono`.

Chrono builds on Salesforce's native `Date`, `Time`,
`Datetime` and time-zone capabilities. Its scope is to add an easy-to-use zoned
date/time API for organisations working across multiple time zones, with
conversions to and from the native Salesforce types.

Chrono will support schedule-aware arithmetic using Salesforce `OperatingHours`,
its time slots and associated holidays, as well as the native `BusinessHours`
API. These are distinct Salesforce models; verify object availability and managed
package dependencies before selecting the implementation.

For example, with operating hours of 09:00–17:00 Monday to Friday and a holiday
on Monday, adding one working hour to Friday 16:30 must produce Tuesday 09:30
in the schedule's time zone. Closed periods do not consume the requested working
time. Include partial-day holidays, schedule time zones and daylight-saving
transitions in the behaviour and validation.

Provide both instance and static call styles for operations. Static overloads
accept the value being operated on as their first argument and delegate to the
same behaviour as the instance methods. Support native Salesforce inputs where
applicable; require an explicit zone when a native `Datetime` needs zoned
semantics rather than silently using the running user's zone. Intended examples:

```apex
zoned.addHours(1, operatingHours);
ChronoZonedDateTime.addHours(zoned, 1, operatingHours);
ChronoZonedDateTime.addHours(nativeDatetime, zoneId, 1, operatingHours);
```

Both styles return a new value and leave the input unchanged.

JavaScript Temporal's [type relationships and string representations](https://tc39.es/proposal-temporal/docs/)
are the reference for the types and conversions. Alternate calendar
systems, such as the Japanese calendar, are outside the scope.

Chrono implements the eight native-backed value types below. It is an Apex
library with no runtime dependencies. This is an initial beta API, not a complete
JavaScript Temporal polyfill.

## API scope

| Type                   | Purpose                                                                               |
| ---------------------- | ------------------------------------------------------------------------------------- |
| `ChronoInstant`        | An exact instant.                                                                     |
| `ChronoZonedDateTime`  | An exact instant with a time-zone ID, backed by a native `Datetime`.                  |
| `ChronoPlainDateTime`  | A local date and time without a time zone, backed by native `Date` and `Time` values. |
| `ChronoPlainDate`      | A date without a time or time zone, backed by a native `Date`.                        |
| `ChronoPlainTime`      | A time without a date or time zone, backed by a native `Time`.                        |
| `ChronoPlainYearMonth` | A year and month without a day.                                                       |
| `ChronoPlainMonthDay`  | A month and day without a year.                                                       |
| `ChronoDuration`       | An amount of time for arithmetic and differences.                                     |

Support conversions between these types where the required information is
provided, and conversions to and from the corresponding native Salesforce types.
Use the existing `SkelDateTimeZoneResolver` as the basis for resolving local
date/time values into instants in a chosen zone, including skipped and repeated
local times.

Support calendar-day and month arithmetic using native Salesforce date
operations, with local values resolved again when applying a time zone. Keep
calendar arithmetic distinct from elapsed-time arithmetic across time-zone
offset changes.

Support parsing and serialisation of the corresponding ISO-style date/time,
partial-date and duration strings, including UTC `Z`, numeric offsets and named
time-zone annotations such as `[Asia/Tokyo]` where appropriate. Use the native
Salesforce calendar model; alternate calendar annotations such as
`[u-ca=japanese]` are not supported.

## Using Chrono from subscriber Apex

Prefix classes with the managed-package namespace, `skel`:

```apex
skel.ChronoPlainDateTime local = new skel.ChronoPlainDateTime(
    Date.newInstance(2026, 8, 28), Time.newInstance(16, 30, 0, 0)
);
skel.ChronoZonedDateTime friday = local.toZonedDateTime('Europe/London');
OperatingHours hours = [SELECT Id FROM OperatingHours WHERE Name = 'UK Office' LIMIT 1];
skel.ChronoZonedDateTime next = friday.addHours(1, hours);
// The same operation with a Chrono or native starting value:
next = skel.ChronoZonedDateTime.addHours(friday, 1, hours);
next = skel.ChronoZonedDateTime.addHours(friday.toDatetime(), 'Europe/London', 1, hours);
Datetime nativeInstant = next.toDatetime();
Date localDate = next.toDate();
Time localTime = next.toTime();
```

With 09:00–17:00 weekdays and a linked Monday holiday, the result is Tuesday
09:30. `addHours` and `addMinutes` also accept a saved `BusinessHours` record;
those overloads delegate to Salesforce's native `BusinessHours.addGmt`.

All arithmetic returns new values. Instance/static pairs share their behaviour;
static operations accept the source value first. Date, time and instant
arithmetic also has native-input overloads. Constructors and `parse` provide
entry points for all eight types. Individual methods have ApexDoc in source.

### Calendar and elapsed time

`addDays`, `addMonths` and `addYears` operate on local calendar values. Native
Salesforce date arithmetic determines month-end behaviour, including clamping
31 January plus one month to the last day of February. `addHours` on an instant
or zoned datetime adds elapsed time. On a plain datetime it adds wall-clock time;
on a plain time it wraps at midnight.

`ChronoDuration` retains separate signed months, days and milliseconds. ISO years
become months and weeks become days. Components must share a sign. Zoned `add`
applies calendar months and days first, resolves the zone, then adds elapsed
milliseconds. `until` on instants or zoned datetimes returns an elapsed duration.
`toMilliseconds` rejects calendar components because their length depends on a
relative value. This API does not implement Temporal's complete balancing,
rounding or difference-options system.

Converting a plain datetime to a zone rejects skipped and repeated clock times
by default. Pass `earlier` or `later` to select an occurrence of a repeated time:

```apex
skel.ChronoZonedDateTime chosen = skel.ChronoPlainDateTime
    .parse('2026-10-25T01:30')
    .toZonedDateTime('Europe/London', 'later');
```

Skipped local values always raise `skel.ChronoException`. Changing a zoned value
with `withTimeZone` preserves its instant. The native `Datetime` always denotes
an instant; `toDate` and `toTime` on the zoned value return its local components.
A plain datetime has no unqualified conversion to a native instant: supply a zone.

### Working schedules and permissions

Operating-hours arithmetic reads the saved `OperatingHours`, its **normal**
`TimeSlot` records and holidays linked through `OperatingHoursHoliday`. It honours
all-day and partial-day holidays, including Salesforce's seven recurrence types.
It uses the schedule's zone and preserves the source value's zone in the result.
Negative amounts traverse openings backwards; zero preserves the instant.

Clock gaps consume no time. Repeated opening windows count each actual occurrence,
while closed periods between them remain closed. Salesforce rejects overlapping
slots and end times before start times; configure coverage on separate days with
separate valid slots. Extended hours and appointment-filtered slots are not generic
availability: extended slots are excluded and conditional normal slots raise an
explicit error because Chrono has no appointment context.

The OperatingHours overload performs **three SOQL queries per call** in user mode,
without a hidden cache or DML. The caller must be able to read the schedule, slots,
links and holiday fields. Salesforce feature availability and permissions still
apply. Do not put these query-backed overloads into an unbounded record loop.
Native BusinessHours overloads use Salesforce's own calculation and access
behaviour. Holidays on that model must be associated through its own configuration.

Search is limited to 3,660 calendar days, with normal Apex CPU, heap and query-row
limits also applying; very large working-time additions may hit those limits sooner.
Zone intervals use Salesforce's time-zone rules, sampling for transitions every six
hours and locating detected transitions to millisecond precision. No time-zone
database is bundled or maintained by Chrono.

### Parsing and errors

ISO representations support four-digit dates, times with optional seconds and
up to three fractional digits, offset-bearing instants, named-zone datetimes,
`YYYY-MM`, `--MM-DD` and durations. Output includes seconds and milliseconds;
year-month and month-day retain their partial form. Zoned parsing requires an
offset matching the named zone. Alternate calendar annotations and sub-millisecond
precision are rejected. Historical offsets containing seconds cannot currently be
serialised as zoned strings. Salesforce's native date ranges and exceptions apply.

Chrono-specific invalid inputs and unresolved local times raise the globally
catchable `ChronoException`. Native range errors, permissions and query failures
propagate from Salesforce. These classes are subscriber Apex APIs; no Flow actions,
LWC endpoints or Apex-defined transport types are included in this beta.

## Project configuration

- `sfdx-project.json`: package directory, namespace, API version and version settings.
- `config/project-scratch-def.json`: Developer Edition scratch-org definition.
- `force-app/main/default/classes/`: package implementation and Apex tests.

The package version setting is `0.1.0.NEXT`. See [validation](docs/validation.md)
for the exact version and checks performed.

## Managed-package feasibility

Managed-package constraints are a project-wide engineering requirement across
design, implementation, testing and releases. Check packaging, installation,
subscriber use and upgrade behaviour relevant to each feature. The examples
below are not exhaustive; working in an unpackaged development org is not
sufficient validation. This requirement is also recorded in [AGENTS.md](AGENTS.md)
for future development work.

Before selecting a feature or approach, establish whether it is supported in
managed 2GP **for the intended use and consumer**. Ask "Can we actually use X
here?" before building around X. Verify the relevant restrictions in official
documentation and resolve uncertain behaviour with focused package/subscriber
validation before committing to the design. The specific checks and references
below are examples, not the limits of this requirement.

Before exposing an API, check the intended consumer: subscriber Apex, Apex in
another package, Lightning Web Components, or Flow/invocable actions. Each has
different access and serialisation rules; successful compilation inside this
package is not sufficient evidence that a consumer can use it.

- Keep the subscriber-facing `global` API small. Check constructors, members,
  parameter and return types, nested types and enums for the intended access.
  Keep implementation details internal.
- Treat released global signatures as compatibility commitments. Review
  Salesforce's manageability restrictions before changing names, signatures,
  constructors, annotations, inheritance or enum values.
- For any LWC-facing Apex endpoint, use supported transport types. Apex inner
  classes are not supported as parameters or return values for LWC calls.
  `@NamespaceAccessible` does not enable cross-package LWC-to-Apex calls, even
  when the packages share a namespace. Use an appropriate consumer-side Apex
  adapter when needed.
- For any Flow/invocable endpoint, separately verify supported input/output
  types, annotations, constructor requirements and bulk input/output behaviour.
  Flow Apex-defined variables do not support inner classes or getter methods;
  their fields need `@AuraEnabled`. Invocable request/response wrappers have
  different rules and can use inner classes. From API 66.0, custom invocable
  parameter classes need an accessible no-argument constructor (`global` for
  packaged classes invoked from outside the package). Do not assume that a
  type usable by Apex or LWC is also usable by Flow.
- Before release, install a beta package into a separate subscriber test org
  and exercise the exposed APIs from consumer code outside the package. Test
  upgrades against existing consumer code when a released version exists.

PMD's `AvoidGlobalModifier` rule remains enabled. Necessary global API classes
should have narrowly scoped suppressions with a documented reason; do not
disable the rule for the whole project. Lint does not replace package creation,
subscriber compilation or consumer integration tests.

References: [Apex Developer Guide, Apex in Managed Packages](https://resources.docs.salesforce.com/latest/latest/en-us/sfdc/pdf/salesforce_apex_developer_guide.pdf),
[exposing Apex to LWC](https://developer.salesforce.com/docs/platform/lwc/guide/apex-expose-method.html),
[Flow Apex-defined type limitations](https://help.salesforce.com/s/articleView?id=sf.flow_considerations_apex_data_type.htm&language=en_US&type=5),
[Flow Apex action wrappers](https://help.salesforce.com/s/articleView?id=platform.flow_concepts_apex_type.htm&language=en_US&type=5),
and [PMD's global modifier rule](https://pmd.github.io/pmd/pmd_rules_apex_bestpractices.html#avoidglobalmodifier).

## Local development setup

Authenticate the Dev Hub if the `skel-devhub` alias is not already available:

```sh
sf org login web --alias skel-devhub --set-default-dev-hub
```

Set the Dev Hub for this project:

```sh
sf config set target-dev-hub=skel-devhub
```

When development begins, create a namespaced scratch org:

```sh
sf org create scratch --definition-file config/project-scratch-def.json --target-dev-hub skel-devhub --alias chrono-dev --set-default --duration-days 7
```

Reuse the existing `chrono-dev` and `chrono-subscriber` orgs. Scratch-org and
package-version allocations are limited; do not recreate them for routine tests.

Package configuration follows the [Salesforce managed 2GP project configuration documentation](https://developer.salesforce.com/docs/platform/pkg2-dev/guide/sfdx-dev2gp-config-file.html).

## Linting and formatting

Use Node.js 24 (see `.nvmrc`), a Java JDK 21 or newer, and Salesforce CLI with
Code Analyzer v5. The CI workflow pins Salesforce CLI to `2.150.6` and Code
Analyzer to `5.14.0`.

Install the development tools:

```sh
npm ci
sf plugins install @salesforce/plugin-code-analyzer@5.14.0
```

| Command                | Purpose                                                           |
| ---------------------- | ----------------------------------------------------------------- |
| `npm run format`       | Format Apex, XML metadata, JSON, YAML and Markdown with Prettier. |
| `npm run format:check` | Check formatting without changing files.                          |
| `npm run lint`         | Run PMD's recommended and AppExchange rules against `force-app`.  |
| `npm run check`        | Run both formatting checks and Apex linting.                      |

Linting fails on critical, high or moderate findings (severity levels 1–3).
Lower-severity findings remain visible. These checks run locally without a
Salesforce org login and are configured in GitHub Actions for pull requests
and pushes to `main`.

Static analysis is separate from Apex compilation, runtime tests and package
installation. See [validation](docs/validation.md) for actual results and the
[Salesforce Code Analyzer documentation](https://developer.salesforce.com/docs/platform/salesforce-code-analyzer/guide/analyze.html)
for rule selection and severity thresholds.

## Licence

Chrono is licensed under the [BSD 3-Clause License](LICENSE)
(`BSD-3-Clause`). Copyright (c) 2026, Karl.
