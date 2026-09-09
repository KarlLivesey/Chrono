// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Convert zones, inspect date-specific offsets and search bounded timezone transitions. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoZoneToolsInput {
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
  /** @description Target timezone. */
  @AuraEnabled
  @InvocableVariable(label='Target timezone' description='Target timezone.')
  global String targetTimeZoneId;
  /** @description Keep. */
  @AuraEnabled
  @InvocableVariable(label='Keep' description='Keep.')
  global String conversionMode;
  /** @description An explicit signed offset such as +01:00. The result also includes the actual zone projection. */
  @AuraEnabled
  @InvocableVariable(
    label='Supplied UTC offset'
    description='An explicit signed offset such as +01:00. The result also includes the actual zone projection.'
  )
  global String suppliedOffset;
  /** @description Filter timezone IDs. */
  @AuraEnabled
  @InvocableVariable(
    label='Filter timezone IDs'
    description='Filter timezone IDs.'
  )
  global String search;
  /** @description Exclusive end for listing transitions. Searches are limited to 366 days. */
  @AuraEnabled
  @InvocableVariable(
    label='Search end'
    description='Exclusive end for listing transitions. Searches are limited to 366 days.'
  )
  global Datetime endInstant;
  /** @description 1–366 days for next or previous transition. Defaults to 366. */
  @AuraEnabled
  @InvocableVariable(
    label='Search days'
    description='1–366 days for next or previous transition. Defaults to 366.'
  )
  global Integer searchDays;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoZoneToolsInput() {
  }
}
