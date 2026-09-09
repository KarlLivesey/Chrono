// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Inspect calendar and clock components with an explicit timezone for instants. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoValueDetailsAction {
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
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Inspect calendar and clock components with an explicit timezone for instants.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Get date/time details'
    description='Inspect calendar and clock components with an explicit timezone for instants.'
    category='Chrono: Values'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-value-details-editor'
  )
  global static List<ChronoDetailsResult> run(List<Request> requests) {
    List<ChronoDetailsResult> results = new List<ChronoDetailsResult>();
    List<ChronoValueDetailsInput> inputs = new List<ChronoValueDetailsInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (ChronoDetailsResult item : ChronoValueService.details(inputs)) {
      results.add(item);
    }
    return results;
  }
  private static ChronoValueDetailsInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoValueDetailsInput item = new ChronoValueDetailsInput();
    item.valueType = request.valueType;
    item.value = request.value;
    item.dateValue = request.dateValue;
    item.instantValue = request.instantValue;
    item.timeValue = request.timeValue;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    return item;
  }
}
