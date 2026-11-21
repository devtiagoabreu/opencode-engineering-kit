import fs from "node:fs";
import path from "node:path";
import os from "node:os";
import { spawnSync } from "node:child_process";
import { findKitRoot, countSkills, countAgents, run } from "./kit-utils.js";
import { globalConfigDir } from "./install.js";

export const HELP = `
OpenCode Engineering Kit CLI - doctor

Checks the integrity of a kit checkout: schema, indexes, dependency
resolution, security scan and test suite. Optionally checks an installed
project/global wiring.

Usage:
  opencode-engineering-kit doctor [options]

Options:
  --dir <dir>      Kit checkout directory (default: current directory)
  --target <dir>   Also check kit wiring in a target project
  --global         Also check kit wiring in global OpenCode config
  --fast           Skip the full test suite (only structural checks)
  --json           Output as JSON
  --help           Show this help
`;

export function parseArgs(argv) {
  const args = { dir: process.cwd(), json: false, fast: false, help: false, target: null, global: false };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    switch (a) {
      case "--dir": args.dir = argv[++i]; break;
      case "--target": args.target = argv[++i]; break;
      case "--global": args.global = true; break;
      case "--fast": args.fast = true; break;
      case "--json": args.json = true; break;
      case "--help": case "-h": args.help = true; break;
      default: throw new Error(`unknown option: ${a}\n${HELP}`);
    }
  }
  return args;
}

function check(name, pass, detail) {
  return { name, pass, detail };
}

function commandAvailable(cmd) {
  const probe = process.platform === "win32" ? "where" : "which";
  const r = spawnSync(probe, [cmd], { stdio: "ignore" });
  return r.status === 0;
}

function bashUsable() {
  if (!commandAvailable("bash")) return { ok: false, reason: "bash not found" };
  const probe = run("bash", ["-lc", "echo ok"], { timeout: 5000 });
  if (probe.status === 0) return { ok: true };
  const out = `${probe.stdout || ""}\n${probe.stderr || ""}`;
  if (/WSL|distribui/i.test(out)) return { ok: false, reason: "bash unavailable (WSL distro missing)" };
  return { ok: false, reason: "bash unavailable" };
}

function runPython(kitRoot, scriptRel, extraArgs = []) {
  const script = path.join(kitRoot, scriptRel);
  for (const cmd of ["python3", "python"]) {
    if (!commandAvailable(cmd)) continue;
    const r = run(cmd, [script, ...extraArgs], { cwd: kitRoot });
    if (r.error) continue;
    return { cmd, ...r, script };
  }
  return { cmd: null, status: 127, stdout: "", stderr: "python not found", script };
}

function indexFreshness(kitRoot) {
  const indexFile = path.join(kitRoot, "core/discovery/index/skills.txt");
  const actual = countSkills(kitRoot);
  if (!fs.existsSync(indexFile)) return { pass: false, actual, indexed: 0 };
  const indexed = fs.readFileSync(indexFile, "utf8").trim().split("\n").filter(Boolean).length;
  return { pass: actual === indexed, actual, indexed };
}

