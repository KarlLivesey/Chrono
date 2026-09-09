// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoTimeAllocationInput {
  /** @description Value type. */
  @AuraEnabled
  @InvocableVariable(label='Value type' description='Value type.')
  global String valueType;
  /** @description ISO value. */
  @AuraEnabled
  @InvocableVariable(label='ISO value' description='ISO value.')
  global String value;
  /** @description Native date. */
  @AuraEnabled
  @InvocableVariable(label='Native date' description='Native date.')
  global Date dateValue;
  /** @description Native datetime. */
  @AuraEnabled
  @InvocableVariable(label='Native datetime' description='Native datetime.')
  global Datetime instantValue;
  /** @description ISO time for a native date and time input. */
  @AuraEnabled
  @InvocableVariable(
    label='Local time'
    description='ISO time for a native date and time input.'
  )
  global String timeValue;
  /** @description Required. All block clocks and supplied holiday dates use this timezone. */
  @AuraEnabled
  @InvocableVariable(
    label='Block timezone'
    description='Required. All block clocks and supplied holiday dates use this timezone.'
  )
  global String timeZoneId;
  /** @description Repeated-time policy. */
  @AuraEnabled
  @InvocableVariable(
    label='Repeated-time policy'
    description='Repeated-time policy.'
  )
  global String disambiguation;
  /** @description End ISO value. */
  @AuraEnabled
  @InvocableVariable(label='End ISO value' description='End ISO value.')
  global String endValue;
  /** @description End native date. */
  @AuraEnabled
  @InvocableVariable(label='End native date' description='End native date.')
  global Date endDate;
  /** @description End native datetime. */
  @AuraEnabled
  @InvocableVariable(
    label='End native datetime'
    description='End native datetime.'
  )
  global Datetime endInstant;
  /** @description Optional clock with a native end date. */
  @AuraEnabled
  @InvocableVariable(
    label='End local time'
    description='Optional clock with a native end date.'
  )
  global String endTime;
  /** @description Ordered named blocks. Configure here or supply the same JSON definition from a Text resource. */
  @AuraEnabled
  @InvocableVariable(
    label='Time blocks'
    description='Ordered named blocks. Configure here or supply the same JSON definition from a Text resource.'
  )
  global String blocksText;
  /** @description Native Holiday record collection, including unsaved or recurring holidays. Dates use the block timezone. */
  @AuraEnabled
  @InvocableVariable(
    label='Bank holidays'
    description='Native Holiday record collection, including unsaved or recurring holidays. Dates use the block timezone.'
  )
  global List<Holiday> holidays;
  /** @description Strict rejects matching overlaps; lax uses the first block; duplicate credits every block; split shares time equally. */
  @AuraEnabled
  @InvocableVariable(
    label='Overlapping blocks'
    description='Strict rejects matching overlaps; lax uses the first block; duplicate credits every block; split shares time equally.'
  )
  global String overlapMode;
  /** @description Default elapsed: actual time. Clock: local endpoint difference, counting skipped clock time and repeated clock time once. */
  @AuraEnabled
  @InvocableVariable(
    label='Count time as'
    description='Default elapsed: actual time. Clock: local endpoint difference, counting skipped clock time and repeated clock time once.'
  )
  global String timeBasis;
  /** @description Default millisecond. Whole units are distributed per segment; remaining units go to earlier blocks. Sub-unit time is reported separately. */
  @AuraEnabled
  @InvocableVariable(
    label='Allocate in units of'
    description='Default millisecond. Whole units are distributed per segment; remaining units go to earlier blocks. Sub-unit time is reported separately.'
  )
  global String allocationUnit;
  /** @description Default 1000; allowed 1–5000. Exceeding the limit fails without partial totals. */
  @AuraEnabled
  @InvocableVariable(
    label='Maximum segment rows'
    description='Default 1000; allowed 1–5000. Exceeding the limit fails without partial totals.'
  )
  global Integer maximumSegments;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoTimeAllocationInput() {
  }
}
