// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Schema selector coverage, independent of record data. */
@IsTest
private class ChronoFlowEditorTest {
  @IsTest
  static void fieldsAndParentTraversalWithoutQueries() {
    Integer beforeQueries = Limits.getQueries();
    Map<String, ChronoFlowResourceField> fields = new Map<String, ChronoFlowResourceField>();
    for (
      ChronoFlowResourceField field : ChronoFlowEditorController.getFields(
        'Contact'
      )
    ) {
      fields.put(field.name, field);
    }
    Assert.areEqual(
      'String',
      fields.get('LastName').dataType,
      'Text fields can be selected.'
    );
    Assert.areEqual(
      'Date',
      fields.get('Birthdate').dataType,
      'Date fields retain their Flow type.'
    );
    Assert.areEqual(
      'Account',
      fields.get('Account').objectType,
      'The parent record can be traversed.'
    );
    Assert.areEqual(
      beforeQueries,
      Limits.getQueries(),
      'Schema navigation does not query records.'
    );
  }
  @IsTest
  static void rejectsUnknownObject() {
    try {
      ChronoFlowEditorController.getFields('NotAnObject');
      Assert.fail('Unknown object must fail.');
    } catch (ChronoException expected) {
      Assert.isTrue(
        expected.getMessage().contains('unavailable'),
        'Explain the unavailable object.'
      );
    }
  }
}
