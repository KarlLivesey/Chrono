// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Native/ISO validation, date-specific details and Unix conversion. */
public with sharing class ChronoValueInspection {
  public static ChronoValidationResult validate(ChronoValueFields input) {
    ChronoValidationResult result = new ChronoValidationResult();
    result.success = true;
    result.valueType = input.valueType;
    try {
      result.value = ChronoFlowValue.read(ChronoValueInputs.source(input))
        .result()
        .value;
      result.isValid = true;
    } catch (Exception ex) {
      result.isValid = false;
      result.validationMessage = ex.getMessage();
    }
    return result;
  }
  public static ChronoDetailsResult details(ChronoValueFields input) {
    ChronoOperationResult value = ChronoFlowValue.read(
        ChronoValueInputs.source(input)
      )
      .result();
    ChronoDetailsResult result = new ChronoDetailsResult();
    result.success = true;
    result.valueType = value.valueType;
    result.value = value.value;
    result.instantValue = value.instantValue;
    result.dateValue = value.dateValue;
    result.timeValue = value.timeValue;
    result.timeZoneId = String.isBlank(input.timeZoneId)
      ? value.timeZoneId
      : input.timeZoneId;
    if (value.instantValue != null) {
      Datetime wall = ChronoSupport.localValue(
        value.instantValue,
        result.timeZoneId
      );
      result.dateValue = wall.dateGmt();
      result.timeValue = ChronoIso.timeText(wall.timeGmt());
      result.offsetSeconds =
        ChronoSupport.zone(result.timeZoneId).getOffset(value.instantValue) /
        1000;
    }
    if (result.dateValue != null) {
      fillDate(result);
    }
    if (!String.isBlank(result.timeValue)) {
      Time clock = ChronoIso.parseTime(result.timeValue);
      result.hour = clock.hour();
      result.minute = clock.minute();
      result.second = clock.second();
      result.millisecond = clock.millisecond();
    }
    if (value.valueType == 'PlainYearMonth') {
      result.year = Integer.valueOf(value.value.left(4));
      result.month = Integer.valueOf(value.value.right(2));
      result.daysInMonth = Date.daysInMonth(result.year, result.month);
    }
    if (value.valueType == 'PlainMonthDay') {
      result.month = Integer.valueOf(value.value.substring(2, 4));
      result.day = Integer.valueOf(value.value.right(2));
    }
    if (value.valueType == 'Duration') {
      result.durationMonths = value.months;
      result.durationDays = value.days;
      result.durationMilliseconds = value.milliseconds;
    }
    return result;
  }
  private static void fillDate(ChronoDetailsResult result) {
    Date day = result.dateValue;
    result.year = day.year();
    result.month = day.month();
    result.day = day.day();
    result.dayOfWeek = weekday(day);
    result.dayOfYear = Date.newInstance(day.year(), 1, 1).daysBetween(day) + 1;
    result.daysInMonth = Date.daysInMonth(day.year(), day.month());
    result.isLeapYear = Date.isLeapYear(day.year());
    result.daysInYear = result.isLeapYear ? 366 : 365;
    result.quarter = (day.month() - 1) / 3 + 1;
    Date thursday = day.addDays(4 - result.dayOfWeek);
    result.yearOfWeek = thursday.year();
    Date january4 = Date.newInstance(result.yearOfWeek, 1, 4);
    result.weekOfYear =
      january4.addDays(1 - weekday(january4)).daysBetween(day) / 7 + 1;
  }
  public static Integer weekday(Date day) {
    return Math.mod(
        Math.mod(Date.newInstance(1900, 1, 1).daysBetween(day), 7) + 7,
        7
      ) + 1;
  }
  public static ChronoEpochResult epoch(ChronoValueFields input) {
    ChronoSupport.choice(
      input.operation,
      new Set<String>{ 'fromEpoch', 'toEpoch' },
      'Unix operation'
    );
    ChronoSupport.choice(
      input.epochUnit,
      new Set<String>{ 'second', 'millisecond' },
      'Unix unit'
    );
    ChronoEpochResult result = new ChronoEpochResult();
    result.success = true;
    result.epochUnit = input.epochUnit;
    Decimal scale = input.epochUnit == 'second' ? 1000 : 1;
    if (input.operation == 'fromEpoch') {
      ChronoSupport.requireValue(input.epochValue, 'Unix timestamp');
      requireNoSource(input);
      result.instantValue = Datetime.newInstance(
        ChronoNumbers.milliseconds(input.epochValue * scale)
      );
      result.value = String.isBlank(input.timeZoneId)
        ? ChronoInstantService.toIsoString(
            ChronoInstantService.create(result.instantValue)
          )
        : ChronoZonedDateTimeService.toIsoString(
            ChronoZonedDateTimeService.create(
              result.instantValue,
              input.timeZoneId
            )
          );
    } else {
      ChronoOperationResult source = ChronoFlowValue.read(
          ChronoValueInputs.source(input)
        )
        .result();
      ChronoSupport.requireValue(
        source.instantValue,
        'An exact instant or zoned date/clock'
      );
      if (input.epochValue != null) {
        throw new ChronoException(
          'Do not supply a Unix timestamp when converting to one.'
        );
      }
      result.instantValue = source.instantValue;
      result.value = source.value;
    }
    result.epochValue =
      Decimal.valueOf(String.valueOf(result.instantValue.getTime())) / scale;
    return result;
  }
  private static void requireNoSource(ChronoValueFields input) {
    if (
      input.value != null ||
      input.instantValue != null ||
      input.dateValue != null ||
      input.timeValue != null
    ) {
      throw new ChronoException(
        'Supply a Unix timestamp without a second source value.'
      );
    }
  }
}
