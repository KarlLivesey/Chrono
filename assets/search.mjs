export function rankPages(pages, query) {
  const words = query.toLowerCase().trim().split(/\s+/).filter(Boolean);
  if (!words.length) return [];
  return pages
    .map((page) => {
      const title = page.title.toLowerCase();
      const text = page.text.toLowerCase();
      if (!words.every((word) => title.includes(word) || text.includes(word)))
        return null;
      const score =
        words.reduce((sum, word) => sum + (title.includes(word) ? 12 : 1), 0) +
        (page.category === "guide" ? 4 : 0) +
        (title === query.toLowerCase().trim() ? 30 : 0);
      const firstMatch = text.indexOf(words[0]);
      const start = Math.max(0, firstMatch - 65);
      return {
        ...page,
        score,
        excerpt:
          (start ? "…" : "") +
          page.text.slice(start, start + 230).replace(/\s+/g, " ") +
          "…"
      };
    })
    .filter(Boolean)
    .sort((a, b) => b.score - a.score || a.title.localeCompare(b.title))
    .slice(0, 40);
}
