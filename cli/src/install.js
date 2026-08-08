#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";
import os from "node:os";
import { execFileSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

export const DEFAULT_REPO = "devtiagoabreu/opencode-engineering-kit";
export const DEFAULT_BRANCH = "main";
export const HELP = `
OpenCode Engineering Kit - project installer

Installs skills, agents, commands, context, prompts, playbooks, recipes and
templates from the kit into the OpenCode config of an existing project
(.opencode/), wiring it up through opencode.json.

Usage:
  opencode-engineering-kit install [options]
  npx opencode-engineering-kit install [options]

Options:
  --target <dir>    Target project directory (default: current directory)
  --source <dir>    Use a local kit checkout instead of downloading from GitHub
  --repo <repo>     GitHub repository to fetch the kit from (default: ${DEFAULT_REPO})
  --branch <name>   Git branch/tag of the kit (default: ${DEFAULT_BRANCH})
  --only <list>     Comma-separated subset: skills,agents,commands,context,assets
  --force           Overwrite existing files in .opencode/
  --dry-run         Print what would be done without touching the filesystem
  --verbose         Print every copied file
  --version         Print version
  --help            Show this help
`;

const GROUPS = {
  skills: { from: "assets/skills", to: "skills", mode: "dir" },
  agents: { from: "assets/agents", to: "agents", mode: "flatten" },
  commands: { from: "assets/commands", to: "commands", mode: "dir" },
  context: { from: "context", to: "context", mode: "dir" },
  assets: { from: "assets", to: "assets", mode: "dir" },
};

function log(msg) {
  console.log(`[opencode-engineering-kit] ${msg}`);
}

function warn(msg) {
  console.warn(`[opencode-engineering-kit] warn: ${msg}`);
}

export function parseArgs(argv) {
  const args = { target: process.cwd(), only: Object.keys(GROUPS), force: false, dryRun: false, verbose: false };
  const positional = [];
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    const next = () => (++i < argv.length ? argv[i] : undefined);
    if (a === "install") { positional.push(a); continue; }
    switch (a) {
      case "--target": args.target = next(); break;
      case "--source": args.source = next(); break;
      case "--repo": args.repo = next(); break;
      case "--branch": args.branch = next(); break;
      case "--only": args.only = String(next()).split(",").filter(Boolean); break;
      case "--force": args.force = true; break;
      case "--dry-run": args.dryRun = true; break;
      case "--verbose": args.verbose = true; break;
      case "--version": args.version = true; break;
      case "--help": case "-h": args.help = true; break;
      default: throw new Error(`unknown option: ${a}\n${HELP}`);
    }
  }
  if (!args.repo) args.repo = DEFAULT_REPO;
  if (!args.branch) args.branch = DEFAULT_BRANCH;
  return args;
}

async function downloadTar(repo, branch) {
  const url = `https://github.com/${repo}/archive/refs/heads/${branch}.tar.gz`;
  log(`downloading kit from ${url}`);
  const res = await fetch(url);
  if (!res.ok) throw new Error(`failed to download kit (${res.status} ${res.statusText})`);
  const buf = Buffer.from(await res.arrayBuffer());
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "oek-download-"));
  const archive = path.join(tmp, "kit.tar.gz");
  fs.writeFileSync(archive, buf);
  execFileSync("tar", ["-xzf", archive, "-C", tmp], { stdio: "inherit" });
  return { dir: findKitRoot(tmp), cleanup: () => fs.rmSync(tmp, { recursive: true, force: true }) };
}

function findKitRoot(dir) {
  for (const entry of fs.readdirSync(dir)) {
    const candidate = path.join(dir, entry);
    if (fs.statSync(candidate).isDirectory() && fs.existsSync(path.join(candidate, "assets")) && fs.existsSync(path.join(candidate, "context"))) {
      return candidate;
    }
  }
  throw new Error("downloaded archive did not contain a valid kit (no assets/ + context/)");
}

function isSameOrSubPath(child, parent) {
  const rel = path.relative(parent, child);
  return rel === "" || (!rel.startsWith("..") && !path.isAbsolute(rel));
}

function copyDir(src, dest, { force, dryRun, verbose }) {
  const created = [];
  const skipped = [];
  const fsWalk = (s, d) => {
    for (const entry of fs.readdirSync(s, { withFileTypes: true })) {
      const sPath = path.join(s, entry.name);
      const dPath = path.join(d, entry.name);
      if (entry.isDirectory()) {
        fsWalk(sPath, dPath);
      } else {
        if (fs.existsSync(dPath) && !force) {
          skipped.push(path.relative(src, sPath));
          continue;
        }
        created.push(path.relative(src, sPath));
        if (!dryRun) {
          fs.mkdirSync(path.dirname(dPath), { recursive: true });
          fs.copyFileSync(sPath, dPath);
        }
        if (verbose && !dryRun) log(`  -> ${path.relative(process.cwd(), dPath)}`);
      }
    }
  };
  fsWalk(src, dest);
  return { created, skipped };
}

