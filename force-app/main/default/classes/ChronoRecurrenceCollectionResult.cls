// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Find calendar occurrences and generate bounded recurrences, with optional native operating-hour adjustments. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoRecurrenceCollectionResult {
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  @AuraEnabled
  @InvocableVariable(label='Results')
  global List<ChronoRecurrenceResult> results = new List<ChronoRecurrenceResult>();
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoRecurrenceCollectionResult() {
  }
}
