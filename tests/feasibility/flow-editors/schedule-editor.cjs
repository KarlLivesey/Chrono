// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
// Isolated headless browser; no screen capture, recording or personal browser.
const target = process.env.CHRONO_TARGET_ORG || "chrono-dev";
const { execFileSync } = require("node:child_process");
const { chromium } = require(
  process.env.CHRONO_PLAYWRIGHT_MODULE || "playwright"
);
(async () => {
  const version = JSON.parse(
    execFileSync(
      "sf",
      [
        "data",
        "query",
        "--use-tooling-api",
        "--target-org",
        target,
        "--query",
        "SELECT ActiveVersionId FROM FlowDefinition WHERE DeveloperName='ChronoExampleWorkingHours'",
        "--json"
      ],
      { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] }
    )
  ).result.records[0].ActiveVersionId;
  const d = JSON.parse(
    execFileSync(
      "sf",
      [
        "org",
        "open",
        "--target-org",
        target,
        "--url-only",
        "--path",
        "/builder_platform_interaction/flowBuilder.app?flowId=" + version,
        "--json"
      ],
      { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] }
    )
  );
  const b = await chromium.launch({ headless: true });
  try {
    const p = await b.newPage({ viewport: { width: 1440, height: 1000 } });
    p.setDefaultTimeout(45000);
    await p.goto(d.result.url);
    await p
      .locator("span.text-element-label-mask")
      .filter({ hasText: "Chrono example 4 - Operating hours and holidays" })
      .waitFor();
    await p
      .locator("span.text-element-label-mask")
      .filter({ hasText: "Chrono example 4 - Operating hours and holidays" })
      .click();
    await p.getByRole("button", { name: "Done", exact: true }).waitFor();
    const preview = p.getByText("Choose a local date and time", {
      exact: true
    });
    await preview.scrollIntoViewIfNeeded();
    const box = await preview.boundingBox();
    await p.mouse.click(box.x + box.width / 2, box.y + box.height / 2);
    await p
      .getByRole("button", { name: "Operating hours", exact: true })
      .click();
    const policy = p
      .getByRole("combobox", { name: "User selection", exact: true })
      .last();
    await policy.click();
    await p
      .getByRole("option", { name: "Fixed operating hours", exact: true })
      .click();
    await p
      .getByRole("combobox", { name: "Values supplied by", exact: true })
      .last()
      .click();
    await p
      .getByRole("option", {
        name: "Enter weekly hours and holidays",
        exact: true
      })
      .click();
    const zone = p.getByRole("combobox", {
      name: "Schedule timezone (required)",
      exact: true
    });
    await zone.fill("Asia/Tokyo");
    await p
      .getByRole("option", { name: "Asia/Tokyo", exact: true })
      .click({ delay: 150 });
    if ((await zone.inputValue()) !== "Asia/Tokyo")
      throw Error("Schedule timezone did not stick");
    const preset = p.getByRole("button", {
      name: "Use Mon–Fri, 09:00–17:00",
      exact: true
    });
    const size = await preset.boundingBox();
    if (size.height > 40) throw Error("Weekday control wraps excessively");
    await preset.click();
    const opens = await p
      .getByLabel("Opens", { exact: true })
      .first()
      .boundingBox();
    const closes = await p
      .getByLabel("Closes", { exact: true })
      .first()
      .boundingBox();
    const container = await p.locator(".fixed-schedule").boundingBox();
    if (
      Math.abs(opens.y - closes.y) > 2 ||
      closes.x <= opens.x ||
      closes.x + closes.width > container.x + container.width + 1
    )
      throw Error("Time fields do not fit side by side");
    if (
      (await p
        .getByRole("combobox", { name: "Weekday", exact: true })
        .count()) !== 5
    )
      throw Error("Weekday preset missing rows");
    await p.getByRole("button", { name: "Add holiday", exact: true }).click();
    await p.getByText("Closed all day", { exact: true }).click();
    if (
      await p
        .getByRole("checkbox", { name: "Closed all day", exact: true })
        .isChecked()
    )
      throw Error("Holiday checkbox did not change");
    await p.getByLabel("Closed from", { exact: true }).waitFor();
    console.log(
      "PASS fixed schedule lookup, compact preset, five weekdays, aligned time fields and partial holiday",
      JSON.stringify({
        containerWidth: container.width,
        presetHeight: size.height,
        timeWidth: opens.width
      })
    );
  } finally {
    await b.close();
  }
})().catch((e) => {
  console.error(e.message.replace(/https?:\/\/[^\s]+/g, "[url]"));
  process.exitCode = 1;
});
