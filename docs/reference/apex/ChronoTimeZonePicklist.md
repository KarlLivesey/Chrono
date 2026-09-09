# ChronoTimeZonePicklist

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoTimeZonePicklist`.

Flow Builder choices from Salesforce's supported user time-zone values. No record data is read.

## Declaration

```apex
global with sharing class ChronoTimeZonePicklist extends VisualEditor.DynamicPickList
```

Flow Builder choices from Salesforce's supported user time-zone values. No record data is read.

Types: [ChronoTimeZonePicklist](ChronoTimeZonePicklist.md).

## ChronoTimeZonePicklist

### ChronoTimeZonePicklist

```apex
global ChronoTimeZonePicklist()
```

Constructor used by the subscriber's configuration editor.

Types: [ChronoTimeZonePicklist](ChronoTimeZonePicklist.md).

### getDefaultValue

```apex
global override VisualEditor.DataRow getDefaultValue()
```

Leaves the zone unselected rather than inferring the designer's zone.

### getValues

```apex
global override VisualEditor.DynamicPickListRows getValues()
```

Returns supported active zones, preserving Salesforce labels.

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
