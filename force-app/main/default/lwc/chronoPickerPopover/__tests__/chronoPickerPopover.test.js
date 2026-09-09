import { createElement } from "lwc";
import Popover from "c/chronoPickerPopover";
afterEach(() => {
  document.body.innerHTML = "";
});
it("keeps a narrow-column popover within the viewport and closes when disabled", async () => {
  const el = createElement("c-chrono-picker-popover", { is: Popover });
  document.body.appendChild(el);
  el.getBoundingClientRect = () => ({ right: 180, top: 100, bottom: 124 });
  el.open();
  await Promise.resolve();
  expect(el.shadowRoot.querySelector("section").style.right).toBe("-188px");
  el.disabled = true;
  await Promise.resolve();
  expect(el.shadowRoot.querySelector("section")).toBeNull();
});
it("opens from the trigger, closes with Escape and restores trigger focus", async () => {
  const el = createElement("c-chrono-picker-popover", { is: Popover });
  document.body.appendChild(el);
  const trigger = el.shadowRoot.querySelector("button");
  trigger.click();
  await Promise.resolve();
  expect(trigger.getAttribute("aria-expanded")).toBe("true");
  expect(el.shadowRoot.querySelector("section")).not.toBeNull();
  trigger.dispatchEvent(
    new KeyboardEvent("keydown", { key: "Escape", bubbles: true })
  );
  await Promise.resolve();
  expect(el.shadowRoot.querySelector("section")).toBeNull();
  expect(el.shadowRoot.activeElement).toBe(trigger);
});
it("closes on an outside pointer and refuses to open when disabled", async () => {
  const el = createElement("c-chrono-picker-popover", { is: Popover });
  document.body.appendChild(el);
  el.open();
  await Promise.resolve();
  document.body.dispatchEvent(new Event("pointerdown", { bubbles: true }));
  await Promise.resolve();
  expect(el.shadowRoot.querySelector("section")).toBeNull();
  el.disabled = true;
  el.open();
  await Promise.resolve();
  expect(el.shadowRoot.querySelector("section")).toBeNull();
});
it("dismisses when keyboard focus leaves without entering another control inside", async () => {
  const el = createElement("c-chrono-picker-popover", { is: Popover });
  document.body.appendChild(el);
  el.open();
  await Promise.resolve();
  el.shadowRoot
    .querySelector("button")
    .dispatchEvent(new FocusEvent("focusout", { bubbles: true }));
  await new Promise((done) => setTimeout(done, 5));
  expect(el.shadowRoot.querySelector("section")).toBeNull();
});
