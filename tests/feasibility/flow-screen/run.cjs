// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
// Runs the deployed example in an isolated headless browser, without recording.
const assert = require("node:assert/strict");
const { execFileSync } = require("node:child_process");
const { chromium } = require(
  process.env.CHRONO_PLAYWRIGHT_MODULE || "playwright"
);
const target = process.env.CHRONO_TARGET_ORG || "chrono-dev";
const sf = (args) =>
  JSON.parse(
    execFileSync("sf", [...args, "--target-org", target, "--json"], {
      encoding: "utf8",
      stdio: ["ignore", "pipe", "ignore"]
    })
  ).result;

async function run() {
  const login = sf([
    "org",
    "open",
    "--url-only",
    "--path",
    "/flow/ChronoCoreScreenProbe"
  ]);
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();
  page.setDefaultTimeout(30000);
  try {
    await page.goto(login.url);
    const inputs = page.locator("input:not([type=hidden])");
    await page
      .getByRole("button", { name: "Time offset: Choose offset", exact: true })
      .waitFor();
    assert.equal(await inputs.count(), 7);
    for (let i = 0; i < 7; i++)
      assert.notEqual(
        await inputs.nth(i).inputValue(),
        "",
        `Initial input ${i} is blank`
      );
    await page
      .getByRole("button", { name: "Time offset: Choose offset", exact: true })
      .click();
    await page
      .getByRole("button", { name: "Second · GMT · UTC+00:00", exact: true })
      .click();
    await page
      .getByRole("button", {
        name: "Time offset: BST · UTC+01:00 · Auto",
        exact: true
      })
      .nth(1)
      .click();
    await page
      .getByRole("button", { name: "Second · GMT · UTC+00:00", exact: true })
      .click();

    async function readResult(expected) {
      await page.getByRole("button", { name: "Next", exact: true }).click();
      await page.getByRole("button", { name: "Finish", exact: true }).waitFor();
      const text = await page.locator("body").innerText();
      const actual = JSON.parse(
        text.slice(text.indexOf("{"), text.lastIndexOf("}") + 1)
      );
      assert.deepEqual(actual, expected);
    }
    const base = {
      durationValue: "P1M2DT3.000S",
      monthDayValue: "--10-25",
      yearMonthValue: "2026-10",
      dateValue: "2026-10-25",
      timeValue: "01:30:00.000",
      dateTimeValue: "2026-10-25T01:30:00.000",
      instantValue: "2026-10-25T01:30:00.000Z",
      zonedValue: "2026-10-25T01:30:00.000+00:00[Europe/London]"
    };
    await readResult(base);
    console.log(
      "PASS: initial values, overlap selection, Next and all eight parsed ISO results"
    );
    await page.getByRole("button", { name: "Previous", exact: true }).click();
    await page
      .getByRole("button", { name: /Time offset: GMT/ })
      .first()
      .waitFor();
    assert.equal(await inputs.count(), 7);
    for (let i = 0; i < 7; i++)
      assert.notEqual(await inputs.nth(i).inputValue(), "");
    await inputs.nth(6).fill("2:45 AM");
    await inputs.nth(6).press("Tab");
    await page
      .getByRole("button", { name: /Time offset: GMT/ })
      .last()
      .waitFor();
    await readResult({
      ...base,
      timeValue: "02:45:00.000",
      dateTimeValue: "2026-10-25T02:45:00.000",
      instantValue: "2026-10-25T02:45:00.000Z",
      zonedValue: "2026-10-25T02:45:00.000+00:00[Europe/London]"
    });
    console.log(
      "PASS: Previous, edited time and changed ISO values across the screen boundary"
    );

    await page.getByRole("button", { name: "Previous", exact: true }).click();
    await page
      .getByRole("button", { name: /^Time offset:/ })
      .last()
      .click();
    await page
      .getByRole("textbox", { name: "UTC offset", exact: true })
      .fill("+02:00");
    await page.getByRole("button", { name: "Apply", exact: true }).click();
    await page
      .getByRole("button", { name: /Time offset:.*Override/ })
      .waitFor();
    await readResult({
      ...base,
      timeValue: "02:45:00.000",
      dateTimeValue: "2026-10-25T02:45:00.000",
      instantValue: "2026-10-25T00:45:00.000Z",
      zonedValue: "2026-10-25T01:45:00.000+01:00[Europe/London]"
    });
    console.log(
      "PASS: manual offset keeps plain clock and returns a parseable zoned ISO value"
    );

    const version = sf([
      "data",
      "query",
      "--use-tooling-api",
      "--query",
      "SELECT Id FROM Flow WHERE Definition.DeveloperName='ChronoCoreScreenProbe' AND Status='Active'"
    ]).records[0].Id;
    const org = sf(["org", "display"]);
    await page.goto(
      `${org.instanceUrl}/builder_platform_interaction/flowBuilder.app?flowId=${version}`
    );
    await page.getByText("Read ISO values", { exact: true }).waitFor();
    await page
      .getByRole("button", { name: "Select element", exact: true })
      .nth(2)
      .dblclick();
    await page.getByText("Set Input Values", { exact: true }).waitFor();
    for (const label of [
      "Duration ISO text",
      "Instant ISO text",
      "PlainDateTime ISO text",
      "PlainMonthDay ISO text",
      "PlainDate ISO text",
      "PlainTime ISO text",
      "PlainYearMonth ISO text",
      "ZonedDateTime ISO text"
    ]) {
      await page
        .getByText(label, { exact: true })
        .last()
        .scrollIntoViewIfNeeded();
    }
    await page
      .getByRole("button", { name: /^Remove / })
      .nth(7)
      .waitFor();
    assert.equal(
      await page
        .getByText(
          "The data type of the resource you entered isn't compatible.",
          { exact: true }
        )
        .count(),
      0
    );
    console.log("PASS: Flow Builder accepts all eight action input bindings");
  } catch (error) {
    console.error((await page.locator("body").innerText()).slice(-2500));
    throw error;
  } finally {
    await browser.close();
  }
}
run().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});
