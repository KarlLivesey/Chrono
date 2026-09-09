// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Flow access to the same occurrence and nearest-gap-boundary rules used by the picker. */
public with sharing class ChronoFlowResolve {
  public static ChronoOperationResult execute(ChronoOperationInput input) {
    ChronoOperationValue value = new ChronoOperationValue(input.source);
    ChronoSupport.choice(
      value.source.valueType,
      new Set<String>{ 'PlainDateTime', 'PlainDate' },
      'local resolution source type'
    );
    String selection = String.isBlank(input.resolution)
      ? 'inspect'
      : input.resolution;
    ChronoSupport.choice(
      selection,
      new Set<String>{ 'inspect', 'earlier', 'later', 'backward', 'forward' },
      'resolution'
    );
    Datetime wall = value.wallClock();
    List<ChronoPickerOption> options = ChronoLocalCandidates.resolveLocal(
      ChronoIso.dateText(wall.dateGmt()),
      ChronoIso.timeText(wall.timeGmt()),
      value.zoneId
    );
    ChronoPickerOption chosen = selected(options, selection);
    ChronoOperationResult result = chosen == null
      ? ChronoOperationResults.success()
      : new ChronoFlowValue(
            'ZonedDateTime',
            ChronoZonedDateTimeService.create(chosen.instantValue, value.zoneId)
          )
          .result();
    describe(result, options, value.zoneId);
    return result;
  }
  private static ChronoPickerOption selected(
    List<ChronoPickerOption> options,
    String selection
  ) {
    for (ChronoPickerOption option : options) {
      if (option.choice == 'exact' || option.choice == selection) {
        return option;
      }
    }
    if (selection != 'inspect') {
      throw new ChronoException(
        'The selected resolution does not apply to this local time. Inspect its candidates first.'
      );
    }
    return null;
  }
  private static void describe(
    ChronoOperationResult result,
    List<ChronoPickerOption> options,
    String zoneId
  ) {
    result.resolutionStatus = options.size() == 1
      ? 'unique'
      : (options[0].choice == 'backward' ? 'nonexistent' : 'repeated');
    for (ChronoPickerOption option : options) {
      String iso = ChronoZonedDateTimeService.toIsoString(
        ChronoZonedDateTimeService.create(option.instantValue, zoneId)
      );
      if (option.choice == 'earlier') {
        result.earlierValue = iso;
      }
      if (option.choice == 'later') {
        result.laterValue = iso;
      }
      if (option.choice == 'backward') {
        result.previousValue = iso;
      }
      if (option.choice == 'forward') {
        result.nextValue = iso;
      }
    }
  }
}
