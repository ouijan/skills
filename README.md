# skills

Agent skills I use day to day. They work with any agent that reads `SKILL.md` folders (Claude Code, OpenCode, Codex, Pi, Cursor, and others).

## Install

```sh
npx skills add ouijan/skills            # pick skills interactively
npx skills add ouijan/skills -g --all   # everything, user-wide
npx skills add ouijan/skills -g --skill writing-for-agents
```

## Skills

| Skill                | What it does                                                                         |
| -------------------- | ------------------------------------------------------------------------------------ |
| `orchestrate`        | Runs the session as an orchestrator: delegates to subagents and reports progress.    |
| `unslop`             | Cuts AI tells from writing.                                                          |
| `writing-for-agents` | A compact guide to writing skills and `AGENTS.md` files that agents follow reliably. |

## Third-party

Skills I use as published. Install them from the source so `npx skills update` keeps them current.

| Skill      | Source                                                                                           | Install                                                |
| ---------- | ------------------------------------------------------------------------------------------------ | ------------------------------------------------------ |
| `grilling` | [mattpocock/skills](https://github.com/mattpocock/skills/tree/main/skills/productivity/grilling) | `npx skills add mattpocock/skills -g --skill grilling` |

## Credits

- [mattpocock/skills](https://github.com/mattpocock/skills) - basis for many skills
- [pstack](https://github.com/cursor/plugins/tree/main/pstack) - skill routing & workflow inspiration

---

See [LICENSE](LICENSE).
