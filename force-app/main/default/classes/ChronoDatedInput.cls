// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Resolves elapsed/working-time endpoints without inferring a user timezone. */
public with sharing class ChronoDatedInput {
  public static Datetime start(ChronoWorkingTimeInput request) {
    ChronoConvertInput input = new ChronoConvertInput();
    input.value = request.startValue;
    input.instantValue = request.startInstant;
    input.dateValue = request.startDate;
    input.timeValue = request.startTime;
    input.timeZoneId = request.timeZoneId;
    input.disambiguation = request.disambiguation;
    return resolve(input);
  }
  public static Datetime start(ChronoDifferenceInput request) {
    ChronoConvertInput input = new ChronoConvertInput();
    input.value = request.startValue;
    input.instantValue = request.startInstant;
    input.dateValue = request.startDate;
    input.timeValue = request.startTime;
    input.timeZoneId = request.timeZoneId;
    input.disambiguation = request.disambiguation;
    return resolve(input);
  }
  public static Datetime finish(ChronoDifferenceInput request) {
    ChronoConvertInput input = new ChronoConvertInput();
    input.value = request.endValue;
    input.instantValue = request.endInstant;
    input.dateValue = request.endDate;
    input.timeValue = request.endTime;
    input.timeZoneId = String.isBlank(request.endTimeZoneId)
      ? request.timeZoneId
      : request.endTimeZoneId;
    input.disambiguation = String.isBlank(request.endDisambiguation)
      ? request.disambiguation
      : request.endDisambiguation;
    return resolve(input);
  }
  private static Datetime resolve(ChronoConvertInput input) {
    input.valueType = inferType(input);
    ChronoOperationValue value = new ChronoOperationValue(input);
    if (value.isExact()) {
      return value.nativeValue.instantValue;
    }
    // A Date supplies local midnight. Resolution still rejects skipped/repeated
    // midnight unless the caller supplies a supported repeated-time policy.
    return value.resolve(value.wallClock());
  }
  private static String inferType(ChronoConvertInput input) {
    if (String.isBlank(input.value)) {
      if (input.instantValue != null) {
        return 'Instant';
      }
      return String.isBlank(input.timeValue) ? 'PlainDate' : 'PlainDateTime';
    }
    String text = input.value.trim();
    if (text.contains('[')) {
      return 'ZonedDateTime';
    }
    if (!text.contains('T')) {
      return 'PlainDate';
    }
    String clock = text.substring(text.indexOf('T') + 1);
    return clock.endsWith('Z') ||
      clock.contains('+') ||
      clock.contains('-')
      ? 'Instant'
      : 'PlainDateTime';
  }
}
