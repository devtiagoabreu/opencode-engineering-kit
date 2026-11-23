#!/usr/bin/env python3
"""Validate kit assets: frontmatter, schema, duplicates, encoding, manifest drift.

Usage:
  python scripts/validate_assets.py --root .
  python scripts/validate_assets.py --root . --check-manifest --check-links
  python scripts/validate_assets.py --root . --check-links --strict-policy

Policy: core/registry/policy/asset-policy.json (see docs/QUALITY_POLICY.md).
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
POLICY_REL = "core/registry/policy/asset-policy.json"

def load_json(p: Path):
    return json.loads(p.read_text(encoding="utf-8"))

def load_policy(root: Path, errors):
    """Load and sanity-check the machine-readable asset policy."""
    p = root / POLICY_REL
    try:
        policy = load_json(p)
    except Exception as e:
        errors.append(f"{POLICY_REL}: unreadable policy: {e}")
        return {}
    if policy.get("schema_version") != 1:
        errors.append(f"{POLICY_REL}: unsupported schema_version {policy.get('schema_version')!r} (expected 1)")
    maturity = policy.get("maturity") or {}
    allowed = maturity.get("allowed") or []
    if not isinstance(allowed, list) or not allowed:
        errors.append(f"{POLICY_REL}: maturity.allowed must be a non-empty list")
    if maturity.get("default") not in allowed:
        errors.append(f"{POLICY_REL}: maturity.default must be one of {allowed}")
    prov = policy.get("provenance") or {}
    if not isinstance(prov.get("required_for", []), list):
        errors.append(f"{POLICY_REL}: provenance.required_for must be a list")
    links = (policy.get("links") or {}).get("aspirational") or []
    if not isinstance(links, list):
        errors.append(f"{POLICY_REL}: links.aspirational must be a list")
    else:
        seen = set()
        for entry in links:
            if not isinstance(entry, dict) or not entry.get("path") or not entry.get("target") or not entry.get("reason"):
                errors.append(f"{POLICY_REL}: aspirational entry needs path, target and reason: {entry!r}")
                continue
            key = (entry["path"], entry["target"])
            if key in seen:
                errors.append(f"{POLICY_REL}: duplicate aspirational entry: {key}")
            seen.add(key)
    return policy

def validate_policy_schemas(policy: dict, schemas: dict, errors):
    """Keep the policy enum in sync with the JSON Schemas."""
    allowed = set((policy.get("maturity") or {}).get("allowed") or [])
    for kind, schema in schemas.items():
        prop = ((schema.get("properties") or {}).get("maturity") or {})
        enum = set(prop.get("enum") or [])
        if allowed and enum and allowed != enum:
            errors.append(f"{POLICY_REL}: maturity.allowed {sorted(allowed)} differs from {kind} schema enum {sorted(enum)}")

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

LINK_RE = re.compile(r"\[[^\]]+\]\(([^)]+)\)")

def check_links(text: str, path: Path, root: Path, policy: dict, errors, warnings, used_allowlist):
    allowed = {}
    for entry in (policy.get("links") or {}).get("aspirational") or []:
        if isinstance(entry, dict) and entry.get("path") and entry.get("target"):
            allowed[(entry["path"], entry["target"])] = entry
    for m in LINK_RE.finditer(text):
        target = m.group(1).strip()
        if not target or target.startswith(('http://','https://','mailto:','#','data:')):
            continue
        target = target.split('#',1)[0]
        if not target:
            continue
        # ignore templated/example links
        if '{{' in target or '}}' in target or '<' in target or '>' in target:
            continue
        rel = path.relative_to(root).as_posix()
        p = (path.parent / target).resolve()
        if not p.exists():
            p2 = (root / target.lstrip('/')).resolve()
            if p2.exists():
                continue
        if p.exists():
            continue
        key = (rel, target)
        if key in allowed:
            entry = allowed[key]
            used_allowlist.add(key)
            review_by = entry.get("review_by") or "unset"
            warnings.append(f"{rel}: aspirational link allowed by policy: {target} (review_by {review_by})")
        else:
            errors.append(f"{rel}: broken link: {target}")


def check_provenance(fm: dict, rel: str, kind: str, policy: dict, errors, warnings):
    prov_cfg = policy.get("provenance") or {}
    if kind not in (prov_cfg.get("required_for") or []):
        return
    prov = fm.get('provenance')
    if prov is None:
        warnings.append(f"{rel}: missing provenance metadata")
        return
    if not isinstance(prov, dict):
        errors.append(f"{rel}: provenance must be a mapping")
        return
    if prov_cfg.get("require_source") and not prov.get('source'):
        warnings.append(f"{rel}: provenance.source missing")
    verified = prov.get('verified')
    if verified and not re.match(r"^\d{4}-\d{2}-\d{2}$", str(verified)):
        warnings.append(f"{rel}: provenance.verified should be YYYY-MM-DD")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=str(ROOT_DEFAULT))
    ap.add_argument("--check-manifest", action="store_true")
    ap.add_argument("--check-links", action="store_true", help="validate relative markdown links in assets using the asset policy allowlist")
    ap.add_argument("--strict-policy", action="store_true", help="promote provenance/maturity policy warnings to errors")
    ap.add_argument("--strict-provenance", action="store_true", help="legacy flag: promote only provenance warnings to errors")
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
    policy = load_policy(root, errors)
    validate_policy_schemas(policy, schemas, errors)
    assets = collect(root)
    seen_names = {}
    seen_hashes = {}
    used_allowlist = set()
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
            norm = re.sub(r"\s+", " ", text.strip()).lower()
            h = __import__("hashlib").sha256(norm.encode("utf-8")).hexdigest()
            if h in seen_hashes and seen_hashes[h] != rel:
                warnings.append(f"{rel}: identical normalized content as {seen_hashes[h]}")
            else:
                seen_hashes[h] = rel
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
            check_provenance(fm, rel, kind, policy, errors, warnings)
            if args.check_links and p.suffix.lower() == '.md':
                check_links(text, p, root, policy, errors, warnings, used_allowlist)
    if args.check_links:
        aspirational = (policy.get("links") or {}).get("aspirational") or []
        for entry in aspirational:
            if not isinstance(entry, dict) or not entry.get("path") or not entry.get("target"):
                continue
            key = (entry["path"], entry["target"])
            if key not in used_allowlist:
                warnings.append(f"{POLICY_REL}: unused aspirational link entry: {key[0]} -> {key[1]}")
    if args.strict_policy or args.strict_provenance:
        markers = ('provenance', 'maturity') if args.strict_policy else ('provenance',)
        promote = [w for w in warnings if any(marker in w for marker in markers)]
        for w in promote:
            errors.append(f"{w} (strict policy)")
        warnings = [w for w in warnings if w not in promote]
    if args.check_manifest:
        check_manifest(root, errors, warnings)

    report = {
        "ok": len(errors)==0,
        "counts": {k:len(v) for k,v in assets.items()},
        "policy": {
            "schema_version": policy.get("schema_version"),
            "maturity_default": (policy.get("maturity") or {}).get("default"),
            "aspirational_links_used": len(used_allowlist),
        },
        "errors": errors,
        "warnings": warnings,
    }
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
