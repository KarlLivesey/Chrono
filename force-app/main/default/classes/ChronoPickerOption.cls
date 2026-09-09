// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Top-level transport value for Chrono's packaged picker. */
public class ChronoPickerOption {
  @AuraEnabled
  public Datetime instantValue { get; set; }
  @AuraEnabled
  public String localValue { get; set; }
  @AuraEnabled
  public Integer offsetSeconds { get; set; }
  @AuraEnabled
  public String choice { get; set; }
}
