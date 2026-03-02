#!/usr/bin/env python3
"""Generate build/html/feed.xml from Typst events using introspection."""
import json
import os
import subprocess
import sys
from datetime import datetime
from xml.sax.saxutils import escape

SITE_URL = "https://machinevisualculture.org"
FEED_TITLE = "Machine Visual Culture – Events and News"
FEED_DESCRIPTION = "Events and news from the Machine Visual Culture Research Group"
TYPST_FILE = "content/index.typ"  # Query index.typ for <all-events> metadata
OUTPUT_FILE = "build/html/feed.xml"

def to_rfc2822(date_str):
    dt = datetime.strptime(date_str, "%Y-%m-%d")
    return dt.strftime("%a, %d %b %Y 00:00:00 +0000")

def extract_events():
    """Extract events using Typst query CLI."""
    cmd = [
        "typst", "query",
        TYPST_FILE,
        "<all-events>",
        "--format", "json",
        "--field", "value",
        "--one"
    ]

    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        print(f"Error: typst query failed: {result.stderr}", file=sys.stderr)
        sys.exit(1)

    try:
        events = json.loads(result.stdout)
        # Sort by date (newest first)
        events.sort(key=lambda e: e.get("date", ""), reverse=True)
        return events
    except json.JSONDecodeError as e:
        print(f"Error parsing typst query output: {e}", file=sys.stderr)
        sys.exit(1)

def extract_text_from_typst(content):
    """Extract plain text from Typst content structure."""
    if isinstance(content, str):
        return content.strip()
    elif isinstance(content, dict):
        # Typst content structure: {"func": "sequence", "children": [...]}
        if "children" in content:
            return "".join(extract_text_from_typst(c) for c in content["children"])
        elif "text" in content:
            return content["text"]
        return ""
    elif isinstance(content, list):
        return "".join(extract_text_from_typst(c) for c in content)
    return str(content).strip()

def main():
    events = extract_events()

    items_xml = ""
    for e in events:
        link = e.get("link") or f"{SITE_URL}/#events-and-news"

        # Handle content - may be strings or Typst content
        title = extract_text_from_typst(e["title"])
        description = extract_text_from_typst(e.get("description", ""))

        items_xml += f"""
    <item>
      <title>{escape(title)}</title>
      <link>{escape(link)}</link>
      <description>{escape(description)}</description>
      <pubDate>{to_rfc2822(e['date'])}</pubDate>
      <guid isPermaLink="false">{escape(link)}#{e['date']}</guid>
    </item>"""

    os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)
    last_build = to_rfc2822(events[0]['date']) if events else ''

    feed = f"""<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>{escape(FEED_TITLE)}</title>
    <link>{SITE_URL}</link>
    <description>{escape(FEED_DESCRIPTION)}</description>
    <lastBuildDate>{last_build}</lastBuildDate>{items_xml}
  </channel>
</rss>
"""

    with open(OUTPUT_FILE, "w") as f:
        f.write(feed)

    print(f"Generated {OUTPUT_FILE} with {len(events)} item(s)")

if __name__ == "__main__":
    main()
