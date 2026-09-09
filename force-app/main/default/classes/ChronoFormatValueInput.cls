// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoFormatValueInput {
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
  /** @description Component order and names follow the context user locale. Gregorian years always use four digits. */
  @AuraEnabled
  @InvocableVariable(
    label='Display length'
    description='Component order and names follow the context user locale. Gregorian years always use four digits.'
  )
  global String style;
  /** @description Optional Apex date-format pattern. Overrides display length; parsing never guesses this pattern. */
  @AuraEnabled
  @InvocableVariable(
    label='Explicit output pattern'
    description='Optional Apex date-format pattern. Overrides display length; parsing never guesses this pattern.'
  )
  global String pattern;
  /** @description Append timezone offset and ID. */
  @AuraEnabled
  @InvocableVariable(
    label='Append timezone offset and ID'
    description='Append timezone offset and ID.'
  )
  global Boolean includeZone;
  /** @description The same value family as the start. */
  @AuraEnabled
  @InvocableVariable(
    label='Range end ISO value'
    description='The same value family as the start.'
  )
  global String endValue;
  /** @description Defaults to an en dash. */
  @AuraEnabled
  @InvocableVariable(
    label='Range separator'
    description='Defaults to an en dash.'
  )
  global String separator;
  /** @description ISO is language-neutral; compact uses unit symbols and long uses English unit names. */
  @AuraEnabled
  @InvocableVariable(
    label='Duration style'
    description='ISO is language-neutral; compact uses unit symbols and long uses English unit names.'
  )
  global String durationStyle;
  /** @description Supply a reference of the same type, or another exact value. */
  @AuraEnabled
  @InvocableVariable(
    label='Relative reference ISO value'
    description='Supply a reference of the same type, or another exact value.'
  )
  global String referenceValue;
  /** @description Auto chooses elapsed seconds, minutes, hours or 24-hour days. */
  @AuraEnabled
  @InvocableVariable(
    label='Relative elapsed unit'
    description='Auto chooses elapsed seconds, minutes, hours or 24-hour days.'
  )
  global String relativeUnit;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Reference native date'
    description='Use one native or ISO source for this value.'
  )
  global Date referenceDate;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Reference native datetime'
    description='Use one native or ISO source for this value.'
  )
  global Datetime referenceInstant;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Reference local time'
    description='Use one native or ISO source for this value.'
  )
  global String referenceTime;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Range end native date'
    description='Use one native or ISO source for this value.'
  )
  global Date endDate;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Range end native datetime'
    description='Use one native or ISO source for this value.'
  )
  global Datetime endInstant;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Range end local time'
    description='Use one native or ISO source for this value.'
  )
  global String endTime;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoFormatValueInput() {
  }
}
