# skills

Agent skills I use day to day. They work with any agent that reads `SKILL.md` folders (Claude Code, OpenCode, Codex, Pi, Cursor, and others).

## Install

```sh
npx skills add ouijan/skills                                          # pick skills interactively
npx skills add ouijan/skills -g -y -a opencode claude-code --skill '*'  # everything, user-wide
npx skills add ouijan/skills -g -y -a opencode claude-code --skill writing-for-agents
```

See [Third-party](#third-party) for why the agents are named.

## Skills

| Skill                | What it does                                                                         |
| -------------------- | ------------------------------------------------------------------------------------ |
| `orchestrate`        | Runs the session as an orchestrator: delegates to subagents and reports progress.    |
| `unslop`             | Cuts AI tells from writing.                                                          |
| `writing-for-agents` | A compact guide to writing skills and `AGENTS.md` files that agents follow reliably. |

## Third-party

Skills I use as published, not copied here. Install them from the source so `npx skills update` keeps them current.

### [mattpocock/skills](https://github.com/mattpocock/skills)

| Skill             | What it does                                                      |
| ----------------- | ----------------------------------------------------------------- |
| `grilling`        | Interviews you in rounds to stress-test a plan or idea.           |
| `grill-me`        | The earlier, one-question-at-a-time version of `grilling`.        |
| `grill-with-docs` | `grill-me`, writing ADRs and a glossary as it goes.               |
| `to-spec`         | Turns the current conversation into a spec on your issue tracker. |
| `to-tickets`      | Breaks a plan or spec into tickets with blocking edges.           |
| `wayfinder`       | Plans work too big for one session as a map of decision tickets.  |

```sh
npx skills add mattpocock/skills -g -y -a opencode claude-code --skill grilling grill-me grill-with-docs to-spec to-tickets wayfinder
```

### [angular/skills](https://github.com/angular/skills)

| Skill               | What it does                                     |
| ------------------- | ------------------------------------------------ |
| `angular-developer` | Angular code generation and architecture advice. |

```sh
npx skills add angular/skills -g -y -a opencode claude-code --skill angular-developer
```

`-a opencode claude-code` puts each skill in `~/.agents/skills`, which OpenCode, Codex and Pi read, and links it into `~/.claude/skills`. Name agents explicitly: `-a '*'` creates a skills folder for each of the ~50 agents the CLI knows, and `-a claude-code` alone skips `~/.agents/skills`. `-y` matters too: without it the CLI waits for a confirmation, and when run unattended it cancels and still exits 0.

## Credits

- [mattpocock/skills](https://github.com/mattpocock/skills) - basis for many skills
- [pstack](https://github.com/cursor/plugins/tree/main/pstack) - skill routing & workflow inspiration

---

See [LICENSE](LICENSE).
