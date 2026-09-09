// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoTimeAllocationCollectionResult {
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  @AuraEnabled
  @InvocableVariable(label='Results')
  global List<ChronoTimeAllocationResult> results = new List<ChronoTimeAllocationResult>();
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoTimeAllocationCollectionResult() {
  }
}
