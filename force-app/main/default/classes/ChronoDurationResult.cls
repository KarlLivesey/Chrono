// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Flat duration calculation outputs. Calendar and elapsed components remain distinct. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoDurationResult {
  /** @description Success. */
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  /** @description Error. */
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  /** @description ISO duration. */
  @AuraEnabled
  @InvocableVariable(label='ISO duration')
  global String value;
  /** @description Total calendar months. */
  @AuraEnabled
  @InvocableVariable(label='Total calendar months')
  global Integer months;
  /** @description Total calendar days. */
  @AuraEnabled
  @InvocableVariable(label='Total calendar days')
  global Integer days;
  /** @description Elapsed milliseconds. */
  @AuraEnabled
  @InvocableVariable(label='Elapsed milliseconds')
  global Long milliseconds;
  /** @description Whole calendar years. */
  @AuraEnabled
  @InvocableVariable(label='Whole calendar years')
  global Integer years;
  /** @description Remaining months. */
  @AuraEnabled
  @InvocableVariable(label='Remaining months')
  global Integer remainingMonths;
  /** @description Whole calendar weeks. */
  @AuraEnabled
  @InvocableVariable(label='Whole calendar weeks')
  global Integer weeks;
  /** @description Remaining days. */
  @AuraEnabled
  @InvocableVariable(label='Remaining days')
  global Integer remainingDays;
  /** @description Whole elapsed hours. */
  @AuraEnabled
  @InvocableVariable(label='Whole elapsed hours')
  global Long hours;
  /** @description Remaining minutes. */
  @AuraEnabled
  @InvocableVariable(label='Remaining minutes')
  global Integer minutes;
  /** @description Remaining seconds. */
  @AuraEnabled
  @InvocableVariable(label='Remaining seconds')
  global Integer seconds;
  /** @description Remaining milliseconds. */
  @AuraEnabled
  @InvocableVariable(label='Remaining milliseconds')
  global Integer millisecondPart;
  /** @description Total in result unit. */
  @AuraEnabled
  @InvocableVariable(label='Total in result unit')
  global Decimal total;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoDurationResult() {
  }
}
