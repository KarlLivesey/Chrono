// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Constructs and copies Flow results independently of their data representation. */
public with sharing class ChronoFlowResults {
  /** @description Copies scalar fields so cached results never escape by reference.
   * @return An independent result.
   */
  public static ChronoFlowResult copy(ChronoFlowResult source) {
    ChronoFlowResult result = new ChronoFlowResult();
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
  public static ChronoFlowResult failure(String message) {
    ChronoFlowResult result = new ChronoFlowResult();
    result.success = false;
    result.errorMessage = message;
    return result;
  }
  public static ChronoFlowResult success() {
    ChronoFlowResult result = new ChronoFlowResult();
    result.success = true;
    return result;
  }
  public static ChronoFlowResult fromOperation(ChronoOperationResult source) {
    ChronoFlowResult result = new ChronoFlowResult();
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
    result.resolutionStatus = source.resolutionStatus;
    result.earlierValue = source.earlierValue;
    result.laterValue = source.laterValue;
    result.previousValue = source.previousValue;
    result.nextValue = source.nextValue;
    result.withinTolerance = source.withinTolerance;
    result.samePeriod = source.samePeriod;
    return result;
  }
}
