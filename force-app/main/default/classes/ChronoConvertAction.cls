// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Convert or normalise all eight Chrono value types. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Flow actions in managed packages require global methods.
global with sharing class ChronoConvertAction {
  /** @description Scalar invocable wrapper targeted by Flow Builder extension metadata. */
  global class Request {
    /** @description The Chrono type of the input. */
    @InvocableVariable(
      label='Value type'
      description='The Chrono type of the input.'
      required=true
    )
    global String valueType;
    /** @description ISO representation; provide this or the corresponding native input. */
    @InvocableVariable(
      label='ISO value'
      description='ISO representation; provide this or the corresponding native input.'
    )
    global String value;
    /** @description Native exact instant for Instant or ZonedDateTime inputs. */
    @InvocableVariable(
      label='Native datetime'
      description='Native exact instant for Instant or ZonedDateTime inputs.'
    )
    global Datetime instantValue;
    /** @description Native date for plain date, partial date or plain datetime inputs. */
    @InvocableVariable(
      label='Native date'
      description='Native date for plain date, partial date or plain datetime inputs.'
    )
    global Date dateValue;
    /** @description Local clock time such as 09:30:00.000. */
    @InvocableVariable(
      label='Local time'
      description='Local clock time such as 09:30:00.000.'
    )
    global String timeValue;
    /** @description Output Chrono type; omit to normalise the input type. */
    @InvocableVariable(
      label='Convert to'
      description='Output Chrono type; omit to normalise the input type.'
    )
    global String targetType;
    /** @description Explicit Salesforce time-zone ID; never inferred from the running user. */
    @InvocableVariable(
      label='Time zone'
      description='Explicit Salesforce time-zone ID; never inferred from the running user.'
    )
    global String timeZoneId;
    /** @description reject (default), earlier or later. Skipped local times fail. */
    @InvocableVariable(
      label='Repeated-time policy'
      description='reject (default), earlier or later. Skipped local times fail.'
    )
    global String disambiguation;
    /** @description Supplies the date for a plain time, year for month-day, or day for year-month. */
    @InvocableVariable(
      label='Reference date'
      description='Supplies the date for a plain time, year for month-day, or day for year-month.'
    )
    global Date referenceDate;
    /** @description Clock time to combine with a plain or partial date. */
    @InvocableVariable(
      label='Reference time'
      description='Clock time to combine with a plain or partial date.'
    )
    global String referenceTime;
    /** @description Global constructor for subscriber Flow. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
    private ChronoConvertInput toInput() {
      ChronoConvertInput item = new ChronoConvertInput();
      item.valueType = this.valueType;
      item.value = this.value;
      item.instantValue = this.instantValue;
      item.dateValue = this.dateValue;
      item.timeValue = this.timeValue;
      item.targetType = this.targetType;
      item.timeZoneId = this.timeZoneId;
      item.disambiguation = this.disambiguation;
      item.referenceDate = this.referenceDate;
      item.referenceTime = this.referenceTime;
      return item;
    }
  }

  /** @description Convert or normalise all eight Chrono value types. Bulkified across Flow interviews.
   * @param requests One request per interview.
   * @return One independent result per request, in the same order.
   */
  @InvocableMethod(
    label='Chrono: Convert date/time'
    description='Convert or normalise all eight Chrono value types.'
    category='Chrono'
    iconName='slds:standard:event'
  )
  global static List<ChronoFlowResult> run(List<Request> requests) {
    List<Object> items = new List<Object>();
    if (requests != null) {
      for (Request request : requests) {
        items.add(request == null ? null : request.toInput());
      }
    }
    return new ChronoFlowBatch('Convert').run(items);
  }
}
