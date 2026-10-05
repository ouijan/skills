---
name: review-reminders
description: "Drafts Slack reminder messages, one per reviewer, listing the user's open PRs that reviewer still needs to review (first review or re-review). Triggers: remind reviewers, chase reviews, nudge reviewers, who needs to review my PRs, /review-reminders."
---

# Review reminders

Covers one repository: the one the user names (`owner/repo`), otherwise the repo of the current working directory.

## Steps

1. Run `scripts/pending-reviews.sh [owner/repo]` from this skill's directory. Done when you have its JSON. Use its classification as is, without re-deriving it from `gh`: it already counts reviewers whose approval was dismissed after a push, and reviewers who requested changes before a later commit. If `reviewers` is empty, say nobody owes a review and stop.
2. Write the **summary** (format below). Done when every reviewer in `reviewers` has a row, and every entry in `waiting_on_author`, `nobody_owes_review`, plus every PR whose `last_commit` is more than 30 days old, has a note.
3. Write one **message** per reviewer (format below), in the same order as the summary. Done when every PR under each reviewer appears in that reviewer's message.

## Summary format

A table: `Reviewer | First review | Re-review | Total`, sorted by total, highest first. Then a short **Notes** list:

- PRs blocked on the author (`waiting_on_author`): who requested changes.
- PRs nobody owes a review on (`nobody_owes_review`), with who approved them.
- Stale PRs (last commit over 30 days ago): ask whether they're still ready, because they're included in the messages.

## Message format

The user pastes each message into Slack, and copying rendered markdown keeps the links. Use GitHub handles as headings and don't guess Slack names. Put first reviews before re-reviews. Separate messages with `---`.

```
**<reviewer>**

Hey! These PRs of mine are waiting on your review:
- [<title>](<url>) (ready for first review)
- [<title>](<url>) (ready for re-review)
```

With a single PR, the opening line is `Hey! This PR of mine is waiting on your review:`.
