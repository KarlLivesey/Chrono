# Chrono project requirements

Chrono's overall purpose is to support dates, times and durations in Salesforce.
Timezone handling, working time and time allocation are parts of that broader
scope. This purpose does not authorise speculative features beyond the current
request; existing exclusions such as alternate calendars still apply.

Keep the methods consumers call separate from implementation. Core global
`Chrono*Service` methods are stable forwarding entry points; internal
`Chrono*Operations` classes own validation and algorithms and are not global.
Keep data classes data-only. Preserve current semantics when adding features:
new options must not silently reinterpret existing inputs or change defaults.
Run `npm run test:contracts` when changing the core API or its implementation.

Chrono is a Salesforce second-generation managed package in the `skel`
namespace. The functional scope and tooling commands are recorded in
[README.md](README.md).

## Managed-package engineering

Design and validate Chrono as a managed package from the outset. Apply this
requirement throughout architecture, implementation, testing and releases.

Before choosing any Apex feature, type, annotation, metadata component or design
approach, ask: **Can this actually be used in a second-generation managed
package, in the way Chrono and its intended consumers need to use it?**

Check feasibility before building around the choice:

1. Identify the proposed capability and where it must work: inside Chrono,
   across a package/namespace boundary, or in the subscriber's execution context.
2. Verify that Salesforce supports that use in managed 2GP, including relevant
   access, packaging and lifecycle restrictions. General Apex support or an
   unpackaged example is not proof of managed-package support.
3. If documentation leaves the behaviour uncertain, identify the smallest
   package/subscriber validation needed before committing to the design. Keep
   the choice explicitly unverified until there is supporting evidence.
4. If it does not work in that context, explain the limitation before proposing
   a supported approach. Do not build on the assumption that a packaging problem
   can be fixed later, or silently change the agreed scope to work around it.

This is an open-ended feasibility requirement for every proposed capability,
not merely a check against a fixed list of known gotchas.

- Check the managed-package constraints relevant to each change. Code that
  compiles or works in an unpackaged development org is not sufficient evidence
  that it can be packaged, installed, upgraded or used by subscribers.
- Verify uncertain or version-dependent behaviour against current official
  Salesforce documentation and, where necessary, a focused package/subscriber
  test. Make unresolved assumptions explicit.
- Consider the actual consumer and package boundary when designing APIs.
  Subscriber Apex, another managed package, LWC and Flow/invocable actions have
  different visibility, supported-type and serialisation requirements.
- Review exposed classes, members, constructors, parameters, return types,
  nested types, enums and annotations together. Keep implementation details
  internal and expose only the API consumers need.
- Account for namespaces, dependencies, supported metadata, permissions and
  subscriber configuration wherever they affect a feature. Avoid assumptions
  based solely on the development org's configuration.
- Review release manageability and upgrade compatibility before committing to
  a global API or changing an existing released contract.
- Validate exposed behaviour from outside the package in a separate subscriber
  org before release. Include installation and, once released versions exist,
  upgrade checks appropriate to the change.
- Treat lint, package validation and consumer integration tests as distinct
  checks. State exactly which were run and what remains unverified.

These examples are not an exhaustive checklist. Investigate other packaging
constraints as features are designed. The requirement is a general engineering
standard, not a request to add speculative APIs, wrappers or metadata.

See the README's managed-package feasibility section for documented LWC, Flow and global
API considerations.

## API call styles and working time

Core Chrono values are data-only classes with fields and an empty constructor.
Construction, validation, conversion and arithmetic belong in dedicated services.
This supersedes the earlier instance-method requirement. Service operations take
the source value first and support corresponding native Salesforce values where
applicable. Validate mutable data at each public service boundary. Use internal
interfaces for substitutable operations; never expose interface-typed Flow/LWC
contracts. Zoned operations on a native `Datetime`
require an explicit time-zone ID. Arithmetic returns new values.

Working-time arithmetic must support Salesforce `OperatingHours`, time slots
and associated holidays; do not substitute `BusinessHours` without addressing
the distinct object model. Verify availability and managed-package dependencies.
The acceptance example is Friday 16:30 plus one working hour, with 09:00–17:00
Monday–Friday hours and Monday a holiday, returning Tuesday 09:30.

## Salesforce allocation limits

Scratch-org and package-version creation allocations are limited. Reuse the
existing `chrono-dev` and `chrono-subscriber` scratch orgs. Do not create further
scratch orgs without checking with Karl.

- Default to `--skip-validation` for every package build unless Karl explicitly
  specifies another mode. Quick builds are charged to
  `Package2VersionCreatesWithoutValidation`. Use these for test packages.
- **Do not consume `Package2VersionCreates` without Karl's explicit approval.**
  Standard/full builds (the CLI default) and async validation builds are not
  authorised by a request to implement, test, commit, push or make a quick build.
- Always include `--skip-validation` on an authorised quick-build command. Do not
  combine it with `--code-coverage` or `--async-validation`.
- Run compilation, tests and lint in existing orgs before building. Consolidate
  validation into as few builds as practical; do not retry creation blindly.
- Quick builds do not validate package dependencies/metadata or calculate package
  coverage and cannot be promoted. Install and test in the existing subscriber
  org, and report that evidence separately from standard build validation.

## Flow and component delivery

