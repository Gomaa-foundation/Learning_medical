# 💠 Sovereign Skill Registry

Skills are natively available as `/command-name` in Antigravity.
Each skill's logic lives in a `system/commands/<skill-name>/SKILL.md` file.

---

## 🧠 Learning OS Pipeline Skills

These are the skills that form the core Learning OS workflow.

### `/audit`
- **Purpose:** Deep system audit — vault and pipeline integrity, mastery decay alerts, broken link detection, skill registry validation.
- **Logic:** [`system/commands/audit/SKILL.md`](system/commands/audit/SKILL.md)

### `/extract`
- **Purpose:** Natively reads, sanitizes, and splits raw markdown books into `chapter-XX.md` chunks with YAML frontmatter injection.
- **Logic:** [`system/commands/extract/SKILL.md`](system/commands/extract/SKILL.md)

### `/verify`
- **Purpose:** Quality-assures extracted chapters — validates YAML schemas and structural integrity.
- **Logic:** [`system/commands/verify/SKILL.md`](system/commands/verify/SKILL.md)

### `/model-ckd`
- **Purpose:** Natively distills a chapter into a Causal Knowledge Document (CKD) and writes it to `knowledge-base/`. Updates `progress-tracker/*.yaml` mastery nodes.
- **Logic:** [`system/commands/model-ckd/SKILL.md`](system/commands/model-ckd/SKILL.md)

### `/learn`
- **Purpose:** Start a formal Socratic distillation session for a specific target chapter.
- **Logic:** [`system/commands/learn/SKILL.md`](system/commands/learn/SKILL.md)

### `/socratic-synthesis`
- **Purpose:** FSRS-driven decay review targeting weak nodes. Dual-mode: **Mode A** (Socratic Memory Tester) and **Mode B** (Aristotle First-Principles Deconstructor — activated when a corrupted mental model is detected, not just a recall gap).
- **Logic:** [`system/commands/socratic-synthesis/SKILL.md`](system/commands/socratic-synthesis/SKILL.md)

### `/anki-forge`
- **Purpose:** Extracts `[ANKI CORE]` blocks from CKD vaults and generates deployment-ready `srs/[domain]-deck.csv` files. Focuses on mental models and transformations, not rote Q&A.
- **Logic:** [`system/commands/anki-forge/SKILL.md`](system/commands/anki-forge/SKILL.md)

### `/find-analogies`
- **Purpose:** Forages the vault for isomorphic structural analogies to a target concept. Uses `progress-tracker/primitive-index.md` as the anchor.
- **Logic:** [`system/commands/find-analogies/SKILL.md`](system/commands/find-analogies/SKILL.md)

### `/orchestrate`
- **Purpose:** Autonomous batch processing loop — sanitizes `input-library/` directories (Sovereign Naming) and runs the full extraction pipeline.
- **Logic:** [`system/commands/orchestrate/SKILL.md`](system/commands/orchestrate/SKILL.md)

---

## 🌐 Intelligence Gathering Skills

### `/intel`
- **Purpose:** Daily AI & tech intelligence briefing for a power user.
- **Logic:** [`system/commands/intel/SKILL.md`](system/commands/intel/SKILL.md)

### `/catchup`
- **Purpose:** 3-day catch-up intelligence brief for missed days.
- **Logic:** [`system/commands/catchup/SKILL.md`](system/commands/catchup/SKILL.md)

### `/deep-dive`
- **Purpose:** Perform a deep-dive research sprint on a specific topic.
- **Logic:** [`system/commands/deep-dive/SKILL.md`](system/commands/deep-dive/SKILL.md)

---

## 🔧 Utility Skills

### `/squash`
- **Purpose:** Flatten git history into a single root commit to optimize repository size.
- **Logic:** [`system/commands/squash/SKILL.md`](system/commands/squash/SKILL.md)

---

> [!NOTE]
> **Active Skills: 13 real skill directories.** This registry reflects only skills with a backing `SKILL.md` file. Do not add entries here without a corresponding `system/commands/<name>/SKILL.md`.
