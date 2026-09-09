// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Converts typed service values to the unchanged Flow native/ISO result contract. */
public with sharing class ChronoFlowServiceResults {
  public static ChronoFlowResult value(ChronoValueResult source) {
    ChronoFlowResult result = source.value == null
      ? outcome(source.success, source.errorMessage)
      : ChronoFlowResults.fromOperation(operationValue(source.value));
    result.isOpen = source.isOpen;
    return result;
  }
  private static ChronoOperationResult operationValue(ChronoValue source) {
    Object value;
    switch on source.valueType {
      when 'Instant' {
        value = source.instant;
      }
      when 'ZonedDateTime' {
        value = source.zonedDateTime;
      }
      when 'PlainDateTime' {
        value = source.plainDateTime;
      }
      when 'PlainDate' {
        value = source.plainDate;
      }
      when 'PlainTime' {
        value = source.plainTime;
      }
      when 'PlainYearMonth' {
        value = source.yearMonth;
      }
      when 'PlainMonthDay' {
        value = source.monthDay;
      }
      when 'Duration' {
        value = source.duration;
      }
      when else {
        throw new ChronoException(
          'Unknown service value type: ' + source.valueType
        );
      }
    }
    return new ChronoFlowValue(source.valueType, value).result();
  }
  public static ChronoFlowResult duration(
    ChronoDurationCalculationResult source
  ) {
    return source.success
      ? ChronoFlowResults.fromOperation(
          new ChronoFlowValue('Duration', source.value).result()
        )
      : outcome(false, source.errorMessage);
  }
  public static ChronoFlowResult comparison(ChronoComparisonResult source) {
    ChronoFlowResult result = outcome(source.success, source.errorMessage);
    result.comparison = source.comparison;
    result.withinTolerance = source.withinTolerance;
    result.samePeriod = source.samePeriod;
    return result;
  }
  public static ChronoFlowResult check(ChronoWorkingTimeCheckResult source) {
    ChronoFlowResult result = outcome(source.success, source.errorMessage);
    result.isOpen = source.isOpen;
    return result;
  }
  public static ChronoFlowResult resolution(
    ChronoLocalResolutionResult source
  ) {
    ChronoFlowResult result = source.value == null
      ? outcome(source.success, source.errorMessage)
      : ChronoFlowResults.fromOperation(
          new ChronoFlowValue('ZonedDateTime', source.value).result()
        );
    result.resolutionStatus = source.resolutionStatus;
    result.earlierValue = source.earlierValue == null
      ? null
      : ChronoZonedDateTimeService.toIsoString(source.earlierValue);
    result.laterValue = source.laterValue == null
      ? null
      : ChronoZonedDateTimeService.toIsoString(source.laterValue);
    result.previousValue = source.previousValue == null
      ? null
      : ChronoZonedDateTimeService.toIsoString(source.previousValue);
    result.nextValue = source.nextValue == null
      ? null
      : ChronoZonedDateTimeService.toIsoString(source.nextValue);
    return result;
  }
  private static ChronoFlowResult outcome(
    Boolean success,
    String errorMessage
  ) {
    ChronoFlowResult result = new ChronoFlowResult();
    result.success = success;
    result.errorMessage = errorMessage;
    return result;
  }
}
