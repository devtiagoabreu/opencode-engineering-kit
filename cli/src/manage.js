#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";
import os from "node:os";
import { fileURLToPath } from "node:url";
import { globalConfigDir } from "./install.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

export const STATUS_HELP = `
OpenCode Engineering Kit CLI - status

Reports where the kit is installed (global and/or project), whether it is
enabled, and how many assets were installed.

Usage:
  opencode-engineering-kit status [options]

Options:
  --json          Output as JSON
  --help          Show this help
`;

export const START_STOP_HELP = `
OpenCode Engineering Kit CLI - start/stop

Enables ("start") or disables ("stop") the kit in the project (.opencode/)
and/or the global config (~/.config/opencode/) without deleting any files.
Disabling removes the opencode.json wiring (skills.paths + instructions) so
opencode stops loading the kit; re-enabling restores it.

Usage:
  opencode-engineering-kit start [options]
  opencode-engineering-kit stop [options]

Options:
  --global        Only manage the global config
  --project       Only manage the current project
  --help          Show this help
`;

function pkgVersion() {
  try {
    return JSON.parse(fs.readFileSync(path.join(__dirname, "..", "package.json"), "utf8")).version;
  } catch {
    return "unknown";
  }
}

function readConfig(cfgPath) {
  if (!fs.existsSync(cfgPath)) return null;
  try {
    return JSON.parse(fs.readFileSync(cfgPath, "utf8"));
  } catch {
    return null;
  }
}

function countFiles(dir, predicate) {
  if (!fs.existsSync(dir)) return 0;
  let n = 0;
  const walk = (d) => {
    for (const entry of fs.readdirSync(d, { withFileTypes: true })) {
      const p = path.join(d, entry.name);
      if (entry.isDirectory()) walk(p);
      else if (predicate(p)) n++;
    }
  };
  walk(dir);
  return n;
}

function scopeState(scope) {
  const { label, root, cfgPath, global } = scope;
  const installed = global
    ? fs.existsSync(path.join(root, "skills")) || fs.existsSync(path.join(root, "context"))
    : fs.existsSync(path.join(root, ".opencode"));
  if (!installed) return { label, installed: false, enabled: false, skills: 0, agents: 0, commands: 0, path: null };

  const base = global ? root : path.join(root, ".opencode");
  const skills = countFiles(path.join(base, "skills"), (p) => p.endsWith("SKILL.md"));
  const agents = countFiles(path.join(base, "agents"), (p) => p.endsWith(".md"));
  const commands = countFiles(path.join(base, "commands"), (p) => p.endsWith(".md"));

  let enabled = false;
  const cfg = readConfig(cfgPath);
  if (cfg) {
    const skillsPath = global ? path.join(root, "skills") : ".opencode/skills";
    const ctxPrefix = global ? path.join(root, "context") : ".opencode/context";
    const hasSkills = (cfg.skills?.paths ?? []).includes(skillsPath);
    const hasCtx = (cfg.instructions ?? []).some((i) => i.startsWith(ctxPrefix));
    enabled = hasSkills && hasCtx;
  }
  return { label, installed: true, enabled, skills, agents, commands, path: base, cfgPath };
}

export function detectScopes({ globalOnly = false, projectOnly = false } = {}) {
  const scopes = [];
  if (!globalOnly) scopes.push({ label: "project", root: process.cwd(), cfgPath: path.join(process.cwd(), "opencode.json"), global: false });
  if (!projectOnly) scopes.push({ label: "global", root: globalConfigDir(), cfgPath: path.join(globalConfigDir(), "opencode.json"), global: true });
  return scopes.map(scopeState);
}

export function status(args = {}) {
  const states = detectScopes();
  const anyInstalled = states.some((s) => s.installed);
  if (args.json) {
    return { version: pkgVersion(), scopes: states.map(({ label, installed, enabled, skills, agents, commands, path }) => ({ label, installed, enabled, skills, agents, commands, path })) };
  }
  console.log(`OpenCode Engineering Kit status — v${pkgVersion()}`);
  console.log("");
  if (!anyInstalled) {
    console.log("The kit is not installed. Run:  npx opencode-engineering-kit install");
    return { installed: false };
  }
  for (const s of states) {
    if (!s.installed) continue;
    const state = s.enabled ? "enabled" : "disabled";
    console.log(`  ${s.label}: installed (${state}) — ${s.skills} skills, ${s.agents} agents, ${s.commands} commands`);
    console.log(`    ${s.path}`);
  }
  const global = states.find((s) => s.label === "global");
  const project = states.find((s) => s.label === "project");
  if ((global?.installed && global.enabled) || (project?.installed && project.enabled)) {
    console.log("");
    console.log("The kit is active. Run \"npx opencode-engineering-kit stop\" to disable it.");
  } else if (anyInstalled) {
    console.log("");
    console.log("The kit is disabled. Run \"npx opencode-engineering-kit start\" to enable it.");
  }
  return { installed: anyInstalled };
}

