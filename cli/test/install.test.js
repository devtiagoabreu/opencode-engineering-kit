import { test, beforeEach, afterEach } from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import os from "node:os";
import { fileURLToPath } from "node:url";
import { install } from "../src/install.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const KIT_SOURCE = path.resolve(__dirname, "..", "..");

let tmp;
let target;
let cwd;

beforeEach(() => {
  tmp = fs.mkdtempSync(path.join(os.tmpdir(), "oek-test-"));
  target = path.join(tmp, "my-app");
  fs.mkdirSync(target);
  fs.mkdirSync(path.join(target, ".git"));
  cwd = process.cwd();
  process.chdir(target);
});

afterEach(() => {
  process.chdir(cwd);
  fs.rmSync(tmp, { recursive: true, force: true });
});

test("installs all groups into .opencode/", async () => {
  const { summary } = await install({ target, source: KIT_SOURCE, only: Object.keys({ skills: 1, agents: 1, commands: 1, context: 1, assets: 1 }), force: true, dryRun: false, verbose: false });

  assert.ok(summary.skills.created.length > 10, "skills installed");
  assert.ok(summary.agents.created.length >= 5, "agents installed");
  assert.ok(summary.commands.created.length >= 3, "commands installed");
  assert.ok(summary.context.created.length > 5, "context installed");

  const skillMd = fs.readdirSync(path.join(target, ".opencode/skills"), { recursive: true }).find((f) => f.endsWith("SKILL.md"));
  assert.ok(skillMd, "a SKILL.md exists under .opencode/skills");
  assert.ok(fs.existsSync(path.join(target, ".opencode/agents/backend-developer.md")), "agent flattened with basename");
  assert.ok(fs.existsSync(path.join(target, ".opencode/commands/review.md")), "command installed");

  const cfg = JSON.parse(fs.readFileSync(path.join(target, "opencode.json"), "utf8"));
  assert.ok(cfg.skills.paths.includes(".opencode/skills"), "skills.paths registered");
  assert.ok(cfg.instructions.some((f) => f.startsWith(".opencode/context/")), "context instructions registered");
  assert.equal(cfg.$schema, "https://opencode.ai/config.json");
});

test("is idempotent and skips existing files without --force", async () => {
  await install({ target, source: KIT_SOURCE, only: ["commands"], force: false, dryRun: false, verbose: false });
  const before = fs.readdirSync(path.join(target, ".opencode/commands")).length;
  const { summary } = await install({ target, source: KIT_SOURCE, only: ["commands"], force: false, dryRun: false, verbose: false });
  assert.equal(summary.commands.skipped.length, before, "second run skips existing files");
  assert.equal(fs.readdirSync(path.join(target, ".opencode/commands")).length, before);
});

test("merges existing opencode.json without clobbering it", async () => {
  fs.writeFileSync(path.join(target, "opencode.json"), JSON.stringify({ model: "anthropic/claude-sonnet-4-6", skills: { paths: [".opencode/skills"] } }));
  await install({ target, source: KIT_SOURCE, only: ["commands"], force: false, dryRun: false, verbose: false });
  const cfg = JSON.parse(fs.readFileSync(path.join(target, "opencode.json"), "utf8"));
  assert.equal(cfg.model, "anthropic/claude-sonnet-4-6", "existing field preserved");
  assert.equal(cfg.skills.paths.filter((p) => p === ".opencode/skills").length, 1, "no duplicate skills path");
});

test("dry-run does not touch the filesystem", async () => {
  const { summary } = await install({ target, source: KIT_SOURCE, only: ["commands"], force: false, dryRun: true, verbose: false });
  assert.ok(summary.commands.created.length >= 3, "dry-run still reports work");
  assert.ok(!fs.existsSync(path.join(target, ".opencode")), "nothing created on dry-run");
  assert.ok(!fs.existsSync(path.join(target, "opencode.json")), "no config written on dry-run");
});
