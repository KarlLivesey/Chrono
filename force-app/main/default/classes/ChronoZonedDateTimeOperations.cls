// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal implementation; callers use ChronoZonedDateTimeService. Validates data before use. */
public with sharing class ChronoZonedDateTimeOperations { // NOPMD -- Aggregate covers independent conversions and required native/schedule overloads; method rules remain active.
  /**
   * @description Constructs an instant with a named time zone.
   * @param instant Native exact instant.
   * @param zoneId Salesforce time-zone ID.
   */
  public static ChronoZonedDateTime create(Datetime instant, String zoneId) {
    ChronoZonedDateTime result = new ChronoZonedDateTime();

    ChronoSupport.requireValue(instant, 'Datetime');
    ChronoSupport.zone(zoneId);
    result.instant = instant;
    result.timeZoneId = zoneId;

    validate(result);
    return result;
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static Datetime toDatetime(ChronoZonedDateTime source) {
    ChronoZonedDateTimeOperations.validate(source);
    return source.instant;
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static String getTimeZoneId(ChronoZonedDateTime source) {
    ChronoZonedDateTimeOperations.validate(source);
    return source.timeZoneId;
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoInstant toInstant(ChronoZonedDateTime source) {
    ChronoZonedDateTimeOperations.validate(source);
    return ChronoInstantOperations.create(source.instant);
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoPlainDateTime toPlainDateTime(
    ChronoZonedDateTime source
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    Datetime local = ChronoSupport.localValue(
      source.instant,
      source.timeZoneId
    );
    return ChronoPlainDateTimeOperations.create(
      local.dateGmt(),
      local.timeGmt()
    );
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static Date toDate(ChronoZonedDateTime source) {
    ChronoZonedDateTimeOperations.validate(source);
    return ChronoPlainDateTimeOperations.toDate(
      ChronoZonedDateTimeOperations.toPlainDateTime(source)
    );
  }
  /**
   * @description Returns the corresponding native value or Chrono representation.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static Time toTime(ChronoZonedDateTime source) {
    ChronoZonedDateTimeOperations.validate(source);
    return ChronoPlainDateTimeOperations.toTime(
      ChronoZonedDateTimeOperations.toPlainDateTime(source)
    );
  }
  /**
   * @description Views the same instant in another zone.
   * @param targetZoneId New Salesforce time-zone ID.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime withTimeZone(
    ChronoZonedDateTime source,
    String targetZoneId
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    return ChronoZonedDateTimeOperations.create(source.instant, targetZoneId);
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addHours(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    return ChronoZonedDateTimeOperations.addMilliseconds(
      source,
      ChronoSupport.hours(amount)
    );
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addHours(
    Datetime source,
    String zoneId,
    Integer amount
  ) {
    return ChronoZonedDateTimeOperations.addHours(
      ChronoZonedDateTimeOperations.create(source, zoneId),
      amount
    );
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addMinutes(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    return ChronoZonedDateTimeOperations.addMilliseconds(
      source,
      ChronoSupport.minutes(amount)
    );
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addMinutes(
    Datetime source,
    String zoneId,
    Integer amount
  ) {
    return ChronoZonedDateTimeOperations.addMinutes(
      ChronoZonedDateTimeOperations.create(source, zoneId),
      amount
    );
  }
  /**
   * @description Adds elapsed seconds.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addSeconds(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    return ChronoZonedDateTimeOperations.addMilliseconds(
      source,
      ((Long) amount) * 1000L
    );
  }
  /**
   * @description Adds elapsed seconds.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addSeconds(
    Datetime source,
    String zoneId,
    Integer amount
  ) {
    return ChronoZonedDateTimeOperations.addSeconds(
      ChronoZonedDateTimeOperations.create(source, zoneId),
      amount
    );
  }
  /**
   * @description Adds elapsed milliseconds.
   * @param amount Signed elapsed milliseconds.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addMilliseconds(
    ChronoZonedDateTime source,
    Long amount
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    return ChronoZonedDateTimeOperations.create(
      ChronoSupport.shift(source.instant, amount),
      source.timeZoneId
    );
  }
  /**
   * @description Adds local calendar days; rejects gaps and overlaps.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addDays(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    return ChronoZonedDateTimeOperations.addDays(source, amount, 'reject');
  }
  /**
   * @description Adds local calendar days; rejects gaps and overlaps.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addDays(
    ChronoZonedDateTime source,
    Integer amount,
    String disambiguation
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    return calendarResult(
      source,
      ChronoPlainDateTimeOperations.addDays(
        ChronoZonedDateTimeOperations.toPlainDateTime(source),
        amount
      ),
      disambiguation
    );
  }
  /**
   * @description Adds local calendar months; rejects gaps and overlaps.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addMonths(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    return ChronoZonedDateTimeOperations.addMonths(source, amount, 'reject');
  }
  /**
   * @description Adds local calendar months; rejects gaps and overlaps.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addMonths(
    ChronoZonedDateTime source,
    Integer amount,
    String disambiguation
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    return calendarResult(
      source,
      ChronoPlainDateTimeOperations.addMonths(
        ChronoZonedDateTimeOperations.toPlainDateTime(source),
        amount
      ),
      disambiguation
    );
  }
  /**
   * @description Adds local calendar years; rejects gaps and overlaps.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addYears(
    ChronoZonedDateTime source,
    Integer amount
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    return ChronoZonedDateTimeOperations.addYears(source, amount, 'reject');
  }
  /**
   * @description Adds local calendar years; rejects gaps and overlaps.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addYears(
    ChronoZonedDateTime source,
    Integer amount,
    String disambiguation
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    return calendarResult(
      source,
      ChronoPlainDateTimeOperations.addYears(
        ChronoZonedDateTimeOperations.toPlainDateTime(source),
        amount
      ),
      disambiguation
    );
  }
  private static ChronoZonedDateTime calendarResult(
    ChronoZonedDateTime source,
    ChronoPlainDateTime target,
    String disambiguation
  ) {
    String policy = disambiguation == null ? 'reject' : disambiguation;
    ChronoSupport.choice(
      policy,
      new Set<String>{ 'reject', 'earlier', 'later' },
      'Disambiguation'
    );
    Datetime original = ChronoSupport.localValue(
      source.instant,
      source.timeZoneId
    );
    if (
      target.localDate == original.dateGmt() &&
      target.localTime == original.timeGmt()
    ) {
      // An unchanged clock already has an occurrence: do not discard that exact instant.
      return ChronoZonedDateTimeOperations.create(
        source.instant,
        source.timeZoneId
      );
    }
    return ChronoPlainDateTimeOperations.toZonedDateTime(
      target,
      source.timeZoneId,
      policy
    );
  }
  /**
   * @description Adds months and days locally, then elapsed milliseconds.
   * @param duration Amount to add.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime add(
    ChronoZonedDateTime source,
    ChronoDuration duration
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    ChronoDurationOperations.validate(duration);
    return ChronoZonedDateTimeOperations.add(source, duration, 'reject');
  }
  /**
   * @description Adds months and days locally, then elapsed milliseconds.
   * @param duration Amount to add.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime add(
    ChronoZonedDateTime source,
    ChronoDuration duration,
    String disambiguation
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    ChronoDurationOperations.validate(duration);
    ChronoZonedDateTime base = source;
    if (
      ChronoDurationOperations.getMonths(duration) != 0 ||
      ChronoDurationOperations.getDays(duration) != 0
    ) {
      base = ChronoPlainDateTimeOperations.toZonedDateTime(
        ChronoPlainDateTimeOperations.addDays(
          ChronoPlainDateTimeOperations.addMonths(
            ChronoZonedDateTimeOperations.toPlainDateTime(source),
            ChronoDurationOperations.getMonths(duration)
          ),
          ChronoDurationOperations.getDays(duration)
        ),
        source.timeZoneId,
        disambiguation
      );
    }
    return ChronoZonedDateTimeOperations.addMilliseconds(
      base,
      ChronoDurationOperations.getMilliseconds(duration)
    );
  }
  /**
   * @description Returns the elapsed difference between instants.
   * @param other End value.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoDuration elapsedDifference(
    ChronoZonedDateTime source,
    ChronoZonedDateTime other
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    ChronoZonedDateTimeOperations.validate(other);
    return ChronoInstantOperations.elapsedDifference(
      ChronoZonedDateTimeOperations.toInstant(source),
      ChronoZonedDateTimeOperations.toInstant(other)
    );
  }
  /**
   * @description Serialises the local datetime, offset and named zone.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static String toIsoString(ChronoZonedDateTime source) {
    ChronoZonedDateTimeOperations.validate(source);
    Integer offset =
      ChronoSupport.zone(source.timeZoneId).getOffset(source.instant) / 1000;
    Integer magnitude = Math.abs(offset);
    String suffix =
      (offset < 0 ? '-' : '+') +
      ChronoIso.pad(magnitude / 3600, 2) +
      ':' +
      ChronoIso.pad(Math.mod(magnitude / 60, 60), 2);
    if (Math.mod(magnitude, 60) != 0) {
      throw new ChronoException(
        'ISO output requires a whole-minute UTC offset.'
      );
    }
    return ChronoPlainDateTimeOperations.toIsoString(
        ChronoZonedDateTimeOperations.toPlainDateTime(source)
      ) +
      suffix +
      '[' +
      source.timeZoneId +
      ']';
  }
  /**
   * @description Parses a zoned datetime and validates its offset against the zone.
   * @param value ISO datetime with offset and bracketed zone.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime parseIso(String value) {
    ChronoSupport.requireValue(value, 'Zoned datetime');
    Integer bracket = value.indexOf('[');
    if (
      bracket < 0 ||
      !value.endsWith(']') ||
      value.substring(bracket + 1).contains('[')
    ) {
      throw new ChronoException(
        'Expected datetime with offset and one [time-zone] annotation.'
      );
    }
    String parsedZone = value.substring(bracket + 1, value.length() - 1);
    String instantText = value.substring(0, bracket);
    Datetime parsed = ChronoIso.parseInstant(instantText);
    Datetime local = ChronoIso.parseLocal(
      instantText.endsWith('Z')
        ? instantText.substring(0, instantText.length() - 1)
        : instantText.substring(0, instantText.length() - 6)
    );
    if (ChronoSupport.localValue(parsed, parsedZone) != local) {
      throw new ChronoException(
        'UTC offset does not match the named time zone.'
      );
    }
    return ChronoZonedDateTimeOperations.create(parsed, parsedZone);
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addHours(
    ChronoZonedDateTime source,
    Integer amount,
    OperatingHours schedule
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    ChronoSupport.requireValue(schedule, 'Schedule');
    ChronoSupport.requireValue(schedule.Id, 'Saved schedule ID');
    return ChronoZonedDateTimeOperations.create(
      new ChronoWorkingTime(schedule)
        .addMilliseconds(source.instant, ChronoSupport.hours(amount)),
      source.timeZoneId
    );
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Source, units and native schedule records are distinct API inputs.
  public static ChronoZonedDateTime addHours(
    Datetime source,
    String zoneId,
    Integer amount,
    OperatingHours schedule
  ) {
    return ChronoZonedDateTimeOperations.addHours(
      ChronoZonedDateTimeOperations.create(source, zoneId),
      amount,
      schedule
    );
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addHours(
    ChronoZonedDateTime source,
    Integer amount,
    BusinessHours schedule
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    ChronoSupport.requireValue(schedule, 'Schedule');
    ChronoSupport.requireValue(schedule.Id, 'Saved schedule ID');
    return ChronoZonedDateTimeOperations.create(
      System.BusinessHours.addGmt(
        schedule.Id,
        source.instant,
        ChronoSupport.hours(amount)
      ),
      source.timeZoneId
    );
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Source, units and native schedule records are distinct API inputs.
  public static ChronoZonedDateTime addHours(
    Datetime source,
    String zoneId,
    Integer amount,
    BusinessHours schedule
  ) {
    return ChronoZonedDateTimeOperations.addHours(
      ChronoZonedDateTimeOperations.create(source, zoneId),
      amount,
      schedule
    );
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addMinutes(
    ChronoZonedDateTime source,
    Integer amount,
    OperatingHours schedule
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    ChronoSupport.requireValue(schedule, 'Schedule');
    ChronoSupport.requireValue(schedule.Id, 'Saved schedule ID');
    return ChronoZonedDateTimeOperations.create(
      new ChronoWorkingTime(schedule)
        .addMilliseconds(source.instant, ChronoSupport.minutes(amount)),
      source.timeZoneId
    );
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Source, units and native schedule records are distinct API inputs.
  public static ChronoZonedDateTime addMinutes(
    Datetime source,
    String zoneId,
    Integer amount,
    OperatingHours schedule
  ) {
    return ChronoZonedDateTimeOperations.addMinutes(
      ChronoZonedDateTimeOperations.create(source, zoneId),
      amount,
      schedule
    );
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  public static ChronoZonedDateTime addMinutes(
    ChronoZonedDateTime source,
    Integer amount,
    BusinessHours schedule
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    ChronoSupport.requireValue(schedule, 'Schedule');
    ChronoSupport.requireValue(schedule.Id, 'Saved schedule ID');
    return ChronoZonedDateTimeOperations.create(
      System.BusinessHours.addGmt(
        schedule.Id,
        source.instant,
        ChronoSupport.minutes(amount)
      ),
      source.timeZoneId
    );
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Source, units and native schedule records are distinct API inputs.
  public static ChronoZonedDateTime addMinutes(
    Datetime source,
    String zoneId,
    Integer amount,
    BusinessHours schedule
  ) {
    return ChronoZonedDateTimeOperations.addMinutes(
      ChronoZonedDateTimeOperations.create(source, zoneId),
      amount,
      schedule
    );
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Source, units and native schedule records are distinct API inputs.
  public static ChronoZonedDateTime addHours(
    ChronoZonedDateTime source,
    Integer amount,
    OperatingHours schedule,
    List<TimeSlot> slots,
    List<Holiday> holidays
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    return ChronoZonedDateTimeOperations.create(
      new ChronoWorkingTime(schedule, slots, holidays)
        .addMilliseconds(source.instant, ChronoSupport.hours(amount)),
      source.timeZoneId
    );
  }
  /**
   * @description Adds elapsed hours.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Source, units and native schedule records are distinct API inputs.
  public static ChronoZonedDateTime addHours(
    Datetime source,
    String zoneId,
    Integer amount,
    OperatingHours schedule,
    List<TimeSlot> slots,
    List<Holiday> holidays
  ) {
    return ChronoZonedDateTimeOperations.addHours(
      ChronoZonedDateTimeOperations.create(source, zoneId),
      amount,
      schedule,
      slots,
      holidays
    );
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Source, units and native schedule records are distinct API inputs.
  public static ChronoZonedDateTime addMinutes(
    ChronoZonedDateTime source,
    Integer amount,
    OperatingHours schedule,
    List<TimeSlot> slots,
    List<Holiday> holidays
  ) {
    ChronoZonedDateTimeOperations.validate(source);
    return ChronoZonedDateTimeOperations.create(
      new ChronoWorkingTime(schedule, slots, holidays)
        .addMilliseconds(source.instant, ChronoSupport.minutes(amount)),
      source.timeZoneId
    );
  }
  /**
   * @description Adds elapsed minutes.
   * @param amount Signed number of units.
   * @param source Value to operate on; validated before use.
   * @return The resulting value.
   */
  @SuppressWarnings(
    'PMD.ExcessiveParameterList'
  ) // Source, units and native schedule records are distinct API inputs.
  public static ChronoZonedDateTime addMinutes(
    Datetime source,
    String zoneId,
    Integer amount,
    OperatingHours schedule,
    List<TimeSlot> slots,
    List<Holiday> holidays
  ) {
    return ChronoZonedDateTimeOperations.addMinutes(
      ChronoZonedDateTimeOperations.create(source, zoneId),
      amount,
      schedule,
      slots,
      holidays
    );
  }
  /** @description Rejects incomplete or invalid data before use. */
  public static void validate(ChronoZonedDateTime source) {
    ChronoSupport.requireValue(source, 'Value');
    ChronoDates.validateInstant(source.instant);
    ChronoSupport.requireValue(source.timeZoneId, 'timeZoneId');
    ChronoSupport.zone(source.timeZoneId);
  }
}
