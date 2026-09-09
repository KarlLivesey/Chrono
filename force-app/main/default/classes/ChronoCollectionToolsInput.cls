// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoCollectionToolsInput {
  /** @description Operation. */
  @AuraEnabled
  @InvocableVariable(label='Operation' description='Operation.')
  global String operation;
  /** @description Value type. */
  @AuraEnabled
  @InvocableVariable(label='Value type' description='Value type.')
  global String valueType;
  /** @description Ordered ISO text collection, or fixed values with one item per line. */
  @AuraEnabled
  @InvocableVariable(
    label='ISO values'
    description='Ordered ISO text collection, or fixed values with one item per line.'
  )
  global List<String> values;
  /** @description One ISO value per line. */
  @AuraEnabled
  @InvocableVariable(
    label='Fixed ISO values'
    description='One ISO value per line.'
  )
  global String valuesText;
  /** @description Alternative Date collection; do not supply another source. */
  @AuraEnabled
  @InvocableVariable(
    label='Native dates'
    description='Alternative Date collection; do not supply another source.'
  )
  global List<Date> dates;
  /** @description Alternative Datetime collection; do not supply another source. */
  @AuraEnabled
  @InvocableVariable(
    label='Native datetimes'
    description='Alternative Datetime collection; do not supply another source.'
  )
  global List<Datetime> datetimes;
  /** @description Required for exact calendar grouping or zoned native input. */
  @AuraEnabled
  @InvocableVariable(
    label='Calculation timezone'
    description='Required for exact calendar grouping or zoned native input.'
  )
  global String timeZoneId;
  /** @description Required to order durations containing calendar units. */
  @AuraEnabled
  @InvocableVariable(
    label='Duration reference date'
    description='Required to order durations containing calendar units.'
  )
  global Date referenceDate;
  /** @description Sort order. */
  @AuraEnabled
  @InvocableVariable(label='Sort order' description='Sort order.')
  global String direction;
  /** @description Included lower filter boundary. */
  @AuraEnabled
  @InvocableVariable(
    label='Lower ISO value'
    description='Included lower filter boundary.'
  )
  global String lowerValue;
  /** @description Excluded upper filter boundary. */
  @AuraEnabled
  @InvocableVariable(
    label='Upper ISO value'
    description='Excluded upper filter boundary.'
  )
  global String upperValue;
  /** @description Group by. */
  @AuraEnabled
  @InvocableVariable(label='Group by' description='Group by.')
  global String period;
  /** @description 1 is Monday through 7 Sunday; defaults to Monday. */
  @AuraEnabled
  @InvocableVariable(
    label='Week starts on'
    description='1 is Monday through 7 Sunday; defaults to Monday.'
  )
  global Integer weekStartsOn;
  /** @description Nearest to ISO value. */
  @AuraEnabled
  @InvocableVariable(
    label='Nearest to ISO value'
    description='Nearest to ISO value.'
  )
  global String pointValue;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Lower boundary native date'
    description='Use one native or ISO source for this value.'
  )
  global Date lowerDate;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Lower boundary native datetime'
    description='Use one native or ISO source for this value.'
  )
  global Datetime lowerInstant;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Lower boundary local time'
    description='Use one native or ISO source for this value.'
  )
  global String lowerTime;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Upper boundary native date'
    description='Use one native or ISO source for this value.'
  )
  global Date upperDate;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Upper boundary native datetime'
    description='Use one native or ISO source for this value.'
  )
  global Datetime upperInstant;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Upper boundary local time'
    description='Use one native or ISO source for this value.'
  )
  global String upperTime;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Nearest reference native date'
    description='Use one native or ISO source for this value.'
  )
  global Date pointDate;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Nearest reference native datetime'
    description='Use one native or ISO source for this value.'
  )
  global Datetime pointInstant;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Nearest reference local time'
    description='Use one native or ISO source for this value.'
  )
  global String pointTime;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoCollectionToolsInput() {
  }
}
