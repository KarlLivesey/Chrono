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

This project currently contains setup only. No Apex implementation, tests,
dependencies or package versions have been created.

## Planned API scope

| Type | Purpose |
| --- | --- |
| `ChronoInstant` | An exact instant. |
| `ChronoZonedDateTime` | An exact instant with a time-zone ID, backed by a native `Datetime`. |
| `ChronoPlainDateTime` | A local date and time without a time zone, backed by native `Date` and `Time` values. |
| `ChronoPlainDate` | A date without a time or time zone, backed by a native `Date`. |
| `ChronoPlainTime` | A time without a date or time zone, backed by a native `Time`. |
| `ChronoPlainYearMonth` | A year and month without a day. |
| `ChronoPlainMonthDay` | A month and day without a year. |
| `ChronoDuration` | An amount of time for arithmetic and differences. |

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

## Licence

Chrono is licensed under the [BSD 3-Clause License](LICENSE)
(`BSD-3-Clause`). Copyright (c) 2026, Karl.
