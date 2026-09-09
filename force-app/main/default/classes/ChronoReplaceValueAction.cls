// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Replace supplied components and preserve other fields. Resolve zoned values explicitly. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoReplaceValueAction {
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
    /** @description Year. */
    @InvocableVariable(label='Year' description='Year.')
    global Integer year;
    /** @description Month. */
    @InvocableVariable(label='Month' description='Month.')
    global Integer month;
    /** @description Day. */
    @InvocableVariable(label='Day' description='Day.')
    global Integer day;
    /** @description Hour. */
    @InvocableVariable(label='Hour' description='Hour.')
    global Integer hour;
    /** @description Minute. */
    @InvocableVariable(label='Minute' description='Minute.')
    global Integer minute;
    /** @description Second. */
    @InvocableVariable(label='Second' description='Second.')
    global Integer second;
    /** @description Millisecond. */
    @InvocableVariable(label='Millisecond' description='Millisecond.')
    global Integer millisecond;
    /** @description Invalid date handling. */
    @InvocableVariable(
      label='Invalid date handling'
      description='Invalid date handling.'
    )
    global String overflow;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Replace supplied components and preserve other fields. Resolve zoned values explicitly.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Replace date/time components'
    description='Replace supplied components and preserve other fields. Resolve zoned values explicitly.'
    category='Chrono: Values'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-replace-value-editor'
  )
  global static List<ChronoFlowResult> run(List<Request> requests) {
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    List<ChronoReplaceValueInput> inputs = new List<ChronoReplaceValueInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (ChronoValueResult item : ChronoValueService.replace(inputs)) {
      results.add(ChronoFlowServiceResults.value(item));
    }
    return results;
  }
  private static ChronoReplaceValueInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoReplaceValueInput item = new ChronoReplaceValueInput();
    item.valueType = request.valueType;
    item.value = request.value;
    item.dateValue = request.dateValue;
    item.instantValue = request.instantValue;
    item.timeValue = request.timeValue;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    item.year = request.year;
    item.month = request.month;
    item.day = request.day;
    item.hour = request.hour;
    item.minute = request.minute;
    item.second = request.second;
    item.millisecond = request.millisecond;
    item.overflow = request.overflow;
    return item;
  }
}
