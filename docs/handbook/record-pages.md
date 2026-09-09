# Add Chrono to a record page

Use **Chrono: Record date and time** in Lightning App Builder when users should
edit a native Date or DateTime field with timezone and operating-hours validation.
The record adapter adds persistence around the reusable control.

## Configure the field mapping

| Property                             | Set it to                                                    |
| ------------------------------------ | ------------------------------------------------------------ |
| Date or DateTime field API name      | The field to edit, for example `Appointment__c`              |
| Timezone text field API name         | Optional field storing a named timezone ID                   |
| OperatingHours lookup field API name | Optional lookup containing the schedule ID                   |
| Default timezone ID                  | Fallback when the mapped timezone field has no value         |
| Fixed OperatingHours ID              | Fallback when the mapped schedule field has no value         |
| Allow timezone changes               | Whether users can change the display/input zone              |
| Date display length                  | `short`, `medium` or `long`, interpreted through user locale |

Use field API names, not labels or relationship paths. The mapped value field
must actually be Date or DateTime. The optional timezone field must store text
(String/Picklist) and the schedule field must be a lookup. Configure an actual
OperatingHours relationship, not an unrelated lookup with a similar label.

The adapter reads the record's timezone/schedule field first, then uses the fixed
fallback. If there is no configured zone value it uses the running user's zone.

## Saving

The component reads and updates through Lightning Data Service. Users need the
appropriate record and field permissions. The adapter checks the loaded
LastModifiedDate when saving, so a concurrent edit is surfaced instead of quietly
overwriting it.

A date/time selection remains a draft until Save. A Flow screen component, or
the UI-only picker composed elsewhere, does not inherit this persistence.

For a Date field the adapter uses date mode. A calendar date is not silently
converted to an exact midnight timestamp just because this component can also
edit DateTime fields.

## Verify your page

Try an ordinary value, a repeated local time and a closed schedule time. Verify
that your selected timezone field is writable if it should be saved. Confirm the
intended fallback when mapped fields are empty, and test with the actual user's
permissions rather than only a system administrator.

See [record component properties](../reference/components/chronoRecordDateTime.md)
and [permissions](security.md).
