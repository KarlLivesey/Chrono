// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Validate a native or ISO value without failing other interviews. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoValidateValueAction {
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
  /** @description Validate a native or ISO value without failing other interviews.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Validate date/time value'
    description='Validate a native or ISO value without failing other interviews.'
    category='Chrono: Values'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-validate-value-editor'
  )
  global static List<ChronoValidationResult> run(List<Request> requests) {
    List<ChronoValidationResult> results = new List<ChronoValidationResult>();
    List<ChronoValidateValueInput> inputs = new List<ChronoValidateValueInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (ChronoValidationResult item : ChronoValueService.validate(inputs)) {
      results.add(item);
    }
    return results;
  }
  private static ChronoValidateValueInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoValidateValueInput item = new ChronoValidateValueInput();
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
