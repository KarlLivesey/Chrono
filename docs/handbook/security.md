# Permissions and execution context

Install the managed package and assign **Chrono Flow User** for the relevant
package Apex entry points. Then grant access to the business data the operation
actually uses. Installing a package does not give every user access to every
schedule or field.

## Saved operating hours

Schedule loads and selection use user-mode reads. The user needs the required
OperatingHours, TimeSlot, OperatingHoursHoliday and Holiday object/field access.
Malformed, excluded or inaccessible IDs produce errors. A filter is validated
again on selection; typing an ID is not a way to bypass its restrictions.

The configuration resource lookup loads readable schema for record fields and
relationships. Matching an already supplied record resource is distinct from
querying a saved schedule. Unsaved records can be passed directly where supported.

## Supplied records

Supplied schedules and time-allocation requests perform their calculations over
the records provided, without hidden schedule queries or DML. Your caller is
responsible for how it obtained or constructed those records. Chrono cannot
decide that arbitrary supplied data belongs to a record the user may update.

Use the supplied-record mode deliberately; do not treat it as permission to
extract inaccessible records through a different path.

## Record editing

The record-page adapter uses Lightning Data Service. It checks the configured
field types/access and uses the loaded modification date when saving to detect
conflicting edits. It saves only through the record adapter's explicit Save
operation. UI-only components and Flow screen adapters do not save records.

## Package boundaries

Subscriber Apex calls the documented global services with `skel.` qualification.
Internal operations and controllers are not public extension points. A component
inside Chrono calls its own Apex controllers. Another package must not rely on
calling those controllers directly from its LWC.

Cross-namespace LWC composition requires Lightning Web Security; legacy Locker
does not support that composition. Use exposed UI/control components as designed
and keep business persistence in the owning application.

## Diagnose without leaking data

Errors should identify the invalid value or missing context in the user's
workflow. Avoid logging complete request collections, customer-entered data or
record payloads just to report a parse failure. Apex governor-limit failures
remain platform failures; bulk actions cannot promise per-item recovery from an
exhausted transaction limit.

See [troubleshooting](troubleshooting.md) and [the platform's LWC Apex boundary](https://developer.salesforce.com/docs/platform/lwc/guide/apex-expose-method.html).
