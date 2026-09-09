import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs/promises";
import { JSDOM } from "jsdom";
import { rankPages } from "../../docs/assets/search.mjs";

test("search favours exact API names and requires every query term", () => {
  const pages = [
    {
      title: "Timezones",
      text: "Use ChronoInstantService to parse an instant.",
      category: "guide",
      url: "zones.html"
    },
    {
      title: "ChronoInstantService",
      text: "Parse exact instants.",
      category: "apex",
      url: "instant.html"
    },
    {
      title: "Operating hours",
      text: "Skip a bank holiday when adding working time.",
      category: "guide",
      url: "hours.html"
    }
  ];
  assert.equal(rankPages(pages, "ChronoInstantService")[0].url, "instant.html");
  assert.deepEqual(
    rankPages(pages, "bank holiday").map((r) => r.url),
    ["hours.html"]
  );
  assert.equal(rankPages(pages, "bank unknown").length, 0);
  assert.equal(rankPages(pages, " ").length, 0);
});

test("search index finds guides, action fields and overloads", async () => {
  const pages = JSON.parse(
    await fs.readFile(".docs-site/search-index.json", "utf8")
  );
  for (const query of [
    "operating hours",
    "ChronoPlainDateService",
    "offsetOverride",
    "maximumSegments",
    "WorkingDays",
    "midnight"
  ]) {
    assert.ok(rankPages(pages, query).length > 0, query);
  }
  assert.equal(
    rankPages(pages, "ChronoPlainDateService")[0].title,
    "ChronoPlainDateService"
  );
});

test("search page renders text safely, changes theme and supports keyboard navigation", async () => {
  const dom = new JSDOM(await fs.readFile(".docs-site/search.html", "utf8"), {
    url: "https://karllivesey.github.io/Chrono/search.html?q=holiday"
  });
  const window = dom.window;
  const previous = new Map();
  const globals = {
    document: window.document,
    location: window.location,
    history: window.history,
    localStorage: window.localStorage,
    matchMedia: () => ({ matches: true, addEventListener() {} }),
    fetch: async () => ({
      ok: true,
      json: async () => [
        {
          title: "<img src=x> holiday",
          text: "Holiday <script>bad()</script>",
          category: "guide",
          url: "handbook/operating-hours.html"
        }
      ]
    })
  };
  try {
    for (const [key, value] of Object.entries(globals)) {
      previous.set(key, Object.getOwnPropertyDescriptor(globalThis, key));
      Object.defineProperty(globalThis, key, {
        configurable: true,
        writable: true,
        value
      });
    }
    await import(`../../docs/assets/site.mjs?test=${Date.now()}`);
    await new Promise((resolve) => setTimeout(resolve, 0));
    const doc = window.document;
    assert.equal(doc.querySelectorAll("#search-results li").length, 1);
    assert.equal(doc.querySelector("#search-results img"), null);
    assert.equal(doc.querySelector("#search-results script"), null);
    assert.match(
      doc.querySelector("#search-results").textContent,
      /<img src=x>/
    );
    assert.equal(doc.querySelector(".mobile-navigation").open, false);
    doc.querySelector(".theme-button").click();
    assert.equal(doc.documentElement.dataset.theme, "light");
    doc.querySelector(".theme-button").click();
    assert.equal(doc.documentElement.dataset.theme, "dark");
    doc.dispatchEvent(
      new window.KeyboardEvent("keydown", { key: "/", bubbles: true })
    );
    assert.equal(doc.activeElement.id, "site-search");
  } finally {
    for (const [key, descriptor] of previous) {
      if (descriptor) Object.defineProperty(globalThis, key, descriptor);
      else delete globalThis[key];
    }
    window.close();
  }
});

function luminance(hex) {
  const components = hex
    .match(/[a-f0-9]{2}/gi)
    .map((v) => parseInt(v, 16) / 255)
    .map((v) => (v <= 0.04045 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4));
  return (
    components[0] * 0.2126 + components[1] * 0.7152 + components[2] * 0.0722
  );
}
test("body, muted text, links and accents meet normal-text contrast in both themes", () => {
  for (const theme of [
    {
      backgrounds: ["f6f4ee", "fbfaf6"],
      colours: ["20343a", "576465", "a64023", "275868"]
    },
    {
      backgrounds: ["182629", "1d2e31"],
      colours: ["edece1", "b3bdb5", "efb188", "bfceba"]
    }
  ]) {
    for (const background of theme.backgrounds)
      for (const colour of theme.colours) {
        const values = [luminance(background), luminance(colour)].sort(
          (a, b) => b - a
        );
        assert.ok(
          (values[0] + 0.05) / (values[1] + 0.05) >= 4.5,
          `${colour} on ${background}`
        );
      }
  }
});

test("development APIs are never labelled as the released package", async () => {
  const project = JSON.parse(await fs.readFile("sfdx-project.json", "utf8"));
  const version = project.packageDirectories[0].versionNumber;
  for (const name of [
    "reference/apex/index.md",
    "reference/apex/ChronoWorkingTimeService.md",
    "reference/actions/WorkingTime.md"
  ]) {
    const text = await fs.readFile(`docs/${name}`, "utf8");
    assert.ok(text.includes(version), name);
    assert.ok(text.includes("Development source"), name);
    assert.ok(!text.includes("Released 0.1.0.19"), name);
  }
});
