# Dates and times, on Salesforce terms.

Chrono adds timezone-aware date and time operations to Salesforce's native values.
Use it in Flow, Apex and Lightning components: convert a customer's local time,
calculate a deadline inside operating hours, find an appointment, or divide work
into named billing blocks.

**Released version 0.1.0.19 · Namespace `skel` · BSD-3-Clause**

## Install into your org

**[Install in production / Developer Edition](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tgK000000KFNtQAO)**
· **[Install in a sandbox](https://test.salesforce.com/packaging/installPackage.apexp?p0=04tgK000000KFNtQAO)**

Sign in to your target org, select **Install for Admins Only**, then assign
**Chrono Flow User** in Setup → Permission Sets. Follow the
[installation quick start](handbook/installation.md) for CLI commands, schedule
permissions and your first Flow. No repository clone or Dev Hub is needed.

## Start with your job

| I want to…                                            | Start here                                               |
| ----------------------------------------------------- | -------------------------------------------------------- |
| Install Chrono and give people access                 | [Installation](handbook/installation.md)                 |
| Build a Flow without writing Apex                     | [Your first Flow](handbook/first-flow.md)                |
| Pick dates, timezones and operating hours on a screen | [Screen configuration](handbook/screen-configuration.md) |
| Call the library from Apex                            | [Apex quick start](handbook/apex.md)                     |
| Find the right action                                 | [Action reference](reference/actions/index.md)           |
| Try complete working examples                         | [Example library](handbook/examples.md)                  |

## Understand the value before calculating

A calendar date, a local clock reading and an exact instant answer different
questions. Chrono preserves those differences. A duration of one calendar day can
cross a clock change; a duration of 24 elapsed hours always measures 24 hours.

The [type guide](handbook/types.md) explains all eight values. The
[timezone guide](handbook/timezones.md) covers repeated times, missing times,
offsets and changing a zone without accidentally changing the instant.

## Build the rest of the journey

- [Operating hours and holidays](handbook/operating-hours.md): add working time,
  count working differences and use unsaved native records.
- [Availability and appointments](handbook/availability.md): intersect schedules,
  remove busy intervals and apply buffers and notice periods.
- [Time allocation](handbook/allocation.md): normal and holiday blocks, overlaps,
  millisecond precision and reconciled totals.
- [Ranges and recurrence](handbook/ranges-recurrence.md): half-open intervals,
  recurring dates and the supported RRULE subset.
- [Formatting and localisation](handbook/formatting.md): user locale, display
  length, ISO transport and explicit parsing patterns.
- [Troubleshooting](handbook/troubleshooting.md): errors, permissions, Flow
  resource types and unresolved local times.

## Reference and release evidence

The reference covers the released [global Apex API](reference/apex/index.md),
all **27 Flow families / 54 actions**, and the
[exposed components](reference/components/index.md). Core values are data-only;
their services own construction, validation and calculations.

The released candidate passed **210 Apex tests**, **30 shared conformance cases**
and the installed configuration checks for all **54 actions**, with **91% package
coverage**. See [release notes](handbook/releases.md) for the evidence and its limits.

Chrono uses Salesforce timezone rules and millisecond arithmetic. It does not
bundle another timezone database, implement alternative calendars, or claim
complete JavaScript Temporal compatibility. See [supported behaviour and limits](handbook/limits.md).
