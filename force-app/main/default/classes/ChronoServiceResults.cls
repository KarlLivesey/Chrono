// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Maps neutral calculation outputs to typed, data-only subscriber Apex results. */
public with sharing class ChronoServiceResults {
  public static ChronoValueResult value(ChronoOperationResult source) {
    ChronoValueResult result = new ChronoValueResult();
    result.success = source.success;
    result.errorMessage = source.errorMessage;
    result.isOpen = source.isOpen;
    if (source.success && source.valueType != null) {
      result.value = typedValue(source);
    }
    return result;
  }
  private static ChronoValue typedValue(ChronoOperationResult source) {
    ChronoValue result = new ChronoValue();
    result.valueType = source.valueType;
    switch on source.valueType {
      when 'Instant' {
        result.instant = ChronoInstantService.parseIso(source.value);
      }
      when 'ZonedDateTime' {
        result.zonedDateTime = ChronoZonedDateTimeService.parseIso(
          source.value
        );
      }
      when 'PlainDateTime' {
        result.plainDateTime = ChronoPlainDateTimeService.parseIso(
          source.value
        );
      }
      when 'PlainDate' {
        result.plainDate = ChronoPlainDateService.parseIso(source.value);
      }
      when 'PlainTime' {
        result.plainTime = ChronoPlainTimeService.parseIso(source.value);
      }
      when 'PlainYearMonth' {
        result.yearMonth = ChronoPlainYearMonthService.parseIso(source.value);
      }
      when 'PlainMonthDay' {
        result.monthDay = ChronoPlainMonthDayService.parseIso(source.value);
      }
      when 'Duration' {
        result.duration = ChronoDurationService.parseIso(source.value);
      }
      when else {
        throw new ChronoException(
          'Unknown value result type: ' + source.valueType
        );
      }
    }
    return result;
  }
  public static ChronoDurationCalculationResult duration(
    ChronoOperationResult source
  ) {
    ChronoDurationCalculationResult result = new ChronoDurationCalculationResult();
    result.success = source.success;
    result.errorMessage = source.errorMessage;
    if (source.success) {
      result.value = ChronoDurationService.create(
        source.months,
        source.days,
        source.milliseconds
      );
    }
    return result;
  }
  public static ChronoComparisonResult comparison(
    ChronoOperationResult source
  ) {
    ChronoComparisonResult result = new ChronoComparisonResult();
    result.success = source.success;
    result.errorMessage = source.errorMessage;
    result.comparison = source.comparison;
    result.withinTolerance = source.withinTolerance;
    result.samePeriod = source.samePeriod;
    return result;
  }
  public static ChronoWorkingTimeCheckResult check(
    ChronoOperationResult source
  ) {
    ChronoWorkingTimeCheckResult result = new ChronoWorkingTimeCheckResult();
    result.success = source.success;
    result.errorMessage = source.errorMessage;
    result.isOpen = source.isOpen;
    return result;
  }
  public static ChronoLocalResolutionResult resolution(
    ChronoOperationResult source
  ) {
    ChronoLocalResolutionResult result = new ChronoLocalResolutionResult();
    result.success = source.success;
    result.errorMessage = source.errorMessage;
    result.resolutionStatus = source.resolutionStatus;
    result.value = zoned(source.value);
    result.earlierValue = zoned(source.earlierValue);
    result.laterValue = zoned(source.laterValue);
    result.previousValue = zoned(source.previousValue);
    result.nextValue = zoned(source.nextValue);
    return result;
  }
  private static ChronoZonedDateTime zoned(String value) {
    return value == null ? null : ChronoZonedDateTimeService.parseIso(value);
  }
}
