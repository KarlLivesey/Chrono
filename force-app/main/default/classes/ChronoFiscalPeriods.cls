// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Fiscal boundaries from subscriber Period records or an explicit month-based configuration. */
public with sharing class ChronoFiscalPeriods implements ChronoActionOperation {
  @TestVisible
  private List<Period> rows = new List<Period>();
  private String loadError;
  private Map<String, String> sourceErrors = new Map<String, String>();
  public ChronoFiscalPeriods(List<Object> requests) {
    List<Date> days = new List<Date>();
    for (Object request : requests) {
      if (request == null) {
        continue;
      }
      ChronoFiscalPeriodInput input = (ChronoFiscalPeriodInput) request;
      if (input.calendarSource != 'organisation') {
        continue;
      }
      try {
        days.add(
          new ChronoOperationValue(ChronoValueInputs.source(input))
            .wallClock()
            .dateGmt()
        );
      } catch (Exception ex) {
        sourceErrors.put(JSON.serialize(request), ex.getMessage());
      }
    }
    if (days.isEmpty()) {
      return;
    }
    days.sort();
    Date first = days[0];
    Date last = days[days.size() - 1];
    try {
      rows = [
        SELECT
          Id,
          Type,
          StartDate,
          EndDate,
          Number,
          FullyQualifiedLabel,
          FiscalYearSettings.Name
        FROM Period
        WHERE StartDate <= :last AND EndDate >= :first
        WITH USER_MODE
        LIMIT 10001
      ];
    } catch (Exception ex) {
      loadError = ex.getMessage();
    }
  }
  public ChronoFiscalResult execute(ChronoFiscalPeriodInput input) {
    ChronoSupport.requireValue(input, 'Input');
    if (sourceErrors.containsKey(JSON.serialize(input))) {
      throw new ChronoException(sourceErrors.get(JSON.serialize(input)));
    }
    ChronoOperationValue source = new ChronoOperationValue(
      ChronoValueInputs.source(input)
    );
    ChronoSupport.choice(
      input.period,
      new Set<String>{ 'year', 'quarter', 'month' },
      'fiscal period'
    );
    Date day = source.wallClock().dateGmt();
    ChronoFiscalResult result;
    switch on input.calendarSource {
      when 'organisation' {
        if (loadError != null) {
          throw new ChronoException(loadError);
        }
        if (rows.size() > 10000) {
          throw new ChronoException(
            'Too many fiscal periods span these requests. Use a narrower set of dates.'
          );
        }
        result = configured(day, input.period);
      }
      when 'monthBased' {
        result = monthBased(day, input.period, input.startMonth);
      }
      when else {
        throw new ChronoException(
          'Choose organisation or month-based fiscal configuration.'
        );
      }
    }
    return output(result, source);
  }
  private static ChronoFiscalResult output(
    ChronoFiscalResult result,
    ChronoOperationValue source
  ) {
    result.endExclusiveDate = ChronoDates.addDays(result.lastDate, 1);
    result.success = true;
    if (source.source.valueType == 'PlainDate') {
      result.startValue = ChronoIso.dateText(result.startDate);
      result.endExclusiveValue = ChronoIso.dateText(result.endExclusiveDate);
    } else if (source.isExact()) {
      result.startInstant = ChronoFlowPeriod.startOfDay(
        result.startDate,
        source.zoneId
      );
      result.endExclusiveInstant = ChronoFlowPeriod.startOfDay(
        result.endExclusiveDate,
        source.zoneId
      );
      result.startValue = source.fromInstant(result.startInstant).value;
      result.endExclusiveValue = source.fromInstant(result.endExclusiveInstant)
        .value;
    } else {
      result.startValue = source.fromWall(
          Datetime.newInstanceGmt(
            result.startDate,
            Time.newInstance(0, 0, 0, 0)
          )
        )
        .value;
      result.endExclusiveValue = source.fromWall(
          Datetime.newInstanceGmt(
            result.endExclusiveDate,
            Time.newInstance(0, 0, 0, 0)
          )
        )
        .value;
    }
    return result;
  }
  private ChronoFiscalResult configured(Date day, String period) {
    for (Period row : rows) {
      if (
        row.Type.toLowerCase() == period &&
        row.StartDate <= day &&
        row.EndDate >= day
      ) {
        ChronoFiscalResult result = new ChronoFiscalResult();
        result.periodId = row.Id;
        result.label = row.FullyQualifiedLabel;
        result.yearLabel = row.FiscalYearSettings.Name;
        result.periodNumber = row.Number;
        result.startDate = row.StartDate;
        result.lastDate = row.EndDate;
        return result;
      }
    }
    throw new ChronoException(
      'No configured Salesforce fiscal period covers this date. Define the fiscal year or use an explicit month-based configuration.'
    );
  }
  private static ChronoFiscalResult monthBased(
    Date day,
    String period,
    Integer firstMonth
  ) {
    if (firstMonth == null || firstMonth < 1 || firstMonth > 12) {
      throw new ChronoException('Fiscal start month must be 1–12.');
    }
    Date start = Date.newInstance(
      day.year() - (day.month() < firstMonth ? 1 : 0),
      firstMonth,
      1
    );
    Integer monthIndex =
      (day.year() - start.year()) * 12 +
      day.month() -
      start.month();
    Integer length = period == 'year' ? 12 : (period == 'quarter' ? 3 : 1);
    Integer index = monthIndex / length;
    ChronoFiscalResult result = new ChronoFiscalResult();
    result.periodNumber = index + 1;
    result.startDate = start.addMonths(index * length);
    result.lastDate = result.startDate.addMonths(length).addDays(-1);
    Integer finalYear = start.addYears(1).addDays(-1).year();
    result.yearLabel =
      String.valueOf(start.year()) +
      (finalYear == start.year() ? '' : '/' + String.valueOf(finalYear));
    result.label = result.yearLabel + ' ' + period + ' ' + result.periodNumber;
    return result;
  }
  /** @description Executes a concrete request through the internal operation contract. */
  public Object evaluate(Object input) {
    return this.execute((ChronoFiscalPeriodInput) input);
  }
  /** @description Supplies the concrete result used to isolate batched results. */
  public Type resultType() {
    return ChronoFiscalResult.class;
  }
}
