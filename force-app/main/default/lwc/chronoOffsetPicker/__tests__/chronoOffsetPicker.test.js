import { createElement } from "lwc";
import OffsetPicker from "c/chronoOffsetPicker";
afterEach(() => {
  document.body.innerHTML = "";
});
it("shows selected offsets persistently and allows reopening to change the occurrence", async () => {
  const first = {
    instantValue: "2026-10-25T00:30:00.000Z",
    localValue: "2026-10-25T01:30:00.000",
    offsetSeconds: 3600,
    choice: "earlier"
  };
  const second = {
    ...first,
    instantValue: "2026-10-25T01:30:00.000Z",
    offsetSeconds: 0,
    choice: "later"
  };
  const el = createElement("c-chrono-offset-picker", { is: OffsetPicker });
  Object.assign(el, {
    candidates: [first, second],
    candidate: first,
    timeZoneId: "Europe/London",
    selectionMode: "selected"
  });
  document.body.appendChild(el);
  const popover = el.shadowRoot.querySelector("c-chrono-picker-popover");
  expect(popover.label).toContain("UTC+01:00 · Selected");
  popover.open();
  await Promise.resolve();
  const events = jest.fn();
  el.addEventListener("resolvechoice", events);
  el.shadowRoot
    .querySelector("c-chrono-picker-menu")
    .dispatchEvent(
      new CustomEvent("choose", { detail: { value: second.instantValue } })
    );
  expect(events.mock.calls[0][0].detail.instantValue).toBe(second.instantValue);
  expect(el.candidate).toEqual(first);
});
it("labels conflicting offsets as overrides and validates entered offsets", async () => {
  const el = createElement("c-chrono-offset-picker", { is: OffsetPicker });
  Object.assign(el, {
    candidate: {
      instantValue: "2026-03-15T09:00:00.000Z",
      localValue: "2026-03-15T10:00:00.000",
      choice: "override",
      offsetSeconds: 3600
    },
    timeZoneId: "Europe/London",
    selectionMode: "override",
    allowOverride: true
  });
  document.body.appendChild(el);
  const popover = el.shadowRoot.querySelector("c-chrono-picker-popover");
  expect(popover.label).toBe("UTC+01:00 · Override");
  popover.open();
  await Promise.resolve();
  const input = el.shadowRoot.querySelector("lightning-input");
  popover.shadowRoot
    .querySelector("button")
    .dispatchEvent(
      new FocusEvent("focusout", { bubbles: true, relatedTarget: el })
    );
  input.dispatchEvent(
    new Event("pointerdown", { bubbles: true, composed: true }) // NOPMD - Simulates native pointer propagation across the slot for this regression.
  );
  input.dispatchEvent(
    new FocusEvent("focusin", { bubbles: true, composed: true }) // NOPMD - Simulates native focus propagation across the slot for this regression.
  );
  await new Promise((done) => setTimeout(done, 5));
  expect(popover.shadowRoot.querySelector("section")).not.toBeNull();
  input.value = "+25:00";
  input.dispatchEvent(new CustomEvent("change"));
  const changes = jest.fn();
  el.addEventListener("offsetchange", changes);
  const apply = [...el.shadowRoot.querySelectorAll("lightning-button")].find(
    (item) => item.label === "Apply"
  );
  apply.click();
  await Promise.resolve();
  expect(changes).not.toHaveBeenCalled();
  expect(el.shadowRoot.querySelector('[role="alert"]')).not.toBeNull();
  input.value = "+01:00";
  input.dispatchEvent(new CustomEvent("change"));
  apply.click();
  expect(changes.mock.calls[0][0].detail.value).toBe("+01:00");
});
