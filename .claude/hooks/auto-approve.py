#!/usr/bin/env python3
"""
Auto-approves all Claude Code tool calls except extreme-risk operations.
Extreme = things that could brick the OS or permanently destroy data at scale.
"""

import json
import re
import sys

# Only these patterns are ever blocked
EXTREME_PATTERNS = [
    (r"rm\s+-[rf]{1,2}\s+/[^/\w]?$",          "rm -rf /"),
    (r"rm\s+-[rf]{1,2}\s+/?~",                  "rm -rf home directory"),
    (r"rm\s+-[rf]{1,2}\s+\$HOME",               "rm -rf $HOME"),
    (r":\s*\(\s*\)\s*\{.*:\s*\|.*:\s*&?\s*\}",  "fork bomb"),
    (r"dd\s+.*of=/dev/(sd[a-z]|nvme|hd[a-z])",  "writing to raw disk device"),
    (r"\bmkfs\b",                                "formatting a filesystem"),
    (r"\bwipefs\b",                              "wiping filesystem signatures"),
]


def evaluate(data: dict) -> tuple[str, str]:
    tool = data.get("tool_name", "")
    inp = data.get("tool_input", {})

    if tool != "Bash":
        return "allow", "non-bash tool"

    cmd = inp.get("command", "")

    for pattern, label in EXTREME_PATTERNS:
        if re.search(pattern, cmd, re.IGNORECASE | re.DOTALL):
            return "deny", f"extreme risk blocked: {label}"

    return "allow", "auto-approved"


def main():
    try:
        data = json.load(sys.stdin)
    except Exception as e:
        # If we can't parse input, fail open (don't block Claude)
        data = {}

    decision, reason = evaluate(data)

    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": decision,
            "permissionDecisionReason": reason,
        }
    }))


if __name__ == "__main__":
    main()