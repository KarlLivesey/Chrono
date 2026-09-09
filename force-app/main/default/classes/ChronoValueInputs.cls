// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Explicit typed adapters from action inputs to internal value operations. */
public with sharing class ChronoValueInputs {
  /**
   * @description Copies the declared ChronoValueFields fields without serialisation.
   * @param input Non-null action input; source values are not modified.
   * @return A new internal request containing the shared fields. Validation occurs in the operation.
   */
  public static ChronoConvertInput source(ChronoValueFields input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoConvertInput result = new ChronoConvertInput();
    result.valueType = input.valueType;
    result.value = input.value;
    result.instantValue = input.instantValue;
    result.dateValue = input.dateValue;
    result.timeValue = input.timeValue;
    result.timeZoneId = input.timeZoneId;
    result.disambiguation = input.disambiguation;
    return result;
  }
  /**
   * @description Copies the declared ChronoZoneToolsInput fields without serialisation.
   * @param input Non-null action input; source values are not modified.
   * @return A new internal request containing the shared fields. Validation occurs in the operation.
   */
  public static ChronoConvertInput source(ChronoZoneToolsInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoConvertInput result = new ChronoConvertInput();
    result.valueType = input.valueType;
    result.value = input.value;
    result.instantValue = input.instantValue;
    result.dateValue = input.dateValue;
    result.timeValue = input.timeValue;
    result.timeZoneId = input.timeZoneId;
    result.disambiguation = input.disambiguation;
    return result;
  }
  /**
   * @description Copies the declared ChronoRangeToolsInput fields without serialisation.
   * @param input Non-null action input; source values are not modified.
   * @return A new internal request containing the shared fields. Validation occurs in the operation.
   */
  public static ChronoConvertInput source(ChronoRangeToolsInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoConvertInput result = new ChronoConvertInput();
    result.valueType = input.valueType;
    result.value = input.value;
    result.instantValue = input.instantValue;
    result.dateValue = input.dateValue;
    result.timeValue = input.timeValue;
    result.timeZoneId = input.timeZoneId;
    result.disambiguation = input.disambiguation;
    return result;
  }
  /**
   * @description Copies the declared ChronoFormatValueInput fields without serialisation.
   * @param input Non-null action input; source values are not modified.
   * @return A new internal request containing the shared fields. Validation occurs in the operation.
   */
  public static ChronoConvertInput source(ChronoFormatValueInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoConvertInput result = new ChronoConvertInput();
    result.valueType = input.valueType;
    result.value = input.value;
    result.instantValue = input.instantValue;
    result.dateValue = input.dateValue;
    result.timeValue = input.timeValue;
    result.timeZoneId = input.timeZoneId;
    result.disambiguation = input.disambiguation;
    return result;
  }
  /**
   * @description Copies the declared ChronoFiscalPeriodInput fields without serialisation.
   * @param input Non-null action input; source values are not modified.
   * @return A new internal request containing the shared fields. Validation occurs in the operation.
   */
  public static ChronoConvertInput source(ChronoFiscalPeriodInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoConvertInput result = new ChronoConvertInput();
    result.valueType = input.valueType;
    result.value = input.value;
    result.instantValue = input.instantValue;
    result.dateValue = input.dateValue;
    result.timeValue = input.timeValue;
    result.timeZoneId = input.timeZoneId;
    result.disambiguation = input.disambiguation;
    return result;
  }
  /**
   * @description Copies the declared ChronoRecurrenceInput fields without serialisation.
   * @param input Non-null action input; source values are not modified.
   * @return A new internal request containing the shared fields. Validation occurs in the operation.
   */
  public static ChronoConvertInput source(ChronoRecurrenceInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoConvertInput result = new ChronoConvertInput();
    result.valueType = input.valueType;
    result.value = input.value;
    result.instantValue = input.instantValue;
    result.dateValue = input.dateValue;
    result.timeValue = input.timeValue;
    result.timeZoneId = input.timeZoneId;
    result.disambiguation = input.disambiguation;
    return result;
  }
  /**
   * @description Copies the declared ChronoWorkingDaysInput fields without serialisation.
   * @param input Non-null action input; source values are not modified.
   * @return A new internal request containing the shared fields. Validation occurs in the operation.
   */
  public static ChronoConvertInput source(ChronoWorkingDaysInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoConvertInput result = new ChronoConvertInput();
    result.valueType = input.valueType;
    result.value = input.value;
    result.instantValue = input.instantValue;
    result.dateValue = input.dateValue;
    result.timeValue = input.timeValue;
    result.timeZoneId = input.timeZoneId;
    result.disambiguation = input.disambiguation;
    return result;
  }
  /**
   * @description Copies the declared ChronoCreateValueInput fields without serialisation.
   * @param input Non-null action input; source values are not modified.
   * @return A new internal request containing the shared fields. Validation occurs in the operation.
   */
  public static ChronoValueFields readValue(ChronoCreateValueInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoValueFields result = new ChronoValueFields();
    result.valueType = input.valueType;
    result.timeZoneId = input.timeZoneId;
    result.disambiguation = input.disambiguation;
    result.year = input.year;
    result.month = input.month;
    result.day = input.day;
    result.hour = input.hour;
    result.minute = input.minute;
    result.second = input.second;
    result.millisecond = input.millisecond;
    return result;
  }
  /**
   * @description Copies the declared ChronoReplaceValueInput fields without serialisation.
   * @param input Non-null action input; source values are not modified.
   * @return A new internal request containing the shared fields. Validation occurs in the operation.
   */
  public static ChronoValueFields readValue(ChronoReplaceValueInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoValueFields result = new ChronoValueFields();
    result.valueType = input.valueType;
    result.value = input.value;
    result.dateValue = input.dateValue;
    result.instantValue = input.instantValue;
    result.timeValue = input.timeValue;
    result.timeZoneId = input.timeZoneId;
    result.disambiguation = input.disambiguation;
    result.year = input.year;
    result.month = input.month;
    result.day = input.day;
    result.hour = input.hour;
    result.minute = input.minute;
    result.second = input.second;
    result.millisecond = input.millisecond;
    result.overflow = input.overflow;
    return result;
  }
  /**
   * @description Copies the declared ChronoParseValueInput fields without serialisation.
   * @param input Non-null action input; source values are not modified.
   * @return A new internal request containing the shared fields. Validation occurs in the operation.
   */
  public static ChronoValueFields readValue(ChronoParseValueInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoValueFields result = new ChronoValueFields();
    result.valueType = input.valueType;
    result.timeZoneId = input.timeZoneId;
    result.disambiguation = input.disambiguation;
    result.text = input.text;
    result.pattern = input.pattern;
    return result;
  }
  /**
   * @description Copies the declared ChronoValueDetailsInput fields without serialisation.
   * @param input Non-null action input; source values are not modified.
   * @return A new internal request containing the shared fields. Validation occurs in the operation.
   */
  public static ChronoValueFields readValue(ChronoValueDetailsInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoValueFields result = new ChronoValueFields();
    result.valueType = input.valueType;
    result.value = input.value;
    result.dateValue = input.dateValue;
    result.instantValue = input.instantValue;
    result.timeValue = input.timeValue;
    result.timeZoneId = input.timeZoneId;
    result.disambiguation = input.disambiguation;
    return result;
  }
  /**
   * @description Copies the declared ChronoValidateValueInput fields without serialisation.
   * @param input Non-null action input; source values are not modified.
   * @return A new internal request containing the shared fields. Validation occurs in the operation.
   */
  public static ChronoValueFields readValue(ChronoValidateValueInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoValueFields result = new ChronoValueFields();
    result.valueType = input.valueType;
    result.value = input.value;
    result.dateValue = input.dateValue;
    result.instantValue = input.instantValue;
    result.timeValue = input.timeValue;
    result.timeZoneId = input.timeZoneId;
    result.disambiguation = input.disambiguation;
    return result;
  }
  /**
   * @description Copies the declared ChronoEpochValueInput fields without serialisation.
   * @param input Non-null action input; source values are not modified.
   * @return A new internal request containing the shared fields. Validation occurs in the operation.
   */
  public static ChronoValueFields readValue(ChronoEpochValueInput input) {
    ChronoSupport.requireValue(input, 'Input');
    ChronoValueFields result = new ChronoValueFields();
    result.operation = input.operation;
    result.valueType = input.valueType;
    result.value = input.value;
    result.dateValue = input.dateValue;
    result.instantValue = input.instantValue;
    result.timeValue = input.timeValue;
    result.timeZoneId = input.timeZoneId;
    result.disambiguation = input.disambiguation;
    result.epochValue = input.epochValue;
    result.epochUnit = input.epochUnit;
    return result;
  }
}
