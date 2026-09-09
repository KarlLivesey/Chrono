import { LightningElement, api } from "lwc";
export default class ChronoAvailabilityScreenEditor extends LightningElement {
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
