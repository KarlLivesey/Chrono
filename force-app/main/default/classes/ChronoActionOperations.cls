// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Selects one operation and preloads shared configuration once per invocation. */
public with sharing class ChronoActionOperations {
  public static ChronoActionOperation create(
    String family,
    List<Object> requests
  ) {
    switch on family {
      when 'TimeAllocation' {
        return new ChronoTimeAllocation();
      }
      when 'WorkingDays' {
        return new ChronoWorkingDays(requests);
      }
      when 'FormatValue' {
        return new ChronoFormatting();
      }
      when 'Recurrence' {
        return new ChronoRecurrence(requests);
      }
      when 'FiscalPeriod' {
        return new ChronoFiscalPeriods(requests);
      }
      when 'CollectionTools' {
        return new ChronoCollectionTools();
      }
      when 'Availability' {
        return new ChronoAvailability(requests);
      }
      when 'RangeTools' {
        return new ChronoRangeTools();
      }
      when 'ZoneTools' {
        return new ChronoZoneTools();
      }
      when 'DurationTools' {
        return new ChronoDurationMath();
      }
      when 'CreateValue',
        'ReplaceValue',
        'ParseValue',
        'ValueDetails',
        'ValidateValue',
        'EpochValue' {
        return new ChronoValueActionOperation(family);
      }
      when else {
        throw new ChronoException('Unknown action family: ' + family);
      }
    }
  }
}
