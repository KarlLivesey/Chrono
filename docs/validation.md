# Chrono validation

Validation performed on 6 September 2026 against Salesforce API 67.0.

## Development checks

- Namespaced development org: `chrono-dev` (`skel`). Reused for every deployment.
- 31 Apex test methods passed; 877 of 905 executable lines covered (96.9%).
- Formatting passed; PMD recommended/AppExchange checks passed the configured
  severity 1–3 gate. Low-priority ApexDoc and test `runAs` suggestions remain visible.
- Test scenarios include native/ISO round trips, all eight types, instance/static
  equivalence, calendar versus elapsed arithmetic, invalid inputs, four-zone DST
  gaps/overlaps including Lord Howe, recurring/partial holidays, working-time
  subtraction and short opening windows inside DST transitions.
- The Friday 16:30 plus one working hour example produces Tuesday 09:30 with
  Monday configured as a bank holiday.

## Package and subscriber checks

The current test package is **0.1.0.2**, subscriber version
`04tgK000000JnGLQA0`, request `08cgK000000H0lBQAS`. It was created with
`--skip-validation`: no package validation or package coverage was calculated,
and it cannot be promoted. It installed successfully into `chrono-subscriber`.
A deployment using `RunAllTestsInOrg` then passed **35 test methods** with no
failures: **31 packaged tests in `skel` and four consumer tests outside the
namespace**. This includes the corrected invalid-date and holiday recurrence
behaviour. Installation request: `0HfAs000002aycPKAQ`.

The earlier **0.1.0.1** (`04tgK000000JnEjQAK`) passed a standard build and installed
successfully. Three selected subscriber test methods passed against it, proving
global constructors, return types, exception handling, both call styles and the
standard-object arguments. That version predates fixes for invalid calendar dates
and the any-day holiday recurrence mask; use the corrected test version instead.

Salesforce refused an in-place beta upgrade. The temporary consumer test class
was removed from the subscriber org, then the earlier beta was uninstalled. The
local test files were retained and restored after the corrected beta installation.
This is a fresh-install check, not evidence of released-package upgrade compatibility.

Consumer tests live in `tests/subscriber`, outside the packaged `force-app` tree.
The separate `chrono-subscriber` scratch org has no namespace. The complete test
class includes the invalid-calendar-date regression introduced after the first beta.
No release has been promoted.

## Allocation policy and usage

Two scratch orgs were created: `chrono-dev` and `chrono-subscriber`, both expiring
13 September 2026. Reuse them; further org creation requires checking with Karl.

- Standard builds: **1 used**, **5 of 6 remaining**. No further use of
  `Package2VersionCreates` is allowed without explicit approval.
- Quick builds: **1 used**, **499 of 500 remaining** in
  `Package2VersionCreatesWithoutValidation`. Karl permits `--skip-validation`
  for test packages. The before/after limits confirm it did not consume a
  standard-build allocation.
- Async validation is not a workaround for the standard-build approval rule.

## Reproducing checks

```sh
npm run check
sf project deploy start --source-dir force-app --target-org chrono-dev --test-level RunLocalTests --wait 10
# After installing the corrected quick beta into chrono-subscriber:
cd tests/subscriber
sf project deploy start --source-dir force-app --target-org chrono-subscriber --test-level RunAllTestsInOrg --wait 10
```

Tests use scratch-org administrator access; restricted-profile behaviour has not
been independently verified. Apex tests in a namespaced scratch org do not prove
managed packaging. A successful
beta install and these subscriber tests validate the tested Apex surface only;
they do not establish Flow/LWC support, another managed-package dependency, every
Salesforce licence/edition, or upgrade compatibility with a released version.

## Platform evidence

- [Operating-hours object relationships](https://developer.salesforce.com/docs/platform/data-models/guide/field-service-operating-hours.html).
- [Field Service object reference](https://resources.docs.salesforce.com/latest/latest/en-us/sfdc/pdf/field_service_dev.pdf): OperatingHoursHoliday and feature access rules.
- [Holiday recurrence configuration](https://resources.docs.salesforce.com/latest/latest/en-us/sfdc/pdf/api_meta.pdf).
- [Scheduler holiday considerations](https://help.salesforce.com/s/articleView?id=sf.ls_considerations_holidays.htm&language=en_US&type=5).

## Lint exceptions

Global value classes and the catchable exception have a scoped AvoidGlobalModifier
suppression because subscriber Apex requires global visibility. A declaration-line
NOPMD comment suppresses aggregate complexity findings driven by the required
instance/static overloads; method-level complexity checks remain enabled. Four-
argument native schedule overloads retain explicit source, zone, amount and schedule
parameters with a scoped ExcessiveParameterList suppression. The resolver test's
assertion helper has equivalent documented exceptions. No project-wide rule is
disabled.

## Quick-build validation limits

The authorised quick build has now been installed and its packaged and consumer
Apex tests have passed. This verifies the tested installation and runtime
behaviour; it does not turn the quick build into a validated/promotable package.
Any standard build still requires explicit approval.
