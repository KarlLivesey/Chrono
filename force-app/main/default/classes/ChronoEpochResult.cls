// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Flat Flow result for epoch operations. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoEpochResult {
  /** @description Success. */
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  /** @description Error. */
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  /** @description ISO value. */
  @AuraEnabled
  @InvocableVariable(label='ISO value')
  global String value;
  /** @description Native datetime. */
  @AuraEnabled
  @InvocableVariable(label='Native datetime')
  global Datetime instantValue;
  /** @description Unix timestamp. */
  @AuraEnabled
  @InvocableVariable(label='Unix timestamp')
  global Decimal epochValue;
  /** @description Timestamp unit. */
  @AuraEnabled
  @InvocableVariable(label='Timestamp unit')
  global String epochUnit;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoEpochResult() {
  }
}
