# How I work with Claude Code

These are my personal preferences for every project. A project's own CLAUDE.md can add to them.

## Git

- Work directly on `main`. Don't create feature branches unless I ask for one in the chat.
- Commit after each change you make during a chat, without asking first. Make small, frequent commits: one logical change per commit.
- Don't push unless I ask. Committing is fine; pushing is my call.
- Write every commit message by the seven rules at https://cbea.ms/git-commit:
  1. Separate the subject from the body with a blank line.
  2. Keep the subject to 50 characters or less.
  3. Capitalize the subject.
  4. Don't end the subject with a period.
  5. Use the imperative mood in the subject ("Add", "Fix", not "Added", "Fixes").
  6. Wrap the body at 72 characters.
  7. Use the body to explain what changed and why, not how.
- Run each commit message through the humanizer skill (`/humanizer:humanizer`) before committing, so it reads like a person wrote it.
- No attribution or "Co-authored-by" lines in commits.
