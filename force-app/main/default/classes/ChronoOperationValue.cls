// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal adapter preserving plain versus exact semantics for Flow operations. */
public with sharing class ChronoOperationValue {
  public final ChronoFlowValue source;
  public final ChronoOperationResult nativeValue;
  public final String zoneId;
  public final String policy;
  public ChronoOperationValue(ChronoConvertInput input) {
    source = ChronoFlowValue.read(input);
    nativeValue = source.result();
    zoneId = String.isBlank(input.timeZoneId)
      ? nativeValue.timeZoneId
      : input.timeZoneId;
    policy = ChronoFlowConvert.policy(input.disambiguation);
  }
  public Boolean isExact() {
    return nativeValue.instantValue != null;
  }
  public Datetime wallClock() {
    if (isExact()) {
      return ChronoSupport.localValue(nativeValue.instantValue, zoneId);
    }
    if (nativeValue.dateValue == null) {
      throw new ChronoException(
        'This operation requires a complete date; convert partial values first.'
      );
    }
    return Datetime.newInstanceGmt(
      nativeValue.dateValue,
      String.isBlank(nativeValue.timeValue)
        ? Time.newInstance(0, 0, 0, 0)
        : ChronoIso.parseTime(nativeValue.timeValue)
    );
  }
  public Datetime resolvedInstant() {
    if (isExact()) {
      return nativeValue.instantValue;
    }
    if (source.valueType != 'PlainDateTime') {
      throw new ChronoException(
        'Supply a date/time or an exact value for this operation.'
      );
    }
    return resolve(wallClock());
  }
  public Datetime resolve(Datetime wall) {
    return ChronoZonedDateTimeService.toDatetime(
      ChronoPlainDateTimeService.toZonedDateTime(
        ChronoPlainDateTimeService.create(wall.dateGmt(), wall.timeGmt()),
        zoneId,
        policy
      )
    );
  }
  public ChronoOperationResult fromWall(Datetime wall) {
    if (isExact()) {
      return fromInstant(resolve(wall));
    }
    if (source.valueType == 'PlainDate') {
      return new ChronoFlowValue(
          'PlainDate',
          ChronoPlainDateService.create(wall.dateGmt())
        )
        .result();
    }
    return new ChronoFlowValue(
        'PlainDateTime',
        ChronoPlainDateTimeService.create(wall.dateGmt(), wall.timeGmt())
      )
      .result();
  }
  public ChronoOperationResult fromInstant(Datetime instant) {
    if (source.valueType == 'Instant') {
      return new ChronoFlowValue(
          'Instant',
          ChronoInstantService.create(instant)
        )
        .result();
    }
    return new ChronoFlowValue(
        'ZonedDateTime',
        ChronoZonedDateTimeService.create(instant, zoneId)
      )
      .result();
  }
}
