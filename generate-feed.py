#!/usr/bin/env python3
"""Generate build/html/feed.xml from content/events.json."""
import json
import os
from datetime import datetime
from xml.sax.saxutils import escape
import markdown as md_lib

SITE_URL = "https://machinevisualculture.org"
FEED_TITLE = "Machine Visual Culture – Events and News"
FEED_DESCRIPTION = "Events and news from the Machine Visual Culture Research Group"
EVENTS_FILE = "content/events.json"
OUTPUT_FILE = "build/html/feed.xml"

def to_rfc2822(date_str):
    dt = datetime.strptime(date_str, "%Y-%m-%d")
    return dt.strftime("%a, %d %b %Y 00:00:00 +0000")

with open(EVENTS_FILE) as f:
    events = json.load(f)

items_xml = ""
for e in events:
    link = e.get("link") or f"{SITE_URL}/#events-and-news"
    items_xml += f"""
    <item>
      <title>{escape(e['title'])}</title>
      <link>{escape(link)}</link>
      <description><![CDATA[{md_lib.markdown(e['description'])}]]></description>
      <pubDate>{to_rfc2822(e['date'])}</pubDate>
      <guid isPermaLink="false">{escape(link)}#{e['date']}</guid>
    </item>"""

os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)
feed = f"""<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>{escape(FEED_TITLE)}</title>
    <link>{SITE_URL}</link>
    <description>{escape(FEED_DESCRIPTION)}</description>
    <lastBuildDate>{to_rfc2822(events[0]['date']) if events else ''}</lastBuildDate>{items_xml}
  </channel>
</rss>
"""

with open(OUTPUT_FILE, "w") as f:
    f.write(feed)

print(f"Generated {OUTPUT_FILE} with {len(events)} item(s)")
