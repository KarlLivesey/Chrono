// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Bulk, user-mode schedule access for working-time checks and navigation. */
public with sharing class ChronoFlowScheduleOps {
  private final ChronoScheduleCatalogue schedules;
  public ChronoFlowScheduleOps(List<Object> requests) {
    List<Object> inputs = new List<Object>();
    for (Object raw : requests) {
      if (raw != null) {
        inputs.add(
          ChronoScheduleInputs.fromOperation((ChronoOperationInput) raw)
        );
      }
    }
    schedules = new ChronoScheduleCatalogue(inputs);
  }
  public ChronoOperationResult execute(
    String family,
    ChronoOperationInput input
  ) {
    ChronoOperationValue value = new ChronoOperationValue(input.source);
    Boolean dateOnly = value.source.valueType == 'PlainDate';
    requireSupported(value);
    Datetime instant = dateOnly ? null : value.resolvedInstant();
    ChronoPickerCalendar calendar = schedules.primary(
        ChronoScheduleInputs.fromOperation(input)
      )
      .picker;
    Date day = dateOnly ? value.nativeValue.dateValue : null;
    Boolean open = calendar.contains(day, instant);
    if (family == 'CheckWorkingTime') {
      ChronoOperationResult result = ChronoOperationResults.success();
      result.isOpen = open;
      return result;
    }
    ChronoSupport.choice(
      input.direction,
      new Set<String>{ 'next', 'previous' },
      'direction'
    );
    if (open) {
      ChronoOperationResult result = dateOnly
        ? value.source.result()
        : value.fromInstant(instant);
      result.isOpen = true;
      return result;
    }
    Datetime nearest = calendar.nearest(
      day,
      instant,
      input.direction == 'previous' ? -1 : 1
    );
    ChronoOperationResult result;
    if (dateOnly) {
      result = new ChronoFlowValue(
          'PlainDate',
          ChronoPlainDateService.create(calendar.localDate(nearest))
        )
        .result();
    } else {
      result = value.fromInstant(nearest);
    }
    result.isOpen = true;
    return result;
  }
  private static void requireSupported(ChronoOperationValue value) {
    ChronoSupport.choice(
      value.source.valueType,
      new Set<String>{
        'PlainDate',
        'PlainDateTime',
        'Instant',
        'ZonedDateTime'
      },
      'working-time source type'
    );
  }
}
