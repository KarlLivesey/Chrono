// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Dispatches related value construction and inspection services. */
public with sharing class ChronoValueActionOperation implements ChronoActionOperation {
  private final String family;
  public ChronoValueActionOperation(String family) {
    this.family = family;
  }
  public Type resultType() {
    switch on family {
      when 'ValueDetails' {
        return ChronoDetailsResult.class;
      }
      when 'ValidateValue' {
        return ChronoValidationResult.class;
      }
      when 'EpochValue' {
        return ChronoEpochResult.class;
      }
      when else {
        return ChronoOperationResult.class;
      }
    }
  }
  public Object evaluate(Object request) {
    ChronoSupport.requireValue(request, 'Input');
    switch on family {
      when 'CreateValue' {
        ChronoValueFields fields = ChronoValueInputs.readValue(
          (ChronoCreateValueInput) request
        );
        return ChronoValueConstruction.create(fields);
      }
      when 'ReplaceValue' {
        ChronoValueFields fields = ChronoValueInputs.readValue(
          (ChronoReplaceValueInput) request
        );
        return ChronoValueConstruction.replace(fields);
      }
      when 'ParseValue' {
        ChronoValueFields fields = ChronoValueInputs.readValue(
          (ChronoParseValueInput) request
        );
        return ChronoPatternParser.parse(fields);
      }
      when 'ValueDetails' {
        ChronoValueFields fields = ChronoValueInputs.readValue(
          (ChronoValueDetailsInput) request
        );
        return ChronoValueInspection.details(fields);
      }
      when 'ValidateValue' {
        ChronoValueFields fields = ChronoValueInputs.readValue(
          (ChronoValidateValueInput) request
        );
        return ChronoValueInspection.validate(fields);
      }
      when 'EpochValue' {
        ChronoValueFields fields = ChronoValueInputs.readValue(
          (ChronoEpochValueInput) request
        );
        return ChronoValueInspection.epoch(fields);
      }
      when else {
        throw new ChronoException('Unknown action family: ' + family);
      }
    }
  }
}
