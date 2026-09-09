// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Per-invocation schedule context; isolates inaccessible/invalid configurations without querying per interview. */
public with sharing class ChronoWorkingTimeContext {
  private ChronoScheduleCatalogue schedules;
  private String businessError;
  private Map<Id, BusinessHours> business = new Map<Id, BusinessHours>();
  public ChronoWorkingTimeContext(List<ChronoWorkingTimeInput> requests) {
    List<Object> operating = new List<Object>();
    Set<Id> businessIds = new Set<Id>();
    for (ChronoWorkingTimeInput input : requests) {
      if (input == null) {
        continue;
      }
      if (input.scheduleType == 'OperatingHours') {
        operating.add(ChronoScheduleInputs.fromWorking(input));
      } else if (
        input.scheduleType == 'BusinessHours' &&
        !String.isBlank(input.scheduleId)
      ) {
        addScheduleId(input, businessIds);
      }
    }
    schedules = new ChronoScheduleCatalogue(operating);
    if (!businessIds.isEmpty()) {
      try {
        business = new Map<Id, BusinessHours>(
          [
            SELECT Id, IsActive
            FROM BusinessHours
            WHERE Id IN :businessIds
            WITH USER_MODE
          ]
        );
      } catch (QueryException ex) {
        businessError =
          'Cannot read business-hour configuration: ' + ex.getMessage();
      }
    }
  }
  private static void addScheduleId(
    ChronoWorkingTimeInput input,
    Set<Id> businessIds
  ) {
    try {
      Id scheduleId = Id.valueOf(input.scheduleId);
      if (
        input.scheduleType == 'BusinessHours' &&
        scheduleId.getSObjectType() == BusinessHours.SObjectType
      ) {
        businessIds.add(scheduleId);
      }
    } catch (StringException ex) {
      // The affected item receives its malformed-ID error in execute, after preloading valid IDs.
      return;
    }
  }
  public ChronoZonedDateTime execute(ChronoWorkingTimeInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoSupport.zone(input.timeZoneId);
    Datetime start = ChronoDatedInput.start(input);
    Long amount = milliseconds(input);
    Datetime result;
    if (input.scheduleType == 'OperatingHours') {
      result = schedules.primary(ChronoScheduleInputs.fromWorking(input))
        .working()
        .addMilliseconds(start, amount);
    } else if (input.scheduleType == 'BusinessHours') {
      result = addBusinessTime(input, start, amount);
    } else {
      throw new ChronoException('Select OperatingHours or BusinessHours.');
    }
    return ChronoZonedDateTimeOperations.create(result, input.timeZoneId);
  }
  private Datetime addBusinessTime(
    ChronoWorkingTimeInput input,
    Datetime start,
    Long amount
  ) {
    if (
      ChronoScheduleInputs.supplied(ChronoScheduleInputs.fromWorking(input))
    ) {
      throw new ChronoException(
        'Supplied records require scheduleType OperatingHours.'
      );
    }
    ChronoSupport.requireValue(input.scheduleId, 'Schedule ID');
    Id scheduleId = Id.valueOf(input.scheduleId);
    if (businessError != null) {
      throw new ChronoException(businessError);
    }
    BusinessHours hours = business.get(scheduleId);
    if (hours == null || !hours.IsActive) {
      throw new ChronoException(
        'Select an accessible, active BusinessHours record.'
      );
    }
    return System.BusinessHours.addGmt(scheduleId, start, amount);
  }
  public Long differenceMilliseconds(
    ChronoDifferenceInput input,
    Datetime start,
    Datetime finish
  ) {
    return schedules.primary(
        ChronoScheduleInputs.fromWorking(
          ChronoScheduleInputs.fromDifference(input)
        )
      )
      .working()
      .differenceMilliseconds(start, finish);
  }
  private static Long milliseconds(ChronoWorkingTimeInput input) {
    ChronoSupport.requireValue(input.amount, 'Amount');
    if (input.unit == 'hours') {
      return ChronoSupport.hours(input.amount);
    }
    if (input.unit == 'minutes') {
      return ChronoSupport.minutes(input.amount);
    }
    throw new ChronoException('Working time supports hours or minutes.');
  }
}
