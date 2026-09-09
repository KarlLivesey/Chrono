// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
// Read-only checks of the seven real Flow Builder action editors. No recording.
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
(async () => {
  const definitions = sf([
    "data",
    "query",
    "--use-tooling-api",
    "--query",
    "SELECT DeveloperName, ActiveVersionId FROM FlowDefinition WHERE DeveloperName LIKE 'Chrono%Harness'"
  ]).records;
  const cases = [
    ["ResolveLocal", "Inspect or resolve local time", "Resolution"],
    ["Round", "Round date/time", "Round to"],
    ["CheckWorkingTime", "Check working time", "OperatingHours ID"],
    ["FindWorkingTime", "Find next or previous working time", "Direction"],
    ["PeriodBoundary", "Start or end of period", "Boundary"],
    ["Compare", "Compare date/time values", "End input format"],
    ["CalendarDifference", "Calendar difference", "Largest calendar unit"]
  ];
  const browser = await chromium.launch({ headless: true });
  try {
    for (const [kind, title, control] of cases) {
      const version = definitions.find(
        (item) => item.DeveloperName === `Chrono${kind}Harness`
      ).ActiveVersionId;
      const login = sf([
        "org",
        "open",
        "--url-only",
        "--path",
        "/builder_platform_interaction/flowBuilder.app?flowId=" + version
      ]);
      const page = await browser.newPage({
        viewport: { width: 1440, height: 1000 }
      });
      page.setDefaultTimeout(45000);
      await page.goto(login.url);
      // The one-action fixture keeps each target visible at normal canvas scale.
      await page
        .locator('button.icon[title^="Apex Action element"]')
        .dblclick();
      await page.getByRole("heading", { name: title, exact: true }).waitFor();
      await page
        .getByRole("combobox", { name: control, exact: true })
        .waitFor();
      assert(
        await page
          .getByRole("group", { name: "Value type", exact: true })
          .getByRole("combobox", { name: "Value type", exact: true })
          .isVisible()
      );
      console.log("PASS", title, "custom editor and", control);
      await page.close();
    }
  } finally {
    await browser.close();
  }
})().catch((error) => {
  console.error(error.message.replace(/https?:\/\/[^\s]+/g, "[url]"));
  process.exitCode = 1;
});
