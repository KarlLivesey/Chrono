// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";
import getFields from "@salesforce/apex/ChronoFlowEditorController.getFields";
import { ResourceCatalog, searchNodes } from "./catalog";

/** Controlled Flow lookup. choose returns a compatible reference, or '' to clear. */
export default class ChronoFlowResourcePicker extends LightningElement {
  @api value = "";
  @api label = "Flow resource";
  _valueType = "String";
  _acceptedTypes = [];
  @api get acceptedTypes() {
    return this._acceptedTypes;
  }
  set acceptedTypes(value) {
    this.close();
    this._acceptedTypes = value || [];
  }
  _objectType = "";
  _builderContext;
  _automaticOutputVariables;
  @api get valueType() {
    return this._valueType;
  }
  set valueType(value) {
    this.close();
    this._valueType = value || "String";
  }
  @api get objectType() {
    return this._objectType;
  }
  set objectType(value) {
    this.close();
    this._objectType = value || "";
  }
  @api get builderContext() {
    return this._builderContext;
  }
  set builderContext(value) {
    this.close();
    this._builderContext = value;
  }
  @api get automaticOutputVariables() {
    return this._automaticOutputVariables;
  }
  set automaticOutputVariables(value) {
    this.close();
    this._automaticOutputVariables = value;
  }
  opened = false;
  searchText = "";
  trail = [];
  nodes = [];
  pending = false;
  error = "";
  revision = 0;
  catalog;
  focusTimer;
  pointers = new WeakSet();
  outside = (event) => {
    if (!this.pointers.has(event)) this.close();
  };
  get inputValue() {
    return this.opened ? this.searchText : this.value || "";
  }
  get expanded() {
    return this.opened ? "true" : "false";
  }
  get containerClass() {
    return "slds-combobox lookup" + (this.opened ? " slds-is-open" : "");
  }
  get title() {
    return this.trail.at(-1)?.label || "All resources";
  }
  get nested() {
    return this.trail.length > 0;
  }
  get currentNodes() {
    return this.trail.at(-1)?.children || this.nodes;
  }
  get rows() {
    return searchNodes(this.currentNodes, this.searchText).map((item) => ({
      ...item,
      navigable: item.children.length > 0,
      containerOnly: !item.selectable && item.children.length > 0,
      selected: item.value === this.value ? "true" : "false",
      detail: item.value,
      icon: item.children.length
        ? "utility:opened_folder"
        : {
            Date: "utility:date_input",
            DateTime: "utility:date_time",
            Boolean: "utility:check",
            SObject: "utility:record"
          }[item.dataType] || "utility:text",
      browseLabel: "Browse " + item.label
    }));
  }
  get groups() {
    const groups = new Map();
    for (const row of this.rows) {
      const label = row.group || "Fields";
      if (!groups.has(label)) groups.set(label, []);
      groups.get(label).push(row);
    }
    return [...groups].map(([label, rows]) => ({ label, rows }));
  }
  get empty() {
    return !this.pending && !this.rows.length;
  }
  async open() {
    if (this.opened) return;
    this.opened = true;
    this.searchText = "";
    this.trail = [];
    this.nodes = [];
    this.pending = true;
    this.error = "";
    const revision = ++this.revision;
    document.addEventListener("pointerdown", this.outside);
    this.catalog = new ResourceCatalog(
      this.builderContext,
      this.automaticOutputVariables,
      this.valueType,
      this.objectType,
      getFields,
      this.acceptedTypes
    );
    const { nodes, incomplete } = await this.catalog.load();
    if (revision !== this.revision) return;
    this.nodes = nodes;
    this.pending = false;
    if (incomplete)
      this.error =
        "Some record fields could not be loaded. Reopen the lookup to retry.";
  }
  close() {
    clearTimeout(this.focusTimer);
    this.opened = false;
    this.pending = false;
    this.revision++;
    document.removeEventListener("pointerdown", this.outside);
  }
  search(event) {
    if (!this.opened) this.open();
    this.searchText = event.target.value;
  }
  choose(event) {
    const item = this.rows.find(
      (row) => row.value === event.currentTarget.dataset.value
    );
    if (!item) return;
    if (!item.selectable) {
      this.browse(event);
      return;
    }
    this.dispatchEvent(
      new CustomEvent("choose", {
        detail: {
          value: item.value,
          dataType: item.dataType,
          objectType: item.objectType
        }
      })
    );
    this.close();
    this.refs.input.focus();
  }
  clear() {
    this.dispatchEvent(new CustomEvent("choose", { detail: { value: "" } }));
    this.searchText = "";
    this.refs.input.focus();
  }
  async browse(event) {
    let item = this.rows.find(
      (row) => row.value === event.currentTarget.dataset.value
    );
    if (!item?.children.length) return;
    if (item.relationship) {
      const revision = ++this.revision;
      this.pending = true;
      try {
        item = await this.catalog.node({ ...item, children: false });
      } catch (error) {
        if (revision === this.revision)
          this.error = error.body?.message || error.message;
        return;
      } finally {
        if (revision === this.revision) this.pending = false;
      }
      if (revision !== this.revision || !item) return;
    }
    this.trail = [...this.trail, item];
    this.searchText = "";
    this.refs.input.focus();
  }
  back() {
    this.trail = this.trail.slice(0, -1);
    this.searchText = "";
    this.refs.input.focus();
  }
  async keydown(event) {
    if (event.key === "Escape") {
      event.preventDefault();
      event.stopPropagation();
      this.close();
      this.refs.input.focus();
    } else if (["ArrowDown", "ArrowUp"].includes(event.key)) {
      event.preventDefault();
      if (!this.opened) {
        await this.open();
        await Promise.resolve();
      }
      const choices = [...this.template.querySelectorAll("[data-option]")];
      const index = choices.indexOf(event.target);
      const next =
        event.key === "ArrowDown"
          ? index + 1
          : index < 0
            ? choices.length - 1
            : index - 1;
      choices[(next + choices.length) % choices.length]?.focus();
    }
  }
  pointerdown(event) {
    this.pointers.add(event);
  }
  focusout() {
    clearTimeout(this.focusTimer);
    // eslint-disable-next-line @lwc/lwc/no-async-operation -- Debounce lookups or defer focus checks until the current event finishes.
    this.focusTimer = setTimeout(() => this.close(), 0);
  }
  focusin() {
    clearTimeout(this.focusTimer);
  }
  disconnectedCallback() {
    this.close();
  }
}
