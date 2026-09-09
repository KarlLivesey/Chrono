// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoFiscalPeriodAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    /** @description Value type. */
    @InvocableVariable(label='Value type' description='Value type.')
    global String valueType;
    /** @description ISO value. */
    @InvocableVariable(label='ISO value' description='ISO value.')
    global String value;
    /** @description Native date. */
    @InvocableVariable(label='Native date' description='Native date.')
    global Date dateValue;
    /** @description Native datetime. */
    @InvocableVariable(label='Native datetime' description='Native datetime.')
    global Datetime instantValue;
    /** @description ISO time for a native date and time input. */
    @InvocableVariable(
      label='Local time'
      description='ISO time for a native date and time input.'
    )
    global String timeValue;
    /** @description Required when resolving local time or inspecting an instant. */
    @InvocableVariable(
      label='Timezone'
      description='Required when resolving local time or inspecting an instant.'
    )
    global String timeZoneId;
    /** @description Repeated-time policy. */
    @InvocableVariable(
      label='Repeated-time policy'
      description='Repeated-time policy.'
    )
    global String disambiguation;
    /** @description Fiscal configuration. */
    @InvocableVariable(
      label='Fiscal configuration'
      description='Fiscal configuration.'
    )
    global String calendarSource;
    /** @description Fiscal period. */
    @InvocableVariable(label='Fiscal period' description='Fiscal period.')
    global String period;
    /** @description 1–12. Used only for a month-based fiscal year. */
    @InvocableVariable(
      label='Fiscal year starts in month'
      description='1–12. Used only for a month-based fiscal year.'
    )
    global Integer startMonth;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Get fiscal period'
    description='Find configured Salesforce fiscal periods or explicit month-based fiscal boundaries.'
    category='Chrono: Calculations'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-fiscal-period-editor'
  )
  global static List<ChronoFiscalResult> run(List<Request> requests) {
    List<ChronoFiscalResult> results = new List<ChronoFiscalResult>();
    List<ChronoFiscalPeriodInput> inputs = new List<ChronoFiscalPeriodInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (ChronoFiscalResult item : ChronoFiscalPeriodService.resolve(inputs)) {
      results.add(item);
    }
    return results;
  }
  private static ChronoFiscalPeriodInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoFiscalPeriodInput item = new ChronoFiscalPeriodInput();
    item.valueType = request.valueType;
    item.value = request.value;
    item.dateValue = request.dateValue;
    item.instantValue = request.instantValue;
    item.timeValue = request.timeValue;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    item.calendarSource = request.calendarSource;
    item.period = request.period;
    item.startMonth = request.startMonth;
    return item;
  }
}
