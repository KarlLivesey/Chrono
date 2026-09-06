// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description One collection response per Flow interview; items preserve input order. */
@SuppressWarnings(
  'PMD.AvoidGlobalModifier'
) // Subscriber Flow response wrapper.
global with sharing class ChronoFlowCollectionResult {
  @InvocableVariable(
    label='Results'
    description='One independent result per collection item, in input order.'
  )
  global List<ChronoFlowResult> results;
  @InvocableVariable(
    label='Success'
    description='True only when every collection item succeeds.'
  )
  global Boolean success;
  @InvocableVariable(
    label='Error'
    description='Invalid collection input diagnostic; item errors are on individual results.'
  )
  global String errorMessage;
  /** @description Global no-argument constructor for Flow. */
  global ChronoFlowCollectionResult() {
    results = new List<ChronoFlowResult>();
    success = true;
  }
}
