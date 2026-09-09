# Chrono values across Flow and LWC

## Current contract

Chrono date/time values cross Flow and LWC boundaries as **ISO text**. Apex
calculations use the core classes, constructed through validating parsers.

The picker has one `initialChronoValue` Text input, which accepts a complete date,
local datetime, instant or bracketed-zone datetime. The Flow editor also supports
native Date and DateTime resources through the existing native properties. Its
five `chrono*Value` outputs are Text. See the [picker migration guide](date-time-picker.md#initial-values-and-iso-chrono-outputs).

The experimental annotated core fields and empty constructors have been removed.
Core values keep private final native state. The picker endpoint parses ISO input;
it no longer uses JSON deserialisation to reconstruct caller-supplied core objects.
Operating-hours configuration uses native OperatingHours, TimeSlot and Holiday
records. The redundant Apex-defined schedule DTOs have also been removed.

Strings themselves remain editable in Flow. Protection comes from parsing and
validation before Chrono uses them, not a claim that Flow Text is immutable. No
admin needs to assemble ISO text for ordinary picker or action usage: labelled
controls create the values, and the output can feed the next action directly.

## Why the direct core-object design was retired

The following behaviours were reproduced in the existing development org. They
are evidence about the earlier design, not supported features of the current API.

| Check                                                | Observed behaviour                                                                                                                                               |
| ---------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Whole core values between Apex actions               | All eight types survived, including an earlier subscriber-owned action check against installed Chrono 0.1.0.6                                                    |
| Flow Assignment into annotated `final` fields        | Flow wrote them, bypassing normal Apex assignment restrictions and validating constructors                                                                       |
| Explicit collections of all eight core types         | Two distinct entries reached the Apex consumer in order; changing the source did not overwrite the earlier entry in this tested Add path                         |
| Mixed-sign duration assignment                       | Flow accepted `months=1`, `days=-2`, `milliseconds=3000`; `toString()` misleadingly produced `-P1M2DT3.000S`; the ordinary constructor rejected those components |
| Invalid clock / unknown zone assignments             | Assignment succeeded; the exercised core method subsequently threw an exception                                                                                  |
| Non-canonical partial-date backing values            | Assignment succeeded and serialisation hid the invalid anchor components                                                                                         |
| Getter-only property assignment                      | Earlier check retained a constructor default rather than assigning the supplied value                                                                            |
| Typed Aura input with final fields                   | Adding a no-argument constructor did not make Aura populate final fields                                                                                         |
| Native Time across a Flow screen                     | Flow sent milliseconds since midnight but did not reconstruct Time on return; the receiving method saw null                                                      |
| Core screen transport after special transport fields | Ran successfully, including Next, Previous and edited values, but did not solve the protection problem                                                           |

These results explain why a successful compile, unit test or Apex JSON test was
insufficient. Apex, Aura, Flow actions and Flow screen serialisation are distinct
boundaries. Core methods also do not become callable Flow formula functions.

The old `tests/feasibility/flow-variables` field-assignment fixtures are retained
as investigation evidence. Their Flow versions have been retired from the dev org
and their helper was removed. They must not be redeployed against the private-field design. `strings.apex` remains
a runnable assertion script using the scalar `ChronoConvertHarness` Flow.

## Current validation fixtures

`tests/feasibility/flow-core` now creates ISO strings and parses them with the
actual core methods in the receiving Apex action. Its retained API names avoid
breaking existing fixture references; its labels describe ISO values.

`tests/feasibility/flow-screen/ChronoCoreScreenProbe.flow` is labelled
**Chrono Example — ISO Values**. Its variables are Text. The runtime test at
`tests/feasibility/flow-screen/run.cjs` checks populated initial values, repeated-time
selection, Next, Previous, edited values and a manual offset override. It verifies
that plain outputs retain the overridden wall clock while zoned output parses
under the named zone's actual rules. It also checks the action bindings in Builder. All four stages passed after migration.
The example uses automatic output storage to retain return-navigation state.

The test uses an existing Playwright installation in an isolated headless browser.
It closes the browser in `finally` and uses no personal browser, screen capture,
screenshots or recording. It does not establish pixel-level rendering quality.

```sh
CHRONO_PLAYWRIGHT_MODULE=/absolute/path/to/playwright-core \
  node tests/feasibility/flow-screen/run.cjs
sf apex run --target-org chrono-dev \
  --file tests/feasibility/flow-variables/strings.apex
```

## Fractional seconds

Apex parsing, native Temporal inputs and the picker fallback truncate fractions to
three digits without rounding. Supplied time slots follow the same policy.

| Input                                                    | Returned canonical value                             |
| -------------------------------------------------------- | ---------------------------------------------------- |
| `1995-12-07T03:24:30.0000035-08:00[America/Los_Angeles]` | `1995-12-07T03:24:30.000-08:00[America/Los_Angeles]` |
| `2021-01-13T20:57:01.500944804Z`                         | `2021-01-13T20:57:01.500Z`                           |
| `P1Y2M3W4DT5H6M7.987654321S`                             | `P14M25DT18367.987S`                                 |

Duration output uses the existing months/days/seconds normalisation. Negative
duration magnitudes truncate towards zero; timestamp fractions truncate within
their second, including before the Unix epoch. No rounding-induced midnight
rollover occurs. Malformed values are still rejected.

## Managed-package boundary

The migrated contract has not yet been built into a new package and installed in
the subscriber org. Earlier installed-package evidence does not validate this new
component metadata. Installation and subscriber execution remain required before
release. This migration creates no scratch org and uses no package build allocation.

Official references: [Flow Apex-defined considerations](https://help.salesforce.com/s/articleView?id=sf.flow_considerations_apex_data_type.htm&language=en_US&type=5),
[LWC Apex boundary](https://developer.salesforce.com/docs/platform/lwc/guide/apex-expose-method.html),
and [Flow screen property types](https://developer.salesforce.com/docs/platform/lwc/guide/targets-lightning-flow-screen.html).
