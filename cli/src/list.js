import fs from "node:fs";
import path from "node:path";
import { findKitRoot, parseCommonArgs } from "./kit-utils.js";

export const HELP = `
OpenCode Engineering Kit CLI - list

Lists assets (skills, agents, prompts, templates) from a kit checkout.

Usage:
  opencode-engineering-kit list [options]

Options:
  --type <type>   Filter by type: skills, agents, prompts, templates (default: all)
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
  if (type && !["skills", "agents", "prompts", "templates"].includes(type)) {
    throw new Error(`unknown type: ${type} (expected skills|agents|prompts|templates)`);
  }
  args.type = type;
  return args;
}

export function collect(kitRoot, type) {
  const out = {};
  const walk = (dir, rel, list) => {
    if (!fs.existsSync(dir)) return list;
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const p = path.join(dir, entry.name);
      const r = rel ? `${rel}/${entry.name}` : entry.name;
      if (entry.isDirectory()) walk(p, r, list);
      else list.push({ name: path.basename(entry.name, path.extname(entry.name)), path: r });
    }
    return list;
  };

  if (!type || type === "skills") {
    out.skills = walk(path.join(kitRoot, "assets/skills"), "assets/skills", [])
      .filter((f) => f.path.endsWith("SKILL.md"))
      .map((f) => ({ name: path.basename(path.dirname(f.path)), path: path.dirname(f.path) }))
      .sort((a, b) => a.name.localeCompare(b.name));
  }
  if (!type || type === "agents") {
    out.agents = walk(path.join(kitRoot, "assets/agents"), "assets/agents", [])
      .filter((f) => f.path.endsWith(".md"))
      .map((f) => ({ name: f.name, path: f.path }))
      .sort((a, b) => a.name.localeCompare(b.name));
  }
  if (!type || type === "prompts") {
    out.prompts = walk(path.join(kitRoot, "assets/prompts"), "assets/prompts", [])
      .filter((f) => f.path.endsWith(".md"))
      .map((f) => ({ name: f.name, path: f.path }))
      .sort((a, b) => a.name.localeCompare(b.name));
  }
  if (!type || type === "templates") {
    out.templates = walk(path.join(kitRoot, "assets/templates"), "assets/templates", [])
      .filter((f) => f.path.endsWith(".md"))
      .map((f) => ({ name: f.name, path: f.path }))
      .sort((a, b) => a.name.localeCompare(b.name));
  }
  return out;
}

export function main(argv) {
  const args = parseArgs(argv);
  if (args.help) {
    console.log(HELP);
    return;
  }
  const kitRoot = findKitRoot(args.dir);
  const types = args.type ? [args.type] : ["skills", "agents", "prompts", "templates"];
  const result = collect(kitRoot, args.type);

  if (args.json) {
    console.log(JSON.stringify(result, null, 2));
    return;
  }

  for (const t of types) {
    const items = result[t] ?? [];
    console.log(`${t}: ${items.length}`);
    for (const item of items) console.log(`  - ${item.name}`);
    console.log("");
  }
}
