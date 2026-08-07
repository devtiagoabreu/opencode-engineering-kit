#!/usr/bin/env python3
"""Publisher registry helper for the marketplace.

Operates on the publishers.json data file:
  add      add a publisher account
  verify   mark a publisher as verified
  list     print all publishers
  remove   delete a publisher
"""
import argparse
import json
import sys


def load(path):
    try:
        with open(path) as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return {"publishers": []}


def save(path, data):
    with open(path, "w") as f:
        json.dump(data, f, indent=2)
        f.write("\n")


def find(data, pub_id):
    for pub in data.get("publishers", []):
        if pub["id"] == pub_id:
            return pub
    return None


def cmd_add(args):
    data = load(args.file)
    if find(data, args.id):
        print(f"error: publisher '{args.id}' already exists", file=sys.stderr)
        return 1
    data.setdefault("publishers", []).append({
        "id": args.id,
        "name": args.name,
        "email": args.email,
        "created": args.date,
        "verified": False,
        "assets_published": 0,
    })
    save(args.file, data)
    return 0


def cmd_verify(args):
    data = load(args.file)
    pub = find(data, args.id)
    if pub is None:
        print(f"error: publisher '{args.id}' not found", file=sys.stderr)
        return 1
    pub["verified"] = True
    save(args.file, data)
    return 0


def cmd_list(args):
    data = load(args.file)
    pubs = data.get("publishers", [])
    if not pubs:
        print("No publishers registered.")
        return 0
    for pub in pubs:
        verified = "verified" if pub.get("verified") else "unverified"
        print(f"{pub['id']:<20} {verified:<12} assets={pub.get('assets_published', 0)} "
              f"created={pub.get('created', '?')} ({pub.get('name', '?')})")
    return 0


def cmd_remove(args):
    data = load(args.file)
    before = len(data.get("publishers", []))
    data["publishers"] = [p for p in data.get("publishers", []) if p["id"] != args.id]
    if len(data["publishers"]) == before:
        print(f"error: publisher '{args.id}' not found", file=sys.stderr)
        return 1
    save(args.file, data)
    return 0


def main():
    parser = argparse.ArgumentParser(description="Marketplace publisher registry")
    sub = parser.add_subparsers(dest="command", required=True)

    p = sub.add_parser("add")
    p.add_argument("--file", required=True)
    p.add_argument("--id", required=True)
    p.add_argument("--name", required=True)
    p.add_argument("--email", required=True)
    p.add_argument("--date", required=True)

    p = sub.add_parser("verify")
    p.add_argument("--file", required=True)
    p.add_argument("--id", required=True)

    p = sub.add_parser("list")
    p.add_argument("--file", required=True)

    p = sub.add_parser("remove")
    p.add_argument("--file", required=True)
    p.add_argument("--id", required=True)

    args = parser.parse_args()
    handlers = {"add": cmd_add, "verify": cmd_verify, "list": cmd_list, "remove": cmd_remove}
    sys.exit(handlers[args.command](args))


if __name__ == "__main__":
    main()
