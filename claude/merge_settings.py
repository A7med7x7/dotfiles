#!/usr/bin/env python3
# Merges into ~/.claude/settings.json rather than symlinking, since Claude Code
# also writes to that file (e.g. onboarding state) and a symlink would fight it.
import json
import os

DOTFILES = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(DOTFILES, "claude", "settings.json")
DEST = os.path.expanduser("~/.claude/settings.json")

with open(SRC) as f:
    src = json.load(f)

dest = {}
if os.path.exists(DEST):
    with open(DEST) as f:
        try:
            dest = json.load(f)
        except json.JSONDecodeError:
            dest = {}

dest.update(src)

os.makedirs(os.path.dirname(DEST), exist_ok=True)
with open(DEST, "w") as f:
    json.dump(dest, f, indent=2)
    f.write("\n")
