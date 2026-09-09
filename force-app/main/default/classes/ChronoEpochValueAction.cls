// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Convert an exact value to or from Unix seconds or milliseconds. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoEpochValueAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    /** @description Operation. */
    @InvocableVariable(label='Operation' description='Operation.')
    global String operation;
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
    /** @description Unix timestamp. */
    @InvocableVariable(label='Unix timestamp' description='Unix timestamp.')
    global Decimal epochValue;
    /** @description Timestamp unit. */
    @InvocableVariable(label='Timestamp unit' description='Timestamp unit.')
    global String epochUnit;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Convert an exact value to or from Unix seconds or milliseconds.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Convert Unix timestamp'
    description='Convert an exact value to or from Unix seconds or milliseconds.'
    category='Chrono: Values'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-epoch-value-editor'
  )
  global static List<ChronoEpochResult> run(List<Request> requests) {
    List<ChronoEpochResult> results = new List<ChronoEpochResult>();
    List<ChronoEpochValueInput> inputs = new List<ChronoEpochValueInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (ChronoEpochResult item : ChronoValueService.convertEpoch(inputs)) {
      results.add(item);
    }
    return results;
  }
  private static ChronoEpochValueInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoEpochValueInput item = new ChronoEpochValueInput();
    item.operation = request.operation;
    item.valueType = request.valueType;
    item.value = request.value;
    item.dateValue = request.dateValue;
    item.instantValue = request.instantValue;
    item.timeValue = request.timeValue;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    item.epochValue = request.epochValue;
    item.epochUnit = request.epochUnit;
    return item;
  }
}
