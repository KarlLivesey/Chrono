// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Deduplicates calculations and returns independent concrete results in request order. */
public with sharing class ChronoCatalogueBatch {
  private final String family;
  public ChronoCatalogueBatch(String family) {
    this.family = family;
  }
  public List<Object> run(List<Object> requests) {
    ChronoActionOperation operation = ChronoActionOperations.create(
      family,
      requests
    );
    List<Object> results = new List<Object>();
    Map<String, String> cache = new Map<String, String>();
    Type resultType = operation.resultType();
    for (Object request : requests) {
      String key = JSON.serialize(request);
      if (!cache.containsKey(key)) {
        try {
          cache.put(key, JSON.serialize(operation.evaluate(request)));
        } catch (Exception ex) {
          cache.put(
            key,
            JSON.serialize(
              new Map<String, Object>{
                'success' => false,
                'errorMessage' => ex.getMessage()
              }
            )
          );
        }
      }
      // Deserialisation creates independent primitive/list result graphs; cached objects never escape.
      results.add(JSON.deserialize(cache.get(key), resultType));
    }
    return results;
  }
}
