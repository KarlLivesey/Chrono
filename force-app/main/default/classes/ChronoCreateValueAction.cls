// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Construct a validated value from individual calendar and clock components. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoCreateValueAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    /** @description Value type. */
    @InvocableVariable(label='Value type' description='Value type.')
    global String valueType;
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
  /** @description Construct a validated value from individual calendar and clock components.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Create date/time from components'
    description='Construct a validated value from individual calendar and clock components.'
    category='Chrono: Values'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-create-value-editor'
  )
  global static List<ChronoFlowResult> run(List<Request> requests) {
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    List<ChronoCreateValueInput> inputs = new List<ChronoCreateValueInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (ChronoValueResult item : ChronoValueService.create(inputs)) {
      results.add(ChronoFlowServiceResults.value(item));
    }
    return results;
  }
  private static ChronoCreateValueInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoCreateValueInput item = new ChronoCreateValueInput();
    item.valueType = request.valueType;
    item.year = request.year;
    item.month = request.month;
    item.day = request.day;
    item.hour = request.hour;
    item.minute = request.minute;
    item.second = request.second;
    item.millisecond = request.millisecond;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    return item;
  }
}
