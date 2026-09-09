import { createElement } from "lwc";
import Component from "c/chronoDateTimePicker";
afterEach(() => {
  document.body.innerHTML = "";
});
it("exposes hours beside a locked timezone without nesting it in the zone menu", async () => {
  const el = createElement("c-chrono-date-time-picker", { is: Component });
  Object.assign(el, {
    timeZoneId: "Europe/London",
    hasSchedule: true,
    showScheduleSelection: true,
    operatingHoursOptions: [
      { value: "hours", label: "New York · America/New_York" }
    ]
  });
  document.body.appendChild(el);
  const controls = el.shadowRoot.querySelector(".controls");
  expect(controls.querySelector(".locked").textContent).toContain("London");
  const popup = controls.querySelector("c-chrono-picker-popover");
  expect(popup.label).toBe("Hours");
  popup.open();
  await Promise.resolve();
  const changes = jest.fn();
  el.addEventListener("schedulechange", changes);
  el.shadowRoot
    .querySelector("c-chrono-picker-menu")
    .dispatchEvent(new CustomEvent("choose", { detail: { value: "hours" } }));
  expect(changes.mock.calls[0][0].detail.value).toBe("hours");
});
it("date-only UI omits time and timezone controls", () => {
  const el = createElement("c-chrono-date-time-picker", { is: Component });
  el.mode = "date";
  document.body.appendChild(el);
  expect(el.shadowRoot.querySelectorAll("lightning-input")).toHaveLength(1);
  expect(el.shadowRoot.querySelector("lightning-combobox")).toBeNull();
});
it("emits user choices without owning the parent value", async () => {
  const el = createElement("c-chrono-date-time-picker", { is: Component });
  el.timeZoneId = "Europe/London";
  el.allowTimeZoneSelection = true;
  document.body.appendChild(el);
  const listener = jest.fn();
  el.addEventListener("edit", listener);
  const popover = el.shadowRoot.querySelector("c-chrono-picker-popover");
  popover.open();
  await Promise.resolve();
  el.shadowRoot
    .querySelector("c-chrono-picker-menu")
    .dispatchEvent(new CustomEvent("choose", { detail: { value: "UTC" } }));
  expect(listener.mock.calls[0][0].detail.timeZoneId).toBe("UTC");
  expect(el.timeZoneId).toBe("Europe/London");
});
