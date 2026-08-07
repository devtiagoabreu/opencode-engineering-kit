#!/usr/bin/env python3
"""Quality dashboard generator for the OpenCode Engineering Kit.

Aggregates asset statistics, metadata coverage, dependency resolution,
versioning, test results, and AI review scores into a JSON + HTML report.

Usage:
  quality_dashboard.py --root <kit-root> [--output <file.json>] [--html <file.html>]
"""
import argparse
import json
import subprocess
import sys
from pathlib import Path


def read_json(path):
    try:
        with open(path) as f:
            return json.load(f)
    except (OSError, json.JSONDecodeError):
        return None


def collect_assets(root):
    root = Path(root)
    assets = []
    for metadata in sorted(list(root.glob("assets/*/*/metadata.json"))
                           + list(root.glob("assets/*/*/*/metadata.json"))):
        parent = metadata.parent
        rel = parent.relative_to(root / "assets")
        asset_type = rel.parts[0].rstrip("s")
        if asset_type not in ("skill", "agent", "prompt", "template", "command"):
            continue
        meta = read_json(metadata) or {}
        assets.append({
            "name": parent.name,
            "type": asset_type,
            "category": rel.parts[1] if len(rel.parts) > 1 else "",
            "path": str(parent),
            "version": meta.get("version", "?"),
            "has_description": bool(meta.get("description")),
            "has_name": "name" in meta,
            "has_tags": bool(meta.get("tags")),
            "deps": meta.get("dependencies", []),
            "deps_resolved": meta.get("dependencies_resolved", False),
        })
    return assets


def run_tests(root):
    try:
        proc = subprocess.run(
            ["bash", "scripts/test.sh"], cwd=root,
            capture_output=True, text=True, timeout=600)
        output = proc.stdout
        line = [l for l in output.splitlines() if "Test Results:" in l]
        return {"exit_code": proc.returncode, "summary": line[0].strip() if line else "?"}
    except Exception as exc:  # noqa: BLE001
        return {"exit_code": -1, "summary": str(exc)}


def main():
    parser = argparse.ArgumentParser(description="Quality dashboard generator")
    parser.add_argument("--root", required=True)
    parser.add_argument("--output", default=None)
    parser.add_argument("--html", default=None)
    parser.add_argument("--with-tests", action="store_true",
                        help="run the full test suite and include results")
    args = parser.parse_args()

    root = Path(args.root)
    assets = collect_assets(root)

    by_type = {}
    by_category = {}
    meta_complete = 0
    deps_resolved = 0
    versions = {}
    for a in assets:
        by_type[a["type"]] = by_type.get(a["type"], 0) + 1
        if a["category"]:
            key = f"{a['type']}/{a['category']}"
            by_category[key] = by_category.get(key, 0) + 1
        if a["has_name"] and a["version"] != "?" and a["has_description"]:
            meta_complete += 1
        if a["deps_resolved"]:
            deps_resolved += 1
        versions[a["version"]] = versions.get(a["version"], 0) + 1

    tests = run_tests(root) if args.with_tests else {"exit_code": None, "summary": "skipped (use --with-tests)"}

    review_scores = []
    try:
        proc = subprocess.run(
            ["python3", "scripts/quality_review.py", "--root", str(root), "--json"],
            capture_output=True, text=True, timeout=300)
        if proc.returncode == 0:
            review = json.loads(proc.stdout)
            review_scores = review.get("reviews", [])
    except Exception:  # noqa: BLE001
        review_scores = []

    n = len(assets)
    report = {
        "generated_at": "dashboard",
        "asset_count": n,
        "by_type": by_type,
        "by_category": by_category,
        "metadata_completeness": round(100 * meta_complete / n, 1) if n else 0,
        "dependencies_resolved": f"{deps_resolved}/{n}" if n else "0/0",
        "version_distribution": versions,
        "tests": tests,
        "ai_review": {
            "average_score": round(
                sum(r["score"] for r in review_scores) / len(review_scores), 1)
                if review_scores else None,
            "asset_count": len(review_scores),
        },
        "lowest_scoring": sorted(review_scores, key=lambda r: r["score"])[:5],
    }

    if args.output:
        out = Path(args.output)
        out.parent.mkdir(parents=True, exist_ok=True)
        with open(out, "w") as f:
            json.dump(report, f, indent=2)
            f.write("\n")

    if args.html:
        html = render_html(report)
        out = Path(args.html)
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(html)

    print(json.dumps(report, indent=2))
    return 0


def render_html(report):
    by_type_rows = "".join(
        f"<tr><td>{k}</td><td>{v}</td></tr>"
        for k, v in sorted(report["by_type"].items()))
    cat_rows = "".join(
        f"<tr><td>{k}</td><td>{v}</td></tr>"
        for k, v in sorted(report["by_category"].items()))
    version_rows = "".join(
        f"<tr><td>{k}</td><td>{v}</td></tr>"
        for k, v in sorted(report["version_distribution"].items()))
    low_rows = "".join(
        f"<tr><td>{r['name']}</td><td>{r['type']}</td><td>{r['score']}</td><td>{r['grade']}</td></tr>"
        for r in report.get("lowest_scoring", []))
    ai = report.get("ai_review", {})
    ai_score = f"{ai.get('average_score')}/100" if ai.get("average_score") is not None else "n/a"
    tests = report.get("tests", {})

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Engineering Kit — Quality Dashboard</title>
<style>
  body {{ font-family: system-ui, sans-serif; margin: 2rem; color: #222; }}
  h1 {{ border-bottom: 3px solid #2563eb; padding-bottom: .5rem; }}
  table {{ border-collapse: collapse; margin: 1rem 0; min-width: 30rem; }}
  th, td {{ border: 1px solid #ddd; padding: .4rem .7rem; text-align: left; }}
  th {{ background: #eff6ff; }}
  .card {{ background: #f9fafb; border: 1px solid #e5e7eb; border-radius: 8px;
          padding: 1rem; margin: 1rem 0; display: inline-block; min-width: 14rem; }}
  .ok {{ color: #16a34a; font-weight: 600; }}
  .warn {{ color: #d97706; font-weight: 600; }}
</style>
</head>
<body>
<h1>OpenCode Engineering Kit — Quality Dashboard</h1>
<div class="card"><strong>Assets:</strong> {report['asset_count']}</div>
<div class="card"><strong>Metadata completeness:</strong> {report['metadata_completeness']}%</div>
<div class="card"><strong>Dependencies resolved:</strong> {report['dependencies_resolved']}</div>
<div class="card"><strong>AI review average:</strong> {ai_score}</div>
<div class="card"><strong>Tests:</strong> <span class="{ 'ok' if tests.get('exit_code') == 0 else 'warn' }">{tests.get('summary', 'n/a')}</span></div>

<h2>Assets by type</h2>
<table><tr><th>Type</th><th>Count</th></tr>{by_type_rows}</table>

<h2>Assets by category</h2>
<table><tr><th>Category</th><th>Count</th></tr>{cat_rows}</table>

<h2>Version distribution</h2>
<table><tr><th>Version</th><th>Count</th></tr>{version_rows}</table>

<h2>Lowest-scoring assets (AI review)</h2>
<table><tr><th>Name</th><th>Type</th><th>Score</th><th>Grade</th></tr>{low_rows}</table>
</body>
</html>
"""


if __name__ == "__main__":
    sys.exit(main())
