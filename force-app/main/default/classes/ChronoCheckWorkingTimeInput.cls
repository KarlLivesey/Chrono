// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Check whether a date has opening hours or an instant is inside OperatingHours. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Required subscriber Flow request contract.
global with sharing class ChronoCheckWorkingTimeInput {
  /** @description Chrono type of the source. */
  @AuraEnabled
  @InvocableVariable(
    label='Value type'
    description='Chrono type of the source.'
  )
  global String valueType;
  /** @description ISO source; alternatively supply native fields. */
  @AuraEnabled
  @InvocableVariable(
    label='ISO value'
    description='ISO source; alternatively supply native fields.'
  )
  global String value;
  /** @description Exact source instant; mutually exclusive with ISO value. */
  @AuraEnabled
  @InvocableVariable(
    label='Native datetime'
    description='Exact source instant; mutually exclusive with ISO value.'
  )
  global Datetime instantValue;
  /** @description Local source date; mutually exclusive with ISO value. */
  @AuraEnabled
  @InvocableVariable(
    label='Native date'
    description='Local source date; mutually exclusive with ISO value.'
  )
  global Date dateValue;
  /** @description ISO local time for native date/time input. */
  @AuraEnabled
  @InvocableVariable(
    label='Local time'
    description='ISO local time for native date/time input.'
  )
  global String timeValue;
  /** @description Explicit zone for local resolution or calendar calculations. */
  @AuraEnabled
  @InvocableVariable(
    label='Calculation timezone'
    description='Explicit zone for local resolution or calendar calculations.'
  )
  global String timeZoneId;
  /** @description reject, earlier or later; skipped local times are rejected unless explicitly corrected. */
  @AuraEnabled
  @InvocableVariable(
    label='Repeated-time policy'
    description='reject, earlier or later; skipped local times are rejected unless explicitly corrected.'
  )
  global String disambiguation;
  /** @description Saved accessible OperatingHours record ID. */
  @AuraEnabled
  @InvocableVariable(
    label='OperatingHours ID'
    description='Saved accessible OperatingHours record ID.'
  )
  global String operatingHoursId;
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
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoCheckWorkingTimeInput() {
  }
}
