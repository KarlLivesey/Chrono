// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description One schedule-aware calculation. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Flow must construct and inspect this type outside the package.
global with sharing class ChronoWorkingTimeInput {
  /** @description Native starting instant; alternatively use startValue. */
  @AuraEnabled
  @InvocableVariable(
    label='Start datetime'
    description='Native starting instant; alternatively use startValue.'
  )
  global Datetime startInstant;
  /** @description ISO Instant or ZonedDateTime string including an offset. */
  @AuraEnabled
  @InvocableVariable(
    label='Start ISO instant'
    description='ISO Instant or ZonedDateTime string including an offset.'
  )
  global String startValue;
  /** @description Explicit zone for the result; availability follows the schedule zone. */
  @AuraEnabled
  @InvocableVariable(
    label='Result time zone'
    description='Explicit zone for the result; availability follows the schedule zone.'
    required=true
  )
  global String timeZoneId;
  /** @description Signed whole working units; negative values subtract. */
  @AuraEnabled
  @InvocableVariable(
    label='Amount'
    description='Signed whole working units; negative values subtract.'
    required=true
  )
  global Integer amount;
  /** @description hours or minutes. */
  @AuraEnabled
  @InvocableVariable(label='Unit' description='hours or minutes.' required=true)
  global String unit;
  /** @description OperatingHours or BusinessHours. */
  @AuraEnabled
  @InvocableVariable(
    label='Schedule type'
    description='OperatingHours or BusinessHours.'
    required=true
  )
  global String scheduleType;
  /** @description Saved Salesforce schedule record ID. */
  @AuraEnabled
  @InvocableVariable(
    label='Schedule record ID'
    description='Saved Salesforce schedule record ID.'
    required=true
  )
  global String scheduleId;
  /** @description Global no-argument constructor required by subscriber Flow. */
  @SuppressWarnings(
    'PMD.EmptyStatementBlock'
  ) // Required global no-argument Flow constructor.
  global ChronoWorkingTimeInput() {
  }
}
