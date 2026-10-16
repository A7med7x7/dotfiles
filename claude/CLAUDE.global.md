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

## READMEs and Markdown on GitHub

- In Markdown that GitHub renders (a repo's `README.md`, `CONTRIBUTING.md`, other docs read on github.com), use GitHub alerts for callouts instead of bold "Note:" lines:

  ```markdown
  > [!NOTE]
  > Useful information that users should know, even when skimming content.
  ```

- Pick the type by meaning:
  - `[!NOTE]`: useful context, even for someone skimming.
  - `[!TIP]`: an easier or better way to do something.
  - `[!IMPORTANT]`: something they must know to reach their goal.
  - `[!WARNING]`: needs attention now to avoid a problem.
  - `[!CAUTION]`: risks or bad outcomes of an action.
- Use them only where a reader would otherwise miss something: about one per section at most, never for ordinary text.
- Don't use them in Markdown that a docs framework renders (Starlight, Docusaurus, MkDocs). Those have their own callout syntax, such as Starlight's `:::note`.

## GitHub repos

- I like CI. When a repo has none, add the checks it actually needs (tests, typecheck, build, lint where one is configured) as GitHub Actions. Don't add checks for things the project doesn't have.
- Show each CI workflow as a shields.io badge at the top of the README, and only once it passes:

  ```markdown
  [![CI](https://img.shields.io/github/actions/workflow/status/OWNER/REPO/ci.yml?branch=main&label=CI)](https://github.com/OWNER/REPO/actions/workflows/ci.yml)
  ```

  shields.io can't read private repos, so a private repo uses GitHub's own badge instead (`https://github.com/OWNER/REPO/actions/workflows/ci.yml/badge.svg`).
- If the GitHub repo has no description, set one with `gh repo edit --description "..."`: one plain sentence saying what the project does, usually the README's tagline.
