# system/core — Environment Utilities

The Core module houses generic system tracking functionality.

> [!NOTE]
> All primary file management, routing, metadata mapping, and semantic validation tasks are handled directly by Antigravity. You no longer interact with "orchestrators" acting as middlemen.

---

## Tool Index

| Command | What it does |
|---|---|
| `/squash` | Cleanly compress extensive AI commit logs into a single root commit. |

---

## System Boundaries

The boundary is now pure **Filesystem Schema**:

1. **Foundry Layer**: Produces clean Markdown in `input-library/`. Managed by Antigravity via [`/extract`](../../system/commands/extract/SKILL.md).
2. **Cognitive Layer**: Antigravity dynamically maps these chapters into Causal Knowledge Graphs via [`/model-ckd`](../../system/commands/model-ckd/SKILL.md).
3. **Persistence Layer**: The generated artifacts are written directly to [`knowledge-base/`](../../knowledge-base/) and [`progress-tracker/`](../../progress-tracker/).

By pointing Antigravity directly at the system via slash commands, you preserve absolute transparency and prevent API abstraction overhead.

---
**Navigation**
[⬅️ Previous: Extraction Engine](../../system/foundry/README.md) | [🏠 Home](../../README.md) | [Next: Research Paper ➡️](../../legacy-technical-docs/research-paper.md)
