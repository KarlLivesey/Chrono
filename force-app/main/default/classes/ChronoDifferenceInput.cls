// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description One elapsed-time difference between exact instants. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier, PMD.TooManyFields'
) // Flow must construct and inspect this type outside the package.
global with sharing class ChronoDifferenceInput {
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
  /** @description Native ending instant; alternatively use endValue. */
  @AuraEnabled
  @InvocableVariable(
    label='End datetime'
    description='Native ending instant; alternatively use endValue.'
  )
  global Datetime endInstant;
  /** @description ISO date, local date/time, instant or zoned date/time. Local values require an explicit timezone. */
  @AuraEnabled
  @InvocableVariable(
    label='End ISO value'
    description='ISO date, local date/time, instant or zoned date/time. Local values require an explicit timezone.'
  )
  global String endValue;
  /** @description Optional saved OperatingHours ID; omit to count all elapsed time. */
  @AuraEnabled
  @InvocableVariable(
    label='OperatingHours ID (optional)'
    description='Count only open time in this schedule’s timezone, excluding associated holidays. Leave blank for all elapsed time.'
  )
  global String operatingHoursId;
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
  /** @description Native local date; midnight unless endTime is supplied. Requires an explicit timezone. */
  @AuraEnabled
  @InvocableVariable(
    label='End date'
    description='Native local date; midnight unless endTime is supplied. Requires an explicit timezone.'
  )
  global Date endDate;
  /** @description Optional ISO clock time with endDate. Omit for local midnight. */
  @AuraEnabled
  @InvocableVariable(
    label='End local time'
    description='Optional ISO clock time with endDate. Omit for local midnight.'
  )
  global String endTime;
  /** @description Explicit timezone for local dates and date/times. Exact inputs retain their instant. */
  @AuraEnabled
  @InvocableVariable(
    label='Local input timezone'
    description='Explicit timezone for local dates and date/times. Exact inputs retain their instant.'
  )
  global String timeZoneId;
  /** @description reject (default), earlier or later. Nonexistent times are rejected. */
  @AuraEnabled
  @InvocableVariable(
    label='Repeated-time policy'
    description='reject (default), earlier or later. Nonexistent times are rejected.'
  )
  global String disambiguation;
  /** @description Optional separate timezone for the end value. Defaults to timeZoneId. */
  @AuraEnabled
  @InvocableVariable(
    label='End local input timezone'
    description='Optional separate timezone for the end value. Defaults to timeZoneId.'
  )
  global String endTimeZoneId;
  /** @description Optional end policy. Defaults to disambiguation; reject, earlier or later. */
  @AuraEnabled
  @InvocableVariable(
    label='End repeated-time policy'
    description='Optional end policy. Defaults to disambiguation; reject, earlier or later.'
  )
  global String endDisambiguation;
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
  global ChronoDifferenceInput() {
  }
}
