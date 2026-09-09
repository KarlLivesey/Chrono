// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Adapts supported native/ISO Flow endpoints and fixed/resource block definitions to the native allocation service. */
public with sharing class ChronoTimeAllocation implements ChronoActionOperation {
  public Object evaluate(Object value) {
    return ChronoTimeAllocationService.allocate(
      request((ChronoTimeAllocationInput) value)
    );
  }
  public static ChronoTimeAllocationRequest request(
    ChronoTimeAllocationInput input
  ) {
    ChronoSupport.requireValue(input, 'Allocation input');
    ChronoRangeToolsInput range = ChronoRangeInputs.range(input);
    ChronoRangeContext context = new ChronoRangeContext(range);
    ChronoTimeAllocationRequest request = new ChronoTimeAllocationRequest();
    request.startInstant = endpoint(context, context.bounds.start);
    request.endInstant = endpoint(context, context.bounds.finish);
    request.timeZoneId = input.timeZoneId;
    request.holidays = input.holidays;
    request.overlapMode = input.overlapMode;
    request.timeBasis = input.timeBasis;
    request.allocationUnit = input.allocationUnit;
    request.maximumSegments = input.maximumSegments;
    if (String.isBlank(input.blocksText)) {
      throw new ChronoException(
        'Configure time blocks or supply a block definition Text resource.'
      );
    }
    try {
      request.blocks = (List<ChronoTimeBlock>) JSON.deserializeStrict(
        input.blocksText,
        List<ChronoTimeBlock>.class
      );
    } catch (JSONException ex) {
      throw new ChronoException(
        'Invalid time block definition: ' + ex.getMessage()
      );
    }
    return request;
  }
  private static Datetime endpoint(ChronoRangeContext context, Long ticks) {
    Datetime value = Datetime.newInstance(ticks);
    return context.source.isExact() ? value : context.source.resolve(value);
  }
  public Type resultType() {
    return ChronoTimeAllocationResult.class;
  }
}
