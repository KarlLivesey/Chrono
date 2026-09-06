// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Add time inside Salesforce OperatingHours or BusinessHours, skipping closures and holidays. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Flow actions in managed packages require global methods.
global with sharing class ChronoWorkingTimeAction {
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
    /** @description Explicit zone for the result; availability follows the schedule zone. */
    @InvocableVariable(
      label='Result time zone'
      description='Explicit zone for the result; availability follows the schedule zone.'
      required=true
    )
    global String timeZoneId;
    /** @description Signed whole working units; negative values subtract. */
    @InvocableVariable(
      label='Amount'
      description='Signed whole working units; negative values subtract.'
      required=true
    )
    global Integer amount;
    /** @description hours or minutes. */
    @InvocableVariable(
      label='Unit'
      description='hours or minutes.'
      required=true
    )
    global String unit;
    /** @description OperatingHours or BusinessHours. */
    @InvocableVariable(
      label='Schedule type'
      description='OperatingHours or BusinessHours.'
      required=true
    )
    global String scheduleType;
    /** @description Saved Salesforce schedule record ID. */
    @InvocableVariable(
      label='Schedule record ID'
      description='Saved Salesforce schedule record ID.'
      required=true
    )
    global String scheduleId;
    /** @description Global constructor for subscriber Flow. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
    private ChronoWorkingTimeInput toInput() {
      ChronoWorkingTimeInput item = new ChronoWorkingTimeInput();
      item.startInstant = this.startInstant;
      item.startValue = this.startValue;
      item.timeZoneId = this.timeZoneId;
      item.amount = this.amount;
      item.unit = this.unit;
      item.scheduleType = this.scheduleType;
      item.scheduleId = this.scheduleId;
      return item;
    }
  }

  /** @description Add time inside Salesforce OperatingHours or BusinessHours, skipping closures and holidays. Bulkified across Flow interviews.
   * @param requests One request per interview.
   * @return One independent result per request, in the same order.
   */
  @InvocableMethod(
    label='Chrono: Add or subtract working time'
    description='Add time inside Salesforce OperatingHours or BusinessHours, skipping closures and holidays.'
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
    return new ChronoFlowBatch('WorkingTime').run(items);
  }
}
