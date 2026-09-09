// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
// Executes the deployed examples without screen capture or recording.
const assert = require("node:assert/strict");
const { execFileSync } = require("node:child_process");
const { chromium } = require(
  process.env.CHRONO_PLAYWRIGHT_MODULE || "playwright"
);
const target = process.env.CHRONO_TARGET_ORG || "chrono-dev";
const expectations = {
  Planning: [
    "2026-09-01T09:00:00.000+01:00[Europe/London]",
    "Calendar wait: 1 days",
    "Remaining time: 58500000 milliseconds",
    "Inside London operating hours: false"
  ],
  Date: ["2026-02-28"],
  TimeZones: ["2026-10-24T21:30:00.000-04:00[America/New_York]"],
  MissingTime: ["2026-03-29T02:00:00.000", "2026-03-29T01:00:00.000Z"],
  WorkingHours: ["2026-09-01T09:30:00.000+01:00[Europe/London]"],
  Difference: ["Elapsed hours: 89.000", "Working hours: 1.000"],
  Collections: [
    "2026-09\n2026-10-25T01:30:00.000+01:00[Europe/London]\nError: Invalid calendar date: 2026-02-30"
  ]
};
(async () => {
  const browser = await chromium.launch({ headless: true });
  try {
    for (const [name, expected] of Object.entries(expectations)) {
      if (process.env.CHRONO_EXAMPLE && process.env.CHRONO_EXAMPLE !== name)
        continue;
      const login = JSON.parse(
        execFileSync(
          "sf",
          [
            "org",
            "open",
            "--target-org",
            target,
            "--url-only",
            "--path",
            "/flow/ChronoExample" + name,
            "--json"
          ],
          { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] }
        )
      ).result;
      const page = await browser.newPage({
        viewport: { width: 1440, height: 1000 }
      });
      page.setDefaultTimeout(45000);
      await page.goto(login.url);
      await page.getByRole("button", { name: "Next", exact: true }).waitFor();
      if (["TimeZones", "MissingTime"].includes(name)) {
        await page
          .getByRole("button", { name: /^(Time offset|This time is skipped):/ })
          .first()
          .click();
        await page
          .getByRole("button", {
            name:
              name === "TimeZones" ? "Second · GMT · UTC+00:00" : /Move forward/
          })
          .click({ delay: 150 });
      }
      await page
        .getByText("Checking…", { exact: true })
        .waitFor({ state: "hidden" });
      await page.getByRole("button", { name: "Next", exact: true }).click();
      await page.getByRole("button", { name: "Finish", exact: true }).waitFor();
      const result = await page.locator("body").innerText();
      for (const value of expected)
        assert(
          result.replace(/,/g, "").includes(value),
          `${name}: missing expected result ${value}`
        );
      assert(
        !result.includes("could not run"),
        `${name}: reached failure screen`
      );
      console.log("PASS", name, expected.join("; "));
      await page.close();
    }
  } finally {
    await browser.close();
  }
})().catch((error) => {
  console.error(error.message.replace(/https?:\/\/[^\s]+/g, "[url]"));
  process.exitCode = 1;
});
