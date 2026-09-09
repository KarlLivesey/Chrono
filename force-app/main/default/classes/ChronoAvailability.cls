// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Availability over schedule-local windows, converted to exact instants before combining schedules. */
public with sharing class ChronoAvailability implements ChronoActionOperation { // NOPMD -- Aggregate covers independent availability operations; per-method limits remain enforced.
  private final ChronoScheduleCatalogue schedules;
  public ChronoAvailability(List<Object> requests) {
    schedules = new ChronoScheduleCatalogue(requests);
  }
  public ChronoAvailabilityResult execute(ChronoAvailabilityInput input) {
    ChronoSupport.requireValue(input, 'Input');
    if (input.operation == 'validateSchedule') {
      return validate(input);
    }
    ChronoScheduleCatalogue.Schedule primary = schedules.primary(input);
    ChronoRangeContext context = context(input);
    ChronoAvailabilityResult result = new ChronoAvailabilityResult();
    result.success = true;
    result.isValid = true;
    result.timeZoneId = primary.zoneId;
    List<ChronoIntervals.Span> windows = combined(
      input,
      primary,
      context.bounds
    );
    windows = ChronoIntervals.subtract(windows, busy(input, context));
    if (input.operation != 'holidays' && input.operation != 'workingDates') {
      windows = ChronoBookingLimits.apply(input, windows);
    }
    result.containsRange =
      ChronoIntervals.length(windows) ==
      context.bounds.finish - context.bounds.start;
    if (input.operation == 'holidays' || input.operation == 'workingDates') {
      dates(input, primary, context.bounds, result);
    } else {
      windows = chooseWindows(input, windows);
    }
    Integer maximum = ChronoIntervals.resultLimit(input.maximumResults);
    if (windows.size() > maximum) {
      throw new ChronoException(
        'Availability result limit exceeded. Narrow the interval or increase maximum results.'
      );
    }
    result.ranges = new List<String>();
    result.openingValues = new List<String>();
    result.closingValues = new List<String>();
    for (ChronoIntervals.Span span : windows) {
      String opening = ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.create(
          Datetime.newInstance(span.start),
          context.source.zoneId
        )
      );
      String closing = ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.create(
          Datetime.newInstance(span.finish),
          context.source.zoneId
        )
      );
      result.ranges.add(opening + '/' + closing);
      result.openingValues.add(opening);
      result.closingValues.add(closing);
    }
    result.milliseconds = ChronoIntervals.length(windows);
    result.found = found(input.operation, result, windows);
    return result;
  }
  private static Boolean found(
    String operation,
    ChronoAvailabilityResult result,
    List<ChronoIntervals.Span> windows
  ) {
    if (operation == 'holidays') {
      return !result.holidayDates.isEmpty();
    }
    if (operation == 'workingDates') {
      return !result.workingDates.isEmpty();
    }
    return !windows.isEmpty();
  }
  public static ChronoRangeContext context(ChronoAvailabilityInput input) {
    ChronoRangeToolsInput range = ChronoRangeInputs.range(input);
    ChronoRangeContext local = new ChronoRangeContext(range);
    if (local.source.isExact()) {
      ChronoSupport.zone(local.source.zoneId);
      return local;
    }
    range.valueType = 'ZonedDateTime';
    range.value = null;
    range.dateValue = null;
    range.timeValue = null;
    range.instantValue = local.source.resolve(
      Datetime.newInstance(local.bounds.start)
    );
    range.endValue = null;
    range.endDate = null;
    range.endTime = null;
    range.endInstant = local.source.resolve(
      Datetime.newInstance(local.bounds.finish)
    );
    return new ChronoRangeContext(range);
  }
  private List<ChronoIntervals.Span> combined(
    ChronoAvailabilityInput input,
    ChronoScheduleCatalogue.Schedule primary,
    ChronoIntervals.Span bounds
  ) {
    List<ChronoIntervals.Span> result = primary.windows(bounds);
    if (input.otherOperatingHoursIds == null) {
      return result;
    }
    ChronoSupport.choice(
      input.operation,
      new Set<String>{ 'shared', 'anySchedule', 'appointments' },
      'multiple-schedule operation'
    );
    Boolean allSchedules = input.operation != 'anySchedule';
    if (input.operation == 'appointments') {
      String mode = String.isBlank(input.scheduleCombination)
        ? 'all'
        : input.scheduleCombination;
      ChronoSupport.choice(
        mode,
        new Set<String>{ 'all', 'any' },
        'schedule combination'
      );
      allSchedules = mode == 'all';
    }
    for (String recordId : new Set<String>(input.otherOperatingHoursIds)) {
      List<ChronoIntervals.Span> other = schedules.saved(recordId)
        .windows(bounds);
      if (allSchedules) {
        result = ChronoIntervals.intersect(result, other);
      } else {
        result.addAll(other);
        result = ChronoIntervals.unionSpans(result);
      }
    }
    return result;
  }
  private static List<ChronoIntervals.Span> busy(
    ChronoAvailabilityInput input,
    ChronoRangeContext context
  ) {
    if (input.busyRanges != null && !String.isBlank(input.busyRangesText)) {
      throw new ChronoException(
        'Use a busy collection or fixed intervals, not both.'
      );
    }
    List<String> ranges = String.isBlank(input.busyRangesText)
      ? input.busyRanges
      : input.busyRangesText.trim().split('[\\r\\n]+');
    return context.readRanges(ranges);
  }
  private static List<ChronoIntervals.Span> chooseWindows(
    ChronoAvailabilityInput input,
    List<ChronoIntervals.Span> windows
  ) {
    ChronoSupport.choice(
      input.operation,
      new Set<String>{
        'windows',
        'boundaries',
        'containsRange',
        'continuous',
        'shared',
        'anySchedule',
        'appointments'
      },
      'availability operation'
    );
    if (input.operation != 'continuous' && input.operation != 'appointments') {
      return windows;
    }
    Long length = elapsed(input.duration);
    Long step = String.isBlank(input.stepDuration)
      ? length
      : elapsed(input.stepDuration);
    List<ChronoIntervals.Span> result = new List<ChronoIntervals.Span>();
    Integer maximum = ChronoIntervals.resultLimit(input.maximumResults);
    for (ChronoIntervals.Span window : windows) {
      for (
        Long cursor = ChronoBookingLimits.firstStart(
            window.start,
            step,
            input.gridAnchor
          );
        cursor <= window.finish - length;
        cursor += step
      ) {
        if (result.size() == maximum) {
          throw new ChronoException('Appointment result limit exceeded.');
        }
        result.add(ChronoIntervals.span(cursor, cursor + length));
        if (input.operation == 'continuous') {
          return result;
        }
      }
    }
    return result;
  }
  public static Long elapsed(String iso) {
    ChronoDuration duration = ChronoDurationService.parseIso(iso);
    if (
      ChronoDurationService.getMonths(duration) != 0 ||
      ChronoDurationService.getDays(duration) != 0 ||
      ChronoDurationService.getMilliseconds(duration) <= 0
    ) {
      throw new ChronoException(
        'Supply a positive elapsed duration without calendar units.'
      );
    }
    return ChronoDurationService.getMilliseconds(duration);
  }
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Request options, schedule, exact bounds and output are separate responsibilities.
  private static void dates(
    ChronoAvailabilityInput input,
    ChronoScheduleCatalogue.Schedule primary,
    ChronoIntervals.Span bounds,
    ChronoAvailabilityResult result
  ) {
    result.workingDates = new List<Date>();
    result.holidayDates = new List<Date>();
    result.holidayRecords = new List<Holiday>();
    Date first = ChronoSupport.localValue(
        Datetime.newInstance(bounds.start),
        primary.zoneId
      )
      .dateGmt();
    Date last = ChronoSupport.localValue(
        Datetime.newInstance(bounds.finish - 1),
        primary.zoneId
      )
      .dateGmt();
    Integer maximum = ChronoIntervals.resultLimit(input.maximumResults);
    for (Date day = first; day <= last; day = day.addDays(1)) {
      if (
        input.operation == 'workingDates' &&
        !ChronoIntervals.intersect(
            primary.day(day),
            new List<ChronoIntervals.Span>{ bounds }
          )
          .isEmpty()
      ) {
        result.workingDates.add(day);
      }
      if (input.operation == 'holidays') {
        addHolidays(primary.holidays, day, result);
      }
      if (
        result.workingDates.size() > maximum ||
        result.holidayDates.size() > maximum
      ) {
        throw new ChronoException('Date result limit exceeded.');
      }
    }
  }
  private static void addHolidays(
    List<Holiday> holidays,
    Date day,
    ChronoAvailabilityResult result
  ) {
    for (Holiday holiday : holidays) {
      if (ChronoHolidays.occurs(holiday, day)) {
        result.holidayDates.add(day);
        result.holidayRecords.add(holiday.clone(true, true, false, false));
      }
    }
  }
  private ChronoAvailabilityResult validate(ChronoAvailabilityInput input) {
    ChronoAvailabilityResult result = new ChronoAvailabilityResult();
    result.success = true;
    try {
      result.timeZoneId = schedules.primary(input).zoneId;
      result.isValid = true;
    } catch (Exception ex) {
      result.isValid = false;
      result.validationMessage = ex.getMessage();
    }
    return result;
  }
  /** @description Executes a concrete request through the internal operation contract. */
  public Object evaluate(Object input) {
    return this.execute((ChronoAvailabilityInput) input);
  }
  /** @description Supplies the concrete result used to isolate batched results. */
  public Type resultType() {
    return ChronoAvailabilityResult.class;
  }
}
