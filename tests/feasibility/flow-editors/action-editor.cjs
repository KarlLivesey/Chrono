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
        "SELECT ActiveVersionId FROM FlowDefinition WHERE DeveloperName='ChronoExampleTimeZones'",
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
      .getByText("Convert instant to New York", { exact: true })
      .last()
      .waitFor();
    await p
      .getByText("Convert instant to New York", { exact: true })
      .first()
      .dblclick();
    await p.getByText("Input format", { exact: true }).waitFor();
    const zone = p.getByRole("combobox", { name: "Timezone", exact: true });
    for (const value of ["Asia/Tokyo", "Europe/London", "America/New_York"]) {
      await zone.click();
      await zone.fill(value);
      await p
        .getByRole("option", { name: value, exact: true })
        .click({ delay: 150 });
      if ((await zone.inputValue()) !== value)
        throw Error("Timezone selection did not persist: " + value);
    }
    console.log("PASS timezone selections with held mouse clicks");
    await p
      .getByRole("button", {
        name: "Value: Search Resources. Choose input mode",
        exact: true
      })
      .click();
    await p
      .getByRole("menuitemcheckbox", { name: "Enter Date/Time", exact: true })
      .click();
    await p
      .getByRole("button", {
        name: "Value: Enter Date/Time. Choose input mode",
        exact: true
      })
      .click();
    await p
      .getByRole("menuitemcheckbox", { name: "Search Resources", exact: true })
      .click();
    const source = p.getByRole("combobox", { name: "Value", exact: true });
    await source.fill("CurrentDateTime");
    await p
      .getByRole("option")
      .filter({ hasText: "$Flow.CurrentDateTime" })
      .last()
      .click({ delay: 150 });
    if ((await source.inputValue()) !== "$Flow.CurrentDateTime")
      throw Error("Resource selection did not persist");
    console.log("PASS mode change and native DateTime formula selection");
    await source.click();
    await source.fill("dateTimeValue");
    await p
      .getByRole("option")
      .filter({ hasText: "Picker.dateTimeValue" })
      .last()
      .click({ delay: 150 });
    if ((await source.inputValue()) !== "Picker.dateTimeValue")
      throw Error("Picker output did not persist");
    await p
      .getByRole("button", { name: /^Save\s*As\s*New\s*Version$/ })
      .click();
    const dialog = p.getByRole("dialog");
    await dialog.getByRole("button", { name: "Save", exact: true }).click();
    await dialog.waitFor({ state: "hidden" });
    await p.waitForURL(
      (url) =>
        url.searchParams.get("flowId") &&
        url.searchParams.get("flowId") !== version
    );
    const savedVersion = new URL(p.url()).searchParams.get("flowId");
    await p.reload();
    await p
      .getByText("Convert instant to New York", { exact: true })
      .first()
      .dblclick();
    const savedSource = p.getByRole("combobox", { name: "Value", exact: true });
    await savedSource.waitFor();
    if ((await savedSource.inputValue()) !== "Picker.dateTimeValue")
      throw Error("Saved resource binding changed");
    if (
      (await p
        .getByRole("combobox", { name: "Timezone", exact: true })
        .inputValue()) !== "America/New_York"
    )
      throw Error("Saved timezone changed");
    console.log(
      "PASS saved and reopened native binding and timezone",
      savedVersion
    );
  } finally {
    await b.close();
  }
})().catch((e) => {
  console.error(e.message.replace(/https?:\/\/[^\s]+/g, "[url]"));
  process.exitCode = 1;
});
