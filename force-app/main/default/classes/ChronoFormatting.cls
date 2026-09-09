// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Display formatting kept separate from machine-readable ISO serialisation. */
public with sharing class ChronoFormatting implements ChronoActionOperation {
  public static ChronoFormatResult execute(ChronoFormatValueInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoOperationValue source = new ChronoOperationValue(
      ChronoValueInputs.source(input)
    );
    ChronoFormatResult result = new ChronoFormatResult();
    result.success = true;
    result.locale = UserInfo.getLocale();
    result.styleApplied = true;
    switch on input.operation {
      when 'duration' {
        result.text = ChronoReadableTime.duration(source, input.durationStyle);
      }
      when 'relative' {
        result.text = ChronoReadableTime.relative(source, input);
      }
      when 'value', 'range' {
        formatRange(source, input, result);
      }
      when else {
        throw new ChronoException('Choose a supported formatting operation.');
      }
    }
    return result;
  }
  private static void formatRange(
    ChronoOperationValue source,
    ChronoFormatValueInput input,
    ChronoFormatResult result
  ) {
    result.startText = value(source, input, result);
    result.text = result.startText;
    if (input.operation == 'range') {
      ChronoConvertInput finish = new ChronoConvertInput();
      finish.valueType = input.valueType;
      finish.value = ChronoAuxiliaryValue.read(input, 'end', source);
      if (source.isExact() && !String.isBlank(finish.value)) {
        finish.valueType = finish.value.contains('[')
          ? 'ZonedDateTime'
          : 'Instant';
      }

      finish.timeZoneId = String.isBlank(input.timeZoneId)
        ? source.zoneId
        : input.timeZoneId;
      ChronoOperationValue endValue = new ChronoOperationValue(finish);
      result.endText = value(endValue, input, result);
      result.text =
        result.startText +
        (input.separator == null ? ' – ' : input.separator) +
        result.endText;
    }
  }
  private static String value(
    ChronoOperationValue source,
    ChronoFormatValueInput input,
    ChronoFormatResult result
  ) {
    String kind = kind(source.source.valueType);
    Datetime nativeValue = displayValue(source);
    String zone = source.isExact() ? source.zoneId : 'GMT';
    if (source.isExact()) {
      ChronoSupport.zone(zone);
    }
    String pattern = input.pattern;
    if (String.isBlank(pattern)) {
      pattern = ChronoLocalePatterns.getPattern(
        UserInfo.getLocale(),
        kind,
        String.isBlank(input.style) ? 'medium' : input.style
      );
      if (pattern == null) {
        result.styleApplied = false;
        return source.nativeValue.value;
      }
    }
    validatePartialPattern(pattern, source.source.valueType);
    String text = nativeValue.format(pattern, zone);
    if (String.isBlank(input.pattern)) {
      text = gregorianYear(text, nativeValue, zone);
    }
    if (input.includeZone == true) {
      text += zoneSuffix(source, zone);
    }
    return text;
  }
  private static String zoneSuffix(ChronoOperationValue source, String zone) {
    if (!source.isExact()) {
      throw new ChronoException(
        'Only an exact value has a timezone offset to append.'
      );
    }
    return ' ' +
      source.nativeValue.instantValue.format('XXX', zone) +
      ' [' +
      zone +
      ']';
  }
  private static String gregorianYear(
    String text,
    Datetime instant,
    String zone
  ) {
    String nativeYear = instant.format('yyyy', zone);
    String year = ChronoIso.pad(
      ChronoSupport.localValue(instant, zone).yearGmt(),
      4
    );
    return text.replace(nativeYear, year);
  }
  private static void validatePartialPattern(String pattern, String type) {
    Map<String, String> forbidden = new Map<String, String>{
      'PlainTime' => 'yYuUMMLLdDFEecwWQqzZOXVvG',
      'PlainMonthDay' => 'yYuUdDFEecwWQqHhKkmsSaAzZOXVvG',
      'PlainYearMonth' => 'dDFEecwWHhKkmsSaAzZOXVvG'
    };
    // Month/day does contain a day-of-month; remove d from its forbidden fields.
    forbidden.put(
      'PlainMonthDay',
      forbidden.get('PlainMonthDay').replace('d', '')
    );
    if (!forbidden.containsKey(type)) {
      return;
    }
    Boolean quoted = false;
    for (Integer index = 0; index < pattern.length(); index++) {
      String token = pattern.substring(index, index + 1);
      if (token == '\'') {
        quoted = !quoted;
      } else if (!quoted && forbidden.get(type).contains(token)) {
        throw new ChronoException(
          'This pattern requires fields absent from ' + type + '.'
        );
      }
    }
  }
  private static String kind(String type) {
    Map<String, String> kinds = new Map<String, String>{
      'PlainDate' => 'date',
      'PlainTime' => 'time',
      'PlainDateTime' => 'datetime',
      'Instant' => 'datetime',
      'ZonedDateTime' => 'datetime',
      'PlainYearMonth' => 'yearMonth',
      'PlainMonthDay' => 'monthDay'
    };
    if (!kinds.containsKey(type)) {
      throw new ChronoException('Use duration formatting for a duration.');
    }
    return kinds.get(type);
  }
  private static Datetime displayValue(ChronoOperationValue source) {
    if (source.isExact()) {
      return source.nativeValue.instantValue;
    }
    String type = source.source.valueType;
    if (type == 'PlainTime') {
      return Datetime.newInstanceGmt(
        Date.newInstance(2000, 1, 1),
        ChronoIso.parseTime(source.nativeValue.timeValue)
      );
    }
    if (type == 'PlainYearMonth') {
      String iso = source.nativeValue.value;
      return Datetime.newInstanceGmt(
        ChronoIso.parseDate(iso + '-01'),
        Time.newInstance(0, 0, 0, 0)
      );
    }
    if (type == 'PlainMonthDay') {
      String iso = source.nativeValue.value;
      return Datetime.newInstanceGmt(
        ChronoIso.parseDate('2000-' + iso.substring(2)),
        Time.newInstance(0, 0, 0, 0)
      );
    }
    return source.wallClock();
  }
  /** @description Executes a concrete request through the internal operation contract. */
  public Object evaluate(Object input) {
    return ChronoFormatting.execute((ChronoFormatValueInput) input);
  }
  /** @description Supplies the concrete result used to isolate batched results. */
  public Type resultType() {
    return ChronoFormatResult.class;
  }
}
