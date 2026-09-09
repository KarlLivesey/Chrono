// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Applies supported core arithmetic with explicit calendar-versus-elapsed semantics. */
public with sharing class ChronoFlowAdjust {
  public static ChronoOperationResult execute(ChronoAdjustInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoConvertInput transport = new ChronoConvertInput();
    transport.valueType = input.valueType;
    transport.value = input.value;
    transport.instantValue = input.instantValue;
    transport.dateValue = input.dateValue;
    transport.timeValue = input.timeValue;
    transport.timeZoneId = input.timeZoneId;
    ChronoFlowValue source = ChronoFlowValue.read(transport);
    ChronoDuration duration = duration(input);
    return new ChronoFlowValue(
        source.valueType,
        adjust(source, duration, ChronoFlowConvert.policy(input.disambiguation))
      )
      .result();
  }
  private static Object adjust(
    ChronoFlowValue source,
    ChronoDuration duration,
    String policy
  ) {
    switch on source.valueType {
      when 'Instant' {
        return ChronoInstantService.addMilliseconds(
          ((ChronoInstant) source.value),
          ChronoDurationService.toMilliseconds(duration)
        );
      }
      when 'ZonedDateTime' {
        return ChronoZonedDateTimeService.add(
          ((ChronoZonedDateTime) source.value),
          duration,
          policy
        );
      }
      when 'PlainDateTime' {
        return ChronoPlainDateTimeService.add(
          ((ChronoPlainDateTime) source.value),
          duration
        );
      }
      when 'PlainDate' {
        requireNoClock(duration);
        return ChronoPlainDateService.addDays(
          ChronoPlainDateService.addMonths(
            ((ChronoPlainDate) source.value),
            ChronoDurationService.getMonths(duration)
          ),
          ChronoDurationService.getDays(duration)
        );
      }
      when 'PlainTime' {
        return ChronoPlainTimeService.addMilliseconds(
          ((ChronoPlainTime) source.value),
          ChronoDurationService.toMilliseconds(duration)
        );
      }
      when 'PlainYearMonth' {
        requireNoClock(duration);
        if (ChronoDurationService.getDays(duration) != 0) {
          throw new ChronoException(
            'Year-month arithmetic requires months or years.'
          );
        }
        return ChronoPlainYearMonthService.addMonths(
          ((ChronoPlainYearMonth) source.value),
          ChronoDurationService.getMonths(duration)
        );
      }
      when 'Duration' {
        ChronoDuration value = (ChronoDuration) source.value;
        return ChronoDurationService.create(
          checkedInteger(
            (Long) ChronoDurationService.getMonths(value) +
            ChronoDurationService.getMonths(duration)
          ),
          checkedInteger(
            (Long) ChronoDurationService.getDays(value) +
            ChronoDurationService.getDays(duration)
          ),
          sumMilliseconds(
            ChronoDurationService.getMilliseconds(value),
            ChronoDurationService.getMilliseconds(duration)
          )
        );
      }
      when else {
        throw new ChronoException(
          'Convert a month-day to a date with a reference year before adjusting it.'
        );
      }
    }
  }
  private static void requireNoClock(ChronoDuration value) {
    if (ChronoDurationService.getMilliseconds(value) != 0) {
      throw new ChronoException(
        'This type does not contain a clock; use calendar units.'
      );
    }
  }
  private static ChronoDuration duration(ChronoAdjustInput input) {
    if (!String.isBlank(input.duration)) {
      if (input.amount != null || !String.isBlank(input.unit)) {
        throw new ChronoException(
          'Supply a duration or amount and unit, not both.'
        );
      }
      return ChronoDurationService.parseIso(input.duration);
    }
    ChronoSupport.requireValue(input.amount, 'Amount');
    Long amount = input.amount;
    switch on input.unit {
      when 'years' {
        return ChronoDurationService.create(checkedInteger(amount * 12), 0, 0L);
      }
      when 'months' {
        return ChronoDurationService.create(input.amount, 0, 0L);
      }
      when 'weeks' {
        return ChronoDurationService.create(0, checkedInteger(amount * 7), 0L);
      }
      when 'days' {
        return ChronoDurationService.create(0, input.amount, 0L);
      }
      when 'hours' {
        return ChronoDurationService.create(0, 0, amount * 3600000L);
      }
      when 'minutes' {
        return ChronoDurationService.create(0, 0, amount * 60000L);
      }
      when 'seconds' {
        return ChronoDurationService.create(0, 0, amount * 1000L);
      }
      when 'milliseconds' {
        return ChronoDurationService.create(0, 0, amount);
      }
      when else {
        throw new ChronoException('Select a supported arithmetic unit.');
      }
    }
  }
  private static Long sumMilliseconds(Long first, Long second) {
    Decimal total =
      Decimal.valueOf(String.valueOf(first)) +
      Decimal.valueOf(String.valueOf(second));
    return ChronoNumbers.milliseconds(total);
  }
  private static Integer checkedInteger(Long value) {
    return ChronoNumbers.calendar(value);
  }
}
