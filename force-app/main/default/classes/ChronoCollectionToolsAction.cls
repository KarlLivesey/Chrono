// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoCollectionToolsAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    /** @description Operation. */
    @InvocableVariable(label='Operation' description='Operation.')
    global String operation;
    /** @description Value type. */
    @InvocableVariable(label='Value type' description='Value type.')
    global String valueType;
    /** @description Ordered ISO text collection, or fixed values with one item per line. */
    @InvocableVariable(
      label='ISO values'
      description='Ordered ISO text collection, or fixed values with one item per line.'
    )
    global List<String> values;
    /** @description One ISO value per line. */
    @InvocableVariable(
      label='Fixed ISO values'
      description='One ISO value per line.'
    )
    global String valuesText;
    /** @description Alternative Date collection; do not supply another source. */
    @InvocableVariable(
      label='Native dates'
      description='Alternative Date collection; do not supply another source.'
    )
    global List<Date> dates;
    /** @description Alternative Datetime collection; do not supply another source. */
    @InvocableVariable(
      label='Native datetimes'
      description='Alternative Datetime collection; do not supply another source.'
    )
    global List<Datetime> datetimes;
    /** @description Required for exact calendar grouping or zoned native input. */
    @InvocableVariable(
      label='Calculation timezone'
      description='Required for exact calendar grouping or zoned native input.'
    )
    global String timeZoneId;
    /** @description Required to order durations containing calendar units. */
    @InvocableVariable(
      label='Duration reference date'
      description='Required to order durations containing calendar units.'
    )
    global Date referenceDate;
    /** @description Sort order. */
    @InvocableVariable(label='Sort order' description='Sort order.')
    global String direction;
    /** @description Included lower filter boundary. */
    @InvocableVariable(
      label='Lower ISO value'
      description='Included lower filter boundary.'
    )
    global String lowerValue;
    /** @description Excluded upper filter boundary. */
    @InvocableVariable(
      label='Upper ISO value'
      description='Excluded upper filter boundary.'
    )
    global String upperValue;
    /** @description Group by. */
    @InvocableVariable(label='Group by' description='Group by.')
    global String period;
    /** @description 1 is Monday through 7 Sunday; defaults to Monday. */
    @InvocableVariable(
      label='Week starts on'
      description='1 is Monday through 7 Sunday; defaults to Monday.'
    )
    global Integer weekStartsOn;
    /** @description Nearest to ISO value. */
    @InvocableVariable(
      label='Nearest to ISO value'
      description='Nearest to ISO value.'
    )
    global String pointValue;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Lower boundary native date'
      description='Use one native or ISO source for this value.'
    )
    global Date lowerDate;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Lower boundary native datetime'
      description='Use one native or ISO source for this value.'
    )
    global Datetime lowerInstant;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Lower boundary local time'
      description='Use one native or ISO source for this value.'
    )
    global String lowerTime;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Upper boundary native date'
      description='Use one native or ISO source for this value.'
    )
    global Date upperDate;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Upper boundary native datetime'
      description='Use one native or ISO source for this value.'
    )
    global Datetime upperInstant;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Upper boundary local time'
      description='Use one native or ISO source for this value.'
    )
    global String upperTime;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Nearest reference native date'
      description='Use one native or ISO source for this value.'
    )
    global Date pointDate;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Nearest reference native datetime'
      description='Use one native or ISO source for this value.'
    )
    global Datetime pointInstant;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Nearest reference local time'
      description='Use one native or ISO source for this value.'
    )
    global String pointTime;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Work with date/time collections'
    description='Order, filter, group and summarise compatible values without exposing immutable Apex objects to Flow.'
    category='Chrono: Collections'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-collection-tools-editor'
  )
  global static List<ChronoValuesResult> run(List<Request> requests) {
    List<ChronoValuesResult> results = new List<ChronoValuesResult>();
    List<ChronoCollectionToolsInput> inputs = new List<ChronoCollectionToolsInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (ChronoValuesResult item : ChronoCollectionService.calculate(inputs)) {
      results.add(item);
    }
    return results;
  }
  private static ChronoCollectionToolsInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoCollectionToolsInput item = new ChronoCollectionToolsInput();
    item.operation = request.operation;
    item.valueType = request.valueType;
    item.values = request.values;
    item.valuesText = request.valuesText;
    item.dates = request.dates;
    item.datetimes = request.datetimes;
    item.timeZoneId = request.timeZoneId;
    item.referenceDate = request.referenceDate;
    item.direction = request.direction;
    item.lowerValue = request.lowerValue;
    item.upperValue = request.upperValue;
    item.period = request.period;
    item.weekStartsOn = request.weekStartsOn;
    item.pointValue = request.pointValue;
    item.lowerDate = request.lowerDate;
    item.lowerInstant = request.lowerInstant;
    item.lowerTime = request.lowerTime;
    item.upperDate = request.upperDate;
    item.upperInstant = request.upperInstant;
    item.upperTime = request.upperTime;
    item.pointDate = request.pointDate;
    item.pointInstant = request.pointInstant;
    item.pointTime = request.pointTime;
    return item;
  }
}
