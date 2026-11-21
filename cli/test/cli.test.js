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
  assert.ok(checks.length >= 5, "at least 5 checks");
  assert.ok(checks.every((c) => c.pass), "all structural checks pass");
  assert.ok(checks.some((c) => c.name === "asset schema/manifest validation"), "asset validation check present");
});

test("doctor checks target wiring when installed", () => {
  fs.mkdirSync(path.join(target, ".opencode", "skills"), { recursive: true });
  fs.mkdirSync(path.join(target, ".opencode", "context"), { recursive: true });
  fs.writeFileSync(path.join(target, "opencode.json"), JSON.stringify({
    skills: { paths: [".opencode/skills"] },
    instructions: [".opencode/context/base.md"]
  }, null, 2));
  fs.writeFileSync(path.join(target, ".opencode/.kit-install.json"), JSON.stringify({ schema: 1, kit: { profile: "core" } }));
  const checks = doctor(KIT_SOURCE, { fast: true, target });
  assert.ok(checks.some((c) => c.name === "project skills.paths wired" && c.pass));
  assert.ok(checks.some((c) => c.name === "project context instructions wired" && c.pass));
  assert.ok(checks.some((c) => c.name === "project install manifest valid" && c.pass));
});

test("doctor reports missing target wiring", () => {
  fs.mkdirSync(path.join(target, ".opencode", "skills"), { recursive: true });
  fs.mkdirSync(path.join(target, ".opencode", "context"), { recursive: true });
  fs.writeFileSync(path.join(target, "opencode.json"), JSON.stringify({ skills: { paths: [] }, instructions: [] }, null, 2));
  const checks = doctor(KIT_SOURCE, { fast: true, target });
  assert.ok(checks.some((c) => c.name === "project skills.paths wired" && !c.pass));
  assert.ok(checks.some((c) => c.name === "project context instructions wired" && !c.pass));
  assert.ok(checks.some((c) => c.name === "project install manifest present" && !c.pass));
});

test("doctor reports drifted and extra installed files", async () => {
  fs.mkdirSync(path.join(target, ".opencode", "skills", "demo"), { recursive: true });
  fs.mkdirSync(path.join(target, ".opencode", "context"), { recursive: true });
  fs.writeFileSync(path.join(target, ".opencode/skills/demo/SKILL.md"), "old");
  fs.writeFileSync(path.join(target, ".opencode/skills/demo/EXTRA.md"), "extra");
  fs.writeFileSync(path.join(target, ".opencode/context/base.md"), "ctx");
  fs.writeFileSync(path.join(target, "opencode.json"), JSON.stringify({ skills: { paths: [".opencode/skills"] }, instructions: [".opencode/context/base.md"] }, null, 2));
  const crypto = await import("node:crypto");
  const sha = (s) => crypto.createHash("sha256").update(s).digest("hex");
  fs.writeFileSync(path.join(target, ".opencode/.kit-install.json"), JSON.stringify({
    schema: 2,
    kit: { profile: "core" },
    files: {
      skills: [{ path: "demo/SKILL.md", sha256: sha("new") }],
      context: [{ path: "base.md", sha256: sha("ctx") }]
    }
  }, null, 2));
  const checks = doctor(KIT_SOURCE, { fast: true, target });
  const drift = checks.find((c) => c.name === "project install drift");
  assert.ok(drift && !drift.pass);
  assert.match(drift.detail, /modified/);
  assert.match(drift.detail, /extra/);
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
