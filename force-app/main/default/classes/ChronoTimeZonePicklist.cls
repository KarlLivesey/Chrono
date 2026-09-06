// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Flow Builder choices from Salesforce's supported user time-zone values. No record data is read. */
@SuppressWarnings('PMD.AvoidGlobalModifier')
global with sharing class ChronoTimeZonePicklist extends VisualEditor.DynamicPickList {
  /** @description Constructor used by the subscriber's configuration editor. */
  @SuppressWarnings(
    'PMD.EmptyStatementBlock'
  ) // Required global no-argument Flow constructor.
  global ChronoTimeZonePicklist() {
  } // NOPMD - Required global no-argument constructor.
  /** @description Leaves the zone unselected rather than inferring the designer's zone.
   * @return An empty choice requiring explicit configuration.
   */
  global override VisualEditor.DataRow getDefaultValue() {
    return new VisualEditor.DataRow('Choose a time zone', '');
  }
  /** @description Returns supported active zones, preserving Salesforce labels.
   * @return Label and zone-ID choices.
   */
  global override VisualEditor.DynamicPickListRows getValues() {
    VisualEditor.DynamicPickListRows choices = new VisualEditor.DynamicPickListRows();
    for (
      Schema.PicklistEntry entry : Schema.User.TimeZoneSidKey.getDescribe()
        .getPicklistValues()
    ) {
      if (entry.isActive()) {
        choices.addRow(
          new VisualEditor.DataRow(entry.getLabel(), entry.getValue())
        );
      }
    }
    return choices;
  }
}