function flattenAgentFiles(src, dest, { force, dryRun, verbose }) {
  const created = [];
  const skipped = [];
  const walk = (s) => {
    for (const entry of fs.readdirSync(s, { withFileTypes: true })) {
      const sPath = path.join(s, entry.name);
      if (entry.isDirectory()) {
        walk(sPath);
      } else if (entry.name.endsWith(".md")) {
        const targetName = path.basename(entry.name, ".md");
        const dPath = path.join(dest, `${targetName}.md`);
        if (fs.existsSync(dPath) && !force) {
          skipped.push(entry.name);
          continue;
        }
        created.push(entry.name);
        if (!dryRun) {
          fs.mkdirSync(dest, { recursive: true });
          fs.copyFileSync(sPath, dPath);
        }
        if (verbose && !dryRun) log(`  -> ${path.relative(process.cwd(), dPath)}`);
      }
    }
  };
  walk(src);
  return { created, skipped };
}

function copyGroup(source, target, group, opts) {
  const src = path.join(source, group.from);
  if (!fs.existsSync(src)) {
    warn(`group "${group.to}" skipped: ${group.from} not found in kit`);
    return { created: [], skipped: [] };
  }
  const dest = path.join(target, ".opencode", group.to);
  if (group.mode === "flatten") return flattenAgentFiles(src, dest, opts);
  return copyDir(src, dest, opts);
}

function mergeConfig(target, ctxFiles) {
  const cfgPath = path.join(target, "opencode.json");
  let cfg = { $schema: "https://opencode.ai/config.json" };
  if (fs.existsSync(cfgPath)) {
    cfg = JSON.parse(fs.readFileSync(cfgPath, "utf8"));
  }
  cfg.skills = cfg.skills ?? {};
  cfg.skills.paths = cfg.skills.paths ?? [];
  if (!cfg.skills.paths.includes(".opencode/skills")) cfg.skills.paths.push(".opencode/skills");
  cfg.instructions = cfg.instructions ?? [];
  for (const f of ctxFiles) {
    const rel = `.opencode/context/${f}`;
    if (!cfg.instructions.includes(rel)) cfg.instructions.push(rel);
  }
  return cfg;
}

export async function install(args) {
  let sourceCleanup = null;
  let source = args.source;
  if (!source) {
    const dl = await downloadTar(args.repo, args.branch);
    source = dl.dir;
    sourceCleanup = dl.cleanup;
  } else {
    source = path.resolve(source);
    if (!fs.existsSync(source)) throw new Error(`source directory not found: ${source}`);
  }

  const target = path.resolve(args.target);
  if (!fs.existsSync(target)) throw new Error(`target directory not found: ${target}`);
  if (!args.dryRun && !fs.existsSync(path.join(target, ".git"))) {
    warn(`"${target}" does not look like a git repository (no .git). Installing anyway.`);
  }

  const opts = { force: args.force, dryRun: args.dryRun, verbose: args.verbose };
  const summary = {};
  let totalCreated = 0;
  let totalSkipped = 0;

  for (const name of Object.keys(GROUPS)) {
    if (!args.only.includes(name)) continue;
    const group = GROUPS[name];
    const result = copyGroup(source, target, group, opts);
    summary[name] = result;
    totalCreated += result.created.length;
    totalSkipped += result.skipped.length;
    log(`${name}: ${result.created.length} installed${result.skipped.length ? `, ${result.skipped.length} skipped (exists, use --force to overwrite)` : ""}`);
  }

  const ctxDir = path.join(source, "context");
  const ctxFiles = fs.existsSync(ctxDir)
    ? fs.readdirSync(ctxDir).filter((f) => f.endsWith(".md")).sort()
    : [];

  const cfg = mergeConfig(target, ctxFiles);
  if (args.dryRun) {
    log(`dry-run: would write ${path.relative(process.cwd(), path.join(target, "opencode.json"))}`);
  } else {
    fs.writeFileSync(path.join(target, "opencode.json"), `${JSON.stringify(cfg, null, 2)}\n`);
  }
  log(`opencode.json ${args.dryRun ? "would be" : ""} updated (skills.paths + ${ctxFiles.length} context instructions)`);

  if (sourceCleanup) sourceCleanup();

  log(`done: ${totalCreated} file(s) installed, ${totalSkipped} skipped, into .opencode/ of ${target}`);
  log("restart opencode to pick up the new config.");
  return { summary, cfg, target };
}

export async function main(argv) {
  const args = parseArgs(argv);
  if (args.help) {
    console.log(HELP);
    return;
  }
  if (args.version) {
    const pkg = JSON.parse(fs.readFileSync(path.join(__dirname, "..", "package.json"), "utf8"));
    console.log(pkg.version);
    return;
  }
  await install(args);
}
