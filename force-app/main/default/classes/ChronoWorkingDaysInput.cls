// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Add or subtract working dates while retaining the schedule-local clock, skipping closed dates and holidays. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoWorkingDaysInput {
  /** @description Value type. */
  @AuraEnabled
  @InvocableVariable(label='Value type' description='Value type.')
  global String valueType;
  /** @description ISO value. */
  @AuraEnabled
  @InvocableVariable(label='ISO value' description='ISO value.')
  global String value;
  /** @description Native date. */
  @AuraEnabled
  @InvocableVariable(label='Native date' description='Native date.')
  global Date dateValue;
  /** @description Native datetime. */
  @AuraEnabled
  @InvocableVariable(label='Native datetime' description='Native datetime.')
  global Datetime instantValue;
  /** @description ISO time for a native date and time input. */
  @AuraEnabled
  @InvocableVariable(
    label='Local time'
    description='ISO time for a native date and time input.'
  )
  global String timeValue;
  /** @description Required when resolving local time or inspecting an instant. */
  @AuraEnabled
  @InvocableVariable(
    label='Timezone'
    description='Required when resolving local time or inspecting an instant.'
  )
  global String timeZoneId;
  /** @description Repeated-time policy. */
  @AuraEnabled
  @InvocableVariable(
    label='Repeated-time policy'
    description='Repeated-time policy.'
  )
  global String disambiguation;
  /** @description Use one saved ID or a supplied OperatingHours record. */
  @AuraEnabled
  @InvocableVariable(
    label='OperatingHours ID'
    description='Use one saved ID or a supplied OperatingHours record.'
  )
  global String operatingHoursId;
  /** @description A supplied record can be unsaved. Also supply its TimeSlot and Holiday collections. */
  @AuraEnabled
  @InvocableVariable(
    label='OperatingHours record'
    description='A supplied record can be unsaved. Also supply its TimeSlot and Holiday collections.'
  )
  global OperatingHours operatingHours;
  /** @description Normal slots for the supplied schedule; no DML is performed. */
  @AuraEnabled
  @InvocableVariable(
    label='Time slots'
    description='Normal slots for the supplied schedule; no DML is performed.'
  )
  global List<TimeSlot> timeSlots;
  /** @description Holiday records for the supplied schedule, including recurring holidays. */
  @AuraEnabled
  @InvocableVariable(
    label='Holidays'
    description='Holiday records for the supplied schedule, including recurring holidays.'
  )
  global List<Holiday> holidays;
  /** @description Signed whole working dates to add; the starting date is excluded. Maximum search is 3660 calendar days. */
  @AuraEnabled
  @InvocableVariable(
    label='Working calendar days'
    description='Signed whole working dates to add; the starting date is excluded. Maximum search is 3660 calendar days.'
  )
  global Integer amount;
  /** @description Keep rejects neither closed clocks nor missing hours; reject requires open hours; next and previous move to the nearest open boundary. Dates only require a working date. */
  @AuraEnabled
  @InvocableVariable(
    label='If the resulting clock is closed'
    description='Keep rejects neither closed clocks nor missing hours; reject requires open hours; next and previous move to the nearest open boundary. Dates only require a working date.'
  )
  global String closedTimePolicy;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoWorkingDaysInput() {
  }
}
