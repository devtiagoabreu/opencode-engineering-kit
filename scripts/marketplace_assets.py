#!/usr/bin/env python3
"""Published-assets registry helper for the marketplace.

Operates on the assets.json data file:
  add      add/update a published asset
  list     print all published assets
  remove   delete a published asset
"""
import argparse
import json
import sys


def load(path):
    try:
        with open(path) as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return {"assets": []}


def save(path, data):
    with open(path, "w") as f:
        json.dump(data, f, indent=2)
        f.write("\n")


def find(data, name):
    for asset in data.get("assets", []):
        if asset["name"] == name:
            return asset
    return None


def cmd_add(args):
    data = load(args.file)
    entry = find(data, args.name)
    record = {
        "name": args.name,
        "type": args.type,
        "path": args.path,
        "publisher": args.publisher,
        "published": args.date if hasattr(args, "date") else "unknown",
        "quality": "community",
        "downloads": 0,
        "rating": None,
        "reviews": 0,
    }
    if args.metadata:
        try:
            meta = json.loads(args.metadata)
            record["version"] = meta.get("version", "0.0.0")
            record["description"] = meta.get("description", "")
            record["category"] = meta.get("category", "")
        except json.JSONDecodeError:
            pass
    if entry:
        for key, value in record.items():
            if key not in ("downloads", "rating", "reviews", "quality"):
                entry[key] = value
    else:
        data.setdefault("assets", []).append(record)
    save(args.file, data)
    return 0


def cmd_list(args):
    data = load(args.file)
    assets = data.get("assets", [])
    if not assets:
        print("No published assets.")
        return 0
    for asset in assets:
        rating = asset.get("rating")
        rating_str = f"{rating:.1f}" if rating is not None else "-"
        print(f"{asset['type']:<10} {asset['name']:<30} {asset['publisher']:<16} "
              f"v{asset.get('version', '?')} quality={asset.get('quality', 'community'):<10} "
              f"rating={rating_str} downloads={asset.get('downloads', 0)}")
    return 0


def cmd_remove(args):
    data = load(args.file)
    before = len(data.get("assets", []))
    data["assets"] = [a for a in data.get("assets", []) if a["name"] != args.name]
    if len(data["assets"]) == before:
        print(f"error: asset '{args.name}' not found", file=sys.stderr)
        return 1
    save(args.file, data)
    return 0


def main():
    parser = argparse.ArgumentParser(description="Marketplace published assets registry")
    sub = parser.add_subparsers(dest="command", required=True)

    p = sub.add_parser("add")
    p.add_argument("--file", required=True)
    p.add_argument("--type", required=True)
    p.add_argument("--name", required=True)
    p.add_argument("--path", required=True)
    p.add_argument("--publisher", required=True)
    p.add_argument("--metadata", default="")
    p.add_argument("--date", default="")

    p = sub.add_parser("list")
    p.add_argument("--file", required=True)

    p = sub.add_parser("remove")
    p.add_argument("--file", required=True)
    p.add_argument("--name", required=True)

    args = parser.parse_args()
    handlers = {"add": cmd_add, "list": cmd_list, "remove": cmd_remove}
    sys.exit(handlers[args.command](args))


if __name__ == "__main__":
    main()
