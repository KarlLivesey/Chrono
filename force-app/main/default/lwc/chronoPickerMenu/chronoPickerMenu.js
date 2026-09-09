// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";

/** Searchable scalar choices shared by timezone and operating-hours controls. */
export default class ChronoPickerMenu extends LightningElement {
  @api label = "Choose an option";
  @api options = [];
  @api value = "";
  @api searchable = false;
  @api pending = false;
  @api message = "";
  @api disabled = false;
  get rows() {
    return (this.options || []).map((item) => ({
      ...item,
      selected: item.value === this.value
    }));
  }
  get empty() {
    return !this.options?.length && !this.pending;
  }
  search(event) {
    this.dispatchEvent(
      new CustomEvent("search", { detail: { value: event.target.value } })
    );
  }
  choose(event) {
    if (this.disabled) return;
    this.dispatchEvent(
      new CustomEvent("choose", {
        detail: { value: event.currentTarget.dataset.value }
      })
    );
  }
}
