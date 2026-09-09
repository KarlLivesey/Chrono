// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Read-only, same-package LWC fallback. No records or user data are queried. */
public with sharing class ChronoPickerController {
  /** @description Parses an ISO date, local datetime, instant or zoned datetime.
   * @param value ISO text supplied by Flow; no Apex object deserialisation.
   * @return Validated native values used internally by the picker.
   */
  @AuraEnabled(cacheable=true)
  public static ChronoFlowResult readInitialValue(String value) {
    ChronoSupport.requireValue(value, 'Initial ISO value');
    String kind;
    if (value.contains('[')) {
      kind = 'ZonedDateTime';
    } else if (value.contains('T')) {
      kind = Pattern.matches('.*(Z|[+-]\\d{2}:\\d{2})$', value)
        ? 'Instant'
        : 'PlainDateTime';
    } else if (Pattern.matches('\\d{4}-\\d{2}-\\d{2}', value)) {
      kind = 'PlainDate';
    } else {
      throw new ChronoException(
        'The initial ISO value must contain a complete date or instant.'
      );
    }
    ChronoConvertInput input = new ChronoConvertInput();
    input.valueType = kind;
    input.value = value;
    return ChronoFlowResults.fromOperation(
      ChronoFlowValue.read(input).result()
    );
  }
  /** @description Resolves a visible timezone-search page in one LWC request.
   * @param dateValue Entered local date.
   * @param timeValue Entered local time.
   * @param timeZoneIds At most twelve visible timezone IDs.
   * @return Candidates by timezone, including gaps and repeated times.
   */
  @AuraEnabled(cacheable=true)
  public static Map<String, List<ChronoPickerOption>> describeZones(
    String dateValue,
    String timeValue,
    List<String> timeZoneIds
  ) {
    if (timeZoneIds == null || timeZoneIds.size() > 12) {
      throw new ChronoException('Supply at most twelve timezone IDs.');
    }
    Map<String, List<ChronoPickerOption>> result = new Map<String, List<ChronoPickerOption>>();
    for (String zoneId : new Set<String>(timeZoneIds)) {
      result.put(zoneId, resolveLocal(dateValue, timeValue, zoneId));
    }
    return result;
  }
  /** @description Lists supported Salesforce time-zone IDs for the screen picker.
   * @return Active time-zone IDs in alphabetical order.
   */
  @AuraEnabled(cacheable=true)
  public static List<String> getTimeZones() {
    return ChronoZoneTools.timeZones();
  }
  /** @description Projects an existing instant into its local date and time.
   * @param instantValue Native Salesforce datetime.
   * @param timeZoneId Explicit Salesforce time-zone ID.
   * @return Local fields and offset, preserving the exact instant.
   */
  @AuraEnabled(cacheable=true)
  public static ChronoPickerOption projectInstant(
    Datetime instantValue,
    String timeZoneId
  ) {
    return ChronoPickerOptions.create(instantValue, timeZoneId, 'exact');
  }
  /** @description Returns exact candidates or explicit gap corrections; never chooses for the user.
   * @param dateValue ISO local date.
   * @param timeValue ISO local time, at millisecond precision.
   * @param timeZoneId Explicit Salesforce time-zone ID.
   * @return One exact option, repeated-time options, or backward/forward gap corrections.
   */
  @AuraEnabled(cacheable=true)
  public static List<ChronoPickerOption> resolveLocal(
    String dateValue,
    String timeValue,
    String timeZoneId
  ) {
    return ChronoLocalCandidates.resolveLocal(dateValue, timeValue, timeZoneId);
  }
}
