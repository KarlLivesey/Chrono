// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal native-backed value adapter for Flow transport; no core object is exposed to Flow. */
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
        return ChronoInstant.parse(text);
      }
      when 'ZonedDateTime' {
        return ChronoZonedDateTime.parse(text);
      }
      when 'PlainDateTime' {
        return ChronoPlainDateTime.parse(text);
      }
      when 'PlainDate' {
        return ChronoPlainDate.parse(text);
      }
      when 'PlainTime' {
        return ChronoPlainTime.parse(text);
      }
      when 'PlainYearMonth' {
        return ChronoPlainYearMonth.parse(text);
      }
      when 'PlainMonthDay' {
        return ChronoPlainMonthDay.parse(text);
      }
      when 'Duration' {
        return ChronoDuration.parse(text);
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
        return new ChronoInstant(input.instantValue);
      }
      when 'ZonedDateTime' {
        return new ChronoZonedDateTime(input.instantValue, input.timeZoneId);
      }
      when 'PlainDateTime' {
        return new ChronoPlainDateTime(
          input.dateValue,
          ChronoIso.parseTime(input.timeValue)
        );
      }
      when 'PlainDate' {
        return new ChronoPlainDate(input.dateValue);
      }
      when 'PlainTime' {
        return new ChronoPlainTime(ChronoIso.parseTime(input.timeValue));
      }
      when 'PlainYearMonth' {
        return new ChronoPlainDate(input.dateValue).toPlainYearMonth();
      }
      when 'PlainMonthDay' {
        return new ChronoPlainDate(input.dateValue).toPlainMonthDay();
      }
      when else {
        throw new ChronoException(
          'Provide an ISO value for the selected type.'
        );
      }
    }
  }
  public ChronoFlowResult result() {
    ChronoFlowResult result = new ChronoFlowResult();
    result.success = true;
    result.valueType = valueType;
    result.value = String.valueOf(value);
    fillNative(result);
    return result;
  }
  private void fillNative(ChronoFlowResult result) {
    switch on valueType {
      when 'Instant' {
        result.instantValue = ((ChronoInstant) value).toDatetime();
      }
      when 'ZonedDateTime' {
        ChronoZonedDateTime zoned = (ChronoZonedDateTime) value;
        result.instantValue = zoned.toDatetime();
        result.dateValue = zoned.toDate();
        result.timeValue = ChronoIso.timeText(zoned.toTime());
        result.timeZoneId = zoned.getTimeZoneId();
      }
      when 'PlainDateTime' {
        ChronoPlainDateTime local = (ChronoPlainDateTime) value;
        result.dateValue = local.toDate();
        result.timeValue = ChronoIso.timeText(local.toTime());
      }
      when 'PlainDate' {
        result.dateValue = ((ChronoPlainDate) value).toDate();
      }
      when 'PlainTime' {
        result.timeValue = ChronoIso.timeText(
          ((ChronoPlainTime) value).toTime()
        );
      }
      when 'Duration' {
        ChronoDuration duration = (ChronoDuration) value;
        result.months = duration.getMonths();
        result.days = duration.getDays();
        result.milliseconds = duration.getMilliseconds();
      }
    }
  }
  public static Datetime exact(Datetime nativeValue, String text) {
    if (nativeValue != null) {
      if (!String.isBlank(text)) {
        throw new ChronoException(
          'Provide a native instant or an ISO instant, not both.'
        );
      }
      return nativeValue;
    }
    ChronoSupport.requireValue(text, 'ISO instant');
    return text.contains('[')
      ? ChronoZonedDateTime.parse(text).toDatetime()
      : ChronoInstant.parse(text).toDatetime();
  }
}
