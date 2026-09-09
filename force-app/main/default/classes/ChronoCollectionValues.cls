// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Normalises exactly one collection input and retains original item positions. */
public with sharing class ChronoCollectionValues {
  public class Entry {
    public ChronoOperationValue value;
    public String iso;
    public Integer index;
    public Decimal metric;
  }
  public static Entry entry(
    ChronoConvertInput inputValue,
    Integer index,
    ChronoCollectionToolsInput input
  ) {
    Entry result = new Entry();
    result.value = new ChronoOperationValue(inputValue);
    result.iso = result.value.nativeValue.value;
    result.index = index;
    if (result.value.isExact()) {
      result.metric = result.value.nativeValue.instantValue.getTime();
    } else if (inputValue.valueType == 'Duration') {
      ChronoDurationToolsInput duration = new ChronoDurationToolsInput();
      duration.operation = 'total';
      duration.unit = 'millisecond';
      duration.value = result.iso;
      duration.referenceDate = input.referenceDate;
      duration.timeZoneId = input.timeZoneId;
      result.metric = ChronoDurationMath.execute(duration).total;
    }
    return result;
  }
  public static Integer compareValue(Entry left, Entry right) {
    return left.metric == null
      ? left.iso.compareTo(right.iso)
      : (left.metric < right.metric
          ? -1
          : (left.metric > right.metric ? 1 : 0));
  }
  public static String key(Entry source) {
    return source.metric == null ? source.iso : String.valueOf(source.metric);
  }
  public static Decimal distance(Entry source, Entry other) {
    if (source.metric != null) {
      return (source.metric - other.metric).abs();
    }
    if (source.value.source.valueType == 'PlainTime') {
      Time first = ChronoIso.parseTime(source.value.nativeValue.timeValue),
        last = ChronoIso.parseTime(other.value.nativeValue.timeValue);
      return Decimal.valueOf(
          String.valueOf(
            Datetime.newInstanceGmt(Date.newInstance(2000, 1, 1), first)
              .getTime() -
            Datetime.newInstanceGmt(Date.newInstance(2000, 1, 1), last)
              .getTime()
          )
        )
        .abs();
    }
    return Decimal.valueOf(
        String.valueOf(
          source.value.wallClock().getTime() - other.value.wallClock().getTime()
        )
      )
      .abs();
  }
  public static void sortEntries(List<Entry> entries) {
    entries.sort(new EntryComparator());
  }
  private class EntryComparator implements Comparator<Entry> {
    public Integer compare(Entry left, Entry right) {
      ChronoSupport.requireValue(left, 'Collection item');
      ChronoSupport.requireValue(right, 'Collection item');
      Integer comparison = compareValue(left, right);
      return comparison == 0 ? left.index - right.index : comparison;
    }
  }
  public static List<ChronoConvertInput> sources(
    ChronoCollectionToolsInput input
  ) {
    requireSingleSource(input);
    List<ChronoConvertInput> result = new List<ChronoConvertInput>();
    List<String> values = String.isBlank(input.valuesText)
      ? input.values
      : input.valuesText.trim().split('[\\r\\n]+');
    if (values != null) {
      for (String value : values) {
        ChronoConvertInput source = source(input);
        source.value = value;
        result.add(source);
      }
    }
    if (input.dates != null) {
      for (Date value : input.dates) {
        ChronoConvertInput source = source(input);
        source.dateValue = value;
        result.add(source);
      }
    }
    if (input.datetimes != null) {
      for (Datetime value : input.datetimes) {
        ChronoConvertInput source = source(input);
        source.instantValue = value;
        result.add(source);
      }
    }
    requireSize(result);
    return result;
  }
  private static void requireSize(List<ChronoConvertInput> result) {
    if (result.size() > 1000) {
      throw new ChronoException(
        'Collections are limited to 1000 values per request.'
      );
    }
  }
  private static void requireSingleSource(ChronoCollectionToolsInput input) {
    Integer supplied =
      (input.values == null ? 0 : 1) +
      (String.isBlank(input.valuesText) ? 0 : 1) +
      (input.dates == null ? 0 : 1) +
      (input.datetimes == null ? 0 : 1);
    if (supplied != 1) {
      throw new ChronoException(
        'Supply exactly one ISO text, native Date or native Datetime collection. Empty collections are allowed.'
      );
    }
  }
  public static ChronoConvertInput source(ChronoCollectionToolsInput input) {
    ChronoConvertInput result = new ChronoConvertInput();
    result.valueType = input.valueType;
    result.timeZoneId = input.timeZoneId;
    return result;
  }
  public static Entry point(String iso, ChronoCollectionToolsInput input) {
    ChronoConvertInput source = source(input);
    source.value = iso;
    if (
      new Set<String>{ 'Instant', 'ZonedDateTime' }
        .contains(source.valueType) && !String.isBlank(iso)
    ) {
      source.valueType = iso.contains('[') ? 'ZonedDateTime' : 'Instant';
    }
    return entry(source, 0, input);
  }
}
