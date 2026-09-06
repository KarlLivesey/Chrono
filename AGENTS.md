# Chrono project requirements

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

Provide instance and static forms of operations, sharing one implementation.
Static forms take the source value first and support corresponding native
Salesforce values where applicable. Zoned operations on a native `Datetime`
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
