// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Independent result for one Flow item. Check success before reading value fields. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier, PMD.TooManyFields'
) // Flat primitive fields are required by Flow; avoid nested transport objects across package boundaries.
global with sharing class ChronoFlowResult {
  /** @description Whether this item completed successfully. */
  @AuraEnabled
  @InvocableVariable(
    label='Success'
    description='Whether this item completed successfully.'
  )
  global Boolean success;
  /** @description Failure diagnostic for this item; other items can succeed. */
  @AuraEnabled
  @InvocableVariable(
    label='Error'
    description='Failure diagnostic for this item; other items can succeed.'
  )
  global String errorMessage;
  /** @description Chrono type of the result. */
  @AuraEnabled
  @InvocableVariable(
    label='Value type'
    description='Chrono type of the result.'
  )
  global String valueType;
  /** @description Canonical ISO result; usable as input to another Chrono action. */
  @AuraEnabled
  @InvocableVariable(
    label='ISO value'
    description='Canonical ISO result; usable as input to another Chrono action.'
  )
  global String value;
  /** @description Exact instant, when present. */
  @AuraEnabled
  @InvocableVariable(
    label='Native datetime'
    description='Exact instant, when present.'
  )
  global Datetime instantValue;
  /** @description Local date, when present. */
  @AuraEnabled
  @InvocableVariable(label='Local date' description='Local date, when present.')
  global Date dateValue;
  /** @description ISO clock time, when present. */
  @AuraEnabled
  @InvocableVariable(
    label='Local time'
    description='ISO clock time, when present.'
  )
  global String timeValue;
  /** @description Zone of the returned zoned value. */
  @AuraEnabled
  @InvocableVariable(
    label='Time zone'
    description='Zone of the returned zoned value.'
  )
  global String timeZoneId;
  /** @description Calendar months in a duration. */
  @AuraEnabled
  @InvocableVariable(
    label='Calendar months'
    description='Calendar months in a duration.'
  )
  global Integer months;
  /** @description Calendar days in a duration. */
  @AuraEnabled
  @InvocableVariable(
    label='Calendar days'
    description='Calendar days in a duration.'
  )
  global Integer days;
  /** @description Elapsed milliseconds in a duration. */
  @AuraEnabled
  @InvocableVariable(
    label='Elapsed milliseconds'
    description='Elapsed milliseconds in a duration.'
  )
  global Long milliseconds;
  /** @description Whether the value falls in working time; a date asks whether any time is open. */
  @AuraEnabled
  @InvocableVariable(
    label='Is open'
    description='Whether the value falls in working time; a date asks whether any time is open.'
  )
  global Boolean isOpen;
  /** @description -1 before, 0 equal, 1 after. */
  @AuraEnabled
  @InvocableVariable(
    label='Comparison'
    description='-1 before, 0 equal, 1 after.'
  )
  global Integer comparison;
  /** @description unique, repeated or nonexistent. */
  @AuraEnabled
  @InvocableVariable(
    label='Resolution status'
    description='unique, repeated or nonexistent.'
  )
  global String resolutionStatus;
  /** @description First valid zoned ISO occurrence for a repeated time. */
  @AuraEnabled
  @InvocableVariable(
    label='First occurrence'
    description='First valid zoned ISO occurrence for a repeated time.'
  )
  global String earlierValue;
  /** @description Second valid zoned ISO occurrence for a repeated time. */
  @AuraEnabled
  @InvocableVariable(
    label='Second occurrence'
    description='Second valid zoned ISO occurrence for a repeated time.'
  )
  global String laterValue;
  /** @description Nearest valid zoned ISO boundary before a skipped time. */
  @AuraEnabled
  @InvocableVariable(
    label='Previous boundary'
    description='Nearest valid zoned ISO boundary before a skipped time.'
  )
  global String previousValue;
  /** @description Nearest valid zoned ISO boundary after a skipped time. */
  @AuraEnabled
  @InvocableVariable(
    label='Next boundary'
    description='Nearest valid zoned ISO boundary after a skipped time.'
  )
  global String nextValue;
  /** @description Whether the difference is within the supplied tolerance; null when not requested. */
  @AuraEnabled
  @InvocableVariable(label='Within tolerance')
  global Boolean withinTolerance;
  /** @description Whether the values share the requested local calendar period; null when not requested. */
  @AuraEnabled
  @InvocableVariable(label='Same local period')
  global Boolean samePeriod;
  /** @description Global no-argument constructor required by subscriber Flow. */
  @SuppressWarnings(
    'PMD.EmptyStatementBlock'
  ) // Required global no-argument Flow constructor.
  global ChronoFlowResult() {
  }
}
