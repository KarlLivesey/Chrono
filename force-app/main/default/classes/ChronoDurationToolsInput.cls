// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Construct, inspect, total, balance or scale durations with explicit calendar context. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoDurationToolsInput {
  /** @description Operation. */
  @AuraEnabled
  @InvocableVariable(label='Operation' description='Operation.')
  global String operation;
  /** @description ISO duration. */
  @AuraEnabled
  @InvocableVariable(label='ISO duration' description='ISO duration.')
  global String value;
  /** @description Result unit. */
  @AuraEnabled
  @InvocableVariable(label='Result unit' description='Result unit.')
  global String unit;
  /** @description Factor. */
  @AuraEnabled
  @InvocableVariable(label='Factor' description='Factor.')
  global Decimal factor;
  /** @description Components preserves calendar units and requires whole calendar results. Elapsed resolves calendar units at the supplied reference. */
  @AuraEnabled
  @InvocableVariable(
    label='Scale using'
    description='Components preserves calendar units and requires whole calendar results. Elapsed resolves calendar units at the supplied reference.'
  )
  global String scalingMode;
  /** @description Years. */
  @AuraEnabled
  @InvocableVariable(label='Years' description='Years.')
  global Integer years;
  /** @description Months. */
  @AuraEnabled
  @InvocableVariable(label='Months' description='Months.')
  global Integer months;
  /** @description Weeks. */
  @AuraEnabled
  @InvocableVariable(label='Weeks' description='Weeks.')
  global Integer weeks;
  /** @description Days. */
  @AuraEnabled
  @InvocableVariable(label='Days' description='Days.')
  global Integer days;
  /** @description Hours. */
  @AuraEnabled
  @InvocableVariable(label='Hours' description='Hours.')
  global Long hours;
  /** @description Minutes. */
  @AuraEnabled
  @InvocableVariable(label='Minutes' description='Minutes.')
  global Long minutes;
  /** @description Seconds. */
  @AuraEnabled
  @InvocableVariable(label='Seconds' description='Seconds.')
  global Decimal seconds;
  /** @description Milliseconds. */
  @AuraEnabled
  @InvocableVariable(label='Milliseconds' description='Milliseconds.')
  global Long milliseconds;
  /** @description Use one reference date or datetime. A date without a timezone uses a plain midnight clock. */
  @AuraEnabled
  @InvocableVariable(
    label='Reference date'
    description='Use one reference date or datetime. A date without a timezone uses a plain midnight clock.'
  )
  global Date referenceDate;
  /** @description Reference datetime. */
  @AuraEnabled
  @InvocableVariable(
    label='Reference datetime'
    description='Reference datetime.'
  )
  global Datetime referenceInstant;
  /** @description Reference timezone. */
  @AuraEnabled
  @InvocableVariable(
    label='Reference timezone'
    description='Reference timezone.'
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
  global ChronoDurationToolsInput() {
  }
}
