// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Explicit endpoint adapters shared by availability and allocation. */
public with sharing class ChronoRangeInputs {
  /**
   * @description Copies the declared ChronoAvailabilityInput fields without serialisation.
   * @param input Non-null action input; source values are not modified.
   * @return A new internal request containing the shared fields. Validation occurs in the operation.
   */
  public static ChronoRangeToolsInput range(ChronoAvailabilityInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoRangeToolsInput result = new ChronoRangeToolsInput();
    result.operation = input.operation;
    result.valueType = input.valueType;
    result.value = input.value;
    result.dateValue = input.dateValue;
    result.instantValue = input.instantValue;
    result.timeValue = input.timeValue;
    result.timeZoneId = input.timeZoneId;
    result.disambiguation = input.disambiguation;
    result.endValue = input.endValue;
    result.endDate = input.endDate;
    result.endInstant = input.endInstant;
    result.endTime = input.endTime;
    result.duration = input.duration;
    result.maximumResults = input.maximumResults;
    return result;
  }
  /**
   * @description Copies the declared ChronoTimeAllocationInput fields without serialisation.
   * @param input Non-null action input; source values are not modified.
   * @return A new internal request containing the shared fields. Validation occurs in the operation.
   */
  public static ChronoRangeToolsInput range(ChronoTimeAllocationInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoRangeToolsInput result = new ChronoRangeToolsInput();
    result.valueType = input.valueType;
    result.value = input.value;
    result.dateValue = input.dateValue;
    result.instantValue = input.instantValue;
    result.timeValue = input.timeValue;
    result.timeZoneId = input.timeZoneId;
    result.disambiguation = input.disambiguation;
    result.endValue = input.endValue;
    result.endDate = input.endDate;
    result.endInstant = input.endInstant;
    result.endTime = input.endTime;
    return result;
  }
}
