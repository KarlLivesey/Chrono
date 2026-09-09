// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal bulk operations and concrete result adaptation. */
public with sharing class ChronoValueOperations {
  public static List<ChronoValueResult> convert(
    List<ChronoConvertInput> requests
  ) {
    List<ChronoValueResult> results = new List<ChronoValueResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoConvertInput item : requests) {
      inputs.add(item);
    }
    for (
      ChronoOperationResult item : new ChronoCalculationBatch('Convert')
        .run(inputs)
    ) {
      results.add(ChronoServiceResults.value((ChronoOperationResult) item));
    }
    return results;
  }
  public static List<ChronoValueResult> create(
    List<ChronoCreateValueInput> requests
  ) {
    List<ChronoValueResult> results = new List<ChronoValueResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoCreateValueInput item : requests) {
      inputs.add(item);
    }
    for (Object item : new ChronoCatalogueBatch('CreateValue').run(inputs)) {
      results.add(ChronoServiceResults.value((ChronoOperationResult) item));
    }
    return results;
  }
  public static List<ChronoValueResult> replace(
    List<ChronoReplaceValueInput> requests
  ) {
    List<ChronoValueResult> results = new List<ChronoValueResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoReplaceValueInput item : requests) {
      inputs.add(item);
    }
    for (Object item : new ChronoCatalogueBatch('ReplaceValue').run(inputs)) {
      results.add(ChronoServiceResults.value((ChronoOperationResult) item));
    }
    return results;
  }
  public static List<ChronoValueResult> parse(
    List<ChronoParseValueInput> requests
  ) {
    List<ChronoValueResult> results = new List<ChronoValueResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoParseValueInput item : requests) {
      inputs.add(item);
    }
    for (Object item : new ChronoCatalogueBatch('ParseValue').run(inputs)) {
      results.add(ChronoServiceResults.value((ChronoOperationResult) item));
    }
    return results;
  }
  public static List<ChronoValidationResult> validate(
    List<ChronoValidateValueInput> requests
  ) {
    List<ChronoValidationResult> results = new List<ChronoValidationResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoValidateValueInput item : requests) {
      inputs.add(item);
    }
    for (Object item : new ChronoCatalogueBatch('ValidateValue').run(inputs)) {
      results.add((ChronoValidationResult) item);
    }
    return results;
  }
  public static List<ChronoEpochResult> convertEpoch(
    List<ChronoEpochValueInput> requests
  ) {
    List<ChronoEpochResult> results = new List<ChronoEpochResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoEpochValueInput item : requests) {
      inputs.add(item);
    }
    for (Object item : new ChronoCatalogueBatch('EpochValue').run(inputs)) {
      results.add((ChronoEpochResult) item);
    }
    return results;
  }
  public static List<ChronoDetailsResult> details(
    List<ChronoValueDetailsInput> requests
  ) {
    List<ChronoDetailsResult> results = new List<ChronoDetailsResult>();
    if (requests == null || requests.isEmpty()) {
      return results;
    }
    List<Object> inputs = new List<Object>();
    for (ChronoValueDetailsInput item : requests) {
      inputs.add(item);
    }
    for (Object item : new ChronoCatalogueBatch('ValueDetails').run(inputs)) {
      results.add((ChronoDetailsResult) item);
    }
    return results;
  }
}
