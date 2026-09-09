// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
import { LightningElement, api } from "lwc";
/** Explicit action registration; UI and state handling live in the shared editor. */
export default class ActionEditor extends LightningElement {
  @api inputVariables;
  @api builderContext;
  @api automaticOutputVariables;
  @api elementInfo;
  @api validate() {
    return (
      this.template.querySelector("c-chrono-catalogue-editor")?.validate() || []
    );
  }
}
