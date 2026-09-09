// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Read-only schema access for the same-package Flow resource selector. */
public with sharing class ChronoFlowEditorController {
  /** @description Lists readable fields and unambiguous parent relationships; no record queries.
   * @param objectApiName Exact standard or namespaced object API name.
   * @return Fields visible to the configuring admin.
   */
  @AuraEnabled(cacheable=true)
  public static List<ChronoFlowResourceField> getFields(String objectApiName) {
    Schema.DescribeSObjectResult objectDescribe = readableObject(objectApiName);
    List<ChronoFlowResourceField> result = new List<ChronoFlowResourceField>();
    Map<String, Schema.SObjectField> fields = objectDescribe.fields.getMap();
    List<String> names = new List<String>(fields.keySet());
    names.sort();
    for (String fieldName : names) {
      Schema.DescribeFieldResult field = fields.get(fieldName).getDescribe();
      if (!field.isAccessible()) {
        continue;
      }
      String kind = String.valueOf(field.getType()).toLowerCase();
      if (
        new Set<String>{ 'address', 'location', 'base64', 'anytype' }
          .contains(kind)
      ) {
        continue;
      }
      result.add(describeValue(field, kind));
      ChronoFlowResourceField relationship = describeRelationship(field);
      if (relationship != null) {
        result.add(relationship);
      }
    }
    return result;
  }

  private static Schema.DescribeSObjectResult readableObject(
    String objectApiName
  ) {
    if (String.isBlank(objectApiName)) {
      throw new ChronoException('Choose an object to browse its fields.');
    }
    Schema.SObjectType objectType = Schema.getGlobalDescribe()
      .get(objectApiName);
    if (objectType == null || !objectType.getDescribe().isAccessible()) {
      throw new ChronoException(
        'This object is unavailable or you do not have read access.'
      );
    }
    return objectType.getDescribe();
  }

  private static ChronoFlowResourceField describeValue(
    Schema.DescribeFieldResult field,
    String kind
  ) {
    ChronoFlowResourceField value = new ChronoFlowResourceField();
    value.name = field.getName();
    value.label = field.getLabel();
    value.dataType = kind == 'boolean'
      ? 'Boolean'
      : kind == 'date'
          ? 'Date'
          : kind == 'datetime'
              ? 'DateTime'
              : new Set<String>{
                      'double',
                      'currency',
                      'percent',
                      'integer',
                      'long'
                    }
                    .contains(kind)
                  ? 'Number'
                  : 'String';
    return value;
  }

  private static ChronoFlowResourceField describeRelationship(
    Schema.DescribeFieldResult field
  ) {
    if (
      field.getType() == Schema.DisplayType.Reference &&
      field.getRelationshipName() != null &&
      field.getReferenceTo().size() == 1
    ) {
      Schema.DescribeSObjectResult parent = field.getReferenceTo()[0]
        .getDescribe();
      if (parent.isAccessible()) {
        ChronoFlowResourceField relationship = new ChronoFlowResourceField();
        relationship.name = field.getRelationshipName();
        relationship.label = field.getLabel() + ' (record)';
        relationship.dataType = 'SObject';
        relationship.objectType = parent.getName();
        return relationship;
      }
    }
    return null;
  }
}
