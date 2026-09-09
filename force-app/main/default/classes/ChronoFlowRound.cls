// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Explicit clock-grid rounding, preserving plain values and zone-aware day lengths. */
public with sharing class ChronoFlowRound { // NOPMD -- Aggregate complexity spans independent type-specific rounding paths; per-method limits still apply.
  public static ChronoOperationResult execute(ChronoOperationInput input) {
    ChronoOperationValue value = new ChronoOperationValue(input.source);
    String mode = String.isBlank(input.roundingMode)
      ? 'halfExpand'
      : input.roundingMode;
    ChronoSupport.choice(
      mode,
      new Set<String>{
        'floor',
        'ceil',
        'expand',
        'trunc',
        'halfExpand',
        'halfTrunc',
        'halfEven',
        'halfCeil',
        'halfFloor'
      },
      'rounding mode'
    );
    Integer increment = input.increment == null ? 1 : input.increment;
    if (input.unit == 'day') {
      if (increment != 1) {
        throw new ChronoException(
          'Calendar day rounding requires increment 1.'
        );
      }
      return roundDay(value, mode);
    }
    Long step = clockStep(input.unit, increment);
    if (value.source.valueType == 'Instant') {
      return value.fromInstant(
        Datetime.newInstance(
          rounded(value.nativeValue.instantValue.getTime(), step, mode)
        )
      );
    }
    if (value.source.valueType == 'Duration') {
      ChronoDuration duration = (ChronoDuration) value.source.value;
      return new ChronoFlowValue(
          'Duration',
          ChronoDurationService.create(
            ChronoDurationService.getMonths(duration),
            ChronoDurationService.getDays(duration),
            rounded(ChronoDurationService.getMilliseconds(duration), step, mode)
          )
        )
        .result();
    }
    if (value.source.valueType == 'PlainTime') {
      Long millis = rounded(
        clockMillis(ChronoIso.parseTime(value.nativeValue.timeValue)),
        step,
        mode
      );
      return new ChronoFlowValue(
          'PlainTime',
          ChronoPlainTimeService.create(
            Time.newInstance(0, 0, 0, 0)
              .addMilliseconds(Integer.valueOf(Math.mod(millis, 86400000L)))
          )
        )
        .result();
    }
    return roundWall(value, step, mode);
  }
  private static ChronoOperationResult roundWall(
    ChronoOperationValue value,
    Long step,
    String mode
  ) {
    if (
      value.source.valueType != 'PlainDateTime' &&
      value.source.valueType != 'ZonedDateTime'
    ) {
      throw new ChronoException(
        'Clock rounding requires a time, date/time, instant or duration.'
      );
    }
    Datetime wall = value.wallClock();
    Long clock = clockMillis(wall.timeGmt());
    Datetime target = Datetime.newInstance(
      wall.getTime() - clock + rounded(clock, step, mode)
    );
    if (!value.isExact()) {
      return value.fromWall(target);
    }
    // When rounding within a repeated hour, keep the original occurrence unless an explicit policy overrides it.
    List<Datetime> matches = ChronoZoneResolver.resolve(
      target.dateGmt(),
      target.timeGmt(),
      value.zoneId
    );
    if (value.policy == 'reject' && matches.size() > 1) {
      TimeZone zone = ChronoSupport.zone(value.zoneId);
      for (Datetime match : matches) {
        if (
          zone.getOffset(match) ==
          zone.getOffset(value.nativeValue.instantValue)
        ) {
          return value.fromInstant(match);
        }
      }
    }
    return value.fromWall(target);
  }
  private static ChronoOperationResult roundDay(
    ChronoOperationValue value,
    String mode
  ) {
    if (value.source.valueType == 'PlainDate') {
      return value.source.result();
    }
    if (!value.isExact() && value.source.valueType != 'PlainDateTime') {
      throw new ChronoException(
        'Calendar day rounding requires a date or date/time.'
      );
    }
    Datetime wall = value.wallClock();
    Datetime start = Datetime.newInstanceGmt(
      wall.dateGmt(),
      Time.newInstance(0, 0, 0, 0)
    );
    Datetime finish = start.addDays(1);
    Long current = wall.getTime();
    if (value.isExact()) {
      start = ChronoFlowPeriod.startOfDay(wall.dateGmt(), value.zoneId);
      finish = ChronoFlowPeriod.startOfDay(
        wall.dateGmt().addDays(1),
        value.zoneId
      );
      current = value.nativeValue.instantValue.getTime();
    }
    Boolean up = chooseUpper(
      current - start.getTime(),
      finish.getTime() - start.getTime(),
      mode
    );
    Datetime target = up ? finish : start;
    return value.isExact() ? value.fromInstant(target) : value.fromWall(target);
  }
  private static Boolean chooseUpper(Long elapsed, Long length, String mode) {
    Decimal ratio = Decimal.valueOf(String.valueOf(elapsed)) / length;
    return ratio.setScale(0, roundingRule(mode, ratio)) > 0;
  }
  private static Long clockStep(String unit, Integer increment) {
    Map<String, Integer> divisors = new Map<String, Integer>{
      'hour' => 24,
      'minute' => 60,
      'second' => 60,
      'millisecond' => 1000
    };
    if (
      !divisors.containsKey(unit) ||
      increment < 1 ||
      Math.mod(divisors.get(unit), increment) != 0
    ) {
      throw new ChronoException(
        'Choose hour/minute/second/millisecond and a positive increment dividing 24/60/60/1000 respectively.'
      );
    }
    Long millis = unit == 'hour'
      ? 3600000L
      : (unit == 'minute' ? 60000L : (unit == 'second' ? 1000L : 1L));
    return millis * increment;
  }
  private static Long rounded(Long value, Long step, String mode) {
    Decimal quotient = Decimal.valueOf(String.valueOf(value)) / step;
    RoundingMode rule = roundingRule(mode, quotient);
    return quotient.setScale(0, rule).longValue() * step;
  }
  private static RoundingMode roundingRule(String mode, Decimal value) {
    if (mode == 'halfCeil') {
      return value < 0 ? RoundingMode.HALF_DOWN : RoundingMode.HALF_UP;
    }
    if (mode == 'halfFloor') {
      return value < 0 ? RoundingMode.HALF_UP : RoundingMode.HALF_DOWN;
    }
    return new Map<String, RoundingMode>{
        'floor' => RoundingMode.FLOOR,
        'ceil' => RoundingMode.CEILING,
        'expand' => RoundingMode.UP,
        'trunc' => RoundingMode.DOWN,
        'halfExpand' => RoundingMode.HALF_UP,
        'halfTrunc' => RoundingMode.HALF_DOWN,
        'halfEven' => RoundingMode.HALF_EVEN
      }
      .get(mode);
  }
  private static Long clockMillis(Time value) {
    return value.hour() * 3600000L +
      value.minute() * 60000L +
      value.second() * 1000L +
      value.millisecond();
  }
}
