// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Explicit conversions between native-backed values for Flow. Missing date, time or zone information is never inferred. */
public with sharing class ChronoFlowConvert {
  private final ChronoConvertInput input;
  private final ChronoFlowValue source;
  public ChronoFlowConvert(ChronoConvertInput input) {
    this.input = input;
    source = ChronoFlowValue.read(input);
  }
  public ChronoFlowResult execute() {
    String target = String.isBlank(input.targetType)
      ? source.valueType
      : input.targetType;
    if (target == source.valueType && target != 'ZonedDateTime') {
      return source.result();
    }
    if (source.valueType == 'Duration') {
      throw new ChronoException(
        'A duration cannot be converted to a date, time or instant.'
      );
    }
    return new ChronoFlowValue(target, convert(target)).result();
  }
  private Object convert(String target) {
    switch on target {
      when 'Instant' {
        return zoned().toInstant();
      }
      when 'ZonedDateTime' {
        return zoned();
      }
      when 'PlainDateTime' {
        return new ChronoPlainDateTime(localDate(), localTime());
      }
      when 'PlainDate' {
        return new ChronoPlainDate(localDate());
      }
      when 'PlainTime' {
        return new ChronoPlainTime(localTime());
      }
      when 'PlainYearMonth' {
        return new ChronoPlainDate(localDate()).toPlainYearMonth();
      }
      when 'PlainMonthDay' {
        return new ChronoPlainDate(localDate()).toPlainMonthDay();
      }
      when else {
        throw new ChronoException(
          'Unsupported conversion from ' +
            source.valueType +
            ' to ' +
            target +
            '.'
        );
      }
    }
  }
  private ChronoZonedDateTime zoned() {
    if (source.valueType == 'ZonedDateTime') {
      ChronoZonedDateTime value = (ChronoZonedDateTime) source.value;
      return String.isBlank(input.timeZoneId)
        ? value
        : value.withTimeZone(input.timeZoneId);
    }
    if (source.valueType == 'Instant') {
      return ((ChronoInstant) source.value).toZonedDateTime(input.timeZoneId);
    }
    return new ChronoPlainDateTime(localDate(), localTime())
      .toZonedDateTime(input.timeZoneId, policy(input.disambiguation));
  }
  private Date localDate() {
    switch on source.valueType {
      when 'Instant', 'ZonedDateTime' {
        return zoned().toDate();
      }
      when 'PlainDateTime' {
        return ((ChronoPlainDateTime) source.value).toDate();
      }
      when 'PlainDate' {
        return ((ChronoPlainDate) source.value).toDate();
      }
      when 'PlainTime' {
        return referenceDate();
      }
      when 'PlainYearMonth' {
        return ((ChronoPlainYearMonth) source.value)
          .toPlainDate(referenceDate().day())
          .toDate();
      }
      when 'PlainMonthDay' {
        return ((ChronoPlainMonthDay) source.value)
          .toPlainDate(referenceDate().year())
          .toDate();
      }
      when else {
        throw new ChronoException('A duration is not a date or instant.');
      }
    }
  }
  private Time localTime() {
    switch on source.valueType {
      when 'Instant', 'ZonedDateTime' {
        return zoned().toTime();
      }
      when 'PlainDateTime' {
        return ((ChronoPlainDateTime) source.value).toTime();
      }
      when 'PlainTime' {
        return ((ChronoPlainTime) source.value).toTime();
      }
      when else {
        return ChronoIso.parseTime(input.referenceTime);
      }
    }
  }
  private Date referenceDate() {
    ChronoSupport.requireValue(input.referenceDate, 'Reference date');
    return input.referenceDate;
  }
  public static String policy(String value) {
    return String.isBlank(value) ? 'reject' : value;
  }
}
