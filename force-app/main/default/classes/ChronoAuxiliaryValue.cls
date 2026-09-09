// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Normalises auxiliary points/boundaries using the same native-versus-ISO contract as the primary value. */
public with sharing class ChronoAuxiliaryValue {
  public static String read(
    Object request,
    String prefix,
    ChronoOperationValue source
  ) {
    ChronoConvertInput context = new ChronoConvertInput();
    context.valueType = source.source.valueType;
    context.timeZoneId = source.zoneId;
    context.disambiguation = source.policy;
    return read(request, prefix, context);
  }
  public static String read(
    Object request,
    String prefix,
    ChronoConvertInput context
  ) {
    Map<String, Object> fields = (Map<String, Object>) JSON.deserializeUntyped(
      JSON.serialize(request)
    );
    ChronoConvertInput input = new ChronoConvertInput();
    input.value = (String) fields.get(
      fields.containsKey(prefix + 'Value') ? prefix + 'Value' : prefix
    );
    input.valueType = context.valueType;
    input.timeZoneId = context.timeZoneId;
    input.disambiguation = context.disambiguation;
    Object day = fields.get(prefix + 'Date');
    Object instant = fields.get(prefix + 'Instant');
    input.dateValue = day == null
      ? null
      : ChronoIso.parseDate(String.valueOf(day));
    input.instantValue = instant == null
      ? null
      : ChronoInstantService.toDatetime(
          ChronoInstantService.parseIso(String.valueOf(instant))
        );
    input.timeValue = (String) fields.get(prefix + 'Time');
    if (
      String.isBlank(input.value) &&
      day == null &&
      instant == null &&
      String.isBlank(input.timeValue)
    ) {
      return null;
    }
    normalise(input);
    return ChronoFlowValue.read(input).result().value;
  }
  private static void normalise(ChronoConvertInput input) {
    if (
      new Set<String>{ 'Instant', 'ZonedDateTime' }.contains(input.valueType) &&
      !String.isBlank(input.value)
    ) {
      input.valueType = input.value.contains('[') ? 'ZonedDateTime' : 'Instant';
    }
    if (
      input.valueType == 'PlainDateTime' &&
      input.dateValue != null &&
      String.isBlank(input.timeValue)
    ) {
      input.timeValue = '00:00';
    }
  }
}