function applyWiring(root, global, { disable }) {
  const cfgPath = path.join(root, "opencode.json");
  const cfg = readConfig(cfgPath) ?? { $schema: "https://opencode.ai/config.json" };
  const skillsPath = global ? path.join(root, "skills") : ".opencode/skills";
  const ctxPrefix = global ? path.join(root, "context") : ".opencode/context";

  cfg.skills = cfg.skills ?? {};
  cfg.skills.paths = cfg.skills.paths ?? [];
  cfg.instructions = cfg.instructions ?? [];

  if (disable) {
    cfg.skills.paths = cfg.skills.paths.filter((p) => p !== skillsPath);
    cfg.instructions = cfg.instructions.filter((i) => !i.startsWith(ctxPrefix));
  } else {
    if (!cfg.skills.paths.includes(skillsPath)) cfg.skills.paths.push(skillsPath);
    const ctxDir = global ? path.join(root, "context") : path.join(root, ".opencode/context");
    const files = fs.existsSync(ctxDir)
      ? fs.readdirSync(ctxDir).filter((f) => f.endsWith(".md")).sort()
      : [];
    for (const f of files) {
      const rel = global ? path.join(root, "context", f) : `.opencode/context/${f}`;
      if (!cfg.instructions.includes(rel)) cfg.instructions.push(rel);
    }
  }

  if (!cfg.skills.paths.length) delete cfg.skills.paths;
  if (!cfg.instructions.length) delete cfg.instructions;

  fs.mkdirSync(path.dirname(cfgPath), { recursive: true });
  fs.writeFileSync(cfgPath, `${JSON.stringify(cfg, null, 2)}\n`);
  return cfgPath;
}

export function startStop(kind, args = {}) {
  const action = kind === "start" ? "enabled" : "disabled";
  const apply = kind === "start" ? false : true;
  const handled = [];

  const wantProject = !args.global;
  const wantGlobal = !args.project;

  if (wantProject && fs.existsSync(path.join(process.cwd(), ".opencode"))) {
    handled.push({ scope: "project", cfgPath: applyWiring(process.cwd(), false, { disable: apply }) });
  }
  if (wantGlobal && (fs.existsSync(path.join(globalConfigDir(), "skills")) || fs.existsSync(path.join(globalConfigDir(), "context")))) {
    handled.push({ scope: "global", cfgPath: applyWiring(globalConfigDir(), true, { disable: apply }) });
  }

  if (!handled.length) {
    console.log(`Nothing to ${kind}: the kit is not installed in any scope. Run:  npx opencode-engineering-kit install`);
    return { action, handled: [] };
  }
  for (const h of handled) {
    console.log(`kit ${action} for ${h.scope} config (${h.cfgPath})`);
  }
  console.log("restart opencode to pick up the change.");
  return { action, handled };
}

export function parseLifecycleArgs(argv, helpText) {
  const args = { global: false, project: false, json: false, help: false };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    switch (a) {
      case "--global": args.global = true; break;
      case "--project": args.project = true; break;
      case "--json": args.json = true; break;
      case "--help": case "-h": args.help = true; break;
      default: throw new Error(`unknown option: ${a}\n${helpText}`);
    }
  }
  return args;
}

export function mainStatus(argv) {
  const args = parseLifecycleArgs(argv, STATUS_HELP);
  if (args.help) {
    console.log(STATUS_HELP);
    return;
  }
  return status(args);
}

export function mainStart(argv) {
  const args = parseLifecycleArgs(argv, START_STOP_HELP);
  if (args.help) {
    console.log(START_STOP_HELP);
    return;
  }
  return startStop("start", args);
}

export function mainStop(argv) {
  const args = parseLifecycleArgs(argv, START_STOP_HELP);
  if (args.help) {
    console.log(START_STOP_HELP);
    return;
  }
  return startStop("stop", args);
}
