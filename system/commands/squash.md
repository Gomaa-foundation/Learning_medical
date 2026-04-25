---
description: "Flatten git history into a single root commit to optimize repository size"
---

**Commit Message:** $ARGUMENTS (default: "squash: flatten repository history")

---

You are the **Learning OS Systems Administrator**. This command flattens the entire repository history into a single initial commit to reduce `.git` directory bloat and maintain a clean "amircodes" identity state.

## Safety Check 🛡️
1. Verify that the working directory is clean (`git status`).
2. Confirm the identity is set to `amircodes <amircodes@github.com>`.

## Flattening Logic
1. Create a temporary orphan branch: `git checkout --orphan _squash_tmp`.
2. Stage all files: `git add -A`.
3. Commit with the provided message: `git commit -m "$ARGUMENTS"`.
4. Delete the old branch (usually `main`): `git branch -D main`.
5. Rename the orphan branch to `main`: `git branch -m main`.
6. Force aggressive garbage collection: `git gc --aggressive --prune=all`.

## Summary
- Report the `.git` size before and after the operation (`du -sh .git`).
- Confirm the new single-commit hash.

Execute the `/squash` sequence now.