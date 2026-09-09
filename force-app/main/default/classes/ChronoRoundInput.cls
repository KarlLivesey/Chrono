// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Round to a clock increment or a calendar-day boundary. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Required subscriber Flow request contract.
global with sharing class ChronoRoundInput {
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
  /** @description day, hour, minute, second or millisecond. */
  @AuraEnabled
  @InvocableVariable(
    label='Unit'
    description='day, hour, minute, second or millisecond.'
  )
  global String unit;
  /** @description Positive increment dividing its parent unit; defaults to 1. */
  @AuraEnabled
  @InvocableVariable(
    label='Increment'
    description='Positive increment dividing its parent unit; defaults to 1.'
  )
  global Integer increment;
  /** @description floor, ceil or halfExpand (nearest, ties away from zero). Defaults to halfExpand. */
  @AuraEnabled
  @InvocableVariable(
    label='Rounding mode'
    description='floor, ceil or halfExpand (nearest, ties away from zero). Defaults to halfExpand.'
  )
  global String roundingMode;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoRoundInput() {
  }
}
