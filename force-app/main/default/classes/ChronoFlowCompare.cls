// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Compares compatible values without silently inventing missing calendar or timezone context. */
public with sharing class ChronoFlowCompare {
  public static ChronoOperationResult execute(ChronoOperationInput input) {
    ChronoOperationValue first = new ChronoOperationValue(input.source);
    ChronoOperationValue second = new ChronoOperationValue(input.finish);
    Integer comparison = compareValues(first, second, input);
    ChronoOperationResult result = ChronoOperationResults.success();
    result.comparison = comparison < 0 ? -1 : (comparison > 0 ? 1 : 0);
    if (input.toleranceMilliseconds != null) {
      if (input.toleranceMilliseconds < 0) {
        throw new ChronoException('Tolerance cannot be negative.');
      }
      result.withinTolerance =
        (Decimal.valueOf(String.valueOf(metric(first, input))) -
          metric(second, input))
          .abs() <= input.toleranceMilliseconds;
    }
    if (!String.isBlank(input.comparisonPeriod)) {
      result.samePeriod = samePeriod(first, second, input);
    }
    return result;
  }
  private static Integer compareValues(
    ChronoOperationValue first,
    ChronoOperationValue second,
    ChronoOperationInput input
  ) {
    Integer comparison;
    if (first.isExact() && second.isExact()) {
      comparison = compareLong(
        first.nativeValue.instantValue.getTime(),
        second.nativeValue.instantValue.getTime()
      );
    } else {
      if (first.source.valueType != second.source.valueType) {
        throw new ChronoException(
          'Compare matching plain types, or two exact values. Convert mixed types explicitly first.'
        );
      }
      if (first.source.valueType == 'Duration') {
        comparison = compareDurations(first, second, input);
      } else {
        comparison = first.source.result()
          .value.compareTo(second.source.result().value);
      }
    }
    return comparison;
  }
  private static Boolean samePeriod(
    ChronoOperationValue first,
    ChronoOperationValue second,
    ChronoOperationInput input
  ) {
    ChronoSupport.choice(
      input.comparisonPeriod,
      new Set<String>{ 'day', 'week', 'month', 'quarter', 'year' },
      'comparison period'
    );
    if (first.isExact() && first.zoneId != second.zoneId) {
      throw new ChronoException(
        'Supply one calculation timezone to compare local periods across zones.'
      );
    }
    return ChronoFlowPeriod.periodStart(
        first.wallClock().dateGmt(),
        input.comparisonPeriod,
        input.weekStartsOn
      ) ==
      ChronoFlowPeriod.periodStart(
        second.wallClock().dateGmt(),
        input.comparisonPeriod,
        input.weekStartsOn
      );
  }
  private static Long metric(
    ChronoOperationValue value,
    ChronoOperationInput input
  ) {
    if (value.isExact()) {
      return value.nativeValue.instantValue.getTime();
    }
    if (value.source.valueType == 'PlainTime') {
      Time clock = ChronoIso.parseTime(value.nativeValue.timeValue);
      return clock.hour() * 3600000L +
        clock.minute() * 60000L +
        clock.second() * 1000L +
        clock.millisecond();
    }
    if (value.source.valueType == 'Duration') {
      ChronoDuration duration = (ChronoDuration) value.source.value;
      if (
        ChronoDurationService.getMonths(duration) == 0 &&
        ChronoDurationService.getDays(duration) == 0
      ) {
        return ChronoDurationService.getMilliseconds(duration);
      }
      ChronoSupport.requireValue(
        input.referenceDate,
        'Duration reference date'
      );
      ChronoZonedDateTime anchor = ChronoPlainDateTimeService.toZonedDateTime(
        ChronoPlainDateTimeService.create(
          input.referenceDate,
          Time.newInstance(0, 0, 0, 0)
        ),
        input.source.timeZoneId,
        value.policy
      );
      return ChronoZonedDateTimeService.toDatetime(
            ChronoZonedDateTimeService.add(anchor, duration, value.policy)
          )
          .getTime() - ChronoZonedDateTimeService.toDatetime(anchor).getTime();
    }
    return value.wallClock().getTime();
  }
  private static Integer compareDurations(
    ChronoOperationValue first,
    ChronoOperationValue second,
    ChronoOperationInput input
  ) {
    ChronoDuration a = (ChronoDuration) first.source.value,
      b = (ChronoDuration) second.source.value;
    if (
      ChronoDurationService.getMonths(a) == 0 &&
      ChronoDurationService.getDays(a) == 0 &&
      ChronoDurationService.getMonths(b) == 0 &&
      ChronoDurationService.getDays(b) == 0
    ) {
      return compareLong(
        ChronoDurationService.getMilliseconds(a),
        ChronoDurationService.getMilliseconds(b)
      );
    }
    ChronoSupport.requireValue(input.referenceDate, 'Duration reference date');
    ChronoZonedDateTime anchor = ChronoPlainDateTimeService.toZonedDateTime(
      ChronoPlainDateTimeService.create(
        input.referenceDate,
        Time.newInstance(0, 0, 0, 0)
      ),
      first.zoneId,
      first.policy
    );
    return compareLong(
      ChronoZonedDateTimeService.toDatetime(
          ChronoZonedDateTimeService.add(anchor, a, first.policy)
        )
        .getTime(),
      ChronoZonedDateTimeService.toDatetime(
          ChronoZonedDateTimeService.add(anchor, b, first.policy)
        )
        .getTime()
    );
  }
  public static Integer compareLong(Long a, Long b) {
    return a < b ? -1 : (a > b ? 1 : 0);
  }
}
