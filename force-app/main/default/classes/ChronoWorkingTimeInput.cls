// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description One schedule-aware calculation. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Flow must construct and inspect this type outside the package.
global with sharing class ChronoWorkingTimeInput {
  /** @description Native starting instant; alternatively use startValue. */
  @AuraEnabled
  @InvocableVariable(
    label='Start datetime'
    description='Native starting instant; alternatively use startValue.'
  )
  global Datetime startInstant;
  /** @description ISO date, local date/time, instant or zoned date/time. Local values require an explicit timezone. */
  @AuraEnabled
  @InvocableVariable(
    label='Start ISO value'
    description='ISO date, local date/time, instant or zoned date/time. Local values require an explicit timezone.'
  )
  global String startValue;
  /** @description Explicit zone for the result; availability follows the schedule zone. */
  @AuraEnabled
  @InvocableVariable(
    label='Result time zone'
    description='Explicit zone for the result; availability follows the schedule zone.'
    required=true
  )
  global String timeZoneId;
  /** @description Signed whole working units; negative values subtract. */
  @AuraEnabled
  @InvocableVariable(
    label='Amount'
    description='Signed whole working units; negative values subtract.'
    required=true
  )
  global Integer amount;
  /** @description hours or minutes. */
  @AuraEnabled
  @InvocableVariable(label='Unit' description='hours or minutes.' required=true)
  global String unit;
  /** @description OperatingHours or BusinessHours. */
  @AuraEnabled
  @InvocableVariable(
    label='Schedule type'
    description='OperatingHours or BusinessHours.'
    required=true
  )
  global String scheduleType;
  /** @description Saved Salesforce schedule record ID. */
  @AuraEnabled
  @InvocableVariable(
    label='Schedule record ID'
    description='Saved Salesforce schedule record ID; omit when supplying native OperatingHours records.'
  )
  global String scheduleId;
  /** @description Native local date; midnight unless startTime is supplied. Requires an explicit timezone. */
  @AuraEnabled
  @InvocableVariable(
    label='Start date'
    description='Native local date; midnight unless startTime is supplied. Requires an explicit timezone.'
  )
  global Date startDate;
  /** @description Optional ISO clock time with startDate. Omit for local midnight. */
  @AuraEnabled
  @InvocableVariable(
    label='Start local time'
    description='Optional ISO clock time with startDate. Omit for local midnight.'
  )
  global String startTime;
  /** @description reject (default), earlier or later. Nonexistent times are rejected. */
  @AuraEnabled
  @InvocableVariable(
    label='Repeated-time policy'
    description='reject (default), earlier or later. Nonexistent times are rejected.'
  )
  global String disambiguation;
  /** @description Supplied native schedule, including unsaved records. Use instead of a saved schedule ID. */
  @AuraEnabled
  @InvocableVariable(
    label='OperatingHours record'
    description='Supplied native schedule, including unsaved records. Use instead of a saved schedule ID.'
  )
  global OperatingHours operatingHours;
  /** @description Normal time slots for the supplied OperatingHours record. No queries or DML. */
  @AuraEnabled
  @InvocableVariable(
    label='Time slots'
    description='Normal time slots for the supplied OperatingHours record. No queries or DML.'
  )
  global List<TimeSlot> timeSlots;
  /** @description Holiday records for the supplied schedule, including recurring holidays. */
  @AuraEnabled
  @InvocableVariable(
    label='Holidays'
    description='Holiday records for the supplied schedule, including recurring holidays.'
  )
  global List<Holiday> holidays;
  /** @description Global no-argument constructor required by subscriber Flow. */
  @SuppressWarnings(
    'PMD.EmptyStatementBlock'
  ) // Required global no-argument Flow constructor.
  global ChronoWorkingTimeInput() {
  }
}
