// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Applies supported core arithmetic with explicit calendar-versus-elapsed semantics. */
public with sharing class ChronoFlowAdjust {
  public static ChronoFlowResult execute(ChronoAdjustInput input) {
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
        return ((ChronoInstant) source.value)
          .addMilliseconds(duration.toMilliseconds());
      }
      when 'ZonedDateTime' {
        return ((ChronoZonedDateTime) source.value).add(duration, policy);
      }
      when 'PlainDateTime' {
        return ((ChronoPlainDateTime) source.value).add(duration);
      }
      when 'PlainDate' {
        requireNoClock(duration);
        return ((ChronoPlainDate) source.value)
          .addMonths(duration.getMonths())
          .addDays(duration.getDays());
      }
      when 'PlainTime' {
        return ((ChronoPlainTime) source.value)
          .addMilliseconds(duration.toMilliseconds());
      }
      when 'PlainYearMonth' {
        requireNoClock(duration);
        if (duration.getDays() != 0) {
          throw new ChronoException(
            'Year-month arithmetic requires months or years.'
          );
        }
        return ((ChronoPlainYearMonth) source.value)
          .addMonths(duration.getMonths());
      }
      when 'Duration' {
        ChronoDuration value = (ChronoDuration) source.value;
        return new ChronoDuration(
          checkedInteger((Long) value.getMonths() + duration.getMonths()),
          checkedInteger((Long) value.getDays() + duration.getDays()),
          sumMilliseconds(value.getMilliseconds(), duration.getMilliseconds())
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
    if (value.getMilliseconds() != 0) {
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
      return ChronoDuration.parse(input.duration);
    }
    ChronoSupport.requireValue(input.amount, 'Amount');
    Long amount = input.amount;
    switch on input.unit {
      when 'years' {
        return new ChronoDuration(checkedInteger(amount * 12), 0, 0L);
      }
      when 'months' {
        return new ChronoDuration(input.amount, 0, 0L);
      }
      when 'weeks' {
        return new ChronoDuration(0, checkedInteger(amount * 7), 0L);
      }
      when 'days' {
        return new ChronoDuration(0, input.amount, 0L);
      }
      when 'hours' {
        return new ChronoDuration(0, 0, amount * 3600000L);
      }
      when 'minutes' {
        return new ChronoDuration(0, 0, amount * 60000L);
      }
      when 'seconds' {
        return new ChronoDuration(0, 0, amount * 1000L);
      }
      when 'milliseconds' {
        return new ChronoDuration(0, 0, amount);
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
    if (total > 9223372036854775807L || total < -9223372036854775807L) {
      throw new ChronoException(
        'Duration exceeds the supported millisecond range.'
      );
    }
    return total.longValue();
  }
  private static Integer checkedInteger(Long value) {
    if (value < -2147483648L || value > 2147483647L) {
      throw new ChronoException(
        'Calendar amount exceeds the supported integer range.'
      );
    }
    return value.intValue();
  }
}
