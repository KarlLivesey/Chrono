// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";
const blockFields = new Set([
  "key",
  "label",
  "weekdays",
  "dayType",
  "startTime",
  "endTime"
]);
const weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
/** Reusable fixed block editor. Only the value/change JSON contract leaves this component. */
export default class ChronoTimeBlockEditor extends LightningElement {
  _value;
  rows = [];
  error = "";
  serial = 0;
  @api get value() {
    return this._value;
  }
  set value(value) {
    if (value === this._value) return;
    this._value = value;
    try {
      const rows = value ? JSON.parse(value) : [];
      if (
        !Array.isArray(rows) ||
        rows.some(
          (row) =>
            !row ||
            typeof row !== "object" ||
            Array.isArray(row) ||
            Object.entries(row).some(
              ([name, field]) =>
                !blockFields.has(name) ||
                (field != null && typeof field !== "string")
            )
        )
      )
        throw new Error("Invalid blocks");
      this.rows = rows.map((row) => ({ ...row, uid: ++this.serial }));
      this.error = "";
    } catch {
      this.rows = [];
      this.error =
        "The saved block definition cannot be read. Choose a valid Text resource or clear it before configuring blocks.";
    }
  }
  get blocks() {
    return this.rows.map((row, index) => ({
      ...row,
      index,
      heading: `${index + 1}. ${row.label || row.key || "Time block"}`,
      first: index === 0,
      last: index === this.rows.length - 1,
      dayType: row.dayType || "regular",
      midnight: row.endTime?.startsWith("24:00"),
      displayedEnd: row.endTime?.startsWith("24:00")
        ? "00:00:00.000"
        : row.endTime,
      weekdays: weekdays.map((label, day) => ({
        label,
        value: String(day + 1),
        selected: (row.weekdays || "1,2,3,4,5,6,7")
          .split(",")
          .map((s) => s.trim())
          .includes(String(day + 1))
      }))
    }));
  }
  get dayTypes() {
    return [
      { label: "Normal days", value: "regular" },
      { label: "Bank holidays", value: "holiday" }
    ];
  }
  get cannotAdd() {
    return Boolean(this.error) || this.rows.length >= 50;
  }
  get empty() {
    return !this.rows.length && !this.error;
  }
  add() {
    const keys = new Set(this.rows.map((row) => row.key));
    let number = this.rows.length + 1;
    while (keys.has(`block_${number}`)) number++;
    this.rows = [
      ...this.rows,
      {
        uid: ++this.serial,
        key: `block_${number}`,
        label: `Block ${number}`,
        weekdays: "1,2,3,4,5",
        dayType: "regular",
        startTime: "09:00",
        endTime: "17:00"
      }
    ];
    this.emit();
  }
  change(event) {
    const { index, field } = event.target.dataset;
    const value = event.detail?.value ?? event.target.value;
    this.rows = this.rows.map((row, i) =>
      i === Number(index) ? { ...row, [field]: value } : row
    );
    this.emit();
  }
  toggleDay(event) {
    const { index, day } = event.target.dataset;
    this.rows = this.rows.map((row, i) => {
      if (i !== Number(index)) return row;
      const selectedDays = new Set(
        (row.weekdays || "1,2,3,4,5,6,7").split(",").map((s) => s.trim())
      );
      if (selectedDays.has(day)) selectedDays.delete(day);
      else selectedDays.add(day);
      // An empty saved weekdays string means all weekdays, so do not accidentally switch
      // to every day when deselecting the last selected weekday.
      if (!selectedDays.size) return row;
      return { ...row, weekdays: [...selectedDays].sort().join(",") };
    });
    this.emit();
  }
  midnight(event) {
    const index = Number(event.target.dataset.index);
    this.rows = this.rows.map((row, i) =>
      i === index
        ? { ...row, endTime: event.target.checked ? "24:00" : "17:00" }
        : row
    );
    this.emit();
  }
  reorder(event) {
    const index = Number(event.target.dataset.index);
    const target = index + Number(event.target.dataset.step);
    if (target < 0 || target >= this.rows.length) return;
    const rows = [...this.rows];
    [rows[index], rows[target]] = [rows[target], rows[index]];
    this.rows = rows;
    this.emit();
  }
  remove(event) {
    this.rows = this.rows.filter(
      (row, i) => i !== Number(event.target.dataset.index)
    );
    this.emit();
  }
  emit() {
    const rows = this.rows.map((item) => {
      const row = { ...item };
      delete row.uid;
      return row;
    });
    this._value = JSON.stringify(rows);
    this.dispatchEvent(
      new CustomEvent("change", { detail: { value: this._value } })
    );
  }
  @api validate() {
    if (this.error) return this.error;
    if (!this.rows.length) return "Add at least one time block.";
    const keys = new Set();
    for (const row of this.rows) {
      if (!row.key?.trim() || keys.has(row.key))
        return "Each block needs a unique key.";
      keys.add(row.key);
      if (!row.startTime || !row.endTime)
        return "Choose a start and end for every block.";
      if (row.startTime.slice(0, 5) === row.endTime.slice(0, 5))
        return "Start and end must differ. Use End of day for a full-day block.";
    }
    return "";
  }
}
