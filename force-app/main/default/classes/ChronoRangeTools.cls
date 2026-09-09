// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Range operations preserve source value type, timezone rules and exclusive upper bounds. */
public with sharing class ChronoRangeTools implements ChronoActionOperation { // NOPMD -- Aggregate complexity covers distinct interval operations; method limits remain enforced.
  public static ChronoRangeResult execute(ChronoRangeToolsInput input) {
    ChronoSupport.requireValue(input, 'Input');
    if (!String.isBlank(input.rangesText)) {
      if (input.ranges != null) {
        throw new ChronoException(
          'Use fixed ranges or a collection, not both.'
        );
      }
      input = (ChronoRangeToolsInput) JSON.deserialize(
        JSON.serialize(input),
        ChronoRangeToolsInput.class
      );
      input.ranges = input.rangesText.trim().split('[\\r\\n]+');
    }
    if (input.operation == 'validate') {
      return validate(input);
    }
    ChronoRangeContext context = new ChronoRangeContext(input);
    ChronoRangeResult result = new ChronoRangeResult();
    result.success = true;
    result.isValid = true;
    result.startValue = context.text(context.bounds.start);
    result.endValue = context.text(context.bounds.finish);
    List<ChronoIntervals.Span> spans = calculate(input, context, result);
    Integer maximum = ChronoIntervals.resultLimit(input.maximumResults);
    if (spans.size() > maximum) {
      throw new ChronoException(
        'Result limit exceeded. Increase maximum results or narrow the range.'
      );
    }
    result.ranges = new List<String>();
    for (ChronoIntervals.Span span : spans) {
      result.ranges.add(
        context.text(span.start) + '/' + context.text(span.finish)
      );
    }
    result.milliseconds = ChronoIntervals.length(spans);
    result.duration = ChronoDurationService.toIsoString(
      ChronoDurationService.create(0, 0, result.milliseconds)
    );
    return result;
  }
  private static List<ChronoIntervals.Span> calculate(
    ChronoRangeToolsInput input,
    ChronoRangeContext context,
    ChronoRangeResult result
  ) {
    List<ChronoIntervals.Span> base = new List<ChronoIntervals.Span>{
      context.bounds
    };
    switch on input.operation {
      when 'contains', 'clamp' {
        point(input, context, result);
        return base;
      }
      when 'relationship', 'intersection' {
        ChronoIntervals.Span other = ChronoIntervals.span(
          context.read(
            ChronoAuxiliaryValue.read(input, 'otherStart', context.source)
          ),
          context.read(
            ChronoAuxiliaryValue.read(input, 'otherEnd', context.source)
          )
        );
        result.relationship = relationship(context.bounds, other);
        return ChronoIntervals.intersect(
          base,
          new List<ChronoIntervals.Span>{ other }
        );
      }
      when 'merge' {
        base.addAll(context.readRanges(input.ranges));
        return ChronoIntervals.unionSpans(base);
      }
      when 'subtract', 'gaps' {
        return ChronoIntervals.subtract(base, context.readRanges(input.ranges));
      }
      when 'coverage' {
        List<ChronoIntervals.Span> covered = ChronoIntervals.intersect(
          base,
          context.readRanges(input.ranges)
        );
        Long length = context.bounds.finish - context.bounds.start;
        result.coveragePercent = length == 0
          ? null
          : Decimal.valueOf(String.valueOf(ChronoIntervals.length(covered))) *
            100 /
            length;
        return covered;
      }
      when 'split' {
        return split(input, context);
      }
      when else {
        throw new ChronoException('Choose a supported range operation.');
      }
    }
  }
  private static ChronoRangeResult validate(ChronoRangeToolsInput input) {
    ChronoRangeResult result = new ChronoRangeResult();
    result.success = true;
    try {
      new ChronoRangeContext(input);
      result.isValid = true;
    } catch (Exception ex) {
      result.isValid = false;
      result.validationMessage = ex.getMessage();
    }
    return result;
  }
  private static void point(
    ChronoRangeToolsInput input,
    ChronoRangeContext context,
    ChronoRangeResult result
  ) {
    Long value = context.read(
      ChronoAuxiliaryValue.read(input, 'point', context.source)
    );
    ChronoIntervals.Span bounds = context.bounds;
    result.containsValue = value >= bounds.start && value < bounds.finish;
    if (input.operation == 'clamp') {
      if (bounds.start == bounds.finish) {
        throw new ChronoException(
          'An empty range cannot contain a clamped value.'
        );
      }
      Long step = context.source.source.valueType == 'PlainDate'
        ? 86400000L
        : 1L;
      result.value = context.text(
        Math.max(bounds.start, Math.min(bounds.finish - step, value))
      );
    }
  }
  private static List<ChronoIntervals.Span> split(
    ChronoRangeToolsInput input,
    ChronoRangeContext context
  ) {
    ChronoDuration duration = positiveDuration(input.duration);
    Integer maximum = ChronoIntervals.resultLimit(input.maximumResults);
    List<ChronoIntervals.Span> result = new List<ChronoIntervals.Span>();
    Long cursor = context.bounds.start;
    while (cursor < context.bounds.finish) {
      if (result.size() == maximum) {
        throw new ChronoException('Split result limit exceeded.');
      }
      ChronoAdjustInput adjust = new ChronoAdjustInput();
      adjust.valueType = input.valueType;
      adjust.value = context.text(cursor);
      adjust.timeZoneId = context.source.zoneId;
      adjust.disambiguation = input.disambiguation;
      adjust.duration = ChronoDurationService.toIsoString(duration);
      Long next = context.read(ChronoFlowAdjust.execute(adjust).value);
      if (next <= cursor) {
        throw new ChronoException(
          'Split duration must advance the source value.'
        );
      }
      next = Math.min(next, context.bounds.finish);
      result.add(ChronoIntervals.span(cursor, next));
      cursor = next;
    }
    return result;
  }
  private static ChronoDuration positiveDuration(String iso) {
    ChronoDuration duration = ChronoDurationService.parseIso(iso);
    if (
      ChronoDurationService.getMonths(duration) < 0 ||
      ChronoDurationService.getDays(duration) < 0 ||
      ChronoDurationService.getMilliseconds(duration) < 0
    ) {
      throw new ChronoException('Split duration must be positive.');
    }
    return duration;
  }
  private static String relationship(
    ChronoIntervals.Span a,
    ChronoIntervals.Span b
  ) {
    if (a.start > b.start) {
      return new Map<String, String>{
          'before' => 'after',
          'meets' => 'metBy',
          'overlaps' => 'overlappedBy',
          'contains' => 'during',
          'finishedBy' => 'finishes'
        }
        .get(relationship(b, a));
    }
    Integer endOrder = ChronoFlowCompare.compareLong(a.finish, b.finish);
    if (a.start == b.start) {
      return new Map<Integer, String>{
          -1 => 'starts',
          0 => 'equal',
          1 => 'startedBy'
        }
        .get(endOrder);
    }
    if (a.finish < b.start) {
      return 'before';
    }
    if (a.finish == b.start) {
      return 'meets';
    }
    return new Map<Integer, String>{
        -1 => 'overlaps',
        0 => 'finishedBy',
        1 => 'contains'
      }
      .get(endOrder);
  }
  /** @description Executes a concrete request through the internal operation contract. */
  public Object evaluate(Object input) {
    return ChronoRangeTools.execute((ChronoRangeToolsInput) input);
  }
  /** @description Supplies the concrete result used to isolate batched results. */
  public Type resultType() {
    return ChronoRangeResult.class;
  }
}
