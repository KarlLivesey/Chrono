// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description One calendar or elapsed adjustment. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Flow must construct and inspect this type outside the package.
global with sharing class ChronoAdjustInput {
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
  /** @description Signed ISO duration, for example P1D or -PT2H. Supply this or amount and unit. */
  @AuraEnabled
  @InvocableVariable(
    label='ISO duration'
    description='Signed ISO duration, for example P1D or -PT2H. Supply this or amount and unit.'
  )
  global String duration;
  /** @description Signed whole units to add; negative values subtract. */
  @AuraEnabled
  @InvocableVariable(
    label='Amount'
    description='Signed whole units to add; negative values subtract.'
  )
  global Integer amount;
  /** @description years, months, weeks, days, hours, minutes, seconds or milliseconds. */
  @AuraEnabled
  @InvocableVariable(
    label='Unit'
    description='years, months, weeks, days, hours, minutes, seconds or milliseconds.'
  )
  global String unit;
  /** @description Global no-argument constructor required by subscriber Flow. */
  @SuppressWarnings(
    'PMD.EmptyStatementBlock'
  ) // Required global no-argument Flow constructor.
  global ChronoAdjustInput() {
  }
}
