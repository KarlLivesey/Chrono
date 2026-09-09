// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Find bounded open windows, shared availability and appointments using native OperatingHours records and holidays. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoAvailabilityCollectionResult {
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  @AuraEnabled
  @InvocableVariable(label='Results')
  global List<ChronoAvailabilityResult> results = new List<ChronoAvailabilityResult>();
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoAvailabilityCollectionResult() {
  }
}
