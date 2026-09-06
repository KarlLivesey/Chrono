// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Independent result for one Flow item. Check success before reading value fields. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Flow must construct and inspect this type outside the package.
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
  /** @description Global no-argument constructor required by subscriber Flow. */
  @SuppressWarnings(
    'PMD.EmptyStatementBlock'
  ) // Required global no-argument Flow constructor.
  global ChronoFlowResult() {
  }
  /** @description Copies scalar fields so cached results never escape by reference.
   * @return An independent result.
   */
  public ChronoFlowResult copyResult() {
    ChronoFlowResult result = new ChronoFlowResult();
    result.success = this.success;
    result.errorMessage = this.errorMessage;
    result.valueType = this.valueType;
    result.value = this.value;
    result.instantValue = this.instantValue;
    result.dateValue = this.dateValue;
    result.timeValue = this.timeValue;
    result.timeZoneId = this.timeZoneId;
    result.months = this.months;
    result.days = this.days;
    result.milliseconds = this.milliseconds;
    return result;
  }
  /** @description Creates an explicit per-item failure.
   * @param message Diagnostic message.
   * @return Failed result.
   */
  public static ChronoFlowResult failure(String message) {
    ChronoFlowResult result = new ChronoFlowResult();
    result.success = false;
    result.errorMessage = message;
    return result;
  }
}
