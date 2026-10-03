#!/usr/bin/env bash
# Installs the third-party skills listed in README.md, user-wide.
# Skills land in ~/.agents/skills (OpenCode, Codex, Pi) with links in ~/.claude/skills.
# See README.md "Install" for why each flag is there.
set -euo pipefail

install_from() {
	local source="$1"
	shift
	npx -y skills add "$source" -g -y -a opencode claude-code --skill "$@" </dev/null
}

install_from mattpocock/skills grilling grill-me grill-with-docs to-spec to-tickets wayfinder
install_from angular/skills angular-developer
