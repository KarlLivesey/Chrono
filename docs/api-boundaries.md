# Stable consumer API and internal implementation

Chrono aims to make its existing date, time and duration operations safe to use
and extend. Feature completeness is not the goal. Additional capabilities must
preserve existing inputs, defaults and output meanings.

## Public entry points

The eight core `Chrono*Service` classes expose **121 global static method signatures**, including native overloads.
The approved pre-release naming migration is recorded in
[the global API audit](global-api-audit.md). Each method forwards its
arguments unchanged to its corresponding internal `Chrono*Operations` class.
Validation, construction, parsing, formatting and arithmetic belong to those
operations or the existing focused helpers they call. Internal operations are
`public` and package-internal in managed 2GP, not `global` consumer APIs. They call each
other directly rather than routing internal work through the public facades.

Core values remain data-only. The service boundary validates mutable inputs
through its internal implementation. Flow actions already delegate to internal
engines, and the allocation service already delegates to its rules and sweep.
No new interface or alternative public API was introduced by this separation.

`npm run test:contracts`, included in `npm run check`, compares all 121 signatures
against `tests/contracts/core-services.json` and all global declarations against
`tests/contracts/global-api.json`, including nested types, annotations and modifiers. It also verifies that each body is
only its expected forwarding call, that core implementations are not global,
and that they do not call back through the core facades. Intentional API changes
require an explicit baseline review and subscriber consumer validation. This
structural check complements behaviour tests; it does not prove upgrade safety.

## Compatibility checks for existing consumers

The global guard includes property accessor visibility, enum members and implicit
methods on global interfaces. Accessor implementations and method bodies can
change without rewriting the contract baseline.

`tests/contracts/component-api.json` records all component metadata (including
Flow property names, types, roles, defaults and configuration targets), LWC `@api`
fields/accessors/method signatures and defaults, and `@AuraEnabled` Apex transport
members. JavaScript is parsed using the existing LWC test toolchain's Babel parser.
Transport method overloading is rejected: native service overloads are supported,
but Salesforce does not support reliable overload selection for `@AuraEnabled`
endpoints. Runtime event payloads and behavioural defaults still require tests.

Value and endpoint adapters use explicit typed field assignments. The mapping
regression check fails when a shared field is added or renamed without being
mapped. Source projection deliberately excludes formatting reference fields;
these retain their existing separate meaning in formatting operations. JSON
remains appropriate for external Text definitions and independent copies of the
same result type, not conversion between unrelated request types.

See Salesforce's [LWC packaging restrictions](https://developer.salesforce.com/docs/platform/lwc/guide/use-packaging-add.html)
and [Apex endpoint overload guidance](https://developer.salesforce.com/docs/platform/lwc/guide/apex-wire-method.html).

## Confirmed allocation footgun and correction

The installed 0.1.0.15 beta reproduced this case in lax, whole-minute mode:

- Worked interval: 08:00–08:01; winning block: 08:00–09:00.
- With only that block, credited time was 60,000 milliseconds.
- Adding a lower-priority 08:00:30–09:00 block reduced credit to zero because
  each 30-second segment was rounded down. The losing block received zero.

Lax mode now keeps millisecond precision across diagnostic boundaries and applies
optional coarser rounding to a continuous interval with the same winning block.
Adding a losing block cannot change that winner's credit. A change of winner or
an unallocated gap still ends the interval. Totals and diagnostic rows reconcile;
any discarded remainder belongs to the end of the winning interval.

**Milliseconds remain the default.** Seconds/minutes require an explicit option.
The correction changes optional coarse lax rounding; it does not change the
default precision or the other overlap modes. See [the full rules](time-allocation.md).

## Constraints for future changes

- Keep calendar days/months separate from elapsed milliseconds. Converting a
  calendar duration to elapsed time requires a reference value.
- Preserve the distinction between local values, exact instants, display zones
  and schedule zones. Never infer a missing zone from the running user's context.
- Reject contradictory ISO/native sources and unsupported options explicitly.
  New behaviour must use an explicit option or new entry point, without silently
  reinterpreting existing inputs.
- Preserve half-open range boundaries, collection order, independent returned
  data and per-item error handling. Cached result objects must not escape.
- Keep documented ISO and block-definition Text formats distinct from internal
  JSON transport. Subscriber-side generic JSON deserialisation into managed
  request classes is not the supported construction API.
- A passing development test is not a subscriber or released-upgrade check.
  Record those separately in [validation](validation.md).

This review does not add schedule overrides, recurrence exceptions or combined
shift allocation. It does not claim that all future feature interactions are
provably safe; it establishes boundaries and checks that future changes must obey.
