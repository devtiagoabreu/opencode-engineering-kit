#!/usr/bin/env python3
"""Check that the npm tarball for cli/package.json matches the local cli/ folder.

Regra: cli/ e o pacote publicado no npm devem ser sempre identicos. Qualquer
mudanca em cli/ exige bump de versao + publish + `npm view latest`.

Usage:
  python scripts/check_npm_sync.py --root .
  python scripts/check_npm_sync.py --root . --json
"""
from __future__ import annotations

import argparse, hashlib, json, sys, tarfile, tempfile, urllib.request
from pathlib import Path


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as fh:
        for chunk in iter(lambda: fh.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()


def expected_files(cli: Path, patterns: list[str]) -> set[str]:
    out: set[str] = set()
    for pattern in patterns:
        p = cli / pattern
        if p.is_dir():
            out.update(
                f.relative_to(cli).as_posix()
                for f in p.rglob("*")
                if f.is_file()
            )
        elif p.is_file():
            out.add(p.relative_to(cli).as_posix())
    return out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=str(Path(__file__).resolve().parents[1]))
    ap.add_argument("--registry", default="https://registry.npmjs.org")
    ap.add_argument("--json", action="store_true")
    args = ap.parse_args()

    root = Path(args.root).resolve()
    pkg_path = root / "cli" / "package.json"
    pkg = json.loads(pkg_path.read_text(encoding="utf-8"))
    name, version = pkg["name"], pkg["version"]
    expected = expected_files(root / "cli", pkg.get("files", []))

    url = f"{args.registry.rstrip('/')}/{name}/{version}"
    with urllib.request.urlopen(url, timeout=30) as response:
        meta = json.load(response)
    tarball_url = meta["dist"]["tarball"]

    report: dict = {
        "ok": False,
        "name": name,
        "version": version,
        "registry": args.registry,
        "expected_files": len(expected),
        "published_files": 0,
        "missing_in_npm": [],
        "extra_in_npm": [],
        "different": [],
        "error": None,
    }

    try:
        with tempfile.TemporaryDirectory(prefix="oek-npm-sync-") as tmp:
            archive = Path(tmp) / "package.tgz"
            urllib.request.urlretrieve(tarball_url, archive)
            unpacked = Path(tmp) / "package"
            unpacked.mkdir()
            with tarfile.open(archive, "r:gz") as tf:
                try:
                    tf.extractall(unpacked, filter="data")
                except TypeError:  # Python < 3.12
                    tf.extractall(unpacked)
            published = {
                p.relative_to(unpacked).as_posix()
                for p in unpacked.rglob("*")
                if p.is_file()
            }
            report["published_files"] = len(published)
            report["missing_in_npm"] = sorted(expected - published)
            report["extra_in_npm"] = sorted(published - expected)
            for rel in sorted(expected & published):
                if sha256(root / "cli" / rel) != sha256(unpacked / rel):
                    report["different"].append(rel)
            report["ok"] = not (
                report["missing_in_npm"]
                or report["extra_in_npm"]
                or report["different"]
            )
    except Exception as exc:  # network/tarball failures are reported, not silently ignored
        report["error"] = f"{type(exc).__name__}: {exc}"

    if args.json:
        print(json.dumps(report, indent=2, ensure_ascii=False))
    else:
        status = "OK" if report["ok"] else "FAIL"
        print(f"{status}: {name}@{version} — cli/ vs npm")
        print(f"  cli files={report['expected_files']} npm files={report['published_files']}")
        if report["missing_in_npm"]:
            print(f"  missing in npm: {', '.join(report['missing_in_npm'])}")
        if report["extra_in_npm"]:
            print(f"  extra in npm: {', '.join(report['extra_in_npm'])}")
        if report["different"]:
            print(f"  different: {', '.join(report['different'])}")
        if report["error"]:
            print(f"  error: {report['error']}")
    return 0 if report["ok"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