function wiringChecks(target, { global = false } = {}) {
  const root = global ? globalConfigDir() : path.resolve(target || process.cwd());
  const cfgPath = path.join(root, "opencode.json");
  const base = global ? root : path.join(root, ".opencode");
  const scope = global ? "global" : "project";
  const installed = global
    ? fs.existsSync(path.join(root, "skills")) || fs.existsSync(path.join(root, "context"))
    : fs.existsSync(path.join(root, ".opencode"));
  if (!installed) return [check(`${scope} install detected`, true, "not installed (skipped)")];

  const checks = [];
  const cfgExists = fs.existsSync(cfgPath);
  checks.push(check(`${scope} opencode.json exists`, cfgExists, cfgExists ? path.relative(process.cwd(), cfgPath) || cfgPath : cfgPath));
  let cfg = null;
  if (cfgExists) {
    try { cfg = JSON.parse(fs.readFileSync(cfgPath, "utf8")); checks.push(check(`${scope} opencode.json valid JSON`, true)); }
    catch (e) { checks.push(check(`${scope} opencode.json valid JSON`, false, `parse error: ${e.message}`)); }
  }

  const skillsPath = global ? path.join(root, "skills") : ".opencode/skills";
  const ctxPrefix = global ? path.join(root, "context") : ".opencode/context";
  const skillPaths = cfg?.skills?.paths ?? [];
  const instructions = cfg?.instructions ?? [];
  const hasSkills = skillPaths.includes(skillsPath);
  const kitCtx = instructions.filter((i) => String(i).startsWith(ctxPrefix));
  checks.push(check(`${scope} skills.paths wired`, hasSkills, hasSkills ? skillsPath : `missing ${skillsPath}; run install or start`));
  checks.push(check(`${scope} context instructions wired`, kitCtx.length > 0, kitCtx.length > 0 ? `${kitCtx.length} instruction(s)` : `missing ${ctxPrefix}/*; run install or start`));

  const dupSkills = skillPaths.filter((p, i) => skillPaths.indexOf(p) !== i);
  checks.push(check(`${scope} skills.paths no duplicates`, dupSkills.length === 0, dupSkills.length ? `duplicates: ${[...new Set(dupSkills)].join(", ")}` : "ok"));
  const dupInst = instructions.filter((p, i) => instructions.indexOf(p) !== i);
  checks.push(check(`${scope} instructions no duplicates`, dupInst.length === 0, dupInst.length ? `duplicates: ${[...new Set(dupInst)].slice(0,3).join(", ")}` : "ok"));

  const missingInst = kitCtx.filter((i) => !fs.existsSync(path.resolve(root, i)));
  checks.push(check(`${scope} context files exist`, missingInst.length === 0, missingInst.length ? `missing ${missingInst.length}: ${missingInst.slice(0,3).join(", ")}` : `${kitCtx.length} present`));

  const skillsDir = path.join(base, "skills");
  const ctxDir = path.join(base, "context");
  checks.push(check(`${scope} skills dir present`, fs.existsSync(skillsDir), fs.existsSync(skillsDir) ? skillsDir : `missing ${skillsDir}`));
  checks.push(check(`${scope} context dir present`, fs.existsSync(ctxDir), fs.existsSync(ctxDir) ? ctxDir : `missing ${ctxDir}`));

  if (fs.existsSync(skillsDir)) {
    const skillFiles = fs.readdirSync(skillsDir, { recursive: true }).filter((f) => String(f).replace(/\\/g, "/").endsWith("/SKILL.md") || String(f) === "SKILL.md");
    checks.push(check(`${scope} installed skills detected`, skillFiles.length > 0, `${skillFiles.length} SKILL.md file(s)`));
  }

  const manifestPath = path.join(base, ".kit-install.json");
  if (fs.existsSync(manifestPath)) {
    try {
      const m = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
      checks.push(check(`${scope} install manifest valid`, m && m.schema === 1, `profile=${m.kit?.profile || "none"}, repo=${m.kit?.repo || "?"}`));
    } catch (e) {
      checks.push(check(`${scope} install manifest valid`, false, `invalid JSON: ${e.message}`));
    }
  } else {
    checks.push(check(`${scope} install manifest present`, false, `missing ${manifestPath}; reinstall with current CLI to track drift`));
  }
  return checks;
}

function vaultConsistency(kitRoot) {
  const skillsDir = path.join(kitRoot, "assets/skills");
  const vaultDir = path.join(kitRoot, "assets/vault");
  let pointers = 0;
  let broken = 0;
  let entries = 0;
  const countVaultEntries = (d) => {
    if (!fs.existsSync(d)) return 0;
    let n = 0;
    for (const cat of fs.readdirSync(d)) {
      const catPath = path.join(d, cat);
      if (!fs.statSync(catPath).isDirectory()) continue;
      for (const skill of fs.readdirSync(catPath)) {
        if (fs.existsSync(path.join(catPath, skill, "content.md"))) n++;
      }
    }
    return n;
  };
  if (fs.existsSync(vaultDir)) {
    entries = countVaultEntries(vaultDir);
  }
  if (fs.existsSync(skillsDir)) {
    for (const cat of fs.readdirSync(skillsDir)) {
      const catPath = path.join(skillsDir, cat);
      if (!fs.statSync(catPath).isDirectory()) continue;
      for (const skill of fs.readdirSync(catPath)) {
        const skillMd = path.join(catPath, skill, "SKILL.md");
        if (!fs.existsSync(skillMd)) continue;
        const raw = fs.readFileSync(skillMd, "utf8");
        if (!/^pointer: true$/m.test(raw)) continue;
        pointers++;
        const vaultRel = (raw.match(/^vault: (.+)$/m) || [])[1];
        const vaultEntry = vaultRel && fs.existsSync(path.join(vaultDir, vaultRel, "content.md"));
        const meta = vaultRel && fs.existsSync(path.join(vaultDir, vaultRel, "meta.json"));
        if (!vaultEntry || !meta) broken++;
      }
    }
  }
  return { pass: broken === 0, pointers, entries, broken };
}

