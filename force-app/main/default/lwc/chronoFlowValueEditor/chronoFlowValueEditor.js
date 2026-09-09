// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";
/** Builder-only input: a literal or a Flow resource reference. No persistence. */
export default class ChronoFlowValueEditor extends LightningElement {
  @api name;
  @api label;
  @api value;
  @api valueType = "String";
  @api acceptedTypes = [];
  _reference = false;
  _sourceMode;
  @api get reference() {
    return this._reference;
  }
  set reference(value) {
    if (this._reference !== Boolean(value)) this._sourceMode = undefined;
    this._reference = Boolean(value);
  }
  @api literalType = "";
  @api referenceOnly = false;
  @api options = [];
  @api searchable = false;
  @api lookupMessage = "";
  @api helpText = "";
  @api builderContext;
  @api automaticOutputVariables;
  @api objectType = "";
  get isReference() {
    return (
      this.referenceOnly ||
      (this._sourceMode ? this._sourceMode === "reference" : this.reference)
    );
  }
  get isTimeBlocks() {
    return this.literalType === "time-blocks";
  }
  @api validate() {
    return (
      this.template.querySelector("c-chrono-time-block-editor")?.validate() ||
      ""
    );
  }
  get isMultiline() {
    return this.literalType === "textarea";
  }
  get isBoolean() {
    return this.valueType === "Boolean";
  }
  get hasOptions() {
    return this.options?.length > 0;
  }
  get isLiteral() {
    return !this.isReference;
  }
  get literalLabel() {
    if (this.isTimeBlocks) return "Configure Blocks";
    if (this.searchable || this.hasOptions) return "Select Value";
    return (
      {
        Date: "Enter Date",
        DateTime: "Enter Date/Time",
        Integer: "Enter Number",
        Number: "Enter Number",
        Boolean: "Set Checkbox"
      }[this.valueType] || "Enter Text"
    );
  }
  get literalIcon() {
    return (
      {
        Date: "utility:event",
        DateTime: "utility:date_time",
        Boolean: "utility:check"
      }[this.valueType] || "utility:text"
    );
  }
  get sourceIcon() {
    return this.isReference ? "utility:collection" : this.literalIcon;
  }
  get sourceLabel() {
    const mode = this.isReference ? "Search Resources" : this.literalLabel;
    return `${this.label}: ${mode}. Choose input mode`;
  }
  get sourceValue() {
    return this.isReference ? "reference" : "literal";
  }
  get literalInputType() {
    if (this.literalType) return this.literalType;
    if (["Integer", "Number"].includes(this.valueType)) return "number";
    return this.valueType === "Date"
      ? "date"
      : this.valueType === "DateTime"
        ? "datetime"
        : "text";
  }
  changeSource(event) {
    const mode = event.detail.value;
    if (
      this.referenceOnly ||
      mode === this.sourceValue ||
      !["literal", "reference"].includes(mode)
    )
      return;
    this._sourceMode = mode;
    this.emit(null, mode === "reference");
  }
  chooseResource(event) {
    this.emit(event.detail.value, true, event.detail);
  }
  chooseLiteral(event) {
    this.emit(event.detail.value, false);
  }
  changeValue(event) {
    let value =
      this.isBoolean && !this.isReference
        ? event.target.checked
        : (event.detail?.value ?? event.target.value);
    if (
      ["Integer", "Number"].includes(this.valueType) &&
      value !== "" &&
      value != null
    )
      value = Number(value);
    this.emit(value, this.isReference);
  }
  emit(value, reference, selected = {}) {
    this.dispatchEvent(
      new CustomEvent("valuechange", {
        detail: {
          name: this.name,
          value,
          reference,
          dataType: selected.dataType || this.valueType,
          objectType: selected.objectType
        }
      })
    );
  }
}
