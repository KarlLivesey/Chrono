// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Explicit conversions between native-backed values for Flow. Missing date, time or zone information is never inferred. */
public with sharing class ChronoFlowConvert {
  private final ChronoConvertInput input;
  private final ChronoFlowValue source;
  public ChronoFlowConvert(ChronoConvertInput input) {
    this.input = input;
    source = ChronoFlowValue.read(input);
  }
  public ChronoOperationResult execute() {
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
        return ChronoZonedDateTimeService.toInstant(zoned());
      }
      when 'ZonedDateTime' {
        return zoned();
      }
      when 'PlainDateTime' {
        return ChronoPlainDateTimeService.create(localDate(), localTime());
      }
      when 'PlainDate' {
        return ChronoPlainDateService.create(localDate());
      }
      when 'PlainTime' {
        return ChronoPlainTimeService.create(localTime());
      }
      when 'PlainYearMonth' {
        return ChronoPlainDateService.toPlainYearMonth(
          ChronoPlainDateService.create(localDate())
        );
      }
      when 'PlainMonthDay' {
        return ChronoPlainDateService.toPlainMonthDay(
          ChronoPlainDateService.create(localDate())
        );
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
        : ChronoZonedDateTimeService.withTimeZone(value, input.timeZoneId);
    }
    if (source.valueType == 'Instant') {
      return ChronoInstantService.toZonedDateTime(
        ((ChronoInstant) source.value),
        input.timeZoneId
      );
    }
    return ChronoPlainDateTimeService.toZonedDateTime(
      ChronoPlainDateTimeService.create(localDate(), localTime()),
      input.timeZoneId,
      policy(input.disambiguation)
    );
  }
  private Date localDate() {
    switch on source.valueType {
      when 'Instant', 'ZonedDateTime' {
        return ChronoZonedDateTimeService.toDate(zoned());
      }
      when 'PlainDateTime' {
        return ChronoPlainDateTimeService.toDate(
          ((ChronoPlainDateTime) source.value)
        );
      }
      when 'PlainDate' {
        return ChronoPlainDateService.toDate(((ChronoPlainDate) source.value));
      }
      when 'PlainTime' {
        return referenceDate();
      }
      when 'PlainYearMonth' {
        return ChronoPlainDateService.toDate(
          ChronoPlainYearMonthService.toPlainDate(
            ((ChronoPlainYearMonth) source.value),
            referenceDate().day()
          )
        );
      }
      when 'PlainMonthDay' {
        return ChronoPlainDateService.toDate(
          ChronoPlainMonthDayService.toPlainDate(
            ((ChronoPlainMonthDay) source.value),
            referenceDate().year()
          )
        );
      }
      when else {
        throw new ChronoException('A duration is not a date or instant.');
      }
    }
  }
  private Time localTime() {
    switch on source.valueType {
      when 'Instant', 'ZonedDateTime' {
        return ChronoZonedDateTimeService.toTime(zoned());
      }
      when 'PlainDateTime' {
        return ChronoPlainDateTimeService.toTime(
          ((ChronoPlainDateTime) source.value)
        );
      }
      when 'PlainTime' {
        return ChronoPlainTimeService.toTime(((ChronoPlainTime) source.value));
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
