# ChronoCollectionToolsInput

Apex reference · `0.2.0.NEXT` · Development source; not the released installation package · Subscriber name: `skel.ChronoCollectionToolsInput`.

Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow.

## Declaration

```apex
global with sharing class ChronoCollectionToolsInput
```

Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow.

Types: [ChronoCollectionToolsInput](ChronoCollectionToolsInput.md).

## ChronoCollectionToolsInput

| Field / property                  | Flow label                        | Contract                                                             |
| --------------------------------- | --------------------------------- | -------------------------------------------------------------------- |
| `global String operation`         | Operation                         | Operation.                                                           |
| `global String valueType`         | Value type                        | Value type.                                                          |
| `global List<String> values`      | ISO values                        | Ordered ISO text collection, or fixed values with one item per line. |
| `global String valuesText`        | Fixed ISO values                  | One ISO value per line.                                              |
| `global List<Date> dates`         | Native dates                      | Alternative Date collection; do not supply another source.           |
| `global List<Datetime> datetimes` | Native datetimes                  | Alternative Datetime collection; do not supply another source.       |
| `global String timeZoneId`        | Calculation timezone              | Required for exact calendar grouping or zoned native input.          |
| `global Date referenceDate`       | Duration reference date           | Required to order durations containing calendar units.               |
| `global String direction`         | Sort order                        | Sort order.                                                          |
| `global String lowerValue`        | Lower ISO value                   | Included lower filter boundary.                                      |
| `global String upperValue`        | Upper ISO value                   | Excluded upper filter boundary.                                      |
| `global String period`            | Group by                          | Group by.                                                            |
| `global Integer weekStartsOn`     | Week starts on                    | 1 is Monday through 7 Sunday; defaults to Monday.                    |
| `global String pointValue`        | Nearest to ISO value              | Nearest to ISO value.                                                |
| `global Date lowerDate`           | Lower boundary native date        | Use one native or ISO source for this value.                         |
| `global Datetime lowerInstant`    | Lower boundary native datetime    | Use one native or ISO source for this value.                         |
| `global String lowerTime`         | Lower boundary local time         | Use one native or ISO source for this value.                         |
| `global Date upperDate`           | Upper boundary native date        | Use one native or ISO source for this value.                         |
| `global Datetime upperInstant`    | Upper boundary native datetime    | Use one native or ISO source for this value.                         |
| `global String upperTime`         | Upper boundary local time         | Use one native or ISO source for this value.                         |
| `global Date pointDate`           | Nearest reference native date     | Use one native or ISO source for this value.                         |
| `global Datetime pointInstant`    | Nearest reference native datetime | Use one native or ISO source for this value.                         |
| `global String pointTime`         | Nearest reference local time      | Use one native or ISO source for this value.                         |

### ChronoCollectionToolsInput

```apex
global ChronoCollectionToolsInput()
```

Required Flow constructor.

Types: [ChronoCollectionToolsInput](ChronoCollectionToolsInput.md).

Generated from the current development source declarations. Signatures shown without bodies are reference declarations, not a complete runnable Apex class. See [examples](../../handbook/apex.md).
