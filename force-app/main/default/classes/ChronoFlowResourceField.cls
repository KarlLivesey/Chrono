// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Same-package editor transport for accessible field metadata. */
public class ChronoFlowResourceField {
  @AuraEnabled
  public String name { get; set; }
  @AuraEnabled
  public String label { get; set; }
  @AuraEnabled
  public String dataType { get; set; }
  @AuraEnabled
  public String objectType { get; set; }
}
