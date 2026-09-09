// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause

import { LightningElement, api } from "lwc";
import { durationParts, durationText } from "c/chronoInputValues";
export default class ChronoDurationInput extends LightningElement {
  @api label = "Duration";
  @api required = false;
  @api disabled = false;
  _value = "";
  parts = durationParts("");
  error = "";
  @api get value() {
    return this._value;
  }
  set value(value) {
    this._value = value || "";
    try {
      this.parts = durationParts(this._value);
      this.error = "";
    } catch (error) {
      this.error = error.message;
    }
  }
  get fields() {
    return [
      ["months", "Calendar months"],
      ["days", "Calendar days"],
      ["hours", "Hours"],
      ["minutes", "Minutes"],
      ["seconds", "Seconds"]
    ].map(([name, label]) => ({
      name,
      label,
      value: this.parts[name],
      step: name === "seconds" ? "0.001" : "1"
    }));
  }
  change(event) {
    const name = event.target.dataset.field;
    this.parts = {
      ...this.parts,
      [name]:
        name === "negative"
          ? event.target.checked
          : event.target.value === ""
            ? NaN
            : Number(event.target.value)
    };
    try {
      this._value = durationText(this.parts);
      this.error = "";
    } catch (error) {
      this.error = error.message;
      this._value = "";
    }
    this.dispatchEvent(
      new CustomEvent("valuechange", {
        detail: { value: this._value || null, valid: !this.error }
      })
    );
  }
  clear() {
    this._value = "";
    this.parts = durationParts("");
    this.error = "";
    this.dispatchEvent(
      new CustomEvent("valuechange", {
        detail: { value: null, valid: !this.required }
      })
    );
  }
  @api validate() {
    const errorMessage =
      this.error || (this.required && !this._value ? "Enter a duration." : "");
    return { isValid: !errorMessage, errorMessage };
  }
  @api reportValidity() {
    this.error = this.validate().errorMessage;
    return !this.error;
  }
}
