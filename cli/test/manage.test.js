import { test, beforeEach, afterEach } from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import os from "node:os";
import { fileURLToPath } from "node:url";
import { install, globalConfigDir, normalizeRepo } from "../src/install.js";
import { status, startStop, detectScopes } from "../src/manage.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const KIT_SOURCE = path.resolve(__dirname, "..", "..");

let tmp;
let target;
let cwd;
let globalDir;
let origGlobalDir;

beforeEach(() => {
  tmp = fs.mkdtempSync(path.join(os.tmpdir(), "oek-manage-test-"));
  target = path.join(tmp, "my-app");
  fs.mkdirSync(target);
  fs.mkdirSync(path.join(target, ".git"));
  globalDir = path.join(tmp, "global-config");
  origGlobalDir = process.env.KIT_GLOBAL_DIR;
  process.env.KIT_GLOBAL_DIR = globalDir;
  cwd = process.cwd();
  process.chdir(target);
});

afterEach(() => {
  process.chdir(cwd);
  if (origGlobalDir === undefined) delete process.env.KIT_GLOBAL_DIR;
  else process.env.KIT_GLOBAL_DIR = origGlobalDir;
  fs.rmSync(tmp, { recursive: true, force: true });
});

test("normalizeRepo handles URL, SSH and owner/repo forms", () => {
  assert.equal(normalizeRepo("https://github.com/a/b"), "a/b");
  assert.equal(normalizeRepo("https://www.github.com/a/b.git"), "a/b");
  assert.equal(normalizeRepo("git@github.com:a/b.git"), "a/b");
  assert.equal(normalizeRepo("a/b"), "a/b");
});

test("global install writes absolute paths into the global config", async () => {
  const { cfg } = await install({ target, source: KIT_SOURCE, only: ["context", "skills"], force: true, dryRun: false, verbose: false, global: true });

  assert.ok(cfg.skills.paths.includes(path.join(globalDir, "skills")), "global skills path registered");
  assert.ok(cfg.instructions.some((f) => f.startsWith(path.join(globalDir, "context"))), "global context instructions registered");
  assert.ok(fs.existsSync(path.join(globalDir, "skills")), "skills copied to global dir");
  assert.ok(fs.existsSync(path.join(globalConfigDir(), "opencode.json")), "global opencode.json written");
});

test("status reports enabled after install and disabled after stop", async () => {
  await install({ target, source: KIT_SOURCE, only: ["context"], force: true, dryRun: false, verbose: false, global: true });

  const before = status({ json: true });
  const globalBefore = before.scopes.find((s) => s.label === "global");
  assert.equal(globalBefore.installed, true);
  assert.equal(globalBefore.enabled, true);

  startStop("stop", {});
  const after = status({ json: true });
  const globalAfter = after.scopes.find((s) => s.label === "global");
  assert.equal(globalAfter.installed, true, "stop keeps files installed");
  assert.equal(globalAfter.enabled, false, "stop removes wiring");

  startStop("start", {});
  const started = status({ json: true });
  const globalStarted = started.scopes.find((s) => s.label === "global");
  assert.equal(globalStarted.enabled, true, "start restores wiring");
});

test("stop/start only touch scopes that are installed", async () => {
  const result = startStop("stop", {});
  assert.equal(result.handled.length, 0, "nothing to stop when not installed");
});
