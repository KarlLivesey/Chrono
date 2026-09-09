import { LightningElement } from "lwc";
export default class ChronoPickerConsumer extends LightningElement {
  availabilityInput = {
    valueType: "Instant",
    value: "2026-09-08T09:00:00Z",
    endValue: "2026-09-08T10:00:00Z",
    duration: "PT30M",
    maximumResults: 4
  };
}
