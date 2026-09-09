// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Find a calendar period boundary in an explicit timezone where applicable. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Required subscriber Flow request contract.
global with sharing class ChronoPeriodBoundaryInput {
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
  /** @description day, week, month or year. */
  @AuraEnabled
  @InvocableVariable(label='Period' description='day, week, month or year.')
  global String unit;
  /** @description start or end. End is the final millisecond, or final date, in the period. */
  @AuraEnabled
  @InvocableVariable(
    label='Boundary'
    description='start or end. End is the final millisecond, or final date, in the period.'
  )
  global String boundary;
  /** @description ISO weekday: 1 Monday through 7 Sunday. Defaults to Monday. */
  @AuraEnabled
  @InvocableVariable(
    label='Week starts on'
    description='ISO weekday: 1 Monday through 7 Sunday. Defaults to Monday.'
  )
  global Integer weekStartsOn;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoPeriodBoundaryInput() {
  }
}
