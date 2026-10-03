#!/usr/bin/env bash
# Makes every agent skill folder hold exactly this repo's skills.
#
#   ./sync.sh                  link skills, install missing third-party ones, warn about strays
#   ./sync.sh --prune          also move strays to ~/.agents/.trash/<timestamp>/
#   ./sync.sh --keep herdr     treat a skill managed elsewhere as wanted (repeatable)
#
# Runs on macOS's bash 3.2, so no associative arrays.
set -euo pipefail
shopt -s nullglob

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
shared="$HOME/.agents/skills"
claude="$HOME/.claude/skills"
lock="$HOME/.agents/.skill-lock.json"
trash="$HOME/.agents/.trash/$(date +%Y%m%d-%H%M%S)"
unmanaged_dirs=("$HOME/.config/opencode/skills" "$HOME/.codex/skills" "$HOME/.pi/agent/skills")
# The Claude app syncs its own skills into ~/.claude/skills/synced. Hidden entries (.system, .trash) are skipped too.
claude_owned="synced"

prune=false
kept=""
stray_count=0

usage() {
	sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'
	exit "$1"
}

parse_args() {
	while [ $# -gt 0 ]; do
		case "$1" in
		--prune) prune=true ;;
		--keep) kept="$kept $2" && shift ;;
		-h | --help) usage 0 ;;
		*) echo "sync.sh: unknown argument $1" >&2 && usage 1 ;;
		esac
		shift
	done
}

own_skills() {
	for dir in "$repo"/skills/*/; do basename "$dir"; done
}

third_party_lines() {
	grep -v -E '^\s*(#|$)' "$repo/third-party.txt" || true
}

third_party_skills() {
	third_party_lines | cut -d' ' -f2- | tr ' ' '\n'
}

wanted_skills() {
	{
		own_skills
		third_party_skills
		for name in $kept; do echo "$name"; done
	} | sort -u
}

contains() {
	local list="$1" name="$2"
	printf '%s\n' "$list" | grep -qxF "$name"
}

pretty() {
	printf '%s' "${1/#$HOME/~}"
}

stray() {
	local path="$1" reason="$2"
	stray_count=$((stray_count + 1))
	if ! $prune; then
		echo "  stray  $(pretty "$path")  ($reason)"
		return 0
	fi
	local dest="$trash/${path#"$HOME"/}"
	mkdir -p "$(dirname "$dest")"
	mv "$path" "$dest"
	echo "  moved  $(pretty "$path")  ->  $(pretty "$dest")"
}

drop_broken_links() {
	for entry in "$1"/*; do
		[ -L "$entry" ] && [ ! -e "$entry" ] && rm "$entry" && echo "  removed broken link $(pretty "$entry")"
	done
	return 0
}

install_missing_third_party() {
	local source skills missing
	while read -r source skills; do
		missing=""
		for skill in $skills; do [ -e "$shared/$skill" ] || missing="$missing $skill"; done
		[ -z "$missing" ] && continue
		echo "  installing$missing from $source"
		# shellcheck disable=SC2086 # one argument per skill
		npx -y skills add "$source" -g -y -a opencode claude-code --skill $missing </dev/null >/dev/null 2>&1 ||
			echo "  warning: npx skills add $source failed; rerun sync.sh to retry" >&2
	done < <(third_party_lines)
}

# Symlink <name> in <dir> to <source>, unless something else already sits there.
link() {
	local dir="$1" name="$2" source="$3"
	local target="$dir/$name"
	if [ -e "$target" ] && [ ! -L "$target" ]; then
		stray "$target" "installed copy in the way of $(pretty "$source")"
		$prune || return 0
	fi
	ln -sfn "$source" "$target"
}

link_own_skills() {
	mkdir -p "$shared"
	for name in $(own_skills); do link "$shared" "$name" "$repo/skills/$name"; done
}

link_claude_skills() {
	mkdir -p "$claude"
	for name in $(wanted_skills); do
		[ -e "$shared/$name" ] && link "$claude" "$name" "$shared/$name"
	done
	return 0
}

report_strays() {
	local dir="$1" allowed="$2"
	for entry in "$dir"/*; do
		contains "$allowed" "$(basename "$entry")" || stray "$entry" "not in ouijan/skills"
	done
}

locked_skills() {
	[ -f "$lock" ] || return 0
	node -e 'console.log(Object.keys(require(process.argv[1]).skills).join("\n"))' "$lock"
}

# Lock entries outside third-party.txt make `npx skills update` reinstall them, through symlinks into this repo.
report_lock_strays() {
	local third_party unwanted=""
	third_party="$(third_party_skills)"
	for name in $(locked_skills); do contains "$third_party" "$name" || unwanted="$unwanted $name"; done
	[ -z "$unwanted" ] && return 0
	stray_count=$((stray_count + 1))
	if ! $prune; then
		echo "  stray  lock entries in $(pretty "$lock"):$unwanted"
		return 0
	fi
	mkdir -p "$trash" && cp "$lock" "$trash/.skill-lock.json"
	# shellcheck disable=SC2086 # one argument per skill
	node -e 'const fs = require("fs"); const [file, ...names] = process.argv.slice(1);
		const lock = JSON.parse(fs.readFileSync(file)); names.forEach((name) => delete lock.skills[name]);
		fs.writeFileSync(file, JSON.stringify(lock, null, 2) + "\n");' "$lock" $unwanted
	echo "  removed lock entries:$unwanted"
}

summarise() {
	if [ "$stray_count" -eq 0 ]; then
		echo "skills in sync: $(wanted_skills | wc -l | tr -d ' ') wanted, no strays"
	elif $prune; then
		echo "moved $stray_count stray(s) to $(pretty "$trash")"
	else
		echo "$stray_count stray(s). Run $(pretty "$repo")/sync.sh --prune to move them to ~/.agents/.trash/"
	fi
}

main() {
	parse_args "$@"
	echo "syncing skills from $(pretty "$repo")"
	install_missing_third_party
	link_own_skills
	link_claude_skills
	for dir in "$shared" "$claude" "${unmanaged_dirs[@]}"; do drop_broken_links "$dir"; done
	report_strays "$shared" "$(wanted_skills)"
	report_strays "$claude" "$(wanted_skills; echo "$claude_owned")"
	for dir in "${unmanaged_dirs[@]}"; do report_strays "$dir" ""; done
	report_lock_strays
	summarise
}

main "$@"
