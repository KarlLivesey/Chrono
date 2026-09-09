// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";
/** Controlled inline list builder, shared by timezone IDs and saved schedule IDs. */
export default class ChronoFlowListEditor extends LightningElement {
  @api label = "Allowed values";
  @api items = [];
  @api options = [];
  @api pending = false;
  @api error = "";
  @api addLabel = "Add value";
  opened = false;
  get available() {
    const selected = new Set(this.items.map((item) => item.value));
    return this.options.filter((item) => !selected.has(item.value));
  }
  get empty() {
    return !this.available.length && !this.pending;
  }
  open() {
    this.opened = !this.opened;
    if (this.opened)
      this.dispatchEvent(new CustomEvent("search", { detail: { value: "" } }));
  }
  search(event) {
    this.dispatchEvent(
      new CustomEvent("search", { detail: { value: event.target.value } })
    );
  }
  add(event) {
    this.dispatchEvent(
      new CustomEvent("add", {
        detail: { value: event.currentTarget.dataset.value }
      })
    );
  }
  remove(event) {
    this.dispatchEvent(
      new CustomEvent("remove", {
        detail: { value: event.currentTarget.dataset.value }
      })
    );
  }
}
