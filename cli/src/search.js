import fs from "node:fs";
import path from "node:path";
import { findKitRoot, parseCommonArgs } from "./kit-utils.js";
import { collect } from "./list.js";

export const HELP = `
OpenCode Engineering Kit CLI - search

Searches asset names and descriptions by keyword.

Usage:
  opencode-engineering-kit search <query> [options]

Options:
  --type <type>   Restrict to: skills, agents, prompts, templates (default: all)
  --dir <dir>     Kit checkout directory (default: current directory)
  --json          Output as JSON
  --help          Show this help
`;

export function parseArgs(argv) {
  const args = parseCommonArgs(argv);
  let type = null;
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === "--type") { type = argv[++i]; }
  }
  args.type = type;
  return args;
}

function descriptionOf(kitRoot, item) {
  if (!item.path.endsWith("SKILL.md") && item.path.endsWith(".md") === false) return "";
  const file = item.path.endsWith("SKILL.md")
    ? path.join(kitRoot, item.path, "SKILL.md")
    : path.join(kitRoot, item.path);
  if (!fs.existsSync(file)) return "";
  const head = fs.readFileSync(file, "utf8").split("\n").slice(0, 20).join("\n");
  const m = head.match(/description:\s*(.+)/);
  return m ? m[1].trim() : "";
}

export function search(kitRoot, query, type) {
  const q = query.toLowerCase();
  const result = collect(kitRoot, type);
  const matches = [];
  for (const [t, items] of Object.entries(result)) {
    for (const item of items) {
      const desc = descriptionOf(kitRoot, item);
      if (item.name.toLowerCase().includes(q) || desc.toLowerCase().includes(q)) {
        matches.push({ type: t, name: item.name, path: item.path, description: desc });
      }
    }
  }
  return matches;
}

export function main(argv) {
  const args = parseArgs(argv);
  if (args.help) {
    console.log(HELP);
    return;
  }
  const query = args._positional[0];
  if (!query) {
    throw new Error(`missing search query\n${HELP}`);
  }
  const kitRoot = findKitRoot(args.dir);
  const matches = search(kitRoot, query, args.type);

  if (args.json) {
    console.log(JSON.stringify(matches, null, 2));
    return;
  }
  console.log(`matches: ${matches.length}`);
  for (const m of matches) {
    console.log(`  [${m.type}] ${m.name} — ${m.description || m.path}`);
  }
}
