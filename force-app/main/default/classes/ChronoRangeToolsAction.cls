// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Validate and manipulate half-open ranges: start is included and end is excluded. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoRangeToolsAction {
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
    /** @description End ISO value. */
    @InvocableVariable(label='End ISO value' description='End ISO value.')
    global String endValue;
    /** @description End native date. */
    @InvocableVariable(label='End native date' description='End native date.')
    global Date endDate;
    /** @description End native datetime. */
    @InvocableVariable(
      label='End native datetime'
      description='End native datetime.'
    )
    global Datetime endInstant;
    /** @description Optional clock with a native end date. */
    @InvocableVariable(
      label='End local time'
      description='Optional clock with a native end date.'
    )
    global String endTime;
    /** @description Same value type as the range; a zoned value may use another timezone. */
    @InvocableVariable(
      label='Point ISO value'
      description='Same value type as the range; a zoned value may use another timezone.'
    )
    global String pointValue;
    /** @description Other range start ISO. */
    @InvocableVariable(
      label='Other range start ISO'
      description='Other range start ISO.'
    )
    global String otherStart;
    /** @description Other range end ISO. */
    @InvocableVariable(
      label='Other range end ISO'
      description='Other range end ISO.'
    )
    global String otherEnd;
    /** @description Text collection of start/end intervals; slashes inside zone IDs are supported. */
    @InvocableVariable(
      label='Other ISO ranges'
      description='Text collection of start/end intervals; slashes inside zone IDs are supported.'
    )
    global List<String> ranges;
    /** @description Positive ISO duration. Calendar units are evaluated at each boundary. */
    @InvocableVariable(
      label='Split duration'
      description='Positive ISO duration. Calendar units are evaluated at each boundary.'
    )
    global String duration;
    /** @description 1–1000, default 100. Exceeding the limit returns an error, never a partial success. */
    @InvocableVariable(
      label='Maximum results'
      description='1–1000, default 100. Exceeding the limit returns an error, never a partial success.'
    )
    global Integer maximumResults;
    /** @description One start/end interval per line. Use this or a text collection, not both. */
    @InvocableVariable(
      label='Fixed ISO ranges'
      description='One start/end interval per line. Use this or a text collection, not both.'
    )
    global String rangesText;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Point native date'
      description='Use one native or ISO source for this value.'
    )
    global Date pointDate;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Point native datetime'
      description='Use one native or ISO source for this value.'
    )
    global Datetime pointInstant;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Point local time'
      description='Use one native or ISO source for this value.'
    )
    global String pointTime;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Other start native date'
      description='Use one native or ISO source for this value.'
    )
    global Date otherStartDate;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Other start native datetime'
      description='Use one native or ISO source for this value.'
    )
    global Datetime otherStartInstant;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Other start local time'
      description='Use one native or ISO source for this value.'
    )
    global String otherStartTime;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Other end native date'
      description='Use one native or ISO source for this value.'
    )
    global Date otherEndDate;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Other end native datetime'
      description='Use one native or ISO source for this value.'
    )
    global Datetime otherEndInstant;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Other end local time'
      description='Use one native or ISO source for this value.'
    )
    global String otherEndTime;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Validate and manipulate half-open ranges: start is included and end is excluded.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Work with date/time ranges'
    description='Validate and manipulate half-open ranges: start is included and end is excluded.'
    category='Chrono: Ranges'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-range-tools-editor'
  )
  global static List<ChronoRangeResult> run(List<Request> requests) {
    List<ChronoRangeResult> results = new List<ChronoRangeResult>();
    List<ChronoRangeToolsInput> inputs = new List<ChronoRangeToolsInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (ChronoRangeResult item : ChronoRangeService.calculate(inputs)) {
      results.add(item);
    }
    return results;
  }
  private static ChronoRangeToolsInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoRangeToolsInput item = new ChronoRangeToolsInput();
    item.operation = request.operation;
    item.valueType = request.valueType;
    item.value = request.value;
    item.dateValue = request.dateValue;
    item.instantValue = request.instantValue;
    item.timeValue = request.timeValue;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    item.endValue = request.endValue;
    item.endDate = request.endDate;
    item.endInstant = request.endInstant;
    item.endTime = request.endTime;
    item.pointValue = request.pointValue;
    item.otherStart = request.otherStart;
    item.otherEnd = request.otherEnd;
    item.ranges = request.ranges;
    item.duration = request.duration;
    item.maximumResults = request.maximumResults;
    item.rangesText = request.rangesText;
    item.pointDate = request.pointDate;
    item.pointInstant = request.pointInstant;
    item.pointTime = request.pointTime;
    item.otherStartDate = request.otherStartDate;
    item.otherStartInstant = request.otherStartInstant;
    item.otherStartTime = request.otherStartTime;
    item.otherEndDate = request.otherEndDate;
    item.otherEndInstant = request.otherEndInstant;
    item.otherEndTime = request.otherEndTime;
    return item;
  }
}
