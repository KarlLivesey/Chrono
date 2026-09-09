// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause

import { LightningElement, api } from "lwc";
import { FlowAttributeChangeEvent } from "lightning/flowSupport";
export default class ChronoFlowValueInput extends LightningElement {
  @api kind = "duration";
  @api label = "Value";
  @api required = false;
  @api disabled = false;
  _value = "";
  @api get value() {
    return this._value;
  }
  set value(value) {
    this._value = value;
  }
  externalError = "";
  get duration() {
    return this.kind === "duration";
  }
  get time() {
    return this.kind === "time";
  }
  change(event) {
    event.stopPropagation();
    this._value = event.detail.value;
    this.dispatchEvent(new FlowAttributeChangeEvent("value", this.value));
  }
  @api validate() {
    if (!["duration", "time", "yearmonth", "monthday"].includes(this.kind))
      return { isValid: false, errorMessage: "Unsupported value type." };
    return (
      this.template.querySelector("[data-control]")?.validate() || {
        isValid: false,
        errorMessage: "The input is loading."
      }
    );
  }
  @api setCustomValidity(error) {
    this._external = error || "";
  }
  @api reportValidity() {
    this.externalError = this._external;
    this.template.querySelector("[data-control]")?.reportValidity();
  }
}
