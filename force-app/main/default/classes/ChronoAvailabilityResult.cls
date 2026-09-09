// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Independent Flow output with native and ISO fields. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoAvailabilityResult {
  /** @description Success. */
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  /** @description Error. */
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  /** @description Valid schedule. */
  @AuraEnabled
  @InvocableVariable(label='Valid schedule')
  global Boolean isValid;
  /** @description Validation message. */
  @AuraEnabled
  @InvocableVariable(label='Validation message')
  global String validationMessage;
  /** @description Found availability. */
  @AuraEnabled
  @InvocableVariable(label='Found availability')
  global Boolean found;
  /** @description Entire interval is open. */
  @AuraEnabled
  @InvocableVariable(label='Entire interval is open')
  global Boolean containsRange;
  /** @description Open or appointment ISO intervals. */
  @AuraEnabled
  @InvocableVariable(label='Open or appointment ISO intervals')
  global List<String> ranges;
  /** @description Opening zoned ISO values. */
  @AuraEnabled
  @InvocableVariable(label='Opening zoned ISO values')
  global List<String> openingValues;
  /** @description Exclusive closing zoned ISO values. */
  @AuraEnabled
  @InvocableVariable(label='Exclusive closing zoned ISO values')
  global List<String> closingValues;
  /** @description Working dates in primary schedule timezone. */
  @AuraEnabled
  @InvocableVariable(label='Working dates in primary schedule timezone')
  global List<Date> workingDates;
  /** @description Holiday dates in primary schedule timezone. */
  @AuraEnabled
  @InvocableVariable(label='Holiday dates in primary schedule timezone')
  global List<Date> holidayDates;
  /** @description Matching holiday records. */
  @AuraEnabled
  @InvocableVariable(label='Matching holiday records')
  global List<Holiday> holidayRecords;
  /** @description Elapsed open milliseconds. */
  @AuraEnabled
  @InvocableVariable(label='Elapsed open milliseconds')
  global Long milliseconds;
  /** @description Primary schedule timezone. */
  @AuraEnabled
  @InvocableVariable(label='Primary schedule timezone')
  global String timeZoneId;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoAvailabilityResult() {
  }
}
