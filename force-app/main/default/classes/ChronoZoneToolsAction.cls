// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Convert zones, inspect date-specific offsets and search bounded timezone transitions. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoZoneToolsAction {
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
    /** @description Target timezone. */
    @InvocableVariable(label='Target timezone' description='Target timezone.')
    global String targetTimeZoneId;
    /** @description Keep. */
    @InvocableVariable(label='Keep' description='Keep.')
    global String conversionMode;
    /** @description An explicit signed offset such as +01:00. The result also includes the actual zone projection. */
    @InvocableVariable(
      label='Supplied UTC offset'
      description='An explicit signed offset such as +01:00. The result also includes the actual zone projection.'
    )
    global String suppliedOffset;
    /** @description Filter timezone IDs. */
    @InvocableVariable(
      label='Filter timezone IDs'
      description='Filter timezone IDs.'
    )
    global String search;
    /** @description Exclusive end for listing transitions. Searches are limited to 366 days. */
    @InvocableVariable(
      label='Search end'
      description='Exclusive end for listing transitions. Searches are limited to 366 days.'
    )
    global Datetime endInstant;
    /** @description 1–366 days for next or previous transition. Defaults to 366. */
    @InvocableVariable(
      label='Search days'
      description='1–366 days for next or previous transition. Defaults to 366.'
    )
    global Integer searchDays;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Convert zones, inspect date-specific offsets and search bounded timezone transitions.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Work with timezones'
    description='Convert zones, inspect date-specific offsets and search bounded timezone transitions.'
    category='Chrono: Time Zones'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-zone-tools-editor'
  )
  global static List<ChronoZoneResult> run(List<Request> requests) {
    List<ChronoZoneResult> results = new List<ChronoZoneResult>();
    List<ChronoZoneToolsInput> inputs = new List<ChronoZoneToolsInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (ChronoZoneResult item : ChronoTimeZoneService.calculate(inputs)) {
      results.add(item);
    }
    return results;
  }
  private static ChronoZoneToolsInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoZoneToolsInput item = new ChronoZoneToolsInput();
    item.operation = request.operation;
    item.valueType = request.valueType;
    item.value = request.value;
    item.dateValue = request.dateValue;
    item.instantValue = request.instantValue;
    item.timeValue = request.timeValue;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    item.targetTimeZoneId = request.targetTimeZoneId;
    item.conversionMode = request.conversionMode;
    item.suppliedOffset = request.suppliedOffset;
    item.search = request.search;
    item.endInstant = request.endInstant;
    item.searchDays = request.searchDays;
    return item;
  }
}
