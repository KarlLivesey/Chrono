// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Independent Flow output with native and ISO fields. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoZoneResult {
  /** @description Success. */
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  /** @description Error. */
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  /** @description Zoned ISO value. */
  @AuraEnabled
  @InvocableVariable(label='Zoned ISO value')
  global String value;
  /** @description Exact datetime. */
  @AuraEnabled
  @InvocableVariable(label='Exact datetime')
  global Datetime instantValue;
  /** @description Local ISO date and time. */
  @AuraEnabled
  @InvocableVariable(label='Local ISO date and time')
  global String localValue;
  /** @description Timezone. */
  @AuraEnabled
  @InvocableVariable(label='Timezone')
  global String timeZoneId;
  /** @description Actual UTC offset seconds. */
  @AuraEnabled
  @InvocableVariable(label='Actual UTC offset seconds')
  global Integer offsetSeconds;
  /** @description Timezone abbreviation. */
  @AuraEnabled
  @InvocableVariable(label='Timezone abbreviation')
  global String abbreviation;
  /** @description Local value with supplied offset. */
  @AuraEnabled
  @InvocableVariable(label='Local value with supplied offset')
  global String suppliedValue;
  /** @description Offset differs from zone rules. */
  @AuraEnabled
  @InvocableVariable(label='Offset differs from zone rules')
  global Boolean isOverride;
  /** @description Other zoned value. */
  @AuraEnabled
  @InvocableVariable(label='Other zoned value')
  global String otherValue;
  /** @description Other minus source offset seconds. */
  @AuraEnabled
  @InvocableVariable(label='Other minus source offset seconds')
  global Integer offsetDifferenceSeconds;
  /** @description Timezone IDs. */
  @AuraEnabled
  @InvocableVariable(label='Timezone IDs')
  global List<String> timeZoneIds;
  /** @description Transitions as zoned ISO values. */
  @AuraEnabled
  @InvocableVariable(label='Transitions as zoned ISO values')
  global List<String> transitionValues;
  /** @description Offsets before each transition. */
  @AuraEnabled
  @InvocableVariable(label='Offsets before each transition')
  global List<Integer> offsetsBefore;
  /** @description Offsets after each transition. */
  @AuraEnabled
  @InvocableVariable(label='Offsets after each transition')
  global List<Integer> offsetsAfter;
  /** @description Found. */
  @AuraEnabled
  @InvocableVariable(label='Found')
  global Boolean found;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoZoneResult() {
  }
}
