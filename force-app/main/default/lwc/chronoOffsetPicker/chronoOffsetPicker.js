// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";
import {
  offsetLabel,
  parseOffset,
  zoneAbbreviation,
  choiceLabel
} from "c/chronoPickerEngine";

/** Present resolution and explicit offset overrides; the parent resolves/saves values. */
export default class ChronoOffsetPicker extends LightningElement {
  @api candidates = [];
  @api candidate;
  @api timeZoneId = "";
  @api selectionMode = "auto";
  @api allowOverride = false;
  @api disabled = false;
  draft = "";
  error = "";
  get warning() {
    return !this.candidate;
  }
  get heading() {
    return this.candidates[0]?.choice === "backward"
      ? "This time is skipped"
      : "Time offset";
  }
  get label() {
    if (!this.candidate)
      return this.candidates.length ? "Choose offset" : "Offset";
    const abbreviation = zoneAbbreviation(this.candidate, this.timeZoneId);
    const mode =
      { auto: "Auto", selected: "Selected", override: "Override" }[
        this.selectionMode
      ] || "Auto";
    return [abbreviation, offsetLabel(this.candidate.offsetSeconds), mode]
      .filter(Boolean)
      .join(" · ");
  }
  get choices() {
    return this.candidates.map((item) => ({
      value: item.instantValue,
      // Gap corrections must retain their exact boundary date and time.
      label: ["backward", "forward"].includes(item.choice)
        ? choiceLabel(item)
        : [
            { earlier: "First", later: "Second" }[item.choice],
            zoneAbbreviation(item, this.timeZoneId),
            offsetLabel(item.offsetSeconds)
          ]
            .filter(Boolean)
            .join(" · ")
    }));
  }
  get selected() {
    return this.candidate?.instantValue || "";
  }
  get hasChoices() {
    return this.choices.length > 0;
  }
  get unavailable() {
    return this.disabled || (!this.candidates.length && !this.candidate);
  }
  choose(event) {
    this.dispatchEvent(
      new CustomEvent("resolvechoice", {
        detail: { instantValue: event.detail.value }
      })
    );
    this.refs.popover.close();
  }
  editOffset(event) {
    this.draft = event.target.value;
    this.error = "";
  }
  apply() {
    try {
      parseOffset(this.draft);
      this.dispatchEvent(
        new CustomEvent("offsetchange", { detail: { value: this.draft } })
      );
      this.refs.popover.close();
    } catch (error) {
      this.error = error.message;
    }
  }
  automatic() {
    this.dispatchEvent(
      new CustomEvent("offsetchange", { detail: { value: "" } })
    );
    this.refs.popover.close();
  }
  opened() {
    this.draft = this.candidate
      ? offsetLabel(this.candidate.offsetSeconds)
          .replace("UTC", "")
          .replace("−", "-")
      : "";
    this.error = "";
  }
}
