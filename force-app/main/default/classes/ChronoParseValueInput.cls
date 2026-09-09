// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Parse an explicitly specified numeric date and time pattern without guessing. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoParseValueInput {
  /** @description Value type. */
  @AuraEnabled
  @InvocableVariable(label='Value type' description='Value type.')
  global String valueType;
  /** @description Text to parse. */
  @AuraEnabled
  @InvocableVariable(label='Text to parse' description='Text to parse.')
  global String text;
  /** @description Supported tokens: yyyy MM dd HH mm ss SSS and quoted literal text. */
  @AuraEnabled
  @InvocableVariable(
    label='Input pattern'
    description='Supported tokens: yyyy MM dd HH mm ss SSS and quoted literal text.'
  )
  global String pattern;
  /** @description Required when resolving local time or inspecting an instant. */
  @AuraEnabled
  @InvocableVariable(
    label='Timezone'
    description='Required when resolving local time or inspecting an instant.'
  )
  global String timeZoneId;
  /** @description Repeated-time policy. */
  @AuraEnabled
  @InvocableVariable(
    label='Repeated-time policy'
    description='Repeated-time policy.'
  )
  global String disambiguation;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoParseValueInput() {
  }
}
