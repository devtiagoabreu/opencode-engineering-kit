#!/usr/bin/env python3
"""AI-assisted asset review engine.

Scores assets against review heuristics (structure, metadata, quality gates)
and produces a structured report. If an LLM endpoint is configured via
environment variables, an AI-generated summary is included.

Usage:
  quality_review.py review --root <kit-root> [--asset <path>] [--output <file>]
"""
import argparse
import json
import os
import re
import sys
from pathlib import Path


def read_json(path):
    try:
        with open(path) as f:
            return json.load(f)
    except (OSError, json.JSONDecodeError):
        return None


def find_assets(root):
    root = Path(root)
    assets = []
    seen = set()
    for metadata in sorted(list(root.glob("assets/*/*/metadata.json"))
                           + list(root.glob("assets/*/*/*/metadata.json"))):
        if str(metadata) in seen:
            continue
        seen.add(str(metadata))
        parent = metadata.parent
        rel = parent.relative_to(root / "assets")
        asset_type = rel.parts[0].rstrip("s")
        if asset_type not in ("skill", "agent", "prompt", "template", "command"):
            continue
        assets.append({
            "name": parent.name,
            "type": asset_type,
            "dir": str(parent),
            "metadata": read_json(metadata),
        })
    return assets


def semver_valid(version):
    if not version:
        return False
    return bool(re.match(r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)"
                         r"(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$", version))


def content_file_for(asset_type, name, d):
    candidates = {
        "skill": ["SKILL.md"],
        "agent": [f"{name}.md"],
        "prompt": [f"{name}.md"],
        "template": [f"{name}.md"],
        "command": ["command.md"],
    }.get(asset_type, [])
    for c in candidates:
        p = Path(d) / c
        if p.exists():
            return p
    return None


def review_asset(asset):
    meta = asset.get("metadata") or {}
    name = asset["name"]
    asset_type = asset["type"]
    d = Path(asset["dir"])

    checks = []
    suggestions = []
    score = 0

    def check(ok, label, weight):
        nonlocal score
        if ok:
            score += weight
            checks.append({"label": label, "passed": True})
        else:
            checks.append({"label": label, "passed": False})
            return False
        return True

    content = content_file_for(asset_type, name, d)
    check(content is not None, "content file present", 15)
    if content is not None and content.stat().st_size < 200:
        suggestions.append("content file is very short (<200 bytes)")
        check(False, "content has substance", 10)
    else:
        check(content is not None and content.stat().st_size >= 200, "content has substance", 10)

    check("name" in meta, "metadata name present", 10)
    check(semver_valid(meta.get("version")), "metadata version is valid SemVer", 10)
    check(bool(meta.get("description")), "metadata description present", 10)
    check(bool(meta.get("category") or meta.get("tags")), "metadata category or tags present", 10)

    readme = d / "README.md"
    check(readme.exists(), "README present", 5)

    examples = d / "examples"
    has_examples = examples.is_dir() and any(examples.iterdir())
    check(has_examples, "examples present", 5)

    deps = meta.get("dependencies")
    if isinstance(deps, list):
        check(len(deps) >= 0, "dependencies declared (may be empty)", 5)
    else:
        check(False, "dependencies declared (may be empty)", 5)
        suggestions.append("metadata has no 'dependencies' key")

    if isinstance(deps, list) and deps:
        if meta.get("dependencies_resolved") is True:
            check(True, "dependencies resolved", 5)
        else:
            check(False, "dependencies resolved", 5)
            suggestions.append("run core/resolver/lock.sh to resolve dependencies")
    else:
        check(True, "dependencies resolved", 5)

    if not meta:
        suggestions.append("missing or invalid metadata.json")

    grade = "A"
    if score >= 90:
        grade = "A"
    elif score >= 75:
        grade = "B"
    elif score >= 50:
        grade = "C"
    else:
        grade = "D"

    return {
        "name": name,
        "type": asset_type,
        "path": asset["dir"],
        "score": score,
        "grade": grade,
        "checks": checks,
        "suggestions": suggestions,
    }


def ai_summary(report):
    endpoint = os.environ.get("OPENCODE_AI_ENDPOINT")
    key = os.environ.get("OPENCODE_AI_API_KEY")
    if not endpoint or not key:
        return None
    try:
        import urllib.request
        payload = json.dumps({
            "model": os.environ.get("OPENCODE_AI_MODEL", "default"),
            "messages": [{
                "role": "user",
                "content": (
                    "Summarize the quality of these engineering-kit assets in 3 sentences. "
                    + json.dumps(report)
                ),
            }],
        }).encode()
        req = urllib.request.Request(
            endpoint,
            data=payload,
            headers={"Content-Type": "application/json", "Authorization": f"Bearer {key}"},
        )
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.loads(resp.read().decode())
        return data.get("choices", [{}])[0].get("message", {}).get("content")
    except Exception as exc:  # noqa: BLE001
        return f"AI summary unavailable: {exc}"


def main():
    parser = argparse.ArgumentParser(description="AI-assisted asset review")
    parser.add_argument("--root", required=True)
    parser.add_argument("--asset", default=None)
    parser.add_argument("--output", default=None)
    parser.add_argument("--json", action="store_true", help="print raw JSON report")
    args = parser.parse_args()

    assets = find_assets(args.root)
    if args.asset:
        target = str(Path(args.asset)).rstrip("/")
        assets = [a for a in assets if a["dir"].rstrip("/") == target
                  or a["name"] == Path(args.asset).name]
    if not assets:
        print(f"error: no assets found for review", file=sys.stderr)
        return 1

    reviews = [review_asset(a) for a in assets]
    total = sum(r["score"] for r in reviews)
    overall = round(total / len(reviews), 1) if reviews else 0

    report = {
        "generated_at": "review",
        "assets_reviewed": len(reviews),
        "overall_score": overall,
        "overall_grade": ("A" if overall >= 90 else "B" if overall >= 75
                          else "C" if overall >= 50 else "D"),
        "reviews": sorted(reviews, key=lambda r: r["score"]),
    }
    report["ai_summary"] = ai_summary(report)

    if args.output:
        out = Path(args.output)
        out.parent.mkdir(parents=True, exist_ok=True)
        with open(out, "w") as f:
            json.dump(report, f, indent=2)
            f.write("\n")

    if args.json:
        print(json.dumps(report, indent=2))
        return 0

    print("=" * 50)
    print(f"AI-ASSISTED REVIEW — {report['assets_reviewed']} assets")
    print(f"Overall score: {overall}/100 (grade {report['overall_grade']})")
    print("=" * 50)
    for r in report["reviews"]:
        print(f"\n{r['name']} ({r['type']}) — {r['score']}/100 [{r['grade']}]")
        for check in r["checks"]:
            mark = "✓" if check["passed"] else "✗"
            print(f"  {mark} {check['label']}")
        for s in r["suggestions"]:
            print(f"  ! {s}")
    if report.get("ai_summary"):
        print("\n--- AI Summary ---")
        print(report["ai_summary"])
    return 0


if __name__ == "__main__":
    sys.exit(main())
