// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Whole start-anchored calendar units followed by a separate clock/elapsed remainder. */
public with sharing class ChronoFlowCalendarDiff {
  private final ChronoOperationValue start;
  private final ChronoOperationValue finish;
  private final Datetime firstWall;
  private final Datetime lastWall;
  private final Long lastTicks;
  private final Integer direction;
  public ChronoFlowCalendarDiff(ChronoOperationInput input) {
    start = new ChronoOperationValue(input.source);
    finish = new ChronoOperationValue(input.finish);
    validatePair();
    firstWall = start.wallClock();
    lastWall = finish.wallClock();
    lastTicks = finish.isExact()
      ? finish.nativeValue.instantValue.getTime()
      : lastWall.getTime();
    Long firstTicks = start.isExact()
      ? start.nativeValue.instantValue.getTime()
      : firstWall.getTime();
    direction = lastTicks < firstTicks ? -1 : 1;
  }
  private void validatePair() {
    if (
      start.isExact() != finish.isExact() ||
      (!start.isExact() && start.source.valueType != finish.source.valueType)
    ) {
      throw new ChronoException(
        'Calendar difference requires matching plain date/date-time types, or two exact values in one calculation timezone.'
      );
    }
    if (start.isExact() && start.zoneId != finish.zoneId) {
      throw new ChronoException(
        'Different zones require an explicit calculation timezone.'
      );
    }
  }
  public ChronoOperationResult execute(String largestUnit) {
    String unit = String.isBlank(largestUnit) ? 'day' : largestUnit;
    ChronoSupport.choice(
      unit,
      new Set<String>{ 'day', 'month', 'year' },
      'largest calendar unit'
    );
    Integer months = unit == 'day'
      ? 0
      : (lastWall.yearGmt() - firstWall.yearGmt()) * 12 +
        lastWall.monthGmt() -
        firstWall.monthGmt();
    if (months * direction < 0) {
      months = 0;
    }
    Long cursor = at(months, 0);
    while (months != 0 && overshoots(cursor)) {
      months -= direction;
      cursor = at(months, 0);
    }
    Date monthDate = firstWall.dateGmt().addMonths(months);
    Integer days = monthDate.daysBetween(lastWall.dateGmt());
    if (days * direction < 0) {
      days = 0;
    }
    cursor = at(months, days);
    while (days != 0 && overshoots(cursor)) {
      days -= direction;
      cursor = at(months, days);
    }
    return new ChronoFlowValue(
        'Duration',
        ChronoDurationService.create(months, days, lastTicks - cursor)
      )
      .result();
  }
  private Boolean overshoots(Long candidate) {
    return direction > 0 ? candidate > lastTicks : candidate < lastTicks;
  }
  private Long at(Integer months, Integer days) {
    // Avoid re-resolving an unchanged repeated source time and preserve its chosen occurrence.
    if (months == 0 && days == 0 && start.isExact()) {
      return start.nativeValue.instantValue.getTime();
    }
    Datetime local = Datetime.newInstanceGmt(
      firstWall.dateGmt().addMonths(months).addDays(days),
      firstWall.timeGmt()
    );
    return start.isExact() ? start.resolve(local).getTime() : local.getTime();
  }
}
