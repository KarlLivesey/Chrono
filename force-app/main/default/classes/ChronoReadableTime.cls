// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Language-neutral ISO and compact units, with explicitly English long and relative wording. */
public with sharing class ChronoReadableTime {
  public static String duration(ChronoOperationValue source, String style) {
    if (source.source.valueType != 'Duration') {
      throw new ChronoException(
        'Duration formatting requires an ISO duration.'
      );
    }
    String selected = String.isBlank(style) ? 'iso' : style;
    ChronoSupport.choice(
      selected,
      new Set<String>{ 'iso', 'compact', 'long' },
      'duration style'
    );
    if (selected == 'iso') {
      return source.nativeValue.value;
    }
    ChronoDuration value = (ChronoDuration) source.source.value;
    Decimal elapsed = ((Decimal) value.milliseconds).abs();
    Long months = ((Decimal) value.months).abs().longValue();
    Decimal days = ((Decimal) value.days).abs();
    Decimal wholeHours = (elapsed / 3600000).setScale(0, RoundingMode.DOWN);
    Decimal wholeMinutes = (elapsed / 60000).setScale(0, RoundingMode.DOWN);
    List<Decimal> values = new List<Decimal>{
      months / 12,
      Math.mod(months, 12),
      days,
      wholeHours,
      wholeMinutes - wholeHours * 60,
      (elapsed - wholeMinutes * 60000) / 1000
    };
    List<String> names = selected == 'compact'
      ? new List<String>{ 'y', 'mo', 'd', 'h', 'min', 's' }
      : new List<String>{ 'year', 'month', 'day', 'hour', 'minute', 'second' };
    String text = joinParts(values, names, selected);
    Boolean negative =
      ChronoDurationService.getMonths(value) < 0 ||
      ChronoDurationService.getDays(value) < 0 ||
      ChronoDurationService.getMilliseconds(value) < 0;
    return (negative ? '-' : '') + text;
  }
  private static String joinParts(
    List<Decimal> values,
    List<String> names,
    String style
  ) {
    List<String> parts = new List<String>();
    for (Integer i = 0; i < values.size(); i++) {
      if (values[i] != 0) {
        parts.add(amount(values[i], names[i], style));
      }
    }
    if (parts.isEmpty()) {
      parts.add(style == 'compact' ? '0s' : '0 seconds');
    }
    return String.join(parts, ' ');
  }
  private static String amount(Decimal value, String name, String style) {
    String numberText = String.valueOf(value.stripTrailingZeros());
    return numberText +
      (style == 'compact' ? '' : ' ') +
      name +
      (style == 'long' && value != 1 ? 's' : '');
  }
  public static String relative(
    ChronoOperationValue source,
    ChronoFormatValueInput input
  ) {
    ChronoOperationValue reference = reference(source, input);
    Long delta =
      ChronoRangeContext.ticks(source) - ChronoRangeContext.ticks(reference);
    if (delta == 0) {
      return 'now';
    }
    String unit = String.isBlank(input.relativeUnit)
      ? 'auto'
      : input.relativeUnit;
    if (unit == 'auto') {
      unit = automaticUnit(Math.abs(delta));
    }
    Map<String, Long> sizes = new Map<String, Long>{
      'second' => 1000L,
      'minute' => 60000L,
      'hour' => 3600000L,
      'day' => 86400000L
    };
    if (!sizes.containsKey(unit)) {
      throw new ChronoException('Choose an elapsed relative unit.');
    }
    Decimal quantity = (Decimal.valueOf(String.valueOf(Math.abs(delta))) /
      sizes.get(unit))
      .setScale(0, RoundingMode.HALF_UP);
    String text =
      String.valueOf(quantity.longValue()) +
      ' ' +
      unit +
      (quantity == 1 ? '' : 's');
    return delta < 0 ? text + ' ago' : 'in ' + text;
  }
  private static ChronoOperationValue reference(
    ChronoOperationValue source,
    ChronoFormatValueInput input
  ) {
    ChronoConvertInput other = new ChronoConvertInput();
    other.valueType = input.valueType;
    other.value = ChronoAuxiliaryValue.read(input, 'reference', source);
    if (source.isExact() && !String.isBlank(other.value)) {
      other.valueType = other.value.contains('[') ? 'ZonedDateTime' : 'Instant';
    }
    other.timeZoneId = input.timeZoneId;
    return new ChronoOperationValue(other);
  }
  private static String automaticUnit(Long milliseconds) {
    if (milliseconds < 60000) {
      return 'second';
    }
    if (milliseconds < 3600000) {
      return 'minute';
    }
    return milliseconds < 86400000 ? 'hour' : 'day';
  }
}
