// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Constructs and copies calculation results independently of their data representation. */
public with sharing class ChronoOperationResults {
  /** @description Copies scalar fields so cached results never escape by reference.
   * @return An independent result.
   */
  public static ChronoOperationResult copy(ChronoOperationResult source) {
    ChronoOperationResult result = new ChronoOperationResult();
    result.success = source.success;
    result.errorMessage = source.errorMessage;
    result.valueType = source.valueType;
    result.value = source.value;
    result.instantValue = source.instantValue;
    result.dateValue = source.dateValue;
    result.timeValue = source.timeValue;
    result.timeZoneId = source.timeZoneId;
    result.months = source.months;
    result.days = source.days;
    result.milliseconds = source.milliseconds;
    result.isOpen = source.isOpen;
    result.comparison = source.comparison;
    result.withinTolerance = source.withinTolerance;
    result.samePeriod = source.samePeriod;
    result.resolutionStatus = source.resolutionStatus;
    result.earlierValue = source.earlierValue;
    result.laterValue = source.laterValue;
    result.previousValue = source.previousValue;
    result.nextValue = source.nextValue;
    return result;
  }
  /** @description Creates an explicit per-item failure.
   * @param message Diagnostic message.
   * @return Failed result.
   */
  public static ChronoOperationResult failure(String message) {
    ChronoOperationResult result = new ChronoOperationResult();
    result.success = false;
    result.errorMessage = message;
    return result;
  }
  public static ChronoOperationResult success() {
    ChronoOperationResult result = new ChronoOperationResult();
    result.success = true;
    return result;
  }
}
