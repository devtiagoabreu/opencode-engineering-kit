#!/bin/bash
set -euo pipefail

# Tests for the machine-readable asset quality policy consumed by
# scripts/validate_assets.py. Uses isolated fixture repos so policy failures
# cannot be masked by the real asset catalog.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "=== Testing Asset Quality Policy ==="

python3 - "$ROOT_DIR" << 'PYEOF'
import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

repo = Path(sys.argv[1])
validator = repo / "scripts" / "validate_assets.py"
failures = []


def check(label, condition, detail=""):
    if condition:
        print(f"  PASS {label}")
    else:
        print(f"  FAIL {label}: {detail}")
        failures.append(label)


def make_repo(tmp, mutate_policy=None):
    root = Path(tmp)
    for sub in ("core/registry/schema", "core/registry/policy", "assets/skills"):
        (root / sub).mkdir(parents=True, exist_ok=True)
    for kind in ("skill", "agent", "prompt", "template", "command"):
        shutil.copy(
            repo / "core/registry/schema" / f"{kind}.schema.json",
            root / "core/registry/schema" / f"{kind}.schema.json",
        )
    policy_path = root / "core/registry/policy/asset-policy.json"
    shutil.copy(repo / "core/registry/policy/asset-policy.json", policy_path)
    if mutate_policy:
        policy = json.loads(policy_path.read_text(encoding="utf-8"))
        mutate_policy(policy)
        policy_path.write_text(json.dumps(policy, indent=2), encoding="utf-8")
    return root


def add_asset(root, name="demo", category="quality", maturity="beta", links=(), provenance=True, subdir=None):
    path = root / "assets/skills" / (subdir or name) / "SKILL.md"
    path.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "---",
        f"name: {name}",
        "description: A minimal fixture asset for policy validation",
        f"category: {category}",
        "version: 0.1.0",
        "author: fixture",
        "compatible: [opencode]",
    ]
    if maturity is not None:
        lines.append(f"maturity: {maturity}")
    if provenance:
        lines += [
            "provenance:",
            "  source: Fixture",
            "  verified: 2026-01-01",
        ]
    lines += ["---", "", "# Fixture", ""]
    lines += [f"- [reference]({target})" for target in links]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return path


def run(root, *flags):
    result = subprocess.run(
        [sys.executable, str(validator), "--root", str(root), "--check-links", *flags],
        capture_output=True,
        text=True,
    )
    try:
        report = json.loads(result.stdout)
    except Exception:
        report = {}
    return result.returncode, report, result.stdout + result.stderr


with tempfile.TemporaryDirectory(prefix="ocekit-policy-test-") as tmp:
    # Baseline: explicit maturity and valid provenance pass strict policy.
    root = make_repo(Path(tmp) / "baseline")
    add_asset(root)
    code, report, output = run(root, "--strict-policy", "--json")
    check("baseline passes strict policy", code == 0 and report.get("ok") is True, output)

    # Undeclared aspirational links are errors, even under docs/architecture/.
    root = make_repo(Path(tmp) / "undeclared")
    add_asset(root, links=["docs/architecture/999-missing.md"])
    code, report, output = run(root, "--json")
    check(
        "undeclared architecture link is an error",
        code == 1 and any("broken link" in e for e in report.get("errors", [])),
        output,
    )

    # Allowlisted aspirational references warn but do not fail CI.
    root = make_repo(Path(tmp) / "allowlisted")
    add_asset(
        root,
        name="plugin-system",
        category="architecture",
        subdir="architecture/plugin-system",
        links=["docs/architecture/003-plugin-system.md"],
    )
    code, report, output = run(root, "--strict-policy", "--json")
    check(
        "allowlisted aspirational link is a non-blocking warning",
        code == 0
        and report.get("policy", {}).get("aspirational_links_used") == 1
        and any("aspirational link allowed by policy" in w for w in report.get("warnings", [])),
        output,
    )
    consumed = "assets/skills/architecture/plugin-system/SKILL.md -> docs/architecture/003-plugin-system.md"
    check(
        "consumed allowlist entries are not reported as stale",
        not any("unused aspirational" in w and consumed in w for w in report.get("warnings", [])),
        output,
    )

    # Missing or invalid maturity fails schema validation.
    root = make_repo(Path(tmp) / "no-maturity")
    add_asset(root, maturity=None)
    code, report, output = run(root, "--json")
    check(
        "missing maturity is rejected",
        code == 1 and any("maturity" in e for e in report.get("errors", [])),
        output,
    )

    root = make_repo(Path(tmp) / "bad-maturity")
    add_asset(root, maturity="production-ready")
    code, report, output = run(root, "--json")
    check(
        "invalid maturity value is rejected",
        code == 1 and any("maturity" in e for e in report.get("errors", [])),
        output,
    )

    # Provenance warnings are promoted only in strict mode.
    root = make_repo(Path(tmp) / "no-provenance")
    add_asset(root, provenance=False)
    code, report, output = run(root, "--json")
    check(
        "missing provenance warns by default",
        code == 0 and any("missing provenance metadata" in w for w in report.get("warnings", [])),
        output,
    )
    code, report, output = run(root, "--strict-provenance", "--json")
    check(
        "missing provenance fails in strict mode",
        code == 1 and any("missing provenance metadata" in e for e in report.get("errors", [])),
        output,
    )

    # Policy/schema drift and malformed allowlist entries are hard errors.
    root = make_repo(
        Path(tmp) / "policy-drift",
        mutate_policy=lambda p: p["maturity"].__setitem__("allowed", ["stable"]),
    )
    add_asset(root, maturity="stable")
    code, report, output = run(root, "--json")
    check(
        "policy/schema enum drift is rejected",
        code == 1 and any("differs from" in e for e in report.get("errors", [])),
        output,
    )

    def duplicate_entry(policy):
        entry = policy["links"]["aspirational"][0]
        policy["links"]["aspirational"].append(dict(entry))

    root = make_repo(Path(tmp) / "duplicate-entry", mutate_policy=duplicate_entry)
    add_asset(root)
    code, report, output = run(root, "--json")
    check(
        "duplicate allowlist entry is rejected",
        code == 1 and any("duplicate aspirational entry" in e for e in report.get("errors", [])),
        output,
    )

if failures:
    print(f"{len(failures)} policy test(s) failed")
    sys.exit(1)
print("All asset policy tests passed")
PYEOF
