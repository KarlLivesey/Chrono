// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Counts working dates in the schedule timezone; complete clock values remain distinct from dates. */
public with sharing class ChronoWorkingDays implements ChronoActionOperation {
  private final ChronoScheduleCatalogue schedules;
  public ChronoWorkingDays(List<Object> requests) {
    List<Object> nativeSchedules = new List<Object>();
    for (Object request : requests) {
      nativeSchedules.add(scheduleInput((ChronoWorkingDaysInput) request));
    }
    schedules = new ChronoScheduleCatalogue(nativeSchedules);
  }
  public Type resultType() {
    return ChronoOperationResult.class;
  }
  public Object evaluate(Object request) {
    ChronoWorkingDaysInput input = (ChronoWorkingDaysInput) request;
    ChronoSupport.requireValue(input, 'Input');
    ChronoSupport.requireValue(input.amount, 'Working calendar days');
    if (input.amount < -3660 || input.amount > 3660) {
      throw new ChronoException(
        'Working-day amounts must be between -3660 and 3660.'
      );
    }
    ChronoScheduleCatalogue.Schedule schedule = schedules.primary(
      scheduleInput(input)
    );
    ChronoOperationValue source = source(input, schedule.zoneId);
    Boolean dateOnly = source.source.valueType == 'PlainDate';
    Datetime local = dateOnly
      ? source.wallClock()
      : ChronoSupport.localValue(source.resolvedInstant(), schedule.zoneId);
    Date day = workingDate(schedule, local.dateGmt(), input.amount);
    if (dateOnly) {
      return source.fromWall(Datetime.newInstanceGmt(day, local.timeGmt()));
    }
    // Zero preserves the resolved occurrence; closed-time policy still applies below.
    Datetime target = input.amount == 0
      ? source.resolvedInstant()
      : ChronoZoneResolver.choose(
          ChronoPlainDateTimeService.create(day, local.timeGmt()),
          schedule.zoneId,
          source.policy
        );
    target = applyClosedPolicy(input.closedTimePolicy, schedule, target);
    return source.isExact()
      ? source.fromInstant(target)
      : source.fromWall(ChronoSupport.localValue(target, source.zoneId));
  }
  private static Datetime applyClosedPolicy(
    String closedPolicy,
    ChronoScheduleCatalogue.Schedule schedule,
    Datetime target
  ) {
    String policy = String.isBlank(closedPolicy) ? 'keep' : closedPolicy;
    ChronoSupport.choice(
      policy,
      new Set<String>{ 'keep', 'reject', 'next', 'previous' },
      'closed-time policy'
    );
    if (policy != 'keep' && !schedule.picker.contains(null, target)) {
      if (policy == 'reject') {
        throw new ChronoException(
          'The resulting clock is outside operating hours.'
        );
      }
      target = schedule.picker.nearest(null, target, policy == 'next' ? 1 : -1);
    }
    return target;
  }
  private static ChronoOperationValue source(
    ChronoWorkingDaysInput input,
    String scheduleZone
  ) {
    ChronoConvertInput converted = ChronoValueInputs.source(input);
    if (
      input.valueType == 'PlainDate' && String.isBlank(converted.timeZoneId)
    ) {
      converted.timeZoneId = scheduleZone;
    }
    ChronoOperationValue source = new ChronoOperationValue(converted);
    ChronoSupport.choice(
      source.source.valueType,
      new Set<String>{
        'PlainDate',
        'PlainDateTime',
        'Instant',
        'ZonedDateTime'
      },
      'working-day value type'
    );
    return source;
  }
  private static Date workingDate(
    ChronoScheduleCatalogue.Schedule schedule,
    Date start,
    Integer amount
  ) {
    Integer remaining = Math.abs(amount);
    Date day = start;
    Integer direction = amount < 0 ? -1 : 1;
    for (Integer searched = 0; remaining > 0 && searched < 3660; searched++) {
      day = day.addDays(direction);
      if (!schedule.day(day).isEmpty()) {
        remaining--;
      }
    }
    if (remaining > 0) {
      throw new ChronoException(
        'No result within the 3660-calendar-day working-date search limit.'
      );
    }
    return day;
  }
  private static ChronoAvailabilityInput scheduleInput(
    ChronoWorkingDaysInput source
  ) {
    if (source == null) {
      return null;
    }
    ChronoAvailabilityInput result = new ChronoAvailabilityInput();
    result.operatingHoursId = source.operatingHoursId;
    result.operatingHours = source.operatingHours;
    result.timeSlots = source.timeSlots;
    result.holidays = source.holidays;
    return result;
  }
}
