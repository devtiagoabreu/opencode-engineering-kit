import fs from "node:fs";
import path from "node:path";
import { main as installMain, globalConfigDir } from "./install.js";

export const HELP = `
OpenCode Engineering Kit CLI - upgrade

Re-installs the kit into the current project with --force, refreshing every
asset and the opencode.json wiring from the latest remote revision.

Usage:
  opencode-engineering-kit upgrade [options]

Options (same as install):
  --target <dir>    Target project directory (default: current directory)
  --source <dir>    Use a local kit checkout instead of downloading from GitHub
  --global          Upgrade the global OpenCode config
  --profile <name>  Curated profile from profiles/*.json
  --repo <repo>     GitHub repository to fetch from (default: devtiagoabreu/opencode-engineering-kit)
  --branch <name>   Git branch/tag (default: main)
  --only <list>     Comma-separated subset: skills,agents,commands,context,assets,core,scripts,docs
  --verbose         Print every copied file
  --dry-run         Print what would be done without touching the filesystem
  --help            Show this help

Behavior:
  - If .opencode/.kit-install.json exists and you did not pass --profile/--only,
    upgrade reuses the recorded profile/only selection.
`;

function readInstallManifest(target, global) {
  const root = global ? globalConfigDir() : path.resolve(target || process.cwd());
  const base = global ? root : path.join(root, ".opencode");
  const p = path.join(base, ".kit-install.json");
  if (!fs.existsSync(p)) return null;
  try { return JSON.parse(fs.readFileSync(p, "utf8")); } catch { return null; }
}

function hasFlag(argv, name) {
  return argv.some((a) => a === name || a.startsWith(`${name}=`));
}

export function main(argv) {
  const normalized = [];
  let help = false;
  let target = process.cwd();
  let global = false;
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === "--help" || a === "-h") { help = true; continue; }
    if (a === "--target") { target = argv[i + 1] || target; normalized.push(a, argv[++i]); continue; }
    if (a === "--global") { global = true; normalized.push(a); continue; }
    normalized.push(a);
  }
  if (help) {
    console.log(HELP);
    return;
  }

  const manifest = readInstallManifest(target, global);
  if (manifest) {
    if (!hasFlag(normalized, "--profile") && manifest.kit?.profile) normalized.push("--profile", manifest.kit.profile);
    if (!hasFlag(normalized, "--only") && Array.isArray(manifest.only) && manifest.only.length) normalized.push("--only", manifest.only.join(","));
  }

  return installMain(["install", "--force", ...normalized]);
}
