// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Add calendar or elapsed units to a Chrono value. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Flow actions in managed packages require global methods.
global with sharing class ChronoAdjustAction {
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
    /** @description Signed ISO duration, for example P1D or -PT2H. Supply this or amount and unit. */
    @InvocableVariable(
      label='ISO duration'
      description='Signed ISO duration, for example P1D or -PT2H. Supply this or amount and unit.'
    )
    global String duration;
    /** @description Signed whole units to add; negative values subtract. */
    @InvocableVariable(
      label='Amount'
      description='Signed whole units to add; negative values subtract.'
    )
    global Integer amount;
    /** @description years, months, weeks, days, hours, minutes, seconds or milliseconds. */
    @InvocableVariable(
      label='Unit'
      description='years, months, weeks, days, hours, minutes, seconds or milliseconds.'
    )
    global String unit;
    /** @description Global constructor for subscriber Flow. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
    private ChronoAdjustInput toInput() {
      ChronoAdjustInput item = new ChronoAdjustInput();
      item.valueType = this.valueType;
      item.value = this.value;
      item.instantValue = this.instantValue;
      item.dateValue = this.dateValue;
      item.timeValue = this.timeValue;
      item.timeZoneId = this.timeZoneId;
      item.disambiguation = this.disambiguation;
      item.duration = this.duration;
      item.amount = this.amount;
      item.unit = this.unit;
      return item;
    }
  }

  /** @description Add calendar or elapsed units to a Chrono value. Bulkified across Flow interviews.
   * @param requests One request per interview.
   * @return One independent result per request, in the same order.
   */
  @InvocableMethod(
    label='Chrono: Add or subtract time'
    description='Add calendar or elapsed units to a Chrono value.'
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
    return new ChronoFlowBatch('Adjust').run(items);
  }
}
