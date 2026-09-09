// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules. */
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.TooManyFields')
global with sharing class ChronoTimeAllocationAction {
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
    /** @description Required. All block clocks and supplied holiday dates use this timezone. */
    @InvocableVariable(
      label='Block timezone'
      description='Required. All block clocks and supplied holiday dates use this timezone.'
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
    /** @description Ordered named blocks. Configure here or supply the same JSON definition from a Text resource. */
    @InvocableVariable(
      label='Time blocks'
      description='Ordered named blocks. Configure here or supply the same JSON definition from a Text resource.'
    )
    global String blocksText;
    /** @description Native Holiday record collection, including unsaved or recurring holidays. Dates use the block timezone. */
    @InvocableVariable(
      label='Bank holidays'
      description='Native Holiday record collection, including unsaved or recurring holidays. Dates use the block timezone.'
    )
    global List<Holiday> holidays;
    /** @description Strict rejects matching overlaps; lax uses the first block; duplicate credits every block; split shares time equally. */
    @InvocableVariable(
      label='Overlapping blocks'
      description='Strict rejects matching overlaps; lax uses the first block; duplicate credits every block; split shares time equally.'
    )
    global String overlapMode;
    /** @description Default elapsed: actual time. Clock: local endpoint difference, counting skipped clock time and repeated clock time once. */
    @InvocableVariable(
      label='Count time as'
      description='Default elapsed: actual time. Clock: local endpoint difference, counting skipped clock time and repeated clock time once.'
    )
    global String timeBasis;
    /** @description Default millisecond. Whole units are distributed per segment; remaining units go to earlier blocks. Sub-unit time is reported separately. */
    @InvocableVariable(
      label='Allocate in units of'
      description='Default millisecond. Whole units are distributed per segment; remaining units go to earlier blocks. Sub-unit time is reported separately.'
    )
    global String allocationUnit;
    /** @description Default 1000; allowed 1–5000. Exceeding the limit fails without partial totals. */
    @InvocableVariable(
      label='Maximum segment rows'
      description='Default 1000; allowed 1–5000. Exceeding the limit fails without partial totals.'
    )
    global Integer maximumSegments;
    /** @description Required Flow constructor. */
    @SuppressWarnings('PMD.EmptyStatementBlock')
    global Request() {
    }
  }
  /** @description Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.
   * @param requests One request per interview.
   * @return Independent ordered results with per-item errors. */
  @InvocableMethod(
    label='Chrono: Allocate time to blocks'
    description='Break worked time into named weekday and holiday blocks with explicit overlap and rounding rules.'
    category='Chrono: Time allocation'
    iconName='slds:standard:event'
    configurationEditor='skel-chrono-time-allocation-editor'
  )
  global static List<ChronoTimeAllocationResult> run(List<Request> requests) {
    List<ChronoTimeAllocationResult> results = new List<ChronoTimeAllocationResult>();
    if (requests == null) {
      return results;
    }
    List<ChronoTimeAllocationInput> flat = new List<ChronoTimeAllocationInput>();
    for (Request request : requests) {
      flat.add(copyInput(request));
    }
    for (
      ChronoTimeAllocationResult value : ChronoFlowAllocation.allocate(flat)
    ) {
      results.add(value);
    }
    return results;
  }
  private static ChronoTimeAllocationInput copyInput(Request request) {
    if (request == null) {
      return null;
    }
    ChronoTimeAllocationInput item = new ChronoTimeAllocationInput();
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
    item.blocksText = request.blocksText;
    item.holidays = request.holidays;
    item.overlapMode = request.overlapMode;
    item.timeBasis = request.timeBasis;
    item.allocationUnit = request.allocationUnit;
    item.maximumSegments = request.maximumSegments;
    return item;
  }
}