Implement Flow actions first, including meaningful single and bulk tests and
managed-package subscriber validation. LWC components for Flow screens and record
pages are a subsequent phase; do not start them as part of the Flow-action work.
Expose all eight Chrono types through the appropriate Flow operations. Provide
single-value and explicit-collection actions, each bulkified across interviews.
Preserve outer interview order and inner collection order. Load shared schedule
configuration in bulk and reuse identical calculations within an invocation when
it saves work. Return independent result objects; cached instances must not escape.
Use `InvocableActionExtension` for a better Flow Builder configuration experience,
including clear labels, the Chrono category, calendar icons, ordering/groups and
relevant picklists/visibility. Prefer CLI and automated validation; browser checks
are not required. If needed, use a CLI-generated login URL in the internal browser,
not Karl’s personal browser. Verify the
actual packaged action configuration and execution in the subscriber org.

## Additional Flow action requirements

The additional actions cover working-time availability, next/previous working time,
comparison, start/end of a period, rounding, local-time resolution and calendar
difference. Preserve support for the applicable Chrono types, including ZonedDateTime,
rather than restricting them to Instant. Calendar difference returns its remaining
time separately; callers can ignore that remainder and use only whole calendar units.
Assess all eight types for each operation and support meaningful combinations.
Preserve zoned and local-value semantics; do not silently turn plain values into
instants or invent a missing date, year or timezone. Require explicit context
where the operation needs it, and expose only valid choices to Flow authors.
Keep the existing ISO Text/native Salesforce boundary and provide both scalar
and collection actions, bulkified across interviews. OperatingHours calculations
use the schedule's timezone, which can differ from a supplied zoned value's zone.

Flow action input variants must explicitly support ISO Text representing a date
(`2026-09-07`), plain date/time (`2026-09-07T10:15:00.000`) and zoned date/time
(`2026-09-07T10:15:00.000+01:00[Europe/London]`), alongside native Salesforce
Date and Datetime resources. Retain existing ISO instant support. Do not require
admins to convert native resources to Text before using an action. Provide
separate, clearly labelled action variants per input type or compatible set where
needed for Flow's typed inputs, resource selection and configuration experience;
one operation need not mean one invocable action. Share the underlying operation
across these variants and preserve scalar/collection and interview batching.

## Date/time picker requirements

Core Apex-defined Flow values must be both useful to admins and protected against
invalid state. Check actual Flow construction, field assignment, collections and
screen transport; do not treat Apex `final` fields or successful serialisation as
proof of protection. Admins should have labelled, validated operations and usable
typed resources. Invalid or incomplete transported values must not silently enter
arithmetic or produce misleading outputs. Record any protection gap before calling
the core Flow API ready.

Interoperability takes priority over exposing core Apex-defined objects directly.
Karl authorises ISO strings as the common contract where needed across Flow,
LWC and Apex (including bracketed-zone datetimes, instants and ISO durations).
Keep admin-facing controls and labels useful; admins must not need to compose
serialised values for ordinary tasks. Parse and validate strings before use.
Accept sub-millisecond fractional seconds and truncate extra digits to three
decimal places without rounding, including negative durations; native arithmetic
remains at Salesforce millisecond precision.

The LWC phase is authorised. Keep a reusable UI-only picker separate from the
Flow adapter and the custom Flow configuration editor. Support date-only and
zoned-datetime modes, fixed or user-selectable zones, explicit repeated-time
choices, and **nearest valid boundaries** for nonexistent times (not a
shift-by-gap correction). Prefer native Temporal with an Apex fallback.

OperatingHours configuration must support no restriction, a specific ID, allowed
IDs, a filter, unrestricted selection, supplied native records/collections and fixed values. Allow Flow resource bindings. Evaluate hours and
holidays in the schedule's timezone. Supplied OperatingHours, TimeSlot and Holiday
records can be unsaved. Use those native records as the shared Apex contract;
The configurator converts fixed inputs to them rather than introducing wrapper
schedule classes or a separate scheduling engine. Provide service working-time overloads for supplied
records, with no required ID, queries or DML.

Do not start screen capture or the Computer Use service. It previously interfered
with Karl's DRM playback. Validate using CLI, component tests and package/subscriber
fixtures; report browser rendering as unverified.

Chrono date/time values cross picker Flow boundaries as ISO Text. Schedule inputs
use native records, including unsaved records; do not reintroduce redundant
Apex-defined schedule wrappers. For a beta reinstall, deactivate test FlowDefinitions and enumerate
all Flow versions through Tooling API; destructive members must name every version
(e.g. `ChronoConvertHarness-1`). Restore the fixtures after reinstalling.

Use the approved compact-pair picker design: adjacent date/time inputs, sibling
timezone and Hours controls beside the label, and a clickable offset indicator.
Timezone and Hours can be independently fixed or selectable. Use modern LWC
public APIs/events, focused reusable child components, Salesforce base controls
and SLDS semantic theme hooks for light/dark compatibility. Date-specific offsets
must remain accurate; show both overlap candidates. Explicit customer offset
overrides preserve wall fields and derive the instant from that offset, labelled
as an override when different from the named timezone's actual rules. Operating
hours and holidays always follow the schedule's independent timezone.

## Time allocation

Provide named normal-day and bank-holiday blocks. Overlap modes are strict
(reject matching overlaps), lax (first configured priority wins), duplicate
(full duration to every match) and split (equal shares per changing overlap
segment). Default to actual elapsed time; allow nominal clock time. Default to
millisecond allocation with optional whole seconds/minutes. Allocate remaining
whole units in stable priority order and report sub-unit remainders explicitly.
Preserve each block identity and reconcile allocated, unallocated, duplicated and
rounding amounts. See docs/time-allocation.md for the precise contract.

## GitHub delivery

Commit and push completed, checked chunks to GitHub as work progresses. Do not
leave completed authorised work accumulated locally until the end of a long task.
Use ordinary commits and pushes; preserve other contributors' changes and inspect
remote updates before integrating them. Report any failed push or CI run accurately.
