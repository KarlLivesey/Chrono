# Hardening and benchmark review

This follows the data-only service migration and the installation of beta
0.1.0.10. The review covers correctness, boundaries, transport, batching and
component state, as well as interfaces and function responsibilities.

## Corrections

- Oversized duration years, weeks and elapsed units previously wrapped into
  unrelated signed values. Decimal intermediates now reach shared bounds checks
  **before** conversion to Integer or Long. Duration creation, scaling, negation,
  adjustment and Unix timestamps share those checks.
- Minimum signed Integer/Long duration components now serialise without a double
  minus sign and round-trip correctly. Negation rejects an unrepresentable positive
  counterpart. Sub-millisecond digits still truncate towards zero.
- Calendar arithmetic checks the four-digit ISO range before native arithmetic.
  Native Apex accepts some out-of-range years and can wrap extreme additions;
  those results cannot round-trip through Chrono's ISO contract. Values outside
  years 0001–9999 now fail explicitly. Salesforce record fields have their own,
  narrower persistence limits; this is an ISO arithmetic contract, not a promise
  that every value can be saved to a record.
- Recurrence ordinal validation compares signed bounds directly, avoiding the
  minimum-integer absolute-value overflow. Working-time magnitudes are checked
  before traversal, and readable duration formatting uses safe magnitudes.
- Client exact-datetime parsing validates calendar fields before `Date.parse`,
  rejecting normalisation of impossible dates such as 30 February. It truncates
  excess precision and verifies the resulting UTC year.
- Appointment required-field errors no longer hide the available choices. Load
  failures and reported validation messages have separate state, so the user can
  correct a missing selection immediately.

The overflow behaviour was reproduced through the installed subscriber API.
Salesforce also documents that Apex arithmetic can wrap without an exception:
[Apex Developer Guide](https://resources.docs.salesforce.com/latest/latest/en-us/sfdc/pdf/salesforce_apex_developer_guide.pdf).
Record-field date restrictions are documented separately in
[Salesforce's date-range guidance](https://help.salesforce.com/s/articleView?id=000383587&language=en_US&type=1).

## Structure and interfaces

The eight public core values and public request/result contracts remain data-only.
Internal common value fields now also contain only data. `ChronoValueInputs`
owns their transport conversion; `ChronoOperationInputs` retains explicit typed
mappings for the older action contracts. Shared choice validation belongs to
`ChronoSupport`, and successful/failed result construction to `ChronoFlowResults`.
An unused duplicate of the picker value projection module was removed.

The internal `ChronoActionOperation` interface remains the substitution boundary
for catalogue operations. Additional interfaces around simple static validators
or serialisers would add indirection without a second implementation, so none
were introduced. No interface types cross the managed-package Flow/LWC boundary.

`ChronoFlowValue` and `ChronoOperationValue` remain internal conversion adapters:
they implement type dispatch and plain-versus-exact operation context. They are
not public value records or Flow resources. Their conversion behaviour is their
responsibility; replacing it with another layer of forwarding wrappers would not
simplify the implementation.

The two batch implementations retain different copy strategies deliberately:
scalar results use explicit field copies; heterogeneous results with collections
use concrete JSON graph copies. Both preserve interview/item order and isolate
cached results. Schedule queries are preloaded once, with per-item error handling.
The review retains these boundaries rather than merging them into an untyped
copy framework.

The date/time controller remains separate from its UI, Flow adapter and editor.
Its explicit LWC public setters coordinate hydration and revision checks; its
size alone is not a reason to replace those with dynamic property machinery.
The new controls have focused responsibilities and tests for stale asynchronous
responses, changed inputs, record permissions and failed loads. Browser rendering
and live pointer/keyboard behaviour remain unverified under the no-capture rule.

## Benchmarks

See [benchmark commands and interpretation](../tests/benchmarks/README.md) and
versioned JSON results in `tests/benchmarks/results`.

The baseline includes all eight parse/serialise services, native schedule
arithmetic over a weekend/holiday, bulk repeated/distinct conversions, calendar
difference, recurrence, explicit collection availability and real Flow interviews.
Client measurements cover normal/repeated/missing wall times, projection,
explicit offsets and multiple zones. Every case validates its output.

Benchmark timings are observations for the recorded workloads and environment.
They are separate from correctness tests and managed-package integration checks;
they do not establish a universal performance guarantee.

## Shared fixtures and keyboard follow-up

The shared fixtures in `tests/conformance/cases.json` compare native Temporal with
managed Apex using one set of explicit expected values. They exposed three client
acceptance differences (leap-second notation, year zero and projection into year 10000) and two Apex lower-bound cases (projection or resolution before year 1).
The client validates input fields and both output dates. Apex validates epoch
bounds before extracting calendar fields: native year extraction can lose the
calendar era and disguise a preceding-year value as year 1. Local projections use
the same checked arithmetic as instant shifts. The public API is unchanged.

Duration parsing now reuses its compiled pattern, and numeric validation uses
constant bounds. The strict overflow and truncation rules are preserved. The
lookup explicitly handles Enter on a focused option; tests cover arrow wrapping,
single selection dispatch, Escape, empty choices and internal/external focus.
Tab retains native navigation. Jest simulates the subsequent focus movement;
this does not claim live-browser keyboard verification.

The two new heavy benchmarks use distinct availability and recurrence requests
across four schedule zones with dense holidays. Independent expected windows and
ordered recurrence dates are asserted outside the timed operation. Each heavy
sample gets a fresh transaction; reports include total transaction CPU as well
as operation CPU. See `tests/benchmarks/README.md` for the measurement limits.
