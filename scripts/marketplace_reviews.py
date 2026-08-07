#!/usr/bin/env python3
"""Review/rating helper for the marketplace.

Operates on the reviews.json data file:
  add      record a review
  list     list reviews for an asset
  summary  show aggregate rating for an asset
"""
import argparse
import json
import sys


def load(path):
    try:
        with open(path) as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return {"reviews": []}


def save(path, data):
    with open(path, "w") as f:
        json.dump(data, f, indent=2)
        f.write("\n")


def reviews_for(data, asset):
    return [r for r in data.get("reviews", []) if r["asset"] == asset]


def cmd_add(args):
    data = load(args.file)
    data.setdefault("reviews", []).append({
        "asset": args.asset,
        "reviewer": args.reviewer,
        "rating": int(args.rating),
        "title": args.title,
        "content": args.content,
        "verified": False,
        "date": args.date,
    })
    save(args.file, data)
    return 0


def cmd_list(args):
    data = load(args.file)
    reviews = reviews_for(data, args.asset)
    if not reviews:
        print(f"No reviews for '{args.asset}'.")
        return 0
    for r in reviews:
        stars = "*" * r["rating"]
        title = f" - {r['title']}" if r.get("title") else ""
        print(f"{stars} ({r['rating']}/5) {title} by {r['reviewer']} on {r['date']}")
        if r.get("content"):
            print(f"    {r['content']}")
    return 0


def cmd_summary(args):
    data = load(args.file)
    reviews = reviews_for(data, args.asset)
    if not reviews:
        print(f"No reviews for '{args.asset}'.")
        return 1
    total = len(reviews)
    avg = sum(r["rating"] for r in reviews) / total
    print(f"Asset: {args.asset}")
    print(f"Average rating: {avg:.1f}/5 ({total} review{'s' if total != 1 else ''})")
    for star in (5, 4, 3, 2, 1):
        count = sum(1 for r in reviews if r["rating"] == star)
        bar = "#" * count
        print(f"  {star}★ {bar}")
    return 0


def main():
    parser = argparse.ArgumentParser(description="Marketplace review/rating system")
    sub = parser.add_subparsers(dest="command", required=True)

    p = sub.add_parser("add")
    p.add_argument("--file", required=True)
    p.add_argument("--asset", required=True)
    p.add_argument("--reviewer", required=True)
    p.add_argument("--rating", required=True)
    p.add_argument("--title", default="")
    p.add_argument("--content", default="")
    p.add_argument("--date", required=True)

    p = sub.add_parser("list")
    p.add_argument("--file", required=True)
    p.add_argument("--asset", required=True)

    p = sub.add_parser("summary")
    p.add_argument("--file", required=True)
    p.add_argument("--asset", required=True)

    args = parser.parse_args()
    handlers = {"add": cmd_add, "list": cmd_list, "summary": cmd_summary}
    sys.exit(handlers[args.command](args))


if __name__ == "__main__":
    main()
