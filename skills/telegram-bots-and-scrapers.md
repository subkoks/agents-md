---
name: telegram-bots-and-scrapers
description: Use when building Telegram bots, channel scrapers, or Telethon/Pyrogram automation with session safety.
---

# Telegram Bots and Scrapers

## When to Use

- Bot API bots (commands, inline, webhooks)
- User/client API scrapers (Telethon, Pyrogram)
- Channel/group archival, alerts, or moderation helpers

## Implementation Workflow

1. Choose API: Bot API (token) vs MTProto (api_id/hash + session).
2. Store credentials in env; session files outside git with strict permissions.
3. Implement reconnect/backoff for network drops.
4. Paginate history; checkpoint cursors for resumable scrapes.
5. Respect flood limits; batch requests with delays.

## Hard Rules

- Never commit `.session`, API hashes, or bot tokens.
- Bot API: validate webhook signatures when used.
- Scrape only channels/groups you are authorized to access.
- Handle `FloodWaitError` with exponential backoff, not tight loops.

## Done Criteria

- Auth flow documented; session rotation path known.
- Scraper resumes from last message ID or date checkpoint.
- Errors logged with context; no PII in public logs.

## Related Skills

- `python-automation.md`
- `debugging-protocol.md`
