import { LightningElement, api } from "lwc";
import { FlowAttributeChangeEvent } from "lightning/flowSupport";
export default class ChronoFlowAvailability extends LightningElement {
  @api label = "Appointment";
  @api required = false;
  @api disabled = false;
  @api valueType;
  @api value;
  @api dateValue;
  @api instantValue;
  @api timeValue;
  @api timeZoneId;
  @api disambiguation;
  @api endValue;
  @api endDate;
  @api endInstant;
  @api endTime;
  @api operatingHoursId;
  @api operatingHours;
  @api timeSlots;
  @api holidays;
  @api otherOperatingHoursIds;
  @api scheduleCombination;
  @api busyRanges;
  @api busyRangesText;
  @api duration;
  @api stepDuration;
  @api maximumResults;
  @api referenceInstant;
  @api minimumNotice;
  @api bookingHorizon;
  @api bufferBefore;
  @api bufferAfter;
  @api gridAnchor;
  @api startValue;
  @api selectedEndValue;
  @api startDateTime;
  @api endDateTime;
  @api rangeValue;
  externalError = "";
  get input() {
    return {
      valueType: this.valueType,
      value: this.value,
      dateValue: this.dateValue,
      instantValue: this.instantValue,
      timeValue: this.timeValue,
      timeZoneId: this.timeZoneId,
      disambiguation: this.disambiguation,
      endValue: this.endValue,
      endDate: this.endDate,
      endInstant: this.endInstant,
      endTime: this.endTime,
      operatingHoursId: this.operatingHoursId,
      operatingHours: this.operatingHours,
      timeSlots: this.timeSlots,
      holidays: this.holidays,
      otherOperatingHoursIds: this.otherOperatingHoursIds,
      scheduleCombination: this.scheduleCombination,
      busyRanges: this.busyRanges,
      busyRangesText: this.busyRangesText,
      duration: this.duration,
      stepDuration: this.stepDuration,
      maximumResults: this.maximumResults,
      referenceInstant: this.referenceInstant,
      minimumNotice: this.minimumNotice,
      bookingHorizon: this.bookingHorizon,
      bufferBefore: this.bufferBefore,
      bufferAfter: this.bufferAfter,
      gridAnchor: this.gridAnchor
    };
  }
  change(event) {
    event.stopPropagation();
    for (const [name, value] of Object.entries(event.detail)) {
      const output = name === "endValue" ? "selectedEndValue" : name;
      this[output] = value;
      this.dispatchEvent(new FlowAttributeChangeEvent(output, value));
    }
  }
  @api validate() {
    return (
      this.refs.control?.validate() || {
        isValid: false,
        errorMessage: "Availability is loading."
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
