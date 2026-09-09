// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Inspect calendar and clock components with an explicit timezone for instants. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoDetailsCollectionResult {
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  @AuraEnabled
  @InvocableVariable(label='Results')
  global List<ChronoDetailsResult> results = new List<ChronoDetailsResult>();
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoDetailsCollectionResult() {
  }
}
