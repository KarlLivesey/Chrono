// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause

import { LightningElement, api } from "lwc";
import locale from "@salesforce/i18n/locale";
import { partialText } from "c/chronoInputValues";
export default class ChronoPartialDateInput extends LightningElement {
  @api kind = "yearmonth";
  @api label = "Partial date";
  @api required = false;
  @api disabled = false;
  _value = "";
  year = "";
  month = "";
  day = "";
  error = "";
  @api get value() {
    return this._value;
  }
  set value(value) {
    this._value = value || "";
    const match = /^(?:(\d{4})-(\d{2})|--(\d{2})-(\d{2}))$/.exec(this._value);
    this.year = match?.[1] || "";
    this.month = String(Number(match?.[2] || match?.[3] || 0) || "");
    this.day = match?.[4] || "";
    this.error = this._value && !match ? "Enter a valid partial date." : "";
  }
  get yearMonth() {
    return this.kind === "yearmonth";
  }
  get months() {
    return Array.from({ length: 12 }, (_, i) => ({
      value: String(i + 1),
      label: new Intl.DateTimeFormat(locale.replace(/_/g, "-"), {
        month: "long",
        timeZone: "UTC"
      }).format(new Date(Date.UTC(2000, i, 1)))
    }));
  }
  change(event) {
    const name = event.target.dataset.field;
    this[name] = event.detail?.value ?? event.target.value;
    try {
      this._value = partialText(this.kind, this.year, this.month, this.day);
      this.error = "";
    } catch (error) {
      this._value = "";
      this.error = error.message;
    }
    this.dispatchEvent(
      new CustomEvent("valuechange", {
        detail: { value: this._value || null, valid: !this.error }
      })
    );
  }
  @api validate() {
    let errorMessage =
      this.error || (this.required && !this._value ? "Complete the date." : "");
    if (this._value) {
      try {
        partialText(this.kind, this.year, this.month, this.day);
      } catch (error) {
        errorMessage = error.message;
      }
    }
    return { isValid: !errorMessage, errorMessage };
  }
  @api reportValidity() {
    this.error = this.validate().errorMessage;
    return !this.error;
  }
}
