// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal calculation result, independent of invocable transport. */
// Flat internal transport record; each field preserves a distinct calculation outcome.
@SuppressWarnings('PMD.ExcessivePublicCount, PMD.TooManyFields')
public with sharing class ChronoOperationResult {
  public Boolean success;
  public String errorMessage;
  public String valueType;
  public String value;
  public Datetime instantValue;
  public Date dateValue;
  public String timeValue;
  public String timeZoneId;
  public Integer months;
  public Integer days;
  public Long milliseconds;
  public Boolean isOpen;
  public Integer comparison;
  public String resolutionStatus;
  public String earlierValue;
  public String laterValue;
  public String previousValue;
  public String nextValue;
  public Boolean withinTolerance;
  public Boolean samePeriod;
}
