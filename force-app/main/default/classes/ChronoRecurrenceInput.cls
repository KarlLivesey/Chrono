// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoRecurrenceInput {
  /** @description Operation. */
  @AuraEnabled
  @InvocableVariable(label='Operation' description='Operation.')
  global String operation;
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
  /** @description Direction. */
  @AuraEnabled
  @InvocableVariable(label='Direction' description='Direction.')
  global String direction;
  /** @description Include the starting date. */
  @AuraEnabled
  @InvocableVariable(
    label='Include the starting date'
    description='Include the starting date.'
  )
  global Boolean inclusive;
  /** @description 1 Monday through 7 Sunday. */
  @AuraEnabled
  @InvocableVariable(label='Weekday' description='1 Monday through 7 Sunday.')
  global Integer weekday;
  /** @description Positive from the start; negative from the end. For example -1 is last. */
  @AuraEnabled
  @InvocableVariable(
    label='Occurrence'
    description='Positive from the start; negative from the end. For example -1 is last.'
  )
  global Integer ordinal;
  /** @description 1–12. */
  @AuraEnabled
  @InvocableVariable(label='Annual month' description='1–12.')
  global Integer month;
  /** @description Invalid dates such as 29 February in a common year are skipped. */
  @AuraEnabled
  @InvocableVariable(
    label='Annual day'
    description='Invalid dates such as 29 February in a common year are skipped.'
  )
  global Integer day;
  /** @description Repeat every. */
  @AuraEnabled
  @InvocableVariable(label='Repeat every' description='Repeat every.')
  global String frequency;
  /** @description Positive frequency interval; defaults to 1. */
  @AuraEnabled
  @InvocableVariable(
    label='Interval'
    description='Positive frequency interval; defaults to 1.'
  )
  global Integer interval;
  /** @description Comma-separated MO,TU,WE,TH,FR,SA,SU. Weekly rules only. */
  @AuraEnabled
  @InvocableVariable(
    label='Weekdays'
    description='Comma-separated MO,TU,WE,TH,FR,SA,SU. Weekly rules only.'
  )
  global String weekdays;
  /** @description Supported: FREQ DAILY/WEEKLY/MONTHLY/YEARLY, INTERVAL, COUNT, UNTIL, BYDAY (plain weekday codes), BYMONTHDAY, BYMONTH and WKST. Unsupported parts are rejected. */
  @AuraEnabled
  @InvocableVariable(
    label='iCalendar RRULE'
    description='Supported: FREQ DAILY/WEEKLY/MONTHLY/YEARLY, INTERVAL, COUNT, UNTIL, BYDAY (plain weekday codes), BYMONTHDAY, BYMONTH and WKST. Unsupported parts are rejected.'
  )
  global String rule;
  /** @description Inclusive date boundary, at most 3660 days from the start. */
  @AuraEnabled
  @InvocableVariable(
    label='Search through date'
    description='Inclusive date boundary, at most 3660 days from the start.'
  )
  global Date untilDate;
  /** @description Optional deliberate stop count. Distinct from the safety result limit. */
  @AuraEnabled
  @InvocableVariable(
    label='Occurrence count'
    description='Optional deliberate stop count. Distinct from the safety result limit.'
  )
  global Integer count;
  /** @description Skipped local times. */
  @AuraEnabled
  @InvocableVariable(
    label='Skipped local times'
    description='Skipped local times.'
  )
  global String gapPolicy;
  /** @description Closed schedule dates. */
  @AuraEnabled
  @InvocableVariable(
    label='Closed schedule dates'
    description='Closed schedule dates.'
  )
  global String closedPolicy;
  /** @description 1–1000, default 100. Larger output fails rather than being silently truncated. */
  @AuraEnabled
  @InvocableVariable(
    label='Maximum results'
    description='1–1000, default 100. Larger output fails rather than being silently truncated.'
  )
  global Integer maximumResults;
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
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoRecurrenceInput() {
  }
}
