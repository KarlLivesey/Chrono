// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description An accessible operating schedule offered by the picker. */
public class ChronoPickerScheduleChoice {
  @AuraEnabled
  public String value { get; set; }
  @AuraEnabled
  public String label { get; set; }
  @AuraEnabled
  public String timeZoneId { get; set; }
  public ChronoPickerScheduleChoice(OperatingHours hours) {
    value = hours.Id;
    label = hours.Name;
    timeZoneId = hours.TimeZone;
  }
}
