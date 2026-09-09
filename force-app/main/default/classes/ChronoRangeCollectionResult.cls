// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Validate and manipulate half-open ranges: start is included and end is excluded. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoRangeCollectionResult {
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  @AuraEnabled
  @InvocableVariable(label='Results')
  global List<ChronoRangeResult> results = new List<ChronoRangeResult>();
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoRangeCollectionResult() {
  }
}
