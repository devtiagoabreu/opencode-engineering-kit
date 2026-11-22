#!/usr/bin/env python3
"""Fail if tracked text files are not UTF-8 or contain replacement chars."""
from __future__ import annotations
import subprocess, sys
from pathlib import Path

TEXT_EXT = {
    '.md','.json','.yml','.yaml','.js','.mjs','.cjs','.ts','.tsx','.py','.sh','.ps1','.txt','.css','.html','.xml','.svg','.toml','.ini','.cfg','.gitignore','.gitattributes'
}
SKIP_PREFIXES = ('references/', '.git/', 'node_modules/', 'dist/', 'build/', 'coverage/')


def tracked_files(root: Path):
    r = subprocess.run(['git','-C',str(root),'ls-files','-z'], capture_output=True, check=True)
    for name in r.stdout.decode('utf-8', errors='strict').split('\0'):
        if not name: continue
        if name.startswith(SKIP_PREFIXES): continue
        p = root / name
        if p.suffix.lower() in TEXT_EXT or p.name in {'.gitignore','.gitattributes','.editorconfig'}:
            yield p, name


def main():
    root = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path(__file__).resolve().parents[1]
    errors=[]
    for p, rel in tracked_files(root):
        b=p.read_bytes()
        try:
            t=b.decode('utf-8')
        except UnicodeDecodeError as e:
            errors.append(f'{rel}: not UTF-8: {e}')
            continue
        if '\ufffd' in t:
            errors.append(f'{rel}: contains Unicode replacement character U+FFFD')
    if errors:
        print(f'{len(errors)} encoding error(s):')
        for e in errors: print(f' - {e}')
        return 1
    print('OK: tracked text files are UTF-8 clean')
    return 0

if __name__=='__main__':
    raise SystemExit(main())
