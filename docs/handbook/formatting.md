# Formatting and localisation

Store a native value or canonical ISO string. Format it for the person reading
it. The display text is not a replacement for the underlying date/time contract.

## Length and locale are separate

An admin can choose short, medium or long date presentation in the picker; the
user's Salesforce locale chooses the order, names and punctuation. A UK user's
short date is day/month/year. A US user's short date follows their own locale.
Choosing short should not hard-code one country's format for everyone.

The FormatValue action supports `short`, `medium`, `long` and `full` styles where
the source type provides the needed components. Its generated Gregorian patterns
cover 279 Salesforce locale IDs. Month/day names still come from Salesforce's
context-user formatting. An unknown locale falls back to ISO and reports
`styleApplied=false` so the caller can detect the fallback.

## Exact values need a display zone

A native DateTime or ISO instant identifies a moment. Supply the display timezone
before asking for local components or a human-readable local datetime. Otherwise
the same stored instant can look like a different date on different users'
screens. A plain date should not be converted through UTC merely to display it.

## Explicit patterns

FormatValue can use an explicit Apex formatting pattern. ParseValue uses an
explicit supported numeric input pattern rather than guessing from the running
user's locale. Formatting and parsing are separate contracts: do not assume
every arbitrary formatted output is accepted by the parser.

Partial values reject patterns needing missing components. A month-day cannot
truthfully display a year without an explicit reference. See the individual
action fields and operations before reusing a full datetime pattern.

## Durations and relative text

ISO duration and compact units are language-neutral. Long duration names and
relative wording are English in this release. Relative days mean elapsed
24-hour days, not “the next local calendar date”. Choose calendar calculations
when that distinction matters.

For data passed between Flows, Apex or integrations, use the ISO output. For a
screen or email, format a separate display string. This keeps a change of locale
from changing the meaning of your next action's input.

See [FormatValue](../reference/actions/FormatValue.md),
[ParseValue](../reference/actions/ParseValue.md) and [ISO formats](iso-formats.md).
