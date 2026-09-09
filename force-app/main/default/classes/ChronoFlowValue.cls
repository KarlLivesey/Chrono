// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal adapter for the existing Flow action result contract. */
public with sharing class ChronoFlowValue {
  public final String valueType;
  public final Object value;
  public ChronoFlowValue(String valueType, Object value) {
    this.valueType = valueType;
    this.value = value;
  }
  public static ChronoFlowValue read(ChronoConvertInput input) {
    ChronoSupport.requireValue(input, 'Input');
    if (!String.isBlank(input.value)) {
      if (
        input.instantValue != null ||
        input.dateValue != null ||
        !String.isBlank(input.timeValue)
      ) {
        throw new ChronoException(
          'Provide one ISO value or native input, not both.'
        );
      }
      return new ChronoFlowValue(
        input.valueType,
        parseIsoValue(input.valueType, input.value)
      );
    }
    validateNativeFields(input);
    return new ChronoFlowValue(input.valueType, fromNative(input));
  }
  private static Object parseIsoValue(String valueType, String text) {
    switch on valueType {
      when 'Instant' {
        return ChronoInstantService.parseIso(text);
      }
      when 'ZonedDateTime' {
        return ChronoZonedDateTimeService.parseIso(text);
      }
      when 'PlainDateTime' {
        return ChronoPlainDateTimeService.parseIso(text);
      }
      when 'PlainDate' {
        return ChronoPlainDateService.parseIso(text);
      }
      when 'PlainTime' {
        return ChronoPlainTimeService.parseIso(text);
      }
      when 'PlainYearMonth' {
        return ChronoPlainYearMonthService.parseIso(text);
      }
      when 'PlainMonthDay' {
        return ChronoPlainMonthDayService.parseIso(text);
      }
      when 'Duration' {
        return ChronoDurationService.parseIso(text);
      }
      when else {
        throw new ChronoException('Unknown Chrono value type: ' + valueType);
      }
    }
  }

  private static void validateNativeFields(ChronoConvertInput input) {
    Boolean exactType =
      input.valueType == 'Instant' ||
      input.valueType == 'ZonedDateTime';
    Boolean datedType = new Set<String>{
        'PlainDateTime',
        'PlainDate',
        'PlainYearMonth',
        'PlainMonthDay'
      }
      .contains(input.valueType);
    Boolean clockType =
      input.valueType == 'PlainTime' ||
      input.valueType == 'PlainDateTime';
    if (
      (input.instantValue != null && !exactType) ||
      (input.dateValue != null && !datedType) ||
      (!String.isBlank(input.timeValue) && !clockType)
    ) {
      throw new ChronoException(
        'Native inputs do not match the selected value type.'
      );
    }
  }
  private static Object fromNative(ChronoConvertInput input) {
    switch on input.valueType {
      when 'Instant' {
        return ChronoInstantService.create(input.instantValue);
      }
      when 'ZonedDateTime' {
        return ChronoZonedDateTimeService.create(
          input.instantValue,
          input.timeZoneId
        );
      }
      when 'PlainDateTime' {
        return ChronoPlainDateTimeService.create(
          input.dateValue,
          ChronoIso.parseTime(input.timeValue)
        );
      }
      when 'PlainDate' {
        return ChronoPlainDateService.create(input.dateValue);
      }
      when 'PlainTime' {
        return ChronoPlainTimeService.create(
          ChronoIso.parseTime(input.timeValue)
        );
      }
      when 'PlainYearMonth' {
        return ChronoPlainDateService.toPlainYearMonth(
          ChronoPlainDateService.create(input.dateValue)
        );
      }
      when 'PlainMonthDay' {
        return ChronoPlainDateService.toPlainMonthDay(
          ChronoPlainDateService.create(input.dateValue)
        );
      }
      when else {
        throw new ChronoException(
          'Provide an ISO value for the selected type.'
        );
      }
    }
  }
  public ChronoOperationResult result() {
    ChronoOperationResult result = new ChronoOperationResult();
    result.success = true;
    result.valueType = valueType;
    result.value = isoText(valueType, value);
    fillNative(result);
    return result;
  }
  /** @description Serialises concrete core data through its validating service. */
  public static String isoText(String valueType, Object value) {
    switch on valueType {
      when 'Instant' {
        return ChronoInstantService.toIsoString((ChronoInstant) value);
      }
      when 'ZonedDateTime' {
        return ChronoZonedDateTimeService.toIsoString(
          (ChronoZonedDateTime) value
        );
      }
      when 'PlainDateTime' {
        return ChronoPlainDateTimeService.toIsoString(
          (ChronoPlainDateTime) value
        );
      }
      when 'PlainDate' {
        return ChronoPlainDateService.toIsoString((ChronoPlainDate) value);
      }
      when 'PlainTime' {
        return ChronoPlainTimeService.toIsoString((ChronoPlainTime) value);
      }
      when 'PlainYearMonth' {
        return ChronoPlainYearMonthService.toIsoString(
          (ChronoPlainYearMonth) value
        );
      }
      when 'PlainMonthDay' {
        return ChronoPlainMonthDayService.toIsoString(
          (ChronoPlainMonthDay) value
        );
      }
      when 'Duration' {
        return ChronoDurationService.toIsoString((ChronoDuration) value);
      }
      when else {
        throw new ChronoException('Unknown Chrono value type: ' + valueType);
      }
    }
  }
  private void fillNative(ChronoOperationResult result) {
    switch on valueType {
      when 'Instant' {
        result.instantValue = ChronoInstantService.toDatetime(
          ((ChronoInstant) value)
        );
      }
      when 'ZonedDateTime' {
        ChronoZonedDateTime zoned = (ChronoZonedDateTime) value;
        result.instantValue = ChronoZonedDateTimeService.toDatetime(zoned);
        result.dateValue = ChronoZonedDateTimeService.toDate(zoned);
        result.timeValue = ChronoIso.timeText(
          ChronoZonedDateTimeService.toTime(zoned)
        );
        result.timeZoneId = ChronoZonedDateTimeService.getTimeZoneId(zoned);
      }
      when 'PlainDateTime' {
        ChronoPlainDateTime local = (ChronoPlainDateTime) value;
        result.dateValue = ChronoPlainDateTimeService.toDate(local);
        result.timeValue = ChronoIso.timeText(
          ChronoPlainDateTimeService.toTime(local)
        );
      }
      when 'PlainDate' {
        result.dateValue = ChronoPlainDateService.toDate(
          ((ChronoPlainDate) value)
        );
      }
      when 'PlainTime' {
        result.timeValue = ChronoIso.timeText(
          ChronoPlainTimeService.toTime(((ChronoPlainTime) value))
        );
      }
      when 'Duration' {
        ChronoDuration duration = (ChronoDuration) value;
        result.months = ChronoDurationService.getMonths(duration);
        result.days = ChronoDurationService.getDays(duration);
        result.milliseconds = ChronoDurationService.getMilliseconds(duration);
      }
    }
  }
  public static Datetime exact(Datetime nativeValue, String text) {
    return ChronoExactInput.resolve(nativeValue, text);
  }
}
