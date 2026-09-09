// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Independent Flow output with native and ISO fields. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoFiscalResult {
  /** @description Success. */
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  /** @description Error. */
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  /** @description Salesforce fiscal period ID. */
  @AuraEnabled
  @InvocableVariable(label='Salesforce fiscal period ID')
  global String periodId;
  /** @description Period label. */
  @AuraEnabled
  @InvocableVariable(label='Period label')
  global String label;
  /** @description Fiscal year label. */
  @AuraEnabled
  @InvocableVariable(label='Fiscal year label')
  global String yearLabel;
  /** @description Period number. */
  @AuraEnabled
  @InvocableVariable(label='Period number')
  global Integer periodNumber;
  /** @description First date. */
  @AuraEnabled
  @InvocableVariable(label='First date')
  global Date startDate;
  /** @description Last date. */
  @AuraEnabled
  @InvocableVariable(label='Last date')
  global Date lastDate;
  /** @description Calendar date following the last date; exclusive range endpoint. */
  @AuraEnabled
  @InvocableVariable(label='Exclusive end date')
  global Date endExclusiveDate;
  /** @description Start ISO value. */
  @AuraEnabled
  @InvocableVariable(label='Start ISO value')
  global String startValue;
  /** @description Exclusive end ISO value. */
  @AuraEnabled
  @InvocableVariable(label='Exclusive end ISO value')
  global String endExclusiveValue;
  /** @description Start datetime. */
  @AuraEnabled
  @InvocableVariable(label='Start datetime')
  global Datetime startInstant;
  /** @description Exclusive end datetime. */
  @AuraEnabled
  @InvocableVariable(label='Exclusive end datetime')
  global Datetime endExclusiveInstant;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoFiscalResult() {
  }
}
