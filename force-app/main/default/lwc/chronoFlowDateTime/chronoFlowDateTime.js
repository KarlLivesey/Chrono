// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";
import { FlowAttributeChangeEvent } from "lightning/flowSupport";
/** Flow transport adapter. Resolution and UI are reusable outside Flow. */
export default class ChronoFlowDateTime extends LightningElement {
  _inputs = {};
  _outputs = {};
  get controlProperties() {
    return this._inputs;
  }
  @api get allowOffsetOverride() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "allowOffsetOverride"
    )
      ? this._outputs.allowOffsetOverride
      : this.refs.control
        ? this.refs.control.allowOffsetOverride
        : this._inputs.allowOffsetOverride;
  }
  set allowOffsetOverride(value) {
    this._inputs = { ...this._inputs, allowOffsetOverride: value };
    delete this._outputs.allowOffsetOverride;
  }
  @api get initialChronoValue() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "initialChronoValue"
    )
      ? this._outputs.initialChronoValue
      : this.refs.control
        ? this.refs.control.initialChronoValue
        : this._inputs.initialChronoValue;
  }
  set initialChronoValue(value) {
    this._inputs = { ...this._inputs, initialChronoValue: value };
    delete this._outputs.initialChronoValue;
  }
  @api get chronoDateValue() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "chronoDateValue"
    )
      ? this._outputs.chronoDateValue
      : this.refs.control
        ? this.refs.control.chronoDateValue
        : this._inputs.chronoDateValue;
  }
  set chronoDateValue(value) {
    this._inputs = { ...this._inputs, chronoDateValue: value };
    delete this._outputs.chronoDateValue;
  }
  @api get chronoPlainDateTimeValue() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "chronoPlainDateTimeValue"
    )
      ? this._outputs.chronoPlainDateTimeValue
      : this.refs.control
        ? this.refs.control.chronoPlainDateTimeValue
        : this._inputs.chronoPlainDateTimeValue;
  }
  set chronoPlainDateTimeValue(value) {
    this._inputs = { ...this._inputs, chronoPlainDateTimeValue: value };
    delete this._outputs.chronoPlainDateTimeValue;
  }
  @api get chronoTimeValue() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "chronoTimeValue"
    )
      ? this._outputs.chronoTimeValue
      : this.refs.control
        ? this.refs.control.chronoTimeValue
        : this._inputs.chronoTimeValue;
  }
  set chronoTimeValue(value) {
    this._inputs = { ...this._inputs, chronoTimeValue: value };
    delete this._outputs.chronoTimeValue;
  }
  @api get chronoInstantValue() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "chronoInstantValue"
    )
      ? this._outputs.chronoInstantValue
      : this.refs.control
        ? this.refs.control.chronoInstantValue
        : this._inputs.chronoInstantValue;
  }
  set chronoInstantValue(value) {
    this._inputs = { ...this._inputs, chronoInstantValue: value };
    delete this._outputs.chronoInstantValue;
  }
  @api get chronoZonedDateTimeValue() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "chronoZonedDateTimeValue"
    )
      ? this._outputs.chronoZonedDateTimeValue
      : this.refs.control
        ? this.refs.control.chronoZonedDateTimeValue
        : this._inputs.chronoZonedDateTimeValue;
  }
  set chronoZonedDateTimeValue(value) {
    this._inputs = { ...this._inputs, chronoZonedDateTimeValue: value };
    delete this._outputs.chronoZonedDateTimeValue;
  }
  @api get offsetOverride() {
    return Object.prototype.hasOwnProperty.call(this._outputs, "offsetOverride")
      ? this._outputs.offsetOverride
      : this.refs.control
        ? this.refs.control.offsetOverride
        : this._inputs.offsetOverride;
  }
  set offsetOverride(value) {
    this._inputs = { ...this._inputs, offsetOverride: value };
    delete this._outputs.offsetOverride;
  }
  @api get offsetMode() {
    return Object.prototype.hasOwnProperty.call(this._outputs, "offsetMode")
      ? this._outputs.offsetMode
      : this.refs.control
        ? this.refs.control.offsetMode
        : this._inputs.offsetMode;
  }
  set offsetMode(value) {
    this._inputs = { ...this._inputs, offsetMode: value };
    delete this._outputs.offsetMode;
  }
  @api get lockOperatingHoursSelection() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "lockOperatingHoursSelection"
    )
      ? this._outputs.lockOperatingHoursSelection
      : this.refs.control
        ? this.refs.control.lockOperatingHoursSelection
        : this._inputs.lockOperatingHoursSelection;
  }
  set lockOperatingHoursSelection(value) {
    this._inputs = { ...this._inputs, lockOperatingHoursSelection: value };
    delete this._outputs.lockOperatingHoursSelection;
  }
  @api get mode() {
    return Object.prototype.hasOwnProperty.call(this._outputs, "mode")
      ? this._outputs.mode
      : this.refs.control
        ? this.refs.control.mode
        : this._inputs.mode;
  }
  set mode(value) {
    this._inputs = { ...this._inputs, mode: value };
    delete this._outputs.mode;
  }
  @api get dateStyle() {
    return Object.prototype.hasOwnProperty.call(this._outputs, "dateStyle")
      ? this._outputs.dateStyle
      : this.refs.control
        ? this.refs.control.dateStyle
        : this._inputs.dateStyle;
  }
  set dateStyle(value) {
    this._inputs = { ...this._inputs, dateStyle: value };
    delete this._outputs.dateStyle;
  }
  @api get timeZoneSelectionMode() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "timeZoneSelectionMode"
    )
      ? this._outputs.timeZoneSelectionMode
      : this.refs.control
        ? this.refs.control.timeZoneSelectionMode
        : this._inputs.timeZoneSelectionMode;
  }
  set timeZoneSelectionMode(value) {
    this._inputs = { ...this._inputs, timeZoneSelectionMode: value };
    delete this._outputs.timeZoneSelectionMode;
  }
  @api get timeZoneIds() {
    return Object.prototype.hasOwnProperty.call(this._outputs, "timeZoneIds")
      ? this._outputs.timeZoneIds
      : this.refs.control
        ? this.refs.control.timeZoneIds
        : this._inputs.timeZoneIds;
  }
  set timeZoneIds(value) {
    this._inputs = { ...this._inputs, timeZoneIds: value };
    delete this._outputs.timeZoneIds;
  }
  @api get timeZoneIdsText() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "timeZoneIdsText"
    )
      ? this._outputs.timeZoneIdsText
      : this.refs.control
        ? this.refs.control.timeZoneIdsText
        : this._inputs.timeZoneIdsText;
  }
  set timeZoneIdsText(value) {
    this._inputs = { ...this._inputs, timeZoneIdsText: value };
    delete this._outputs.timeZoneIdsText;
  }
  @api get label() {
    return Object.prototype.hasOwnProperty.call(this._outputs, "label")
      ? this._outputs.label
      : this.refs.control
        ? this.refs.control.label
        : this._inputs.label;
  }
  set label(value) {
    this._inputs = { ...this._inputs, label: value };
    delete this._outputs.label;
  }
  @api get helpText() {
    return Object.prototype.hasOwnProperty.call(this._outputs, "helpText")
      ? this._outputs.helpText
      : this.refs.control
        ? this.refs.control.helpText
        : this._inputs.helpText;
  }
  set helpText(value) {
    this._inputs = { ...this._inputs, helpText: value };
    delete this._outputs.helpText;
  }
  @api get required() {
    return Object.prototype.hasOwnProperty.call(this._outputs, "required")
      ? this._outputs.required
      : this.refs.control
        ? this.refs.control.required
        : this._inputs.required;
  }
  set required(value) {
    this._inputs = { ...this._inputs, required: value };
    delete this._outputs.required;
  }
  @api get disabled() {
    return Object.prototype.hasOwnProperty.call(this._outputs, "disabled")
      ? this._outputs.disabled
      : this.refs.control
        ? this.refs.control.disabled
        : this._inputs.disabled;
  }
  set disabled(value) {
    this._inputs = { ...this._inputs, disabled: value };
    delete this._outputs.disabled;
  }
  @api get allowTimeZoneSelection() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "allowTimeZoneSelection"
    )
      ? this._outputs.allowTimeZoneSelection
      : this.refs.control
        ? this.refs.control.allowTimeZoneSelection
        : this._inputs.allowTimeZoneSelection;
  }
  set allowTimeZoneSelection(value) {
    this._inputs = { ...this._inputs, allowTimeZoneSelection: value };
    delete this._outputs.allowTimeZoneSelection;
  }
  @api get timeZoneId() {
    return Object.prototype.hasOwnProperty.call(this._outputs, "timeZoneId")
      ? this._outputs.timeZoneId
      : this.refs.control
        ? this.refs.control.timeZoneId
        : this._inputs.timeZoneId;
  }
  set timeZoneId(value) {
    this._inputs = { ...this._inputs, timeZoneId: value };
    delete this._outputs.timeZoneId;
  }
  @api get dateValue() {
    return Object.prototype.hasOwnProperty.call(this._outputs, "dateValue")
      ? this._outputs.dateValue
      : this.refs.control
        ? this.refs.control.dateValue
        : this._inputs.dateValue;
  }
  set dateValue(value) {
    this._inputs = { ...this._inputs, dateValue: value };
    delete this._outputs.dateValue;
  }
  @api get dateTimeValue() {
    return Object.prototype.hasOwnProperty.call(this._outputs, "dateTimeValue")
      ? this._outputs.dateTimeValue
      : this.refs.control
        ? this.refs.control.dateTimeValue
        : this._inputs.dateTimeValue;
  }
  set dateTimeValue(value) {
    this._inputs = { ...this._inputs, dateTimeValue: value };
    delete this._outputs.dateTimeValue;
  }
  @api get operatingHoursMode() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "operatingHoursMode"
    )
      ? this._outputs.operatingHoursMode
      : this.refs.control
        ? this.refs.control.operatingHoursMode
        : this._inputs.operatingHoursMode;
  }
  set operatingHoursMode(value) {
    this._inputs = { ...this._inputs, operatingHoursMode: value };
    delete this._outputs.operatingHoursMode;
  }
  @api get operatingHoursId() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "operatingHoursId"
    )
      ? this._outputs.operatingHoursId
      : this.refs.control
        ? this.refs.control.operatingHoursId
        : this._inputs.operatingHoursId;
  }
  set operatingHoursId(value) {
    this._inputs = { ...this._inputs, operatingHoursId: value };
    delete this._outputs.operatingHoursId;
  }
  @api get operatingHoursIds() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "operatingHoursIds"
    )
      ? this._outputs.operatingHoursIds
      : this.refs.control
        ? this.refs.control.operatingHoursIds
        : this._inputs.operatingHoursIds;
  }
  set operatingHoursIds(value) {
    this._inputs = { ...this._inputs, operatingHoursIds: value };
    delete this._outputs.operatingHoursIds;
  }
  @api get operatingHoursFilter() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "operatingHoursFilter"
    )
      ? this._outputs.operatingHoursFilter
      : this.refs.control
        ? this.refs.control.operatingHoursFilter
        : this._inputs.operatingHoursFilter;
  }
  set operatingHoursFilter(value) {
    this._inputs = { ...this._inputs, operatingHoursFilter: value };
    delete this._outputs.operatingHoursFilter;
  }
  @api get operatingHoursRecord() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "operatingHoursRecord"
    )
      ? this._outputs.operatingHoursRecord
      : this.refs.control
        ? this.refs.control.operatingHoursRecord
        : this._inputs.operatingHoursRecord;
  }
  set operatingHoursRecord(value) {
    this._inputs = { ...this._inputs, operatingHoursRecord: value };
    delete this._outputs.operatingHoursRecord;
  }
  @api get operatingHoursRecords() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "operatingHoursRecords"
    )
      ? this._outputs.operatingHoursRecords
      : this.refs.control
        ? this.refs.control.operatingHoursRecords
        : this._inputs.operatingHoursRecords;
  }
  set operatingHoursRecords(value) {
    this._inputs = { ...this._inputs, operatingHoursRecords: value };
    delete this._outputs.operatingHoursRecords;
  }
  @api get timeSlots() {
    return Object.prototype.hasOwnProperty.call(this._outputs, "timeSlots")
      ? this._outputs.timeSlots
      : this.refs.control
        ? this.refs.control.timeSlots
        : this._inputs.timeSlots;
  }
  set timeSlots(value) {
    this._inputs = { ...this._inputs, timeSlots: value };
    delete this._outputs.timeSlots;
  }
  @api get holidays() {
    return Object.prototype.hasOwnProperty.call(this._outputs, "holidays")
      ? this._outputs.holidays
      : this.refs.control
        ? this.refs.control.holidays
        : this._inputs.holidays;
  }
  set holidays(value) {
    this._inputs = { ...this._inputs, holidays: value };
    delete this._outputs.holidays;
  }
  @api get fixedHours() {
    return Object.prototype.hasOwnProperty.call(this._outputs, "fixedHours")
      ? this._outputs.fixedHours
      : this.refs.control
        ? this.refs.control.fixedHours
        : this._inputs.fixedHours;
  }
  set fixedHours(value) {
    this._inputs = { ...this._inputs, fixedHours: value };
    delete this._outputs.fixedHours;
  }
  @api get operatingHoursIdsText() {
    return Object.prototype.hasOwnProperty.call(
      this._outputs,
      "operatingHoursIdsText"
    )
      ? this._outputs.operatingHoursIdsText
      : this.refs.control
        ? this.refs.control.operatingHoursIdsText
        : this._inputs.operatingHoursIdsText;
  }
  set operatingHoursIdsText(value) {
    this._inputs = { ...this._inputs, operatingHoursIdsText: value };
    delete this._outputs.operatingHoursIdsText;
  }
  handleValue(event) {
    event.stopPropagation();
    const { name, value } = event.detail;
    this._outputs = { ...this._outputs, [name]: value };
    this.dispatchEvent(new FlowAttributeChangeEvent(name, value));
  }
  @api validate() {
    return (
      this.refs.control?.validate() || {
        isValid: false,
        errorMessage: "The picker is still loading."
      }
    );
  }
  @api setCustomValidity(message) {
    this._externalError = message;
    this.refs.control?.setCustomValidity(message);
  }
  @api reportValidity() {
    this.refs.control?.setCustomValidity(this._externalError || "");
    return this.refs.control?.reportValidity();
  }
}
