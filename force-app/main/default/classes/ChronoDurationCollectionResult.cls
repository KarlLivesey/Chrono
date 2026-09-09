// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Construct, inspect, total, balance or scale durations with explicit calendar context. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoDurationCollectionResult {
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  @AuraEnabled
  @InvocableVariable(label='Results')
  global List<ChronoDurationResult> results = new List<ChronoDurationResult>();
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoDurationCollectionResult() {
  }
}
