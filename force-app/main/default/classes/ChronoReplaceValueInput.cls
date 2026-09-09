// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Replace supplied components and preserve other fields. Resolve zoned values explicitly. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoReplaceValueInput {
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
  /** @description Year. */
  @AuraEnabled
  @InvocableVariable(label='Year' description='Year.')
  global Integer year;
  /** @description Month. */
  @AuraEnabled
  @InvocableVariable(label='Month' description='Month.')
  global Integer month;
  /** @description Day. */
  @AuraEnabled
  @InvocableVariable(label='Day' description='Day.')
  global Integer day;
  /** @description Hour. */
  @AuraEnabled
  @InvocableVariable(label='Hour' description='Hour.')
  global Integer hour;
  /** @description Minute. */
  @AuraEnabled
  @InvocableVariable(label='Minute' description='Minute.')
  global Integer minute;
  /** @description Second. */
  @AuraEnabled
  @InvocableVariable(label='Second' description='Second.')
  global Integer second;
  /** @description Millisecond. */
  @AuraEnabled
  @InvocableVariable(label='Millisecond' description='Millisecond.')
  global Integer millisecond;
  /** @description Invalid date handling. */
  @AuraEnabled
  @InvocableVariable(
    label='Invalid date handling'
    description='Invalid date handling.'
  )
  global String overflow;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoReplaceValueInput() {
  }
}
