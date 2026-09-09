// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Operating-hours eligibility and explicit nearest-open alternatives. */
public class ChronoPickerAvailability {
  @AuraEnabled
  public Boolean isOpen;
  @AuraEnabled
  public String timeZoneId { get; set; }
  @AuraEnabled
  public String scheduleName { get; set; }
  @AuraEnabled
  public Date previousDate { get; set; }
  @AuraEnabled
  public Date nextDate { get; set; }
  @AuraEnabled
  public List<ChronoPickerOption> choices { get; set; }
}
