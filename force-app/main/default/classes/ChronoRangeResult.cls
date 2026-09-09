// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Independent Flow output with native and ISO fields. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoRangeResult {
  /** @description Success. */
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  /** @description Error. */
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  /** @description Valid range. */
  @AuraEnabled
  @InvocableVariable(label='Valid range')
  global Boolean isValid;
  /** @description Validation message. */
  @AuraEnabled
  @InvocableVariable(label='Validation message')
  global String validationMessage;
  /** @description Contains point. */
  @AuraEnabled
  @InvocableVariable(label='Contains point')
  global Boolean containsValue;
  /** @description Range relationship. */
  @AuraEnabled
  @InvocableVariable(label='Range relationship')
  global String relationship;
  /** @description Start ISO value. */
  @AuraEnabled
  @InvocableVariable(label='Start ISO value')
  global String startValue;
  /** @description Exclusive end ISO value. */
  @AuraEnabled
  @InvocableVariable(label='Exclusive end ISO value')
  global String endValue;
  /** @description Point ISO value. */
  @AuraEnabled
  @InvocableVariable(label='Point ISO value')
  global String value;
  /** @description Result ISO ranges. */
  @AuraEnabled
  @InvocableVariable(label='Result ISO ranges')
  global List<String> ranges;
  /** @description Covered milliseconds. */
  @AuraEnabled
  @InvocableVariable(label='Covered milliseconds')
  global Long milliseconds;
  /** @description Covered ISO duration. */
  @AuraEnabled
  @InvocableVariable(label='Covered ISO duration')
  global String duration;
  /** @description Coverage percent. */
  @AuraEnabled
  @InvocableVariable(label='Coverage percent')
  global Decimal coveragePercent;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoRangeResult() {
  }
}
