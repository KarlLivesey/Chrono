# Configure Flow actions

Every action family has a scalar action and an explicit-collection action.
Search for the **Chrono:** label in Flow Builder. Categories group the 54 actions
into values, calculations, timezones, durations, formatting, working hours,
ranges, recurrence, collections and time allocation.

## Fixed value or resource

The small input-mode button selects **Search Resources** or the relevant literal
control: text, date, datetime or a predefined option. Choose a mode first, then
enter a value or select a compatible resource. The lookup filters scalar versus
collection shape and the required type.

Existing formula resources are selectable. The custom editor does not open
Salesforce's Formula or Transform creation tools; create those resources in
Builder and then select them.

Typing a resource name searches; it does not commit arbitrary text as a resource
reference. Select a result. A saved reference can remain visible when Builder
does not supply its metadata, but unlisted references cannot be added as free text.

## Choose one source representation

For a dated value, select its **Value type**, then the source format. Use a native
Date or DateTime where you already have one. Use ISO Text for local datetimes,
zoned strings, durations and partial values, or to chain another Chrono result.

Do not populate both the ISO field and its equivalent native field. Different
endpoints or reference values can independently use different representations.
A comparison can therefore use a native starting Date and an ISO ending date,
provided the selected operation supports that value type.

## Context and choices

Some controls appear only for relevant operations. The reference page for each
family lists its source types, fields and operation choices. A field not marked
universally required by Salesforce can still be required by the selected
operation; for example, an appointment duration is needed for appointments but
not for listing holidays.

Dynamic resources can change operation, type or context at runtime. Editor
validation cannot prove their future contents. Actions validate every request
and return errors for unsupported combinations.

## Outputs and errors

Read **Success** before consuming value fields. Standard value results provide
canonical ISO `value`, native `instantValue` and/or `dateValue` when applicable,
local clock text and a timezone ID. Specialised actions return their own fields:
range collections, recurrence occurrences, availability windows or allocation rows.

Use the exact [result class reference](../reference/apex/index.md) linked from
the action page. A successful result need not populate every possible field.
For example, a plain date has no instant and an omitted comparison tolerance
does not populate `withinTolerance`.

For individual bad values, use the returned error. For platform exceptions,
configure the Flow fault path. Avoid sending user-entered dates, record data or
full payloads into a general-purpose log just to report a validation problem.

## Collections

Scalar actions already batch across interviews. Use an explicit collection
action when **one** interview has many requests. Collection envelopes and the
separate operations which consume Text collections are explained in
[bulk and collection design](collections.md).

For an action-by-action reference, including both invocation forms, start at
[all action families](../reference/actions/index.md).
