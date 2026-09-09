// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Zone operations using Salesforce timezone rules at the supplied date, with bounded transition searches. */
public with sharing class ChronoZoneTools implements ChronoActionOperation {
  public static ChronoZoneResult execute(ChronoZoneToolsInput input) {
    ChronoSupport.requireValue(input, 'Input');
    if (input.operation == 'listZones') {
      return zoneList(input.search);
    }
    ChronoOperationValue source = new ChronoOperationValue(
      ChronoValueInputs.source(input)
    );
    if (input.operation == 'overrideOffset') {
      return overrideOffset(source, input);
    }
    if (input.operation == 'convert' && input.conversionMode == 'localClock') {
      return convert(source, null, input);
    }
    Datetime instant = source.isExact()
      ? source.nativeValue.instantValue
      : source.resolve(source.wallClock());
    ChronoZoneResult result = describe(instant, source.zoneId);
    switch on input.operation {
      when 'convert' {
        return convert(source, instant, input);
      }
      when 'details' {
        return result;
      }
      when 'compareZones' {
        ChronoZoneResult other = describe(instant, input.targetTimeZoneId);
        result.otherValue = other.value;
        result.offsetDifferenceSeconds =
          other.offsetSeconds - result.offsetSeconds;
      }
      when 'transitions', 'nextTransition', 'previousTransition' {
        ChronoZoneTransitions.search(input, instant, result);
      }
      when else {
        throw new ChronoException('Choose a supported timezone operation.');
      }
    }
    return result;
  }
  public static ChronoZoneResult describe(Datetime instant, String zoneId) {
    TimeZone zone = ChronoSupport.zone(zoneId);
    ChronoZoneResult result = new ChronoZoneResult();
    result.success = true;
    result.instantValue = instant;
    result.timeZoneId = zoneId;
    result.value = ChronoZonedDateTimeService.toIsoString(
      ChronoZonedDateTimeService.create(instant, zoneId)
    );
    Datetime local = ChronoSupport.localValue(instant, zoneId);
    result.localValue = ChronoPlainDateTimeService.toIsoString(
      ChronoPlainDateTimeService.create(local.dateGmt(), local.timeGmt())
    );
    result.offsetSeconds = zone.getOffset(instant) / 1000;
    result.abbreviation = instant.format('z', zoneId);
    return result;
  }
  private static ChronoZoneResult convert(
    ChronoOperationValue source,
    Datetime instant,
    ChronoZoneToolsInput input
  ) {
    String mode = String.isBlank(input.conversionMode)
      ? 'instant'
      : input.conversionMode;
    ChronoSupport.choice(
      mode,
      new Set<String>{ 'instant', 'localClock' },
      'conversion mode'
    );
    ChronoSupport.zone(input.targetTimeZoneId);
    if (mode == 'localClock') {
      Datetime wall = source.wallClock();
      instant = ChronoZonedDateTimeService.toDatetime(
        ChronoPlainDateTimeService.toZonedDateTime(
          ChronoPlainDateTimeService.create(wall.dateGmt(), wall.timeGmt()),
          input.targetTimeZoneId,
          source.policy
        )
      );
    }
    return describe(instant, input.targetTimeZoneId);
  }
  private static ChronoZoneResult overrideOffset(
    ChronoOperationValue source,
    ChronoZoneToolsInput input
  ) {
    ChronoSupport.requireMatch(
      input.suppliedOffset,
      '[+-](0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]',
      'UTC offset'
    );
    Datetime wall = source.wallClock();
    String supplied =
      ChronoPlainDateTimeService.toIsoString(
        ChronoPlainDateTimeService.create(wall.dateGmt(), wall.timeGmt())
      ) + input.suppliedOffset;
    Datetime instant = ChronoInstantService.toDatetime(
      ChronoInstantService.parseIso(supplied)
    );
    ChronoZoneResult result = describe(instant, source.zoneId);
    result.suppliedValue = supplied;
    result.isOverride =
      ChronoSupport.localValue(instant, source.zoneId) != wall;
    return result;
  }
  private static ChronoZoneResult zoneList(String query) {
    ChronoZoneResult result = new ChronoZoneResult();
    result.success = true;
    result.timeZoneIds = new List<String>();
    for (String zone : timeZones()) {
      if (
        String.isBlank(query) ||
        zone.toLowerCase().contains(query.toLowerCase())
      ) {
        result.timeZoneIds.add(zone);
      }
    }
    result.found = !result.timeZoneIds.isEmpty();
    return result;
  }
  /** @description Executes a concrete request through the internal operation contract. */
  public Object evaluate(Object input) {
    return ChronoZoneTools.execute((ChronoZoneToolsInput) input);
  }
  /** @description Supplies the concrete result used to isolate batched results. */
  public Type resultType() {
    return ChronoZoneResult.class;
  }
  public static List<String> timeZones() {
    List<String> result = new List<String>();
    for (
      Schema.PicklistEntry entry : Schema.User.TimeZoneSidKey.getDescribe()
        .getPicklistValues()
    ) {
      if (entry.isActive()) {
        result.add(entry.getValue());
      }
    }
    result.sort();
    return result;
  }
}
