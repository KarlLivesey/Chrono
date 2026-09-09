import { LightningElement, api } from "lwc";
import { FlowAttributeChangeEvent } from "lightning/flowSupport";
export default class ChronoFlowRecurrence extends LightningElement {
  @api label = "Repeat";
  @api timeZoneId;
  @api allowTimeZoneSelection;
  @api rule = "FREQ=WEEKLY;INTERVAL=1;COUNT=6";
  @api untilDate;
  @api maximumResults = 100;
  @api operatingHoursId;
  @api operatingHoursRecord;
  @api timeSlots;
  @api holidays;
  @api disabled;
  @api values;
  _startInput;
  _startOutput;
  @api get startValue() {
    return this._startOutput === undefined
      ? this._startInput
      : this._startOutput;
  }
  set startValue(value) {
    this._startInput = value;
    this._startOutput = undefined;
  }
  @api closedPolicy = "keep";
  externalError = "";
  get config() {
    return {
      label: this.label,
      initialValue: this._startInput,
      timeZoneId: this.timeZoneId,
      allowTimeZoneSelection: this.allowTimeZoneSelection,
      rule: this.rule,
      closedPolicy: this.closedPolicy,
      untilDate: this.untilDate,
      maximumResults: this.maximumResults,
      operatingHoursId: this.operatingHoursId,
      operatingHoursRecord: this.operatingHoursRecord,
      timeSlots: this.timeSlots,
      holidays: this.holidays,
      disabled: this.disabled
    };
  }
  changed(event) {
    event.stopPropagation();
    for (const [name, value] of Object.entries(event.detail)) {
      if (name === "startValue") this._startOutput = value;
      else this[name] = value;
      this.dispatchEvent(new FlowAttributeChangeEvent(name, value));
    }
  }
  @api validate() {
    return (
      this.refs.control?.validate() || {
        isValid: false,
        errorMessage: "The recurrence is loading."
      }
    );
  }
  @api setCustomValidity(error) {
    this._external = error || "";
  }
  @api reportValidity() {
    this.externalError = this._external;
    this.refs.control?.reportValidity();
  }
}
