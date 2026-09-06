// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Calculate signed elapsed time between two instants. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Flow actions in managed packages require global methods.
global with sharing class ChronoDifferenceAction {
  /** @description Scalar invocable wrapper targeted by Flow Builder extension metadata. */
  global class Request {
    /** @description Native starting instant; alternatively use startValue. */
    @InvocableVariable(
      label='Start datetime'
      description='Native starting instant; alternatively use startValue.'
    )
    global Datetime startInstant;
    /** @description ISO Instant or ZonedDateTime string including an offset. */
    @InvocableVariable(
      label='Start ISO instant'
      description='ISO Instant or ZonedDateTime string including an offset.'
    )
    global String startValue;
    /** @description Native ending instant; alternatively use endValue. */
    @InvocableVariable(
      label='End datetime'
      description='Native ending instant; alternatively use endValue.'
    )
    global Datetime endInstant;
    /** @description ISO Instant or ZonedDateTime string including an offset. */
    @InvocableVariable(
      label='End ISO instant'
      description='ISO Instant or ZonedDateTime string including an offset.'
    )
    global String endValue;
    /** @description Global constructor for subscriber Flow. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
    private ChronoDifferenceInput toInput() {
      ChronoDifferenceInput item = new ChronoDifferenceInput();
      item.startInstant = this.startInstant;
      item.startValue = this.startValue;
      item.endInstant = this.endInstant;
      item.endValue = this.endValue;
      return item;
    }
  }

  /** @description Calculate signed elapsed time between two instants. Bulkified across Flow interviews.
   * @param requests One request per interview.
   * @return One independent result per request, in the same order.
   */
  @InvocableMethod(
    label='Chrono: Elapsed difference'
    description='Calculate signed elapsed time between two instants.'
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
    return new ChronoFlowBatch('Difference').run(items);
  }
}
