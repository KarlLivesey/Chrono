// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoFiscalPeriodInput {
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
  /** @description Fiscal configuration. */
  @AuraEnabled
  @InvocableVariable(
    label='Fiscal configuration'
    description='Fiscal configuration.'
  )
  global String calendarSource;
  /** @description Fiscal period. */
  @AuraEnabled
  @InvocableVariable(label='Fiscal period' description='Fiscal period.')
  global String period;
  /** @description 1–12. Used only for a month-based fiscal year. */
  @AuraEnabled
  @InvocableVariable(
    label='Fiscal year starts in month'
    description='1–12. Used only for a month-based fiscal year.'
  )
  global Integer startMonth;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoFiscalPeriodInput() {
  }
}
