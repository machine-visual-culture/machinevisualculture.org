#!/usr/bin/env python3
"""Post-process compiled HTML to render Markdown in event title and description fields."""
import json
import re
import markdown as md_lib

EVENTS_FILE = "content/events.json"
HTML_FILE = "build/html/index.html"


def inline_html(text):
    """Render Markdown to HTML, stripping the outer <p> wrapper for inline use."""
    result = md_lib.markdown(text)
    return re.sub(r"^\s*<p>(.*)</p>\s*$", r"\1", result, flags=re.DOTALL)


with open(EVENTS_FILE) as f:
    events = json.load(f)

with open(HTML_FILE) as f:
    html_content = f.read()

for event in events:
    date_id = re.escape(event["date"])
    link = event.get("link", "")
    title_inline = inline_html(event["title"])
    desc_html = md_lib.markdown(event["description"])

    # Build title replacement (include anchor if there's a link)
    if link:
        title_replacement = f'<a href="{link}">{title_inline}</a>'
    else:
        title_replacement = title_inline

    # Replace title placeholder
    title_pattern = (
        rf'<div class="event-title-placeholder" '
        rf'data-event-date="{date_id}"[^>]*>.*?</div>'
    )
    html_content = re.sub(title_pattern, title_replacement, html_content, flags=re.DOTALL)

    # Replace description placeholder
    desc_pattern = (
        rf'<div class="event-desc-placeholder" '
        rf'data-event-date="{date_id}"[^>]*>.*?</div>'
    )
    html_content = re.sub(desc_pattern, desc_html, html_content, flags=re.DOTALL)

with open(HTML_FILE, "w") as f:
    f.write(html_content)

print(f"Rendered Markdown for {len(events)} event(s) in {HTML_FILE}")
