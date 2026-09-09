// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";

/** Reusable, non-modal disclosure. Slotted content owns its controls and events. */
export default class ChronoPickerPopover extends LightningElement {
  @api label = "Options";
  @api heading = "Options";
  @api compact = false;
  _disabled = false;
  @api get disabled() {
    return this._disabled;
  }
  set disabled(value) {
    this._disabled = value === true || value === "true";
    if (this._disabled && this.opened) this.close(false);
  }
  @api warning = false;
  opened = false;
  above = false;
  shift = 0;
  panelHeight = 416;
  focusTimer;
  internalPointers = new WeakSet();
  outside = (event) => {
    if (!this.internalPointers.has(event)) this.close(false);
  };
  handlePointerDown(event) {
    // Observe the event inside the slot boundary before the document listener.
    // Document-level targets/paths can be retargeted by synthetic shadow.
    this.internalPointers.add(event);
  }
  get triggerClass() {
    return `slds-button slds-button_reset trigger${this.warning ? " warning" : ""}`;
  }
  get triggerLabel() {
    return `${this.heading}: ${this.label}`;
  }
  get panelClass() {
    return `slds-popover panel${this.compact ? " compact" : ""}${this.above ? " above" : ""}`;
  }
  get panelStyle() {
    return `right: ${-this.shift}px; max-height: ${this.panelHeight}px;`;
  }
  toggle() {
    if (this.opened) this.close();
    else this.open();
  }
  @api open() {
    if (this.disabled || this.opened) return;
    const rect = this.hostElement.getBoundingClientRect();
    const rem =
      parseFloat(window.getComputedStyle(document.documentElement).fontSize) ||
      16;
    const width = Math.min(
      (this.compact ? 18 : 22) * rem,
      window.innerWidth - 32
    );
    // The control can sit in a narrow Flow column near either viewport edge.
    // Keep a 16px gutter without altering the width/position of the form field.
    this.shift =
      Math.max(0, width + 16 - rect.right) -
      Math.max(0, rect.right - window.innerWidth + 16);
    this.above = window.innerHeight - rect.bottom < 320 && rect.top > 320;
    this.panelHeight = Math.min(
      26 * rem,
      Math.max(
        64,
        this.above ? rect.top - 24 : window.innerHeight - rect.bottom - 24
      )
    );
    this.opened = true;
    document.addEventListener("pointerdown", this.outside);
    this.dispatchEvent(new CustomEvent("open"));
  }
  @api close(restoreFocus = true) {
    clearTimeout(this.focusTimer);
    this.opened = false;
    document.removeEventListener("pointerdown", this.outside);
    if (restoreFocus) this.refs.trigger?.focus();
  }
  handleKey(event) {
    if (event.key === "Escape" && this.opened) {
      event.stopPropagation();
      this.close();
    }
  }
  handleFocusOut() {
    // Wait for the corresponding focusin. Slotted child controls belong to
    // another shadow tree, so relatedTarget/contains cannot identify them.
    clearTimeout(this.focusTimer);
    this.focusTimer = setTimeout(() => this.close(false), 0);
  }
  handleFocusIn() {
    clearTimeout(this.focusTimer);
  }
  disconnectedCallback() {
    clearTimeout(this.focusTimer);
    document.removeEventListener("pointerdown", this.outside);
  }
}
