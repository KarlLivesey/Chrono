// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoFormatCollectionResult {
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  @AuraEnabled
  @InvocableVariable(label='Results')
  global List<ChronoFormatResult> results = new List<ChronoFormatResult>();
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoFormatCollectionResult() {
  }
}
