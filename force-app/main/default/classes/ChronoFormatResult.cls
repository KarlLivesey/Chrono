// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Independent Flow output with native and ISO fields. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoFormatResult {
  /** @description Success. */
  @AuraEnabled
  @InvocableVariable(label='Success')
  global Boolean success;
  /** @description Error. */
  @AuraEnabled
  @InvocableVariable(label='Error')
  global String errorMessage;
  /** @description Formatted text. */
  @AuraEnabled
  @InvocableVariable(label='Formatted text')
  global String text;
  /** @description Formatted start. */
  @AuraEnabled
  @InvocableVariable(label='Formatted start')
  global String startText;
  /** @description Formatted end. */
  @AuraEnabled
  @InvocableVariable(label='Formatted end')
  global String endText;
  /** @description Context user locale. */
  @AuraEnabled
  @InvocableVariable(label='Context user locale')
  global String locale;
  /** @description Requested style applied. */
  @AuraEnabled
  @InvocableVariable(label='Requested style applied')
  global Boolean styleApplied;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoFormatResult() {
  }
}
