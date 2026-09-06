# Chrono

Salesforce second-generation managed package in the `skel` namespace, using
`skel-devhub` as its Dev Hub.

The managed package is registered in the Dev Hub with package ID
`0HogK0000004dxFSAQ` and local alias `Chrono`.

The planned library, Chrono, builds on Salesforce's native `Date`, `Time`,
`Datetime` and time-zone capabilities. Its scope is to add an easy-to-use zoned
date/time API for organisations working across multiple time zones, with
conversions to and from the native Salesforce types.

Chrono will also integrate with Salesforce Business Hours for business-time
calculations using the organisation's configured business hours.

JavaScript Temporal's [type relationships and string representations](https://tc39.es/proposal-temporal/docs/)
are the reference for the planned types and conversions. Alternate calendar
systems, such as the Japanese calendar, are outside the scope.

This project currently contains setup only. No Apex implementation, Apex tests,
runtime dependencies or package versions have been created.

## Planned API scope

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

## Project configuration

- `sfdx-project.json`: package directory, namespace, API version and version settings.
- `config/project-scratch-def.json`: Developer Edition scratch-org definition.
- `force-app/main/default/classes/`: empty directory reserved for future Apex source.

The initial package version setting is `0.1.0.NEXT`. This is configuration for a
future build, not an existing installable version.

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

No scratch org is created as part of the initial setup.

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

The current empty Apex directory produces no lint findings. This does not
represent Apex compilation or test coverage; those require source code and a
Salesforce development org. See the [Salesforce Code Analyzer documentation](https://developer.salesforce.com/docs/platform/salesforce-code-analyzer/guide/analyze.html)
for rule selection and severity thresholds.

## Licence

Chrono is licensed under the [BSD 3-Clause License](LICENSE)
(`BSD-3-Clause`). Copyright (c) 2026, Karl.
