// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Translates one range value family to sortable ticks without mixing local clocks and exact instants. */
public with sharing class ChronoRangeContext {
  public final ChronoOperationValue source;
  public final ChronoIntervals.Span bounds;
  public ChronoRangeContext(ChronoRangeToolsInput input) {
    ChronoSupport.requireValue(input, 'Input');
    source = new ChronoOperationValue(ChronoValueInputs.source(input));
    ChronoSupport.choice(
      source.source.valueType,
      new Set<String>{
        'PlainDate',
        'PlainDateTime',
        'Instant',
        'ZonedDateTime'
      },
      'range value type'
    );
    ChronoConvertInput finish = new ChronoConvertInput();
    finish.valueType = input.valueType;
    finish.value = input.endValue;
    if (source.isExact() && !String.isBlank(input.endValue)) {
      finish.valueType = input.endValue.contains('[')
        ? 'ZonedDateTime'
        : 'Instant';
    }
    finish.dateValue = input.endDate;
    finish.instantValue = input.endInstant;
    finish.timeValue = input.endTime;
    finish.timeZoneId = input.timeZoneId;
    finish.disambiguation = input.disambiguation;
    if (
      finish.valueType == 'PlainDateTime' &&
      String.isBlank(finish.value) &&
      String.isBlank(finish.timeValue)
    ) {
      finish.timeValue = '00:00';
    }
    bounds = ChronoIntervals.span(
      ticks(source),
      ticks(new ChronoOperationValue(finish))
    );
  }
  public Long read(String iso) {
    ChronoConvertInput input = new ChronoConvertInput();
    input.valueType = source.source.valueType;
    input.value = iso;
    input.timeZoneId = source.zoneId;
    // Exact endpoints may interchange UTC/offset and zone-annotated ISO text.
    if (source.isExact()) {
      input.valueType = iso != null && iso.contains('[')
        ? 'ZonedDateTime'
        : 'Instant';
    }
    return ticks(new ChronoOperationValue(input));
  }
  public String text(Long value) {
    Datetime point = Datetime.newInstance(value);
    return (source.isExact()
        ? source.fromInstant(point)
        : source.fromWall(point))
      .value;
  }
  public List<ChronoIntervals.Span> readRanges(List<String> values) {
    List<ChronoIntervals.Span> result = new List<ChronoIntervals.Span>();
    if (values == null) {
      return result;
    }
    if (values.size() > 1000) {
      throw new ChronoException('Supply at most 1000 intervals per request.');
    }
    for (String value : values) {
      List<String> parts = ChronoIntervals.endpoints(value);
      result.add(ChronoIntervals.span(read(parts[0]), read(parts[1])));
    }
    return result;
  }
  public static Long ticks(ChronoOperationValue value) {
    return value.isExact()
      ? value.nativeValue.instantValue.getTime()
      : value.wallClock().getTime();
  }
}
