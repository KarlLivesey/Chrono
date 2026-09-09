// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Independent Flow output with native and ISO fields. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoValuesResult {
  /** @description Success. */
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  /** @description Error. */
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  /** @description Result ISO values. */
  @AuraEnabled
  @InvocableVariable(label='Result ISO values')
  global List<String> values;
  /** @description Original zero-based indexes. */
  @AuraEnabled
  @InvocableVariable(label='Original zero-based indexes')
  global List<Integer> indexes;
  /** @description Group key for each result value. */
  @AuraEnabled
  @InvocableVariable(label='Group key for each result value')
  global List<String> groupKeys;
  /** @description Input count. */
  @AuraEnabled
  @InvocableVariable(label='Input count')
  global Integer count;
  /** @description Distinct value count. */
  @AuraEnabled
  @InvocableVariable(label='Distinct value count')
  global Integer uniqueCount;
  /** @description Earliest ISO value. */
  @AuraEnabled
  @InvocableVariable(label='Earliest ISO value')
  global String earliestValue;
  /** @description Latest ISO value. */
  @AuraEnabled
  @InvocableVariable(label='Latest ISO value')
  global String latestValue;
  /** @description Selected ISO value. */
  @AuraEnabled
  @InvocableVariable(label='Selected ISO value')
  global String value;
  /** @description Total ISO duration. */
  @AuraEnabled
  @InvocableVariable(label='Total ISO duration')
  global String duration;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoValuesResult() {
  }
}
