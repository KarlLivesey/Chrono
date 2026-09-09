// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Data-only time allocation contract; services validate all supplied fields. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoTimeAllocationRow {
  /** @description Null identifies unallocated time in the segment collection. */
  @AuraEnabled
  @InvocableVariable(
    label='Block key'
    description='Null identifies unallocated time in the segment collection.'
  )
  global String blockKey;
  /** @description Readable block name. */
  @AuraEnabled
  @InvocableVariable(label='Block label' description='Readable block name.')
  global String label;
  /** @description Zoned ISO in elapsed mode; plain ISO in clock mode. Empty on totals. */
  @AuraEnabled
  @InvocableVariable(
    label='Segment start'
    description='Zoned ISO in elapsed mode; plain ISO in clock mode. Empty on totals.'
  )
  global String startValue;
  /** @description Exclusive endpoint in the same representation as the start. */
  @AuraEnabled
  @InvocableVariable(
    label='Segment end'
    description='Exclusive endpoint in the same representation as the start.'
  )
  global String endValue;
  /** @description Duration matched before splitting or rounding. */
  @AuraEnabled
  @InvocableVariable(
    label='Matched milliseconds'
    description='Duration matched before splitting or rounding.'
  )
  global Long matchedMilliseconds;
  /** @description Credited duration after overlap handling and unit allocation. */
  @AuraEnabled
  @InvocableVariable(
    label='Allocated milliseconds'
    description='Credited duration after overlap handling and unit allocation.'
  )
  global Long allocatedMilliseconds;
  /** @description ISO elapsed duration for the credited amount. */
  @AuraEnabled
  @InvocableVariable(
    label='Allocated ISO duration'
    description='ISO elapsed duration for the credited amount.'
  )
  global String allocatedDuration;
  /** @description Empty transport constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoTimeAllocationRow() {
  }
}
