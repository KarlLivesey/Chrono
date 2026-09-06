// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description One conversion, also usable as an Apex-defined Flow collection item. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Flow must construct and inspect this type outside the package.
global with sharing class ChronoConvertInput {
  /** @description The Chrono type of the input. */
  @AuraEnabled
  @InvocableVariable(
    label='Value type'
    description='The Chrono type of the input.'
    required=true
  )
  global String valueType;
  /** @description ISO representation; provide this or the corresponding native input. */
  @AuraEnabled
  @InvocableVariable(
    label='ISO value'
    description='ISO representation; provide this or the corresponding native input.'
  )
  global String value;
  /** @description Native exact instant for Instant or ZonedDateTime inputs. */
  @AuraEnabled
  @InvocableVariable(
    label='Native datetime'
    description='Native exact instant for Instant or ZonedDateTime inputs.'
  )
  global Datetime instantValue;
  /** @description Native date for plain date, partial date or plain datetime inputs. */
  @AuraEnabled
  @InvocableVariable(
    label='Native date'
    description='Native date for plain date, partial date or plain datetime inputs.'
  )
  global Date dateValue;
  /** @description Local clock time such as 09:30:00.000. */
  @AuraEnabled
  @InvocableVariable(
    label='Local time'
    description='Local clock time such as 09:30:00.000.'
  )
  global String timeValue;
  /** @description Output Chrono type; omit to normalise the input type. */
  @AuraEnabled
  @InvocableVariable(
    label='Convert to'
    description='Output Chrono type; omit to normalise the input type.'
  )
  global String targetType;
  /** @description Explicit Salesforce time-zone ID; never inferred from the running user. */
  @AuraEnabled
  @InvocableVariable(
    label='Time zone'
    description='Explicit Salesforce time-zone ID; never inferred from the running user.'
  )
  global String timeZoneId;
  /** @description reject (default), earlier or later. Skipped local times fail. */
  @AuraEnabled
  @InvocableVariable(
    label='Repeated-time policy'
    description='reject (default), earlier or later. Skipped local times fail.'
  )
  global String disambiguation;
  /** @description Supplies the date for a plain time, year for month-day, or day for year-month. */
  @AuraEnabled
  @InvocableVariable(
    label='Reference date'
    description='Supplies the date for a plain time, year for month-day, or day for year-month.'
  )
  global Date referenceDate;
  /** @description Clock time to combine with a plain or partial date. */
  @AuraEnabled
  @InvocableVariable(
    label='Reference time'
    description='Clock time to combine with a plain or partial date.'
  )
  global String referenceTime;
  /** @description Global no-argument constructor required by subscriber Flow. */
  @SuppressWarnings(
    'PMD.EmptyStatementBlock'
  ) // Required global no-argument Flow constructor.
  global ChronoConvertInput() {
  }
}
