// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Compare compatible values and return before, equal or after. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier, PMD.TooManyFields'
) // Required subscriber Flow request contract.
global with sharing class ChronoCompareInput {
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
  /** @description Defaults to the source type; exact types can be compared together. */
  @AuraEnabled
  @InvocableVariable(
    label='End value type'
    description='Defaults to the source type; exact types can be compared together.'
  )
  global String endValueType;
  /** @description ISO end value; alternatively use native end fields. */
  @AuraEnabled
  @InvocableVariable(
    label='End ISO value'
    description='ISO end value; alternatively use native end fields.'
  )
  global String endValue;
  /** @description Native exact end instant. */
  @AuraEnabled
  @InvocableVariable(
    label='End native datetime'
    description='Native exact end instant.'
  )
  global Datetime endInstant;
  /** @description Native local end date. */
  @AuraEnabled
  @InvocableVariable(
    label='End native date'
    description='Native local end date.'
  )
  global Date endDate;
  /** @description ISO local time for a native end date/time. */
  @AuraEnabled
  @InvocableVariable(
    label='End local time'
    description='ISO local time for a native end date/time.'
  )
  global String endTime;
  /** @description Required when comparing durations containing calendar units. */
  @AuraEnabled
  @InvocableVariable(
    label='Duration reference date'
    description='Required when comparing durations containing calendar units.'
  )
  global Date referenceDate;
  /** @description Optional non-negative tolerance for complete date, clock, exact or duration values. */
  @AuraEnabled
  @InvocableVariable(
    label='Tolerance in milliseconds'
    description='Optional non-negative tolerance for complete date, clock, exact or duration values.'
  )
  global Long toleranceMilliseconds;
  /** @description Optional day, week, month, quarter or year. Exact values require a common calculation timezone. */
  @AuraEnabled
  @InvocableVariable(
    label='Compare local period'
    description='Optional day, week, month, quarter or year. Exact values require a common calculation timezone.'
  )
  global String comparisonPeriod;
  /** @description 1 is Monday through 7 Sunday. Defaults to Monday. */
  @AuraEnabled
  @InvocableVariable(
    label='Week starts on'
    description='1 is Monday through 7 Sunday. Defaults to Monday.'
  )
  global Integer weekStartsOn;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoCompareInput() {
  }
}
