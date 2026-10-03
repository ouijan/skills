# skills

Agent skills I use day to day. They work with any agent that reads `SKILL.md` folders (Claude Code, OpenCode, Codex, Pi, Cursor, and others).

## Install

```sh
npx skills add ouijan/skills                                          # pick skills interactively
npx skills add ouijan/skills -g -y -a opencode claude-code --skill '*'  # everything, user-wide
npx skills add ouijan/skills -g -y -a opencode claude-code --skill writing-for-agents
```

`-a opencode claude-code` puts each skill in `~/.agents/skills`, which OpenCode, Codex and Pi read, and links it into `~/.claude/skills`. Name agents explicitly: `-a '*'` creates a skills folder for each of the ~50 agents the CLI knows, and `-a claude-code` alone skips `~/.agents/skills`. `-y` matters too: without it the CLI waits for a confirmation, and when run unattended it cancels and still exits 0.

## Skills

| Skill                | What it does                                                                         |
| -------------------- | ------------------------------------------------------------------------------------ |
| `orchestrate`        | Runs the session as an orchestrator: delegates to subagents and reports progress.    |
| `unslop`             | Cuts AI tells from writing.                                                          |
| `writing-for-agents` | A compact guide to writing skills and `AGENTS.md` files that agents follow reliably. |

### From [mattpocock/skills](https://github.com/mattpocock/skills)

Copied verbatim at [`d81f3a1`](https://github.com/mattpocock/skills/tree/d81f3a183412e71a5b1e84ca21bc1a35eea03a60), to be trimmed to how I work. Each `SKILL.md` links its upstream file in `metadata.credits.url`, for diffing against later versions.

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

`grill-with-docs` and `wayfinder` call `grilling`, `domain-modeling`, `research` and `prototype`. Trim or remove them together.

## Third-party

Skills I install from their source because they can't be copied here. `angular/skills` has no licence. [`install-third-party.sh`](install-third-party.sh) installs them:

```sh
curl -fsSL https://raw.githubusercontent.com/ouijan/skills/main/install-third-party.sh | bash
# or, from a clone
./install-third-party.sh
```

| Skill               | Source                                              | What it does                                     |
| ------------------- | --------------------------------------------------- | ------------------------------------------------ |
| `angular-developer` | [angular/skills](https://github.com/angular/skills) | Angular code generation and architecture advice. |

## Credits

- [mattpocock/skills](https://github.com/mattpocock/skills) - basis for many skills, MIT ([licence](LICENSES/mattpocock-skills.txt))
- [pstack](https://github.com/cursor/plugins/tree/main/pstack) - skill routing & workflow inspiration

---

See [LICENSE](LICENSE).
