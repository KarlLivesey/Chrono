// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";
import availability from "@salesforce/apex/ChronoComponentActions.availability";
import locale from "@salesforce/i18n/locale";
import { exactMillis } from "c/chronoInputValues";
/** Read-only availability search. Selection does not reserve or save an appointment. */
export default class ChronoAvailabilityPicker extends LightningElement {
  @api label = "Appointment";
  @api required = false;
  @api disabled = false;
  _input = {};
  _key = "";
  connected = false;
  queued = false;
  revision = 0;
  pending = false;
  error = "";
  validationMessage = "";
  options = [];
  selected = "";
  selectedLabel = "";
  _value = "";
  @api get value() {
    return this._value;
  }
  set value(value) {
    this._value = value || "";
    this.validationMessage = "";
    const selected = this.options.find((item) => item.value === this._value);
    this.selected = selected?.value || "";
    this.selectedLabel = selected?.label || "";
  }
  @api get input() {
    return this._input;
  }
  set input(value) {
    const key = JSON.stringify(value || {});
    if (key === this._key) return;
    this._key = key;
    this._input = value || {};
    this.revision++;
    this.queue();
  }
  connectedCallback() {
    this.connected = true;
    this.queue();
  }
  disconnectedCallback() {
    this.connected = false;
    this.revision++;
  }
  queue() {
    if (!this.connected || this.queued) return;
    this.queued = true;
    Promise.resolve().then(() => {
      this.queued = false;
      if (this.connected) this.load();
    });
  }
  async load() {
    const revision = ++this.revision;
    this.pending = true;
    this.error = "";
    this.validationMessage = "";
    this.options = [];
    this.selected = "";
    this.selectedLabel = "";
    this.emit(null, null);
    try {
      const result = await availability({
        input: { ...this._input, operation: "appointments" }
      });
      if (revision !== this.revision || !this.connected) return;
      if (!result.success) throw new Error(result.errorMessage);
      this.options = (result.ranges || []).map((value, index) => {
        const start = result.openingValues[index],
          end = result.closingValues[index];
        const zone =
          /\[([^\]]+)\]$/.exec(start)?.[1] || this._input.timeZoneId || "UTC";
        const format = new Intl.DateTimeFormat(locale.replace(/_/g, "-"), {
          dateStyle: "short",
          timeStyle: "short",
          timeZone: zone
        });
        const offset = /([+-]\d{2}:\d{2})\[/.exec(start)?.[1] || "+00:00";
        return {
          value,
          label: `${format.format(new Date(exactMillis(start)))} – ${format.format(new Date(exactMillis(end)))} · ${zone} · UTC${offset}`,
          start,
          end
        };
      });
      const restored = this.options.find((item) => item.value === this._value);
      this.selected = restored?.value || "";
      this.selectedLabel = restored?.label || "";
      this._value = this.selected;
      this.emit(restored?.start, restored?.end);
    } catch (error) {
      if (revision === this.revision) {
        this.error = error?.body?.message || error.message;
        this._value = "";
        this.emit(null, null);
      }
    } finally {
      if (revision === this.revision) this.pending = false;
    }
  }
  choose(event) {
    if (this.pending || this.disabled) return;
    const found = this.options.find(
      (item) => item.value === event.detail.value
    );
    this.validationMessage = "";
    this.selected = found?.value || "";
    this._value = this.selected;
    this.selectedLabel = found?.label || "";
    this.emit(found?.start, found?.end);
  }
  emit(startValue, endValue) {
    this.dispatchEvent(
      new CustomEvent("valuechange", {
        detail: {
          startValue: startValue || null,
          endValue: endValue || null,
          startDateTime: startValue
            ? new Date(exactMillis(startValue)).toISOString()
            : null,
          endDateTime: endValue
            ? new Date(exactMillis(endValue)).toISOString()
            : null,
          rangeValue: startValue
            ? `${startValue}/${endValue}`
            : this.pending
              ? this._value || null
              : null
        }
      })
    );
  }
  get showChoices() {
    return (
      !this.pending && !this.error && this.options.length > 0 && !this.disabled
    );
  }
  get empty() {
    return !this.pending && !this.error && !this.options.length;
  }
  @api validate() {
    const errorMessage = this.pending
      ? "Availability is still loading."
      : this.error ||
        (this.required && !this.selected
          ? "Choose an available appointment."
          : "");
    return { isValid: !errorMessage, errorMessage };
  }
  get displayedError() {
    return this.error || this.validationMessage;
  }
  @api reportValidity() {
    this.validationMessage = this.validate().errorMessage;
    return !this.validationMessage;
  }
}
