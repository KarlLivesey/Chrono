// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Duration component arithmetic and totals anchored in native dates and timezone rules. */
public with sharing class ChronoDurationMath implements ChronoActionOperation { // NOPMD -- Aggregate complexity spans independent duration operations.
  private static final Map<String, Long> CLOCK_UNITS = new Map<String, Long>{
    'hour' => 3600000L,
    'minute' => 60000L,
    'second' => 1000L,
    'millisecond' => 1L
  };
  public static ChronoDurationResult execute(ChronoDurationToolsInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoSupport.choice(
      input.operation,
      new Set<String>{
        'create',
        'components',
        'negate',
        'absolute',
        'total',
        'balance',
        'multiply',
        'divide'
      },
      'duration operation'
    );
    ChronoDuration duration = input.operation == 'create'
      ? create(input)
      : ChronoDurationService.parseIso(input.value);
    Decimal total;
    switch on input.operation {
      when 'negate' {
        duration = ChronoDurationService.negate(duration);
      }
      when 'absolute' {
        if (
          ChronoDurationService.getMonths(duration) < 0 ||
          ChronoDurationService.getDays(duration) < 0 ||
          ChronoDurationService.getMilliseconds(duration) < 0
        ) {
          duration = ChronoDurationService.negate(duration);
        }
      }
      when 'total' {
        total = total(duration, input);
      }
      when 'balance' {
        duration = balance(duration, input);
      }
      when 'multiply', 'divide' {
        duration = scale(duration, input);
      }
    }
    ChronoDurationResult result = parts(duration);
    result.total = total;
    return result;
  }
  private static ChronoDuration create(ChronoDurationToolsInput input) {
    if (!String.isBlank(input.value)) {
      throw new ChronoException(
        'Use components without an ISO duration when creating a duration.'
      );
    }
    Decimal months = (Decimal) n(input.years) * 12 + n(input.months);
    Decimal days = (Decimal) n(input.weeks) * 7 + n(input.days);
    Decimal milliseconds =
      Decimal.valueOf(String.valueOf(n(input.hours))) * 3600000 +
      Decimal.valueOf(String.valueOf(n(input.minutes))) * 60000 +
      (input.seconds == null ? 0 : input.seconds) * 1000 +
      n(input.milliseconds);
    return ChronoDurationService.create(
      checked(months),
      checked(days),
      ChronoNumbers.milliseconds(milliseconds)
    );
  }
  private static ChronoDuration scale(
    ChronoDuration value,
    ChronoDurationToolsInput input
  ) {
    Decimal factor = scalingFactor(input);
    String mode = String.isBlank(input.scalingMode)
      ? 'components'
      : input.scalingMode;
    ChronoSupport.choice(
      mode,
      new Set<String>{ 'components', 'elapsed' },
      'scaling mode'
    );
    if (mode == 'elapsed') {
      return ChronoDurationService.create(
        0,
        0,
        ChronoNumbers.milliseconds(elapsed(value, input) * factor)
      );
    }
    Decimal months = ChronoDurationService.getMonths(value) * factor;
    Decimal days = ChronoDurationService.getDays(value) * factor;
    if (
      months != months.setScale(0, RoundingMode.DOWN) ||
      days != days.setScale(0, RoundingMode.DOWN)
    ) {
      throw new ChronoException(
        'Fractional calendar components require elapsed scaling and a reference value.'
      );
    }
    return ChronoDurationService.create(
      checked(months),
      checked(days),
      ChronoNumbers.milliseconds((Decimal) value.milliseconds * factor)
    );
  }
  private static Decimal scalingFactor(ChronoDurationToolsInput input) {
    ChronoSupport.requireValue(input.factor, 'Factor');
    if (input.operation == 'divide' && input.factor == 0) {
      throw new ChronoException('Cannot divide a duration by zero.');
    }
    return input.operation == 'divide' ? 1 / input.factor : input.factor;
  }
  private static ChronoDuration balance(
    ChronoDuration value,
    ChronoDurationToolsInput input
  ) {
    validateUnit(input.unit);
    if (CLOCK_UNITS.containsKey(input.unit)) {
      return ChronoDurationService.create(
        0,
        0,
        ChronoNumbers.milliseconds(elapsed(value, input))
      );
    }
    ChronoOperationInput endpoints = endpoints(value, input);
    ChronoOperationResult result = new ChronoFlowCalendarDiff(endpoints)
      .execute(input.unit == 'year' || input.unit == 'month' ? 'month' : 'day');
    return ChronoDurationService.create(
      result.months,
      result.days,
      result.milliseconds
    );
  }
  private static Decimal total(
    ChronoDuration value,
    ChronoDurationToolsInput input
  ) {
    validateUnit(input.unit);
    if (CLOCK_UNITS.containsKey(input.unit)) {
      return elapsed(value, input) / CLOCK_UNITS.get(input.unit);
    }
    ChronoOperationInput endpoints = endpoints(value, input);
    ChronoOperationValue start = new ChronoOperationValue(endpoints.source);
    ChronoOperationValue finish = new ChronoOperationValue(endpoints.finish);
    ChronoOperationResult difference = new ChronoFlowCalendarDiff(endpoints)
      .execute(input.unit == 'year' || input.unit == 'month' ? 'month' : 'day');
    Integer whole = input.unit == 'year'
      ? difference.months / 12
      : input.unit == 'month'
          ? difference.months
          : input.unit == 'week' ? difference.days / 7 : difference.days;
    Integer direction = ticks(finish) >= ticks(start) ? 1 : -1;
    Long cursor = at(start, input.unit, whole);
    Long next = at(start, input.unit, whole + direction);
    Decimal remainder = Decimal.valueOf(String.valueOf(ticks(finish) - cursor));
    return whole +
      direction * remainder.abs() /
      Decimal.valueOf(String.valueOf(next - cursor)).abs();
  }
  private static Long at(
    ChronoOperationValue start,
    String unit,
    Integer amount
  ) {
    if (amount == 0) {
      return ticks(start);
    }
    Datetime wall = start.wallClock();
    Date dateValue = unit == 'year'
      ? wall.dateGmt().addYears(amount)
      : unit == 'month'
          ? wall.dateGmt().addMonths(amount)
          : wall.dateGmt().addDays(amount * (unit == 'week' ? 7 : 1));
    Datetime target = Datetime.newInstanceGmt(dateValue, wall.timeGmt());
    return start.isExact() ? start.resolve(target).getTime() : target.getTime();
  }
  private static Decimal elapsed(
    ChronoDuration value,
    ChronoDurationToolsInput input
  ) {
    if (
      ChronoDurationService.getMonths(value) == 0 &&
      ChronoDurationService.getDays(value) == 0
    ) {
      return Decimal.valueOf(
        String.valueOf(ChronoDurationService.getMilliseconds(value))
      );
    }
    ChronoOperationInput pair = endpoints(value, input);
    return Decimal.valueOf(
      String.valueOf(
        ticks(new ChronoOperationValue(pair.finish)) -
        ticks(new ChronoOperationValue(pair.source))
      )
    );
  }
  private static ChronoOperationInput endpoints(
    ChronoDuration value,
    ChronoDurationToolsInput input
  ) {
    if (input.referenceDate != null && input.referenceInstant != null) {
      throw new ChronoException('Use one reference date or datetime.');
    }
    ChronoOperationInput pair = new ChronoOperationInput();
    pair.source.timeZoneId = input.timeZoneId;
    pair.source.disambiguation = input.disambiguation;
    if (input.referenceInstant != null) {
      ChronoSupport.zone(input.timeZoneId);
      pair.source.valueType = 'ZonedDateTime';
      pair.source.instantValue = input.referenceInstant;
    } else {
      ChronoSupport.requireValue(
        input.referenceDate,
        'A reference date or datetime for calendar units'
      );
      if (String.isBlank(input.timeZoneId)) {
        pair.source.valueType = 'PlainDateTime';
        pair.source.dateValue = input.referenceDate;
        pair.source.timeValue = '00:00:00.000';
      } else {
        pair.source.valueType = 'ZonedDateTime';
        pair.source.instantValue = ChronoZonedDateTimeService.toDatetime(
          ChronoPlainDateTimeService.toZonedDateTime(
            ChronoPlainDateTimeService.create(
              input.referenceDate,
              Time.newInstance(0, 0, 0, 0)
            ),
            input.timeZoneId,
            ChronoFlowConvert.policy(input.disambiguation)
          )
        );
      }
    }
    ChronoAdjustInput adjust = new ChronoAdjustInput();
    adjust.valueType = pair.source.valueType;
    adjust.instantValue = pair.source.instantValue;
    adjust.dateValue = pair.source.dateValue;
    adjust.timeValue = pair.source.timeValue;
    adjust.timeZoneId = input.timeZoneId;
    adjust.disambiguation = input.disambiguation;
    adjust.duration = ChronoDurationService.toIsoString(value);
    ChronoOperationResult finish = ChronoFlowAdjust.execute(adjust);
    pair.finish.valueType = finish.valueType;
    pair.finish.value = finish.value;
    pair.finish.timeZoneId = input.timeZoneId;
    pair.finish.disambiguation = input.disambiguation;
    return pair;
  }
  private static Long ticks(ChronoOperationValue value) {
    return value.isExact()
      ? value.nativeValue.instantValue.getTime()
      : value.wallClock().getTime();
  }
  private static void validateUnit(String unit) {
    ChronoSupport.choice(
      unit,
      new Set<String>{
        'year',
        'month',
        'week',
        'day',
        'hour',
        'minute',
        'second',
        'millisecond'
      },
      'duration unit'
    );
  }
  private static Long n(Long value) {
    return value == null ? 0 : value;
  }
  private static Integer checked(Decimal value) {
    return ChronoNumbers.calendar(value);
  }
  private static ChronoDurationResult parts(ChronoDuration value) {
    ChronoDurationResult result = new ChronoDurationResult();
    result.success = true;
    result.value = ChronoDurationService.toIsoString(value);
    result.months = ChronoDurationService.getMonths(value);
    result.days = ChronoDurationService.getDays(value);
    result.milliseconds = ChronoDurationService.getMilliseconds(value);
    result.years = result.months / 12;
    result.remainingMonths = Math.mod(result.months, 12);
    result.weeks = result.days / 7;
    result.remainingDays = Math.mod(result.days, 7);
    result.hours = result.milliseconds / 3600000;
    Long remaining = result.milliseconds - result.hours * 3600000;
    result.minutes = checked(remaining / 60000);
    remaining -= result.minutes * 60000;
    result.seconds = checked(remaining / 1000);
    result.millisecondPart = checked(remaining - result.seconds * 1000);
    return result;
  }
  /** @description Executes a concrete request through the internal operation contract. */
  public Object evaluate(Object input) {
    return ChronoDurationMath.execute((ChronoDurationToolsInput) input);
  }
  /** @description Supplies the concrete result used to isolate batched results. */
  public Type resultType() {
    return ChronoDurationResult.class;
  }
}
