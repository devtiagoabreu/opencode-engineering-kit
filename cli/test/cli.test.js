import { test, beforeEach, afterEach } from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import os from "node:os";
import { fileURLToPath } from "node:url";
import { collect } from "../src/list.js";
import { search } from "../src/search.js";
import { doctor } from "../src/doctor.js";
import { main as exportMain } from "../src/export.js";
import { main as cliMain } from "../src/cli.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const KIT_SOURCE = path.resolve(__dirname, "..", "..");

let tmp;
let target;
let cwd;

beforeEach(() => {
  tmp = fs.mkdtempSync(path.join(os.tmpdir(), "oek-cli-test-"));
  target = path.join(tmp, "my-app");
  fs.mkdirSync(target);
  cwd = process.cwd();
  process.chdir(target);
});

afterEach(() => {
  process.chdir(cwd);
  fs.rmSync(tmp, { recursive: true, force: true });
});

test("collect lists skills and agents from the kit", () => {
  const result = collect(KIT_SOURCE, null);
  assert.ok(result.skills.length > 100, "skills > 100");
  assert.ok(result.agents.length > 80, "agents > 80");
  assert.ok(result.skills.some((s) => s.name === "tdd"), "methodology skill present");
});

test("collect filters by type", () => {
  const skills = collect(KIT_SOURCE, "skills");
  assert.equal(Object.keys(skills).length, 1);
  assert.ok(skills.skills.length > 100);
});

test("search finds by name and description", () => {
  const byName = search(KIT_SOURCE, "tdd", null);
  assert.ok(byName.some((m) => m.name === "tdd"));

  const byDesc = search(KIT_SOURCE, "orquestrador", "agents");
  assert.ok(byDesc.length >= 1, "orquestrador found by description");
});

test("doctor reports a healthy kit", () => {
  const checks = doctor(KIT_SOURCE, { fast: true });
  assert.ok(checks.length >= 4, "at least 4 checks");
  assert.ok(checks.every((c) => c.pass), "all structural checks pass");
});

test("export claude writes SKILL.md files and claude-md writes CLAUDE.md", () => {
  const claude = exportMain(["claude", "--target", target, "--dir", KIT_SOURCE]);
  assert.ok(claude.files.length > 100, "many skill files exported");
  assert.ok(fs.existsSync(path.join(target, ".claude/skills/tdd/SKILL.md")), "tdd exported");

  const claudeMd = exportMain(["claude-md", "--target", target, "--dir", KIT_SOURCE]);
  assert.equal(claudeMd.files.length, 1);
  assert.ok(fs.existsSync(path.join(target, "CLAUDE.md")), "CLAUDE.md written");
});

test("cli dispatches unknown command to error", () => {
  assert.throws(() => cliMain(["nonsense"]), /unknown command/);
});

test("cli --version prints a semver", () => {
  const out = [];
  const orig = console.log;
  console.log = (x) => out.push(x);
  try {
    cliMain(["--version"]);
  } finally {
    console.log = orig;
  }
  assert.match(out.join(""), /^\d+\.\d+\.\d+/);
});
