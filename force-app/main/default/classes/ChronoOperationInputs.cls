// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Typed adapters between Flow transport records and calculation inputs. */
public with sharing class ChronoOperationInputs {
  /** @description Adapts typed Flow data without mutating its fields. */
  public static ChronoOperationInput adapt(ChronoPeriodBoundaryInput source) {
    ChronoOperationInput input = new ChronoOperationInput();
    input.source.valueType = source.valueType;
    input.source.value = source.value;
    input.source.instantValue = source.instantValue;
    input.source.dateValue = source.dateValue;
    input.source.timeValue = source.timeValue;
    input.source.timeZoneId = source.timeZoneId;
    input.source.disambiguation = source.disambiguation;
    input.unit = source.unit;
    input.boundary = source.boundary;
    input.weekStartsOn = source.weekStartsOn;
    if (String.isBlank(input.finish.valueType)) {
      input.finish.valueType = input.source.valueType;
    }
    input.finish.timeZoneId = input.source.timeZoneId;
    input.finish.disambiguation = input.source.disambiguation;
    return input;
  }
  /** @description Adapts typed Flow data without mutating its fields. */
  public static ChronoOperationInput adapt(ChronoCompareInput source) {
    ChronoOperationInput input = new ChronoOperationInput();
    input.source.valueType = source.valueType;
    input.source.value = source.value;
    input.source.instantValue = source.instantValue;
    input.source.dateValue = source.dateValue;
    input.source.timeValue = source.timeValue;
    input.source.timeZoneId = source.timeZoneId;
    input.source.disambiguation = source.disambiguation;
    input.finish.valueType = source.endValueType;
    input.finish.value = source.endValue;
    input.finish.instantValue = source.endInstant;
    input.finish.dateValue = source.endDate;
    input.finish.timeValue = source.endTime;
    input.referenceDate = source.referenceDate;
    input.toleranceMilliseconds = source.toleranceMilliseconds;
    input.comparisonPeriod = source.comparisonPeriod;
    input.weekStartsOn = source.weekStartsOn;
    if (String.isBlank(input.finish.valueType)) {
      input.finish.valueType = input.source.valueType;
    }
    input.finish.timeZoneId = input.source.timeZoneId;
    input.finish.disambiguation = input.source.disambiguation;
    return input;
  }
  /** @description Adapts typed Flow data without mutating its fields. */
  public static ChronoOperationInput adapt(ChronoCompareAction.Request source) {
    ChronoOperationInput input = new ChronoOperationInput();
    input.source.valueType = source.valueType;
    input.source.value = source.value;
    input.source.instantValue = source.instantValue;
    input.source.dateValue = source.dateValue;
    input.source.timeValue = source.timeValue;
    input.source.timeZoneId = source.timeZoneId;
    input.source.disambiguation = source.disambiguation;
    input.finish.valueType = source.endValueType;
    input.finish.value = source.endValue;
    input.finish.instantValue = source.endInstant;
    input.finish.dateValue = source.endDate;
    input.finish.timeValue = source.endTime;
    input.referenceDate = source.referenceDate;
    input.toleranceMilliseconds = source.toleranceMilliseconds;
    input.comparisonPeriod = source.comparisonPeriod;
    input.weekStartsOn = source.weekStartsOn;
    if (String.isBlank(input.finish.valueType)) {
      input.finish.valueType = input.source.valueType;
    }
    input.finish.timeZoneId = input.source.timeZoneId;
    input.finish.disambiguation = input.source.disambiguation;
    return input;
  }
  /** @description Adapts typed Flow data without mutating its fields. */
  public static ChronoOperationInput adapt(
    ChronoCheckWorkingTimeAction.Request source
  ) {
    ChronoOperationInput input = new ChronoOperationInput();
    input.source.valueType = source.valueType;
    input.source.value = source.value;
    input.source.instantValue = source.instantValue;
    input.source.dateValue = source.dateValue;
    input.source.timeValue = source.timeValue;
    input.source.timeZoneId = source.timeZoneId;
    input.source.disambiguation = source.disambiguation;
    input.operatingHoursId = source.operatingHoursId;
    if (String.isBlank(input.finish.valueType)) {
      input.finish.valueType = input.source.valueType;
    }
    input.finish.timeZoneId = input.source.timeZoneId;
    input.finish.disambiguation = input.source.disambiguation;
    input.operatingHours = source.operatingHours;
    input.timeSlots = source.timeSlots;
    input.holidays = source.holidays;
    return input;
  }
  /** @description Adapts typed Flow data without mutating its fields. */
  public static ChronoOperationInput adapt(
    ChronoFindWorkingTimeAction.Request source
  ) {
    ChronoOperationInput input = new ChronoOperationInput();
    input.source.valueType = source.valueType;
    input.source.value = source.value;
    input.source.instantValue = source.instantValue;
    input.source.dateValue = source.dateValue;
    input.source.timeValue = source.timeValue;
    input.source.timeZoneId = source.timeZoneId;
    input.source.disambiguation = source.disambiguation;
    input.operatingHoursId = source.operatingHoursId;
    input.direction = source.direction;
    if (String.isBlank(input.finish.valueType)) {
      input.finish.valueType = input.source.valueType;
    }
    input.finish.timeZoneId = input.source.timeZoneId;
    input.finish.disambiguation = input.source.disambiguation;
    input.operatingHours = source.operatingHours;
    input.timeSlots = source.timeSlots;
    input.holidays = source.holidays;
    return input;
  }
  /** @description Adapts typed Flow data without mutating its fields. */
  public static ChronoOperationInput adapt(
    ChronoResolveLocalAction.Request source
  ) {
    ChronoOperationInput input = new ChronoOperationInput();
    input.source.valueType = source.valueType;
    input.source.value = source.value;
    input.source.instantValue = source.instantValue;
    input.source.dateValue = source.dateValue;
    input.source.timeValue = source.timeValue;
    input.source.timeZoneId = source.timeZoneId;
    input.source.disambiguation = source.disambiguation;
    input.resolution = source.resolution;
    if (String.isBlank(input.finish.valueType)) {
      input.finish.valueType = input.source.valueType;
    }
    input.finish.timeZoneId = input.source.timeZoneId;
    input.finish.disambiguation = input.source.disambiguation;
    return input;
  }
  /** @description Adapts typed Flow data without mutating its fields. */
  public static ChronoOperationInput adapt(
    ChronoCalendarDifferenceInput source
  ) {
    ChronoOperationInput input = new ChronoOperationInput();
    input.source.valueType = source.valueType;
    input.source.value = source.value;
    input.source.instantValue = source.instantValue;
    input.source.dateValue = source.dateValue;
    input.source.timeValue = source.timeValue;
    input.source.timeZoneId = source.timeZoneId;
    input.source.disambiguation = source.disambiguation;
    input.finish.valueType = source.endValueType;
    input.finish.value = source.endValue;
    input.finish.instantValue = source.endInstant;
    input.finish.dateValue = source.endDate;
    input.finish.timeValue = source.endTime;
    input.largestUnit = source.largestUnit;
    if (String.isBlank(input.finish.valueType)) {
      input.finish.valueType = input.source.valueType;
    }
    input.finish.timeZoneId = input.source.timeZoneId;
    input.finish.disambiguation = input.source.disambiguation;
    return input;
  }
  /** @description Adapts typed Flow data without mutating its fields. */
  public static ChronoOperationInput adapt(ChronoResolveLocalInput source) {
    ChronoOperationInput input = new ChronoOperationInput();
    input.source.valueType = source.valueType;
    input.source.value = source.value;
    input.source.instantValue = source.instantValue;
    input.source.dateValue = source.dateValue;
    input.source.timeValue = source.timeValue;
    input.source.timeZoneId = source.timeZoneId;
    input.source.disambiguation = source.disambiguation;
    input.resolution = source.resolution;
    if (String.isBlank(input.finish.valueType)) {
      input.finish.valueType = input.source.valueType;
    }
    input.finish.timeZoneId = input.source.timeZoneId;
    input.finish.disambiguation = input.source.disambiguation;
    return input;
  }
  /** @description Adapts typed Flow data without mutating its fields. */
  public static ChronoOperationInput adapt(
    ChronoCalendarDifferenceAction.Request source
  ) {
    ChronoOperationInput input = new ChronoOperationInput();
    input.source.valueType = source.valueType;
    input.source.value = source.value;
    input.source.instantValue = source.instantValue;
    input.source.dateValue = source.dateValue;
    input.source.timeValue = source.timeValue;
    input.source.timeZoneId = source.timeZoneId;
    input.source.disambiguation = source.disambiguation;
    input.finish.valueType = source.endValueType;
    input.finish.value = source.endValue;
    input.finish.instantValue = source.endInstant;
    input.finish.dateValue = source.endDate;
    input.finish.timeValue = source.endTime;
    input.largestUnit = source.largestUnit;
    if (String.isBlank(input.finish.valueType)) {
      input.finish.valueType = input.source.valueType;
    }
    input.finish.timeZoneId = input.source.timeZoneId;
    input.finish.disambiguation = input.source.disambiguation;
    return input;
  }
  /** @description Adapts typed Flow data without mutating its fields. */
  public static ChronoOperationInput adapt(ChronoCheckWorkingTimeInput source) {
    ChronoOperationInput input = new ChronoOperationInput();
    input.source.valueType = source.valueType;
    input.source.value = source.value;
    input.source.instantValue = source.instantValue;
    input.source.dateValue = source.dateValue;
    input.source.timeValue = source.timeValue;
    input.source.timeZoneId = source.timeZoneId;
    input.source.disambiguation = source.disambiguation;
    input.operatingHoursId = source.operatingHoursId;
    if (String.isBlank(input.finish.valueType)) {
      input.finish.valueType = input.source.valueType;
    }
    input.finish.timeZoneId = input.source.timeZoneId;
    input.finish.disambiguation = input.source.disambiguation;
    input.operatingHours = source.operatingHours;
    input.timeSlots = source.timeSlots;
    input.holidays = source.holidays;
    return input;
  }
  /** @description Adapts typed Flow data without mutating its fields. */
  public static ChronoOperationInput adapt(ChronoFindWorkingTimeInput source) {
    ChronoOperationInput input = new ChronoOperationInput();
    input.source.valueType = source.valueType;
    input.source.value = source.value;
    input.source.instantValue = source.instantValue;
    input.source.dateValue = source.dateValue;
    input.source.timeValue = source.timeValue;
    input.source.timeZoneId = source.timeZoneId;
    input.source.disambiguation = source.disambiguation;
    input.operatingHoursId = source.operatingHoursId;
    input.direction = source.direction;
    if (String.isBlank(input.finish.valueType)) {
      input.finish.valueType = input.source.valueType;
    }
    input.finish.timeZoneId = input.source.timeZoneId;
    input.finish.disambiguation = input.source.disambiguation;
    input.operatingHours = source.operatingHours;
    input.timeSlots = source.timeSlots;
    input.holidays = source.holidays;
    return input;
  }
  /** @description Adapts typed Flow data without mutating its fields. */
  public static ChronoOperationInput adapt(
    ChronoPeriodBoundaryAction.Request source
  ) {
    ChronoOperationInput input = new ChronoOperationInput();
    input.source.valueType = source.valueType;
    input.source.value = source.value;
    input.source.instantValue = source.instantValue;
    input.source.dateValue = source.dateValue;
    input.source.timeValue = source.timeValue;
    input.source.timeZoneId = source.timeZoneId;
    input.source.disambiguation = source.disambiguation;
    input.unit = source.unit;
    input.boundary = source.boundary;
    input.weekStartsOn = source.weekStartsOn;
    if (String.isBlank(input.finish.valueType)) {
      input.finish.valueType = input.source.valueType;
    }
    input.finish.timeZoneId = input.source.timeZoneId;
    input.finish.disambiguation = input.source.disambiguation;
    return input;
  }
  /** @description Adapts typed Flow data without mutating its fields. */
  public static ChronoOperationInput adapt(ChronoRoundInput source) {
    ChronoOperationInput input = new ChronoOperationInput();
    input.source.valueType = source.valueType;
    input.source.value = source.value;
    input.source.instantValue = source.instantValue;
    input.source.dateValue = source.dateValue;
    input.source.timeValue = source.timeValue;
    input.source.timeZoneId = source.timeZoneId;
    input.source.disambiguation = source.disambiguation;
    input.unit = source.unit;
    input.increment = source.increment;
    input.roundingMode = source.roundingMode;
    if (String.isBlank(input.finish.valueType)) {
      input.finish.valueType = input.source.valueType;
    }
    input.finish.timeZoneId = input.source.timeZoneId;
    input.finish.disambiguation = input.source.disambiguation;
    return input;
  }
  /** @description Adapts typed Flow data without mutating its fields. */
  public static ChronoOperationInput adapt(ChronoRoundAction.Request source) {
    ChronoOperationInput input = new ChronoOperationInput();
    input.source.valueType = source.valueType;
    input.source.value = source.value;
    input.source.instantValue = source.instantValue;
    input.source.dateValue = source.dateValue;
    input.source.timeValue = source.timeValue;
    input.source.timeZoneId = source.timeZoneId;
    input.source.disambiguation = source.disambiguation;
    input.unit = source.unit;
    input.increment = source.increment;
    input.roundingMode = source.roundingMode;
    if (String.isBlank(input.finish.valueType)) {
      input.finish.valueType = input.source.valueType;
    }
    input.finish.timeZoneId = input.source.timeZoneId;
    input.finish.disambiguation = input.source.disambiguation;
    return input;
  }
  /** @description Adapts scalar request data for shared batch execution. */
  public static ChronoAdjustInput adapt(ChronoAdjustAction.Request source) {
    ChronoAdjustInput item = new ChronoAdjustInput();
    item.valueType = source.valueType;
    item.value = source.value;
    item.instantValue = source.instantValue;
    item.dateValue = source.dateValue;
    item.timeValue = source.timeValue;
    item.timeZoneId = source.timeZoneId;
    item.disambiguation = source.disambiguation;
    item.duration = source.duration;
    item.amount = source.amount;
    item.unit = source.unit;
    return item;
  }
  /** @description Adapts scalar request data for shared batch execution. */
  public static ChronoConvertInput adapt(ChronoConvertAction.Request source) {
    ChronoConvertInput item = new ChronoConvertInput();
    item.valueType = source.valueType;
    item.value = source.value;
    item.instantValue = source.instantValue;
    item.dateValue = source.dateValue;
    item.timeValue = source.timeValue;
    item.targetType = source.targetType;
    item.timeZoneId = source.timeZoneId;
    item.disambiguation = source.disambiguation;
    item.referenceDate = source.referenceDate;
    item.referenceTime = source.referenceTime;
    return item;
  }
  /** @description Adapts scalar request data for shared batch execution. */
  public static ChronoDifferenceInput adapt(
    ChronoDifferenceAction.Request source
  ) {
    ChronoDifferenceInput item = new ChronoDifferenceInput();
    item.startInstant = source.startInstant;
    item.startValue = source.startValue;
    item.endInstant = source.endInstant;
    item.endValue = source.endValue;
    item.operatingHoursId = source.operatingHoursId;
    item.startDate = source.startDate;
    item.startTime = source.startTime;
    item.endDate = source.endDate;
    item.endTime = source.endTime;
    item.timeZoneId = source.timeZoneId;
    item.disambiguation = source.disambiguation;
    item.endTimeZoneId = source.endTimeZoneId;
    item.endDisambiguation = source.endDisambiguation;
    item.operatingHours = source.operatingHours;
    item.timeSlots = source.timeSlots;
    item.holidays = source.holidays;
    return item;
  }
  /** @description Adapts scalar request data for shared batch execution. */
  public static ChronoWorkingTimeInput adapt(
    ChronoWorkingTimeAction.Request source
  ) {
    ChronoWorkingTimeInput item = new ChronoWorkingTimeInput();
    item.startInstant = source.startInstant;
    item.startValue = source.startValue;
    item.timeZoneId = source.timeZoneId;
    item.amount = source.amount;
    item.unit = source.unit;
    item.scheduleType = source.scheduleType;
    item.scheduleId = source.scheduleId;
    item.startDate = source.startDate;
    item.startTime = source.startTime;
    item.disambiguation = source.disambiguation;
    item.operatingHours = source.operatingHours;
    item.timeSlots = source.timeSlots;
    item.holidays = source.holidays;
    return item;
  }
}
