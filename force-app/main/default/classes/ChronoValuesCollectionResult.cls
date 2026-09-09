// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoValuesCollectionResult {
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  @AuraEnabled
  @InvocableVariable(label='Results')
  global List<ChronoValuesResult> results = new List<ChronoValuesResult>();
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoValuesCollectionResult() {
  }
}
