// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Per-invocation schedule context; isolates inaccessible/invalid configurations without querying per interview. */
public with sharing class ChronoFlowWorking {
  private ChronoOperatingSchedules schedules;
  private String operatingError;
  private String businessError;
  private Map<Id, BusinessHours> business = new Map<Id, BusinessHours>();
  private final Map<Id, ChronoWorkingTime> calculators = new Map<Id, ChronoWorkingTime>();
  public ChronoFlowWorking(List<Object> requests) {
    Set<Id> operatingIds = new Set<Id>();
    Set<Id> businessIds = new Set<Id>();
    for (Object raw : requests) {
      ChronoWorkingTimeInput input = (ChronoWorkingTimeInput) raw;
      if (input == null || String.isBlank(input.scheduleId)) {
        continue;
      }
      addScheduleId(input, operatingIds, businessIds);
    }
    if (!operatingIds.isEmpty()) {
      try {
        schedules = new ChronoOperatingSchedules(operatingIds);
      } catch (QueryException ex) {
        operatingError =
          'Cannot read operating-hour configuration: ' + ex.getMessage();
      }
    }
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
    Set<Id> operatingIds,
    Set<Id> businessIds
  ) {
    try {
      Id scheduleId = Id.valueOf(input.scheduleId);
      if (
        input.scheduleType == 'OperatingHours' &&
        scheduleId.getSObjectType() == OperatingHours.SObjectType
      ) {
        operatingIds.add(scheduleId);
      }
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
  public ChronoFlowResult execute(ChronoWorkingTimeInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoSupport.zone(input.timeZoneId);
    Datetime start = ChronoFlowValue.exact(
      input.startInstant,
      input.startValue
    );
    Long amount = milliseconds(input);
    ChronoSupport.requireValue(input.scheduleId, 'Schedule ID');
    Id scheduleId = Id.valueOf(input.scheduleId);
    Datetime result;
    if (input.scheduleType == 'OperatingHours') {
      result = operating(scheduleId).addMilliseconds(start, amount);
    } else if (input.scheduleType == 'BusinessHours') {
      if (businessError != null) {
        throw new ChronoException(businessError);
      }
      BusinessHours hours = business.get(scheduleId);
      if (hours == null || !hours.IsActive) {
        throw new ChronoException(
          'Select an accessible, active BusinessHours record.'
        );
      }
      result = System.BusinessHours.addGmt(scheduleId, start, amount);
    } else {
      throw new ChronoException('Select OperatingHours or BusinessHours.');
    }
    return new ChronoFlowValue(
        'ZonedDateTime',
        new ChronoZonedDateTime(result, input.timeZoneId)
      )
      .result();
  }
  private ChronoWorkingTime operating(Id scheduleId) {
    if (operatingError != null) {
      throw new ChronoException(operatingError);
    }
    if (schedules == null || !schedules.operating.containsKey(scheduleId)) {
      throw new ChronoException('Select an accessible OperatingHours record.');
    }
    if (!calculators.containsKey(scheduleId)) {
      calculators.put(scheduleId, schedules.getSchedule(scheduleId));
    }
    return calculators.get(scheduleId);
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
