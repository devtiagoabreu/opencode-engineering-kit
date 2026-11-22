#!/usr/bin/env python3
"""Sync README asset counts from core/registry/manifest.json.

Usage:
  python scripts/sync_readme_counts.py --root .          # write
  python scripts/sync_readme_counts.py --root . --check  # verify only
"""
from __future__ import annotations
import argparse, json, re, sys
from pathlib import Path

def load_manifest(root: Path):
    return json.loads((root/'core/registry/manifest.json').read_text(encoding='utf-8'))

def count_dirs(root: Path, p: str):
    d=root/p
    return len([x for x in d.iterdir() if x.is_dir()]) if d.exists() else 0

def replace_row(text: str, label: str, value: str):
    pat = re.compile(rf"(^\| {re.escape(label)} \| ).*?( \|$)", re.M)
    new, n = pat.subn(rf"\g<1>{value}\g<2>", text, count=1)
    return new, n

def sync_readme(path: Path, manifest: dict, check: bool):
    text = path.read_text(encoding='utf-8')
    orig = text
    c = manifest.get('counts', {})
    root = path.parent
    # dynamic counts
    skill_cats = count_dirs(root, 'assets/skills')
    agent_cats = count_dirs(root, 'assets/agents')
    replacements = {
        'Skills': f"{c.get('skills','?')} ({skill_cats} categorias)",
        'Agents': f"{c.get('agents','?')} ({agent_cats} categorias)",
        'Prompts': str(c.get('prompts','?')),
        'Templates': str(c.get('templates','?')),
        'Contexto': f"{c.get('context_files','?')} arquivos",
    }
    missing=[]
    for label, value in replacements.items():
        text, n = replace_row(text, label, value)
        if n == 0:
            missing.append(label)
    # Playbooks/Recipes/Commands/Bundles/Composi??es/Prompt chains/Plugins/Tests are less central; sync commands if present
    cmd_n, n = replace_row(text, 'Comandos', str(c.get('commands','?')))
    if n: text = cmd_n
    changed = text != orig
    if missing:
        return False, changed, f"missing rows in {path.name}: {', '.join(missing)}"
    if changed and not check:
        path.write_text(text, encoding='utf-8')
    return True, changed, ('updated' if changed and not check else ('out of date' if changed else 'ok'))

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--root', default='.')
    ap.add_argument('--check', action='store_true')
    args=ap.parse_args()
    root=Path(args.root).resolve()
    manifest=load_manifest(root)
    ok=True
    for name in ['README.md']:
        p=root/name
        if not p.exists():
            print(f'WARN: {name} missing'); continue
        rok, changed, msg = sync_readme(p, manifest, args.check)
        status='OK' if rok and not (args.check and changed) else ('FAIL' if (args.check and changed) or not rok else 'OK')
        if (args.check and changed) or not rok: ok=False
        print(f'{status}: {name}: {msg}')
    return 0 if ok else 1

if __name__=='__main__':
    raise SystemExit(main())
