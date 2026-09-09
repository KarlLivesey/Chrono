// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Independent Flow output with native and ISO fields. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoRecurrenceResult {
  /** @description Success. */
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  /** @description Error. */
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  /** @description Occurrence ISO values. */
  @AuraEnabled
  @InvocableVariable(label='Occurrence ISO values')
  global List<String> values;
  /** @description Occurrence local dates. */
  @AuraEnabled
  @InvocableVariable(label='Occurrence local dates')
  global List<Date> dates;
  /** @description First occurrence ISO value. */
  @AuraEnabled
  @InvocableVariable(label='First occurrence ISO value')
  global String value;
  /** @description Result count. */
  @AuraEnabled
  @InvocableVariable(label='Result count')
  global Integer count;
  /** @description Found occurrences. */
  @AuraEnabled
  @InvocableVariable(label='Found occurrences')
  global Boolean found;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoRecurrenceResult() {
  }
}
