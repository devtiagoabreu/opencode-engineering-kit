import fs from "node:fs";
import path from "node:path";
import { spawnSync } from "node:child_process";

export function parseCommonArgs(argv) {
  const args = { dir: process.cwd(), json: false, help: false, _positional: [] };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    switch (a) {
      case "--dir": args.dir = argv[++i]; break;
      case "--json": args.json = true; break;
      case "--help": case "-h": args.help = true; break;
      default:
        if (a.startsWith("--") && !["--force"].includes(a)) {
          // tolerated in doctor/export; strict commands validate their own
        } else {
          args._positional.push(a);
        }
    }
  }
  return args;
}

export function findKitRoot(dir) {
  const resolved = path.resolve(dir);
  if (
    fs.existsSync(path.join(resolved, "assets/skills")) &&
    fs.existsSync(path.join(resolved, "core")) &&
    fs.existsSync(path.join(resolved, "context"))
  ) {
    return resolved;
  }
  throw new Error(`"${resolved}" is not a kit checkout (expected assets/, core/ and context/). Use --dir to point at the kit.`);
}

export function countSkills(kitRoot) {
  if (!fs.existsSync(path.join(kitRoot, "assets/skills"))) return 0;
  let count = 0;
  const walk = (d) => {
    for (const entry of fs.readdirSync(d, { withFileTypes: true })) {
      const p = path.join(d, entry.name);
      if (entry.isDirectory()) walk(p);
      else if (entry.name === "SKILL.md") count++;
    }
  };
  walk(path.join(kitRoot, "assets/skills"));
  return count;
}

export function countAgents(kitRoot) {
  if (!fs.existsSync(path.join(kitRoot, "assets/agents"))) return 0;
  return fs.readdirSync(path.join(kitRoot, "assets/agents"), { recursive: true })
    .filter((f) => f.endsWith(".md"))
    .length;
}

export function run(cmd, args, opts = {}) {
  return spawnSync(cmd, args, { encoding: "utf8", ...opts });
}
