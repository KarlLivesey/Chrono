// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoFormatValueAction {
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
    /** @description Component order and names follow the context user locale. Gregorian years always use four digits. */
    @InvocableVariable(
      label='Display length'
      description='Component order and names follow the context user locale. Gregorian years always use four digits.'
    )
    global String style;
    /** @description Optional Apex date-format pattern. Overrides display length; parsing never guesses this pattern. */
    @InvocableVariable(
      label='Explicit output pattern'
      description='Optional Apex date-format pattern. Overrides display length; parsing never guesses this pattern.'
    )
    global String pattern;
    /** @description Append timezone offset and ID. */
    @InvocableVariable(
      label='Append timezone offset and ID'
      description='Append timezone offset and ID.'
    )
    global Boolean includeZone;
    /** @description The same value family as the start. */
    @InvocableVariable(
      label='Range end ISO value'
      description='The same value family as the start.'
    )
    global String endValue;
    /** @description Defaults to an en dash. */
    @InvocableVariable(
      label='Range separator'
      description='Defaults to an en dash.'
    )
    global String separator;
    /** @description ISO is language-neutral; compact uses unit symbols and long uses English unit names. */
    @InvocableVariable(
      label='Duration style'
      description='ISO is language-neutral; compact uses unit symbols and long uses English unit names.'
    )
    global String durationStyle;
    /** @description Supply a reference of the same type, or another exact value. */
    @InvocableVariable(
      label='Relative reference ISO value'
      description='Supply a reference of the same type, or another exact value.'
    )
    global String referenceValue;
    /** @description Auto chooses elapsed seconds, minutes, hours or 24-hour days. */
    @InvocableVariable(
      label='Relative elapsed unit'
      description='Auto chooses elapsed seconds, minutes, hours or 24-hour days.'
    )
    global String relativeUnit;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Reference native date'
      description='Use one native or ISO source for this value.'
    )
    global Date referenceDate;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Reference native datetime'
      description='Use one native or ISO source for this value.'
    )
    global Datetime referenceInstant;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Reference local time'
      description='Use one native or ISO source for this value.'
    )
    global String referenceTime;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Range end native date'
      description='Use one native or ISO source for this value.'
    )
    global Date endDate;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Range end native datetime'
      description='Use one native or ISO source for this value.'
    )
    global Datetime endInstant;
    /** @description Use one native or ISO source for this value. */
    @InvocableVariable(
      label='Range end local time'
      description='Use one native or ISO source for this value.'
    )
    global String endTime;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Format date/time for display'
    description='Format native or ISO values with locale-aware display lengths, explicit patterns and clear duration output.'
    category='Chrono: Formatting'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-format-value-editor'
  )
  global static List<ChronoFormatResult> run(List<Request> requests) {
    List<ChronoFormatResult> results = new List<ChronoFormatResult>();
    List<ChronoFormatValueInput> inputs = new List<ChronoFormatValueInput>();
    if (requests != null) {
      for (Request request : requests) {
        inputs.add(copyInput(request));
      }
    }
    for (ChronoFormatResult item : ChronoFormattingService.format(inputs)) {
      results.add(item);
    }
    return results;
  }
  private static ChronoFormatValueInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoFormatValueInput item = new ChronoFormatValueInput();
    item.operation = request.operation;
    item.valueType = request.valueType;
    item.value = request.value;
    item.dateValue = request.dateValue;
    item.instantValue = request.instantValue;
    item.timeValue = request.timeValue;
    item.timeZoneId = request.timeZoneId;
    item.disambiguation = request.disambiguation;
    item.style = request.style;
    item.pattern = request.pattern;
    item.includeZone = request.includeZone;
    item.endValue = request.endValue;
    item.separator = request.separator;
    item.durationStyle = request.durationStyle;
    item.referenceValue = request.referenceValue;
    item.relativeUnit = request.relativeUnit;
    item.referenceDate = request.referenceDate;
    item.referenceInstant = request.referenceInstant;
    item.referenceTime = request.referenceTime;
    item.endDate = request.endDate;
    item.endInstant = request.endInstant;
    item.endTime = request.endTime;
    return item;
  }
}
