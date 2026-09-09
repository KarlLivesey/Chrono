// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal, typed inputs shared by the additional Flow operations. */
@SuppressWarnings(
  'PMD.TooManyFields'
) // Shared internal operation data; algorithms live in operation classes.
public with sharing class ChronoOperationInput {
  public ChronoConvertInput source = new ChronoConvertInput();
  public ChronoConvertInput finish = new ChronoConvertInput();
  public String operatingHoursId;
  public OperatingHours operatingHours;
  public List<TimeSlot> timeSlots;
  public List<Holiday> holidays;

  public String direction;
  public Date referenceDate;
  public String unit;
  public String boundary;
  public Integer weekStartsOn;
  public Integer increment;
  public String roundingMode;
  public String resolution;
  public String largestUnit;
  public Long toleranceMilliseconds;
  public String comparisonPeriod;
}
