# 🔬 Intelligence & Research Commands

> **Status**: Active · v0.1.0 · April 2026  
> **Location**: `system/commands/`  

The intelligence gathering modules are built as **native slash commands**. They encode the formatting rules and your user profile, and they dynamically inject the current date into the research process.

## The Commands

Inside the Antigravity chat, simply type:

| Command | Purpose |
|---|---|
| `/intel` | **The Daily Morning Routine.** Searches for tool releases, tech ecosystem moves, and signals since yesterday. Filters out noise and fluff. |
| `/business-brief` | **Strategic Intelligence.** Tracks company moves, pricing changes, and acquisitions relevant to remote professionals. |
| `/catchup` | **Multi-Day Lookback.** A prioritized 3-day summary for when you've been offline. |
| `/deep-dive <topic>` | **Targeted Sprint.** A comprehensive breakdown of a single topic, outlining the current state of the art and key players. |

---

## How it Works

The Study System uses **Project Memory** to ensure your assistant always knows your goals:

1. **`ANTIGRAVITY.md`**: This file tells your assistant who you are and how you prefer information formatted.
2. **`system/commands/*.md`**: These files store the logic for each command. By typing `/intel`, you are giving your assistant a highly-tuned set of instructions.
3. **Execution**: The assistant reads the command, uses its web search capabilities to find the latest info, and returns a formatted brief directly in the chat.

---

## Modifying the Briefs

If you want to track a new technology or exclude a topic:

1. Ask Antigravity to edit the command file (e.g., `system/commands/intel.md`).
2. Add your topic to the `Research Scope` section or the `Exclusions` list.
3. Save the file. The next time you run the command, your changes will be active.

---

## Daily Routine Integration

The intelligence briefings are Step 1 of your daily routine — establishing context before you focus on your specific studies:

```text
1. Status: ./study.py status      → Check your mastery and dashboard
2. Intel: /intel                  → Start the day with a tech brief
3. Orchestrate: /orchestrate      → Process any new files in your library
4. Learn: /learn <topic>          → Master a specific subject
```

---

**Navigation**
[⬅️ Previous: Usage & Workflow](USAGE.md) | [🏠 Home](../README.md) | [Next: Security Protocol ➡️](SECURITY.md)
