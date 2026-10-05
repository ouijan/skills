# skills

Agent skills I use day to day. They work with any agent that reads `SKILL.md` folders (Claude Code, OpenCode, Codex, Pi, Cursor, and others).

## Install

```sh
npx skills add ouijan/skills                                            # pick skills interactively
npx skills add ouijan/skills -g -y -a opencode claude-code --skill '*'  # everything, user-wide
npx skills add ouijan/skills -g -y -a opencode claude-code --skill writing-for-agents
```

`-a opencode claude-code` puts each skill in `~/.agents/skills`, which OpenCode, Codex and Pi read, and links it into `~/.claude/skills`. Name agents explicitly: `-a '*'` creates a skills folder for each of the ~50 agents the CLI knows, `-a claude-code` alone skips `~/.agents/skills`, and adding `-a pi` makes Pi see every skill twice. `-y` matters too: without it the CLI waits for a confirmation, and when run unattended it cancels and still exits 0.

Update with `npx skills update -g -y`. Keep the `-g`: without it, `-y` picks project scope when run inside a project.

## Skills

| Skill                | What it does                                                                         |
| -------------------- | ------------------------------------------------------------------------------------ |
| `orchestrate`        | Runs the session as an orchestrator: delegates to subagents and reports progress.    |
| `review-reminders`   | Drafts per-reviewer Slack reminders for your open PRs in a repo (needs `gh`, `jq`).  |
| `unslop`             | Cuts AI tells from writing.                                                          |
| `writing-for-agents` | A compact guide to writing skills and `AGENTS.md` files that agents follow reliably. |

## Recommended third-party skills

Skills I use as published. Install them from their source so `npx skills update` keeps them current.

### [mattpocock/skills](https://github.com/mattpocock/skills)

```sh
npx skills add mattpocock/skills -g -y -a opencode claude-code --skill \
  grilling grill-with-docs domain-modeling research prototype \
  to-spec to-tickets wayfinder setup-matt-pocock-skills
```

| Skill                      | What it does                                                                           |
| -------------------------- | -------------------------------------------------------------------------------------- |
| `grilling`                 | Interviews you in rounds to stress-test a plan or idea.                                |
| `grill-with-docs`          | `grilling` plus `domain-modeling`: updates ADRs and the glossary as it goes.           |
| `domain-modeling`          | Builds a project's domain model: `GLOSSARY.md` and ADRs.                               |
| `research`                 | Researches a question from primary sources into a Markdown file.                       |
| `prototype`                | Builds a throwaway prototype to answer a design question.                              |
| `to-spec`                  | Turns the current conversation into a spec on your issue tracker.                      |
| `to-tickets`               | Breaks a plan or spec into tickets with blocking edges.                                |
| `wayfinder`                | Plans work too big for one session as a map of decision tickets.                       |
| `setup-matt-pocock-skills` | Run once per repo: sets the issue tracker `to-spec`, `to-tickets` and `wayfinder` use. |

`grill-with-docs` and `wayfinder` call `grilling`, `domain-modeling`, `research` and `prototype`, so install them together.

### [angular/skills](https://github.com/angular/skills)

```sh
npx skills add angular/skills -g -y -a opencode claude-code --skill angular-developer
```

| Skill               | What it does                                     |
| ------------------- | ------------------------------------------------ |
| `angular-developer` | Angular code generation and architecture advice. |

## Credits

- [mattpocock/skills](https://github.com/mattpocock/skills): basis for `writing-for-agents`
- [pstack](https://github.com/cursor/plugins/tree/main/pstack): `unslop`, and skill routing and workflow inspiration

---

See [LICENSE](LICENSE).
