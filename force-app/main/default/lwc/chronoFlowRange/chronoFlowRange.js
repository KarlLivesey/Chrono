import { LightningElement, api } from "lwc";
import { FlowAttributeChangeEvent } from "lightning/flowSupport";
export default class ChronoFlowRange extends LightningElement {
  @api mode = "datetime";
  @api label = "Date and time range";
  @api timeZoneId;
  @api allowTimeZoneSelection = false;
  @api dateStyle = "short";
  @api required = false;
  @api disabled = false;
  @api operatingHoursId;
  @api operatingHoursRecord;
  @api timeSlots;
  @api holidays;
  _inputs = {};
  _outputs = {};
  @api get startValue() {
    return Object.hasOwn(this._outputs, "startValue")
      ? this._outputs.startValue
      : this._inputs.startValue;
  }
  set startValue(value) {
    this._inputs = { ...this._inputs, startValue: value };
    const outputs = { ...this._outputs };
    delete outputs.startValue;
    this._outputs = outputs;
  }
  @api get endValue() {
    return Object.hasOwn(this._outputs, "endValue")
      ? this._outputs.endValue
      : this._inputs.endValue;
  }
  set endValue(value) {
    this._inputs = { ...this._inputs, endValue: value };
    const outputs = { ...this._outputs };
    delete outputs.endValue;
    this._outputs = outputs;
  }
  @api rangeValue;
  @api duration;
  externalError = "";
  get config() {
    return {
      mode: this.mode,
      label: this.label,
      timeZoneId: this.timeZoneId,
      allowTimeZoneSelection: this.allowTimeZoneSelection,
      dateStyle: this.dateStyle,
      required: this.required,
      disabled: this.disabled,
      operatingHoursId: this.operatingHoursId,
      operatingHoursRecord: this.operatingHoursRecord,
      timeSlots: this.timeSlots,
      holidays: this.holidays,
      startValue: this._inputs.startValue,
      endValue: this._inputs.endValue
    };
  }
  change(event) {
    event.stopPropagation();
    for (const name of ["startValue", "endValue", "rangeValue", "duration"]) {
      if (name === "startValue" || name === "endValue")
        this._outputs = { ...this._outputs, [name]: event.detail[name] };
      else this[name] = event.detail[name];
      this.dispatchEvent(
        new FlowAttributeChangeEvent(name, event.detail[name])
      );
    }
  }
  @api validate() {
    return (
      this.refs.control?.validate() || {
        isValid: false,
        errorMessage: "The range is loading."
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
