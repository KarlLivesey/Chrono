// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Parse an explicitly specified numeric date and time pattern without guessing. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoParseValueAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    /** @description Value type. */
    @InvocableVariable(label='Value type' description='Value type.')
    global String valueType;
    /** @description Text to parse. */
    @InvocableVariable(label='Text to parse' description='Text to parse.')
    global String text;
    /** @description Supported tokens: yyyy MM dd HH mm ss SSS and quoted literal text. */
    @InvocableVariable(
      label='Input pattern'
      description='Supported tokens: yyyy MM dd HH mm ss SSS and quoted literal text.'
    )
    global String pattern;
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
  /** @description Parse an explicitly specified numeric date and time pattern without guessing.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Parse formatted date/time'
    description='Parse an explicitly specified numeric date and time pattern without guessing.'
    category='Chrono: Values'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-parse-value-editor'
  )
  global static List<ChronoFlowResult> run(List<Request> requests) {
    List<ChronoFlowResult> results = new List<ChronoFlowResult>();
    List<ChronoParseValueInput> inputs = new List<ChronoParseValueInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (ChronoValueResult item : ChronoValueService.parse(inputs)) {
      results.add(ChronoFlowServiceResults.value(item));
    }
    return results;
  }
  private static ChronoParseValueInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoParseValueInput item = new ChronoParseValueInput();
    item.valueType = request.valueType;
    item.text = request.text;
    item.pattern = request.pattern;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    return item;
  }
}
