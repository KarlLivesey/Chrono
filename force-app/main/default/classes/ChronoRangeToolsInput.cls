// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Validate and manipulate half-open ranges: start is included and end is excluded. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoRangeToolsInput {
  /** @description Operation. */
  @AuraEnabled
  @InvocableVariable(label='Operation' description='Operation.')
  global String operation;
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
  /** @description Same value type as the range; a zoned value may use another timezone. */
  @AuraEnabled
  @InvocableVariable(
    label='Point ISO value'
    description='Same value type as the range; a zoned value may use another timezone.'
  )
  global String pointValue;
  /** @description Other range start ISO. */
  @AuraEnabled
  @InvocableVariable(
    label='Other range start ISO'
    description='Other range start ISO.'
  )
  global String otherStart;
  /** @description Other range end ISO. */
  @AuraEnabled
  @InvocableVariable(
    label='Other range end ISO'
    description='Other range end ISO.'
  )
  global String otherEnd;
  /** @description Text collection of start/end intervals; slashes inside zone IDs are supported. */
  @AuraEnabled
  @InvocableVariable(
    label='Other ISO ranges'
    description='Text collection of start/end intervals; slashes inside zone IDs are supported.'
  )
  global List<String> ranges;
  /** @description Positive ISO duration. Calendar units are evaluated at each boundary. */
  @AuraEnabled
  @InvocableVariable(
    label='Split duration'
    description='Positive ISO duration. Calendar units are evaluated at each boundary.'
  )
  global String duration;
  /** @description 1–1000, default 100. Exceeding the limit returns an error, never a partial success. */
  @AuraEnabled
  @InvocableVariable(
    label='Maximum results'
    description='1–1000, default 100. Exceeding the limit returns an error, never a partial success.'
  )
  global Integer maximumResults;
  /** @description One start/end interval per line. Use this or a text collection, not both. */
  @AuraEnabled
  @InvocableVariable(
    label='Fixed ISO ranges'
    description='One start/end interval per line. Use this or a text collection, not both.'
  )
  global String rangesText;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Point native date'
    description='Use one native or ISO source for this value.'
  )
  global Date pointDate;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Point native datetime'
    description='Use one native or ISO source for this value.'
  )
  global Datetime pointInstant;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Point local time'
    description='Use one native or ISO source for this value.'
  )
  global String pointTime;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Other start native date'
    description='Use one native or ISO source for this value.'
  )
  global Date otherStartDate;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Other start native datetime'
    description='Use one native or ISO source for this value.'
  )
  global Datetime otherStartInstant;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Other start local time'
    description='Use one native or ISO source for this value.'
  )
  global String otherStartTime;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Other end native date'
    description='Use one native or ISO source for this value.'
  )
  global Date otherEndDate;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Other end native datetime'
    description='Use one native or ISO source for this value.'
  )
  global Datetime otherEndInstant;
  /** @description Use one native or ISO source for this value. */
  @AuraEnabled
  @InvocableVariable(
    label='Other end local time'
    description='Use one native or ISO source for this value.'
  )
  global String otherEndTime;
  /** @description Required Flow constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoRangeToolsInput() {
  }
}