export function doctor(kitRoot, { fast, target = null, global = false } = {}) {
  const checks = [];

  const schema = path.join(kitRoot, "core/registry/schema/skill.schema.json");
  checks.push(check("skill schema valid JSON", (() => {
    try { JSON.parse(fs.readFileSync(schema, "utf8")); return true; } catch { return false; }
  })(), "core/registry/schema/skill.schema.json"));

  const allow = path.join(kitRoot, "core/security/skill-scan.allow");
  checks.push(check("security allowlist present", fs.existsSync(allow), path.relative(kitRoot, allow)));

  const fr = indexFreshness(kitRoot);
  checks.push(check(
    "discovery index up to date",
    fr.pass,
    `${fr.indexed} indexed / ${fr.actual} on disk`
  ));

  const lock = path.join(kitRoot, "core/resolver/lockfile.json");
  let unresolved = -1;
  if (fs.existsSync(lock)) {
    try {
      const data = JSON.parse(fs.readFileSync(lock, "utf8"));
      unresolved = Object.values(data.assets).filter((a) => a.resolved === false).length;
    } catch { unresolved = -1; }
  }
  checks.push(check("all dependencies resolved", unresolved === 0, unresolved < 0 ? "lockfile missing" : `${unresolved} unresolved`));

  const validation = runPython(kitRoot, "scripts/validate_assets.py", ["--root", ".", "--check-manifest"]);
  if (validation.cmd) {
    checks.push(check("asset schema/manifest validation", validation.status === 0, validation.status === 0 ? "PASS" : "FAIL"));
  } else {
    checks.push(check("asset schema/manifest validation", true, "skipped (python not found)"));
  }

  const scanScript = path.join(kitRoot, "core/security/skill-scan.sh");
  const bash = bashUsable();
  if (bash.ok) {
    const scan = run("bash", [scanScript]);
    checks.push(check("skill content security scan", scan.status === 0, scan.status === 0 ? "PASS" : "FAIL"));
  } else {
    checks.push(check("skill content security scan", true, `skipped (${bash.reason})`));
  }

  const vc = vaultConsistency(kitRoot);
  checks.push(check(
    "vault entries consistent",
    vc.pass,
    `${vc.pointers} pointer skills / ${vc.entries} vault entries${vc.broken ? `, ${vc.broken} broken` : ""}`
  ));

  if (target) checks.push(...wiringChecks(target, { global: false }));
  if (global) checks.push(...wiringChecks(null, { global: true }));

  if (!fast) {
    if (bash.ok) {
      const tests = run("bash", [path.join(kitRoot, "scripts/test.sh")], { timeout: 300000 });
      const passed = /Test Results: (\d+) passed, (\d+) failed/.exec(tests.stdout);
      const ok = tests.status === 0 && passed && passed[2] === "0";
      checks.push(check("test suite", ok, ok && passed ? `${passed[1]} passed` : "failed"));
    } else {
      checks.push(check("test suite", true, `skipped (${bash.reason})`));
    }
  }

  return checks;
}

export function main(argv) {
  const args = parseArgs(argv);
  if (args.help) {
    console.log(HELP);
    return;
  }
  const kitRoot = findKitRoot(args.dir);
  const checks = doctor(kitRoot, { fast: args.fast, target: args.target, global: args.global });
  const failed = checks.filter((c) => !c.pass);

  if (args.json) {
    console.log(JSON.stringify({ kitRoot, passed: failed.length === 0, failed: failed.length, checks }, null, 2));
    if (failed.length > 0) process.exitCode = 1;
    return;
  }

  console.log(`OpenCode Engineering Kit doctor - ${kitRoot}`);
  console.log(`skills: ${countSkills(kitRoot)}, agents: ${countAgents(kitRoot)}\n`);
  for (const c of checks) {
    console.log(`  ${c.pass ? "[PASS]" : "[FAIL]"} ${c.name}${c.detail ? ` - ${c.detail}` : ""}`);
  }
  if (failed.length > 0) {
    console.log("\nRecommended actions:");
    for (const f of failed) console.log(`  - ${f.name}: ${f.detail || "inspect and fix"}`);
  }
  console.log(`\n${failed.length === 0 ? "all checks passed" : `${failed.length} check(s) failed`}`);
  if (failed.length > 0) process.exitCode = 1;
}
