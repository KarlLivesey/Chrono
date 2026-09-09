// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Convert zones, inspect date-specific offsets and search bounded timezone transitions. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoZoneCollectionResult {
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  @AuraEnabled
  @InvocableVariable(label='Results')
  global List<ChronoZoneResult> results = new List<ChronoZoneResult>();
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoZoneCollectionResult() {
  }
}
