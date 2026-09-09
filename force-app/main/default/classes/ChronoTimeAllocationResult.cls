// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Data-only time allocation contract; services validate all supplied fields. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoTimeAllocationResult {
  /** @description Whether allocation completed. */
  @AuraEnabled
  @InvocableVariable(
    label='Success'
    description='Whether allocation completed.'
  )
  global Boolean success;
  /** @description Failure message; failed requests return no partial allocation. */
  @AuraEnabled
  @InvocableVariable(
    label='Error'
    description='Failure message; failed requests return no partial allocation.'
  )
  global String errorMessage;
  /** @description Timezone used for block clocks and holiday dates. */
  @AuraEnabled
  @InvocableVariable(
    label='Block timezone'
    description='Timezone used for block clocks and holiday dates.'
  )
  global String timeZoneId;
  /** @description elapsed or clock. */
  @AuraEnabled
  @InvocableVariable(label='Time basis' description='elapsed or clock.')
  global String timeBasis;
  /** @description strict, lax, duplicate or split. */
  @AuraEnabled
  @InvocableVariable(
    label='Overlap mode'
    description='strict, lax, duplicate or split.'
  )
  global String overlapMode;
  /** @description millisecond, second or minute. */
  @AuraEnabled
  @InvocableVariable(
    label='Allocation unit'
    description='millisecond, second or minute.'
  )
  global String allocationUnit;
  /** @description Worked duration in the selected time basis. */
  @AuraEnabled
  @InvocableVariable(
    label='Input milliseconds'
    description='Worked duration in the selected time basis.'
  )
  global Long inputMilliseconds;
  /** @description Sum of credited block totals; duplicate mode can exceed worked duration. */
  @AuraEnabled
  @InvocableVariable(
    label='Allocated milliseconds'
    description='Sum of credited block totals; duplicate mode can exceed worked duration.'
  )
  global Long allocatedMilliseconds;
  /** @description Worked time matching no eligible block. */
  @AuraEnabled
  @InvocableVariable(
    label='Unallocated milliseconds'
    description='Worked time matching no eligible block.'
  )
  global Long unallocatedMilliseconds;
  /** @description Extra credited budget caused by duplicate mode before rounding. */
  @AuraEnabled
  @InvocableVariable(
    label='Duplicated milliseconds'
    description='Extra credited budget caused by duplicate mode before rounding.'
  )
  global Long duplicateMilliseconds;
  /** @description Sub-unit remainder not credited; input plus duplicates equals allocated plus unallocated plus remainder. */
  @AuraEnabled
  @InvocableVariable(
    label='Rounding remainder milliseconds'
    description='Sub-unit remainder not credited; input plus duplicates equals allocated plus unallocated plus remainder.'
  )
  global Long roundingMilliseconds;
  /** @description One independent result per block, preserving priority order, including zero totals. */
  @AuraEnabled
  @InvocableVariable(
    label='Block totals'
    description='One independent result per block, preserving priority order, including zero totals.'
  )
  global List<ChronoTimeAllocationRow> totals;
  /** @description Ordered matched or unallocated segments; overlaps produce one row per credited block. */
  @AuraEnabled
  @InvocableVariable(
    label='Contributing segments'
    description='Ordered matched or unallocated segments; overlaps produce one row per credited block.'
  )
  global List<ChronoTimeAllocationRow> segments;
  /** @description Empty transport constructor. */
  @SuppressWarnings('PMD.EmptyStatementBlock')
  global ChronoTimeAllocationResult() {
  }
}
