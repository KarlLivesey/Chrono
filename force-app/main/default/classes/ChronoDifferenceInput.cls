// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description One elapsed-time difference between exact instants. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Flow must construct and inspect this type outside the package.
global with sharing class ChronoDifferenceInput {
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
  /** @description Native ending instant; alternatively use endValue. */
  @AuraEnabled
  @InvocableVariable(
    label='End datetime'
    description='Native ending instant; alternatively use endValue.'
  )
  global Datetime endInstant;
  /** @description ISO Instant or ZonedDateTime string including an offset. */
  @AuraEnabled
  @InvocableVariable(
    label='End ISO instant'
    description='ISO Instant or ZonedDateTime string including an offset.'
  )
  global String endValue;
  /** @description Global no-argument constructor required by subscriber Flow. */
  @SuppressWarnings(
    'PMD.EmptyStatementBlock'
  ) // Required global no-argument Flow constructor.
  global ChronoDifferenceInput() {
  }
}
