#!/usr/bin/env python3
"""Validate kit assets: frontmatter, schema, duplicates, encoding, manifest drift.

Usage:
  python scripts/validate_assets.py --root .
  python scripts/validate_assets.py --root . --check-manifest
"""
from __future__ import annotations

import argparse, json, re, sys
from pathlib import Path

try:
    import yaml
except Exception as e:
    print(f"ERROR: PyYAML required: {e}", file=sys.stderr)
    sys.exit(2)
try:
    import jsonschema
except Exception as e:
    print(f"ERROR: jsonschema required: {e}", file=sys.stderr)
    sys.exit(2)

ROOT_DEFAULT = Path(__file__).resolve().parents[1]

def load_json(p: Path):
    return json.loads(p.read_text(encoding="utf-8"))

def read_text(p: Path):
    b = p.read_bytes()
    try:
        return b.decode("utf-8")
    except UnicodeDecodeError as e:
        raise ValueError(f"not UTF-8: {e}")

def parse_frontmatter(text: str, path: Path):
    if not text.startswith("---"):
        raise ValueError("missing YAML frontmatter opening ---")
    m = re.match(r"^---\r?\n(.*?)\r?\n---\r?\n?", text, re.DOTALL)
    if not m:
        raise ValueError("missing YAML frontmatter closing ---")
    raw = m.group(1)
    # Templates contain placeholders like {{name}} which YAML parses as flow mappings.
    # For templates, only validate presence of frontmatter; schema validation is skipped.
    if "{{" in raw:
        return {"__template__": True}
    data = yaml.safe_load(raw)
    if not isinstance(data, dict):
        raise ValueError("frontmatter is not a mapping")
    return data

def normalize_yaml_dates(obj):
    # jsonschema expects strings; YAML may parse dates
    import datetime
    if isinstance(obj, dict):
        return {k: normalize_yaml_dates(v) for k, v in obj.items()}
    if isinstance(obj, list):
        return [normalize_yaml_dates(v) for v in obj]
    if isinstance(obj, (datetime.date, datetime.datetime)):
        return obj.isoformat()
    return obj

def validate_schema(data, schema, path: Path, errors):
    try:
        jsonschema.validate(instance=data, schema=schema)
    except jsonschema.ValidationError as e:
        loc = "/".join(str(x) for x in e.path)
        errors.append(f"{path}: schema: {e.message}" + (f" at {loc}" if loc else ""))

def collect(root: Path):
    templates = []
    for d in sorted([p for p in (root / "assets/templates").glob("*") if p.is_dir()]):
        # Accept common template file names
        for name in ("template.md", "TEMPLATE.md", "SKILL.md", "agent.md", "prompt.md", "README.md"):
            p = d / name
            if p.exists():
                templates.append(p)
                break
    return {
        "skills": sorted(root.glob("assets/skills/**/SKILL.md")),
        "agents": sorted([p for p in root.glob("assets/agents/**/*.md") if p.name.lower() != "readme.md"]),
        "prompts": sorted([p for p in root.glob("assets/prompts/**/*.md") if p.name.lower() != "readme.md"]),
        "templates": templates,
        "commands": sorted([p for p in root.glob("assets/commands/*.md") if p.name.lower() != "readme.md"]),
    }

def expected_name(path: Path, kind: str):
    if kind == "skills":
        return path.parent.name
    if kind == "agents":
        return path.stem
    if kind == "prompts":
        return path.stem
    if kind == "templates":
        return path.parent.name
    if kind == "commands":
        return path.stem
    return path.stem

def check_manifest(root: Path, errors, warnings):
    mp = root / "core/registry/manifest.json"
    if not mp.exists():
        errors.append("core/registry/manifest.json: missing")
        return
    manifest = load_json(mp)
    counts = manifest.get("counts", {})
    actual = {
        "skills": len(list(root.glob("assets/skills/**/SKILL.md"))),
        "agents": len([p for p in root.glob("assets/agents/**/*.md") if p.name.lower() != "readme.md"]),
        "prompts": len([p for p in root.glob("assets/prompts/**/*.md") if p.name.lower() != "readme.md"]),
        "templates": len([p for p in root.glob("assets/templates/*") if p.is_dir()]),
        "commands": len([p for p in root.glob("assets/commands/*.md") if p.name.lower() != "readme.md"]),
        "context_files": len(list(root.glob("context/*.md"))),
    }
    for k, v in actual.items():
        if k not in counts:
            warnings.append(f"manifest.counts.{k}: missing (actual {v})")
        elif counts.get(k) != v:
            errors.append(f"manifest.counts.{k}: expected {v}, got {counts.get(k)}")

    # index freshness
    idx = root / "core/discovery/index/skills.txt"
    if idx.exists():
        lines = [l.strip() for l in idx.read_text(encoding="utf-8").splitlines() if l.strip()]
        if len(lines) != actual["skills"]:
            errors.append(f"core/discovery/index/skills.txt: {len(lines)} entries, expected {actual['skills']}")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=str(ROOT_DEFAULT))
    ap.add_argument("--check-manifest", action="store_true")
    ap.add_argument("--json", action="store_true")
    args = ap.parse_args()
    root = Path(args.root).resolve()
    errors=[]; warnings=[]
    schemas = {
        "skills": load_json(root/"core/registry/schema/skill.schema.json"),
        "agents": load_json(root/"core/registry/schema/agent.schema.json"),
        "prompts": load_json(root/"core/registry/schema/prompt.schema.json"),
        "templates": load_json(root/"core/registry/schema/template.schema.json"),
        "commands": load_json(root/"core/registry/schema/command.schema.json"),
    }
    assets = collect(root)
    seen_names = {}
    for kind, paths in assets.items():
        schema = schemas[kind]
        for p in paths:
            rel = p.relative_to(root).as_posix()
            try:
                text = read_text(p)
            except Exception as e:
                errors.append(f"{rel}: {e}")
                continue
            if "\ufffd" in text:
                errors.append(f"{rel}: contains Unicode replacement char (encoding damage)")
            if not text.startswith("---"):
                if rel.startswith("assets/templates/"):
                    warnings.append(f"{rel}: template without frontmatter, schema checks skipped")
                    continue
            try:
                fm = normalize_yaml_dates(parse_frontmatter(text, p))
            except Exception as e:
                errors.append(f"{rel}: frontmatter: {e}")
                continue
            if fm.get("__template__"):
                warnings.append(f"{rel}: template placeholder frontmatter, schema checks skipped")
                continue
            validate_schema(fm, schema, rel, errors)
            name = fm.get("name")
            exp = expected_name(p, kind)
            if name != exp:
                errors.append(f"{rel}: name '{name}' does not match expected '{exp}'")
            key = (kind, name)
            if key in seen_names:
                errors.append(f"{rel}: duplicate {kind} name '{name}' (also {seen_names[key]})")
            else:
                seen_names[key] = rel
            desc = fm.get("description","")
            if isinstance(desc,str) and len(desc.strip()) < 10:
                errors.append(f"{rel}: description too short")
    if args.check_manifest:
        check_manifest(root, errors, warnings)

    report = {"ok": len(errors)==0, "counts": {k:len(v) for k,v in assets.items()}, "errors": errors, "warnings": warnings}
    if args.json:
        print(json.dumps(report, indent=2, ensure_ascii=False))
    else:
        for w in warnings:
            print(f"WARN: {w}")
        if errors:
            print(f"\n{len(errors)} validation error(s):")
            for e in errors:
                print(f" - {e}")
        else:
            print(f"OK: validated assets {report['counts']}")
    return 0 if not errors else 1

if __name__ == "__main__":
    raise SystemExit(main())
