// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Construct, inspect, total, balance or scale durations with explicit calendar context. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoDurationToolsAction {
  /** @description Inputs for one Flow interview. */
  global class Request {
    /** @description Operation. */
    @InvocableVariable(label='Operation' description='Operation.')
    global String operation;
    /** @description ISO duration. */
    @InvocableVariable(label='ISO duration' description='ISO duration.')
    global String value;
    /** @description Result unit. */
    @InvocableVariable(label='Result unit' description='Result unit.')
    global String unit;
    /** @description Factor. */
    @InvocableVariable(label='Factor' description='Factor.')
    global Decimal factor;
    /** @description Components preserves calendar units and requires whole calendar results. Elapsed resolves calendar units at the supplied reference. */
    @InvocableVariable(
      label='Scale using'
      description='Components preserves calendar units and requires whole calendar results. Elapsed resolves calendar units at the supplied reference.'
    )
    global String scalingMode;
    /** @description Years. */
    @InvocableVariable(label='Years' description='Years.')
    global Integer years;
    /** @description Months. */
    @InvocableVariable(label='Months' description='Months.')
    global Integer months;
    /** @description Weeks. */
    @InvocableVariable(label='Weeks' description='Weeks.')
    global Integer weeks;
    /** @description Days. */
    @InvocableVariable(label='Days' description='Days.')
    global Integer days;
    /** @description Hours. */
    @InvocableVariable(label='Hours' description='Hours.')
    global Long hours;
    /** @description Minutes. */
    @InvocableVariable(label='Minutes' description='Minutes.')
    global Long minutes;
    /** @description Seconds. */
    @InvocableVariable(label='Seconds' description='Seconds.')
    global Decimal seconds;
    /** @description Milliseconds. */
    @InvocableVariable(label='Milliseconds' description='Milliseconds.')
    global Long milliseconds;
    /** @description Use one reference date or datetime. A date without a timezone uses a plain midnight clock. */
    @InvocableVariable(
      label='Reference date'
      description='Use one reference date or datetime. A date without a timezone uses a plain midnight clock.'
    )
    global Date referenceDate;
    /** @description Reference datetime. */
    @InvocableVariable(
      label='Reference datetime'
      description='Reference datetime.'
    )
    global Datetime referenceInstant;
    /** @description Reference timezone. */
    @InvocableVariable(
      label='Reference timezone'
      description='Reference timezone.'
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
  /** @description Construct, inspect, total, balance or scale durations with explicit calendar context.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Calculate duration'
    description='Construct, inspect, total, balance or scale durations with explicit calendar context.'
    category='Chrono: Durations'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-duration-tools-editor'
  )
  global static List<ChronoDurationResult> run(List<Request> requests) {
    List<ChronoDurationResult> results = new List<ChronoDurationResult>();
    List<ChronoDurationToolsInput> inputs = new List<ChronoDurationToolsInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (
      ChronoDurationResult item : ChronoDurationCalculationService.calculate(
        inputs
      )
    ) {
      results.add(item);
    }
    return results;
  }
  private static ChronoDurationToolsInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoDurationToolsInput item = new ChronoDurationToolsInput();
    item.operation = request.operation;
    item.value = request.value;
    item.unit = request.unit;
    item.factor = request.factor;
    item.scalingMode = request.scalingMode;
    item.years = request.years;
    item.months = request.months;
    item.weeks = request.weeks;
    item.days = request.days;
    item.hours = request.hours;
    item.minutes = request.minutes;
    item.seconds = request.seconds;
    item.milliseconds = request.milliseconds;
    item.referenceDate = request.referenceDate;
    item.referenceInstant = request.referenceInstant;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    return item;
  }
}
