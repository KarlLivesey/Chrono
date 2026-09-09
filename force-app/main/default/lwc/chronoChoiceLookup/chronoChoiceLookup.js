// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";
/** Controlled lookup over supplied choices. Free text is never committed. */
export default class ChronoChoiceLookup extends LightningElement {
  @api label = "Choose a value";
  @api value = "";
  @api displayValue = "";
  @api options = [];
  @api message = "";
  @api placeholder = "Search…";
  opened = false;
  query = "";
  timer;
  pointers = new WeakSet();
  outside = (event) => {
    if (!this.pointers.has(event)) this.close();
  };
  get text() {
    return this.opened ? this.query : this.displayValue || this.value || "";
  }
  get expanded() {
    return this.opened ? "true" : "false";
  }
  get rows() {
    const query = this.query.trim().toLowerCase();
    return (this.options || [])
      .filter((item) =>
        (item.label + " " + item.value).toLowerCase().includes(query)
      )
      .map((item) => ({
        ...item,
        selected: item.value === this.value ? "true" : "false"
      }));
  }
  get empty() {
    return !this.rows.length;
  }
  open() {
    if (this.opened) return;
    this.opened = true;
    this.query = "";
    document.addEventListener("pointerdown", this.outside);
  }
  close() {
    clearTimeout(this.timer);
    this.opened = false;
    document.removeEventListener("pointerdown", this.outside);
  }
  search(event) {
    this.open();
    this.query = event.target.value;
  }
  choose(event) {
    this.selectValue(event.currentTarget.dataset.value);
  }
  selectValue(value) {
    if (!this.rows.some((item) => item.value === value)) return;
    this.dispatchEvent(new CustomEvent("choose", { detail: { value } }));
    this.close();
    this.refs.input.focus();
  }
  clear() {
    this.dispatchEvent(new CustomEvent("choose", { detail: { value: "" } }));
    this.close();
    this.refs.input.focus();
  }
  async keydown(event) {
    if (event.key === "Enter" && event.target.dataset.value !== undefined) {
      event.preventDefault();
      this.selectValue(event.target.dataset.value);
    } else if (event.key === "Escape") {
      event.stopPropagation();
      event.preventDefault();
      this.close();
      this.refs.input.focus();
    } else if (["ArrowDown", "ArrowUp"].includes(event.key)) {
      event.preventDefault();
      this.open();
      await Promise.resolve();
      const items = [...this.template.querySelectorAll("[role=option]")];
      const current = items.indexOf(event.target);
      const next =
        event.key === "ArrowDown"
          ? current + 1
          : current < 0
            ? items.length - 1
            : current - 1;
      items[(next + items.length) % items.length]?.focus();
    }
  }
  pointerdown(event) {
    this.pointers.add(event);
  }
  focusin() {
    clearTimeout(this.timer);
  }
  focusout() {
    clearTimeout(this.timer);
    // eslint-disable-next-line @lwc/lwc/no-async-operation -- Debounce lookups or defer focus checks until the current event finishes.
    this.timer = setTimeout(() => this.close(), 0);
  }
  disconnectedCallback() {
    this.close();
  }
}
