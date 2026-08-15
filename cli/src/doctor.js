import fs from "node:fs";
import path from "node:path";
import { findKitRoot, countSkills, countAgents, run } from "./kit-utils.js";

export const HELP = `
OpenCode Engineering Kit CLI - doctor

Checks the integrity of a kit checkout: schema, indexes, dependency
resolution, security scan and test suite.

Usage:
  opencode-engineering-kit doctor [options]

Options:
  --dir <dir>     Kit checkout directory (default: current directory)
  --fast          Skip the full test suite (only structural checks)
  --json          Output as JSON
  --help          Show this help
`;

export function parseArgs(argv) {
  const args = { dir: process.cwd(), json: false, fast: false, help: false };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    switch (a) {
      case "--dir": args.dir = argv[++i]; break;
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

function indexFreshness(kitRoot) {
  const indexFile = path.join(kitRoot, "core/discovery/index/skills.txt");
  const actual = countSkills(kitRoot);
  if (!fs.existsSync(indexFile)) return { pass: false, actual, indexed: 0 };
  const indexed = fs.readFileSync(indexFile, "utf8").trim().split("\n").filter(Boolean).length;
  return { pass: actual === indexed, actual, indexed };
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

export function doctor(kitRoot, { fast } = {}) {
  const checks = [];

  const schema = path.join(kitRoot, "core/registry/schema/skill.schema.json");
  checks.push(check("skill schema valid JSON", (() => {
    try { JSON.parse(fs.readFileSync(schema, "utf8")); return true; } catch { return false; }
  })(), "core/registry/schema/skill.schema.json"));

  const allow = path.join(kitRoot, "core/security/skill-scan.allow");
  checks.push(check("security allowlist present", fs.existsSync(allow), allow));

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

  const scan = run("bash", [path.join(kitRoot, "core/security/skill-scan.sh")]);
  checks.push(check("skill content security scan", scan.status === 0, scan.status === 0 ? "PASS" : "FAIL"));

  const vc = vaultConsistency(kitRoot);
  checks.push(check(
    "vault entries consistent",
    vc.pass,
    `${vc.pointers} pointer skills / ${vc.entries} vault entries${vc.broken ? `, ${vc.broken} broken` : ""}`
  ));

  if (!fast) {
    const tests = run("bash", [path.join(kitRoot, "scripts/test.sh")], { timeout: 300000 });
    const passed = /Test Results: (\d+) passed, (\d+) failed/.exec(tests.stdout);
    const ok = tests.status === 0 && passed && passed[2] === "0";
    checks.push(check("test suite", ok, ok && passed ? `${passed[1]} passed` : "failed"));
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
  const checks = doctor(kitRoot, { fast: args.fast });
  const failed = checks.filter((c) => !c.pass);

  if (args.json) {
    console.log(JSON.stringify({ kitRoot, passed: failed.length === 0, checks }, null, 2));
    return;
  }

  console.log(`OpenCode Engineering Kit doctor — ${kitRoot}`);
  console.log(`skills: ${countSkills(kitRoot)}, agents: ${countAgents(kitRoot)}\n`);
  for (const c of checks) {
    console.log(`  ${c.pass ? "✓" : "✗"} ${c.name} ${c.detail ? `(${c.detail})` : ""}`);
  }
  console.log(`\n${failed.length === 0 ? "all checks passed" : `${failed.length} check(s) failed`}`);
  if (failed.length > 0) process.exitCode = 1;
}
