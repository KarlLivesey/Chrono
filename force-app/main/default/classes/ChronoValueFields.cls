// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal common value input; never exposed directly to Flow. */
@SuppressWarnings(
  'PMD.TooManyFields, PMD.ExcessivePublicCount'
) // Internal input transport mirrors declared action fields.
public with sharing class ChronoValueFields {
  public String operation;
  public String valueType;
  public String value;
  public Date dateValue;
  public Datetime instantValue;
  public String timeValue;
  public String timeZoneId;
  public String disambiguation;
  public Integer year;
  public Integer month;
  public Integer day;
  public Integer hour;
  public Integer minute;
  public Integer second;
  public Integer millisecond;
  public String overflow;
  public String text;
  public String pattern;
  public Decimal epochValue;
  public String epochUnit;
}
