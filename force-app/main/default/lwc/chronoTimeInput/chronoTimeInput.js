// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause

import { LightningElement, api } from "lwc";
import { validTime } from "c/chronoPickerEngine";
export default class ChronoTimeInput extends LightningElement {
  @api label = "Time";
  @api required = false;
  @api disabled = false;
  @api value = "";
  error = "";
  change(event) {
    const entered = event.detail?.value ?? event.target.value;
    const value =
      entered && validTime(entered)
        ? `${entered.slice(0, 8).padEnd(8, ":00")}${entered.includes(".") ? "." + entered.split(".")[1].slice(0, 3).padEnd(3, "0") : ".000"}`
        : null;
    this.dispatchEvent(
      new CustomEvent("valuechange", {
        detail: { value, valid: !entered || !!value }
      })
    );
  }
  @api validate() {
    const errorMessage =
      this.value && !validTime(this.value)
        ? "Enter a valid time."
        : this.required && !this.value
          ? "Enter a time."
          : "";
    return { isValid: !errorMessage, errorMessage };
  }
  @api reportValidity() {
    this.error = this.validate().errorMessage;
    return (
      this.template.querySelector("lightning-input").reportValidity() &&
      !this.error
    );
  }
}
