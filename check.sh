
#!/usr/bin/env bash

set -euo pipefail

QUESTIONS_FILE="check.txt"
PROMPT_TEMPLATE_FILE="checkprompt.txt"

if [[ ! -f "$QUESTIONS_FILE" ]]; then
	echo "Missing file: $QUESTIONS_FILE" >&2
	exit 1
fi

if [[ ! -f "$PROMPT_TEMPLATE_FILE" ]]; then
	echo "Missing file: $PROMPT_TEMPLATE_FILE" >&2
	exit 1
fi

prompt_template="$(cat "$PROMPT_TEMPLATE_FILE")"

while IFS= read -r question || [[ -n "$question" ]]; do
	# Skip blank lines in the questions file.
	[[ -z "$question" ]] && continue

	prompt="${prompt_template//__QUESTION__/$question}"

    echo $question

	copilot_output="$(copilot --effort low --model gpt-5.2 -p "$prompt" --output-format json </dev/null 2>/dev/null || true)"

	result="false"
	if command -v jq >/dev/null 2>&1; then
		parsed="$(printf '%s' "$copilot_output" | jq -r '.. | strings | select(test("^(?i:true|false)$"))' 2>/dev/null | head -n 1 || true)"
		if [[ "$parsed" =~ ^([Tt][Rr][Uu][Ee]|[Ff][Aa][Ll][Ss][Ee])$ ]]; then
			result="$(printf '%s' "$parsed" | tr '[:upper:]' '[:lower:]')"
		fi
	else
		if printf '%s' "$copilot_output" | grep -qi '"true"\|\btrue\b'; then
			result="true"
		elif printf '%s' "$copilot_output" | grep -qi '"false"\|\bfalse\b'; then
			result="false"
		fi
	fi

	if [[ "$result" == "true" ]]; then
		icon=$'\033[32m✓\033[0m'
	else
		icon=$'\033[31m✗\033[0m'
	fi

	echo "$icon $result"
done < "$QUESTIONS_FILE"
