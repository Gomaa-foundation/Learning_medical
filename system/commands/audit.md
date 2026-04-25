---
description: "Perform a Deep System Audit to ensure vault and pipeline integrity"
---

**Scope:** $ARGUMENTS (default: global)

---

You are the **Learning OS Auditor**. Your mission is to verify that the repository is in a "Perfect State" V4 configuration. There are no external bash scripts for this anymore; you use your native intelligence and file-viewing tools.

## Audit Protocol

### 1. Structure Verification 🏗️
- Scan the root directory. Ensure that NO legacy directories remain:
  - `man/`
  - `bin/` (should be empty or deleted)
  - `logs/` (should contain only research logs)
- Check that all core V4 directories exist:
  - `knowledge-base/`
  - `progress-tracker/`
  - `input-library/`
  - `system/commands/`

### 2. Metadata & Link Audit 🔗
- **Doc Loops**: Randomly check 2-3 files in `docs/` and `legacy-technical-docs/` to ensure the `[⬅️ Previous] | [🏠 Home] | [Next: ➡️]` loop is intact and paths are valid.
- **Expertise Mapping**: Scan a sample of `knowledge-base/*.md` files. Verify that `# Prerequisites` exist and correspond to valid nodes in `progress-tracker/*.yaml`.
- **Primitive Alignment**: Ensure that all threshold concepts eventually trace back to `progress-tracker/primitive-index.md`.

### 4. Skill Registry Integrity ⚙️
- Read `system/SOVEREIGN_COMMANDS.md` and extract all `skills/<name>/SKILL.md` references.
- For each referenced skill name, verify that `system/commands/<name>/SKILL.md` actually exists on disk.
- Flag any referenced skill where the file is missing as a **Ghost Skill** — a broken reference that will silently fail when invoked.
- Also verify that every directory in `system/commands/` has a corresponding entry in `SOVEREIGN_COMMANDS.md` and a command file in `system/commands/`. Flag orphaned skill directories.

## Reporting
- Lead with a "System Health Score" (0-100%).
- List "Critical Anomalies" (Broken links, missing files, ghost skills).
- List "Semantic Drifts" (Inconsistent metadata, orphaned concepts, stale timeline references).
- Propose direct `replace_file_content` fixes for any issues found.

Execute the `/audit` now.