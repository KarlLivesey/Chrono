// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Flat Flow result for validation operations. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoValidationResult {
  /** @description Success. */
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  /** @description Error. */
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  /** @description Is valid. */
  @AuraEnabled
  @InvocableVariable(label='Is valid')
  global Boolean isValid;
  /** @description Value type. */
  @AuraEnabled
  @InvocableVariable(label='Value type')
  global String valueType;
  /** @description Normalised ISO value. */
  @AuraEnabled
  @InvocableVariable(label='Normalised ISO value')
  global String value;
  /** @description Validation message. */
  @AuraEnabled
  @InvocableVariable(label='Validation message')
  global String validationMessage;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoValidationResult() {
  }
}
